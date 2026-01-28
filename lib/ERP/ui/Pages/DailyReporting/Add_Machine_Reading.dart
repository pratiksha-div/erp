import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import '../../../api/models/DAOGetProjectList.dart';
import '../../../api/models/DAOGetVehicleName.dart';
import '../../../api/models/DAOGetVendorName.dart';
import '../../../bloc/DailyReporting/add_machine_reading_boc.dart';
import '../../../bloc/DailyReporting/machine_reading_by_id_bloc.dart';
import '../../../bloc/DropDownValueBloc/project_list_bloc.dart';
import '../../../bloc/DropDownValueBloc/vehicle_name_bloc.dart';
import '../../../bloc/DropDownValueBloc/vendor_contractor_name_bloc.dart';
import '../../Utils/colors_constants.dart';
import '../../Utils/date_picker.dart';
import '../../Widgets/Custom_Date_Time_Picker.dart';
import '../../Widgets/Custom_Dropdown.dart';
import '../../Widgets/Custom_Button.dart';
import '../../Widgets/Custom_appbar.dart';
import '../../Widgets/Custom_Dialog.dart';
import '../../Widgets/PickTime.dart';
import '../../Widgets/TextWidgets.dart'; // for UploadErrorCard

class AddMachineReading extends StatefulWidget {
  AddMachineReading({super.key,required this.id});
  String id;

  @override
  State<AddMachineReading> createState() => _AddMachineReadingState();
}

class _AddMachineReadingState extends State<AddMachineReading> {
  DateTime? _selectedDate;
  final TextEditingController projectName = TextEditingController();
  final TextEditingController description = TextEditingController();
  final TextEditingController startReading = TextEditingController();
  final TextEditingController stopReading = TextEditingController();
  final TextEditingController spentTime= TextEditingController();
  final TextEditingController vehicleNo= TextEditingController();
  final TextEditingController gatePass= TextEditingController();

  final TextEditingController amount = TextEditingController();
  final TextEditingController total_run = TextEditingController();

  String? selectedProjectName;
  String? selectedProjectId;
  // new state
  String? _selectedVendorId;
  String? _selectedVechicleNameId;
  bool   _isSaving = false;
  TimeOfDay? _startTime;
  TimeOfDay? _stopTime;
  int _timeOfDayToMinutes(TimeOfDay t) => t.hour * 60 + t.minute;

  @override
  void initState() {
    super.initState();
    BlocProvider.of<ProjectListBloc>(context).add(const FetchProjectListsEvent());
    BlocProvider.of<VendorNameBloc>(context).add(const FetchVendorNamesEvent());
    BlocProvider.of<MachineReadingByIDBloc>(context).add( FetchMachineReadingByIDEvent(readingid: widget.id));
    print("ID ${widget.id}");
  }

  @override
  void dispose() {
    projectName.dispose();
    description.dispose();
    super.dispose();
  }

  Future<void> pickStartTime() async {
    final time = await pickTimeDialogue(context);
    if (time != null) {
      setState(() => _startTime = time);
    }
    _updateSpentTime();
  }

  Future<void> pickStopTime() async {
    final time = await pickTimeDialogue(context);
    if (time != null) {
      setState(() => _stopTime = time);
    }
    _updateSpentTime();
  }

  Future<void> _pickDate() async {
    DateTime now = DateTime.now();
    final date = await showAppDatePicker(
      context: context,
      initialDate: _selectedDate??now,
      firstDate: DateTime(now.year - 5),
      lastDate: DateTime(now.year + 5),
    );

    if (date != null && mounted) {
      setState(() => _selectedDate = date);
    }
  }

  String? _validateForm() {
    // Validate each required field, returning an error message if any are missing or invalid.
    if (selectedProjectId == null || selectedProjectId!.isEmpty) {
      return 'Please select a Project Name';
    }
    if (_selectedVendorId == null || _selectedVendorId!.isEmpty) {
      return 'Please select a Vendor Name';
    }
    if (_selectedVechicleNameId == null || _selectedVechicleNameId!.isEmpty) {
      return 'Please select a Vehicle Name';
    }
    if (startReading.text.trim().isEmpty) {
      return 'Please enter Reading on Start';
    }
    if (_selectedDate == null) {
      return 'Please select a Date';
    }
    return null; // No error
  }

  String formatTimeOfDay(TimeOfDay time) {
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, time.hour, time.minute);
    return DateFormat('hh:mm a').format(dt);   // Output: 02:25 AM
  }

  void _onSavePressed() {
    // Validate the form
    final validationError = _validateForm();
    if (validationError != null) {
      // If validation fails, show the error in a dialog and reset the submit state
      showDialog(
        context: context,
        builder: (context) => Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          backgroundColor: Colors.transparent,
          child: UploadErrorCard(
            title: 'Validation Failed',
            subtitle: validationError,
            onRetry: () {
              Navigator.pop(context);
              setState(() {
                _isSaving = false;
              });
            },
          ),
        ),
      );
      return;
    }
    setState(() {
      _isSaving=true;
    });

    print(
      '''
        // date: ${DateFormat('dd/MM/yyyy').format(_selectedDate!)},
        date: ${_selectedDate!.toString()},
        reading_start: ${startReading.text},
        reading_stop: ${stopReading.text},
        machine_Start: ${formatTimeWithSpace(_startTime)},
        machine_Stop: ${formatTimeWithSpace(_stopTime)},
        time_expend: ${spentTime.text},
        notes: ${description.text},
        project_id: ${selectedProjectId},
        vendertype: ${_selectedVendorId},
        vechiceltyp: ${_selectedVechicleNameId},
        readingId: ${widget.id},
        gate_pass_no: ${gatePass.text},
        total_run: ${total_run.text},
        amount: ${amount.text},
      '''
    );

    context.read<AddMachineReadingBloc>().add(
      SubmitAddMachineReadingEvent(
        date: DateFormat('dd/MM/yyyy').format(_selectedDate!),
        reading_start: startReading.text,
        reading_stop: stopReading.text,
        machine_Start: formatTimeWithSpace(_startTime),
        machine_Stop:formatTimeWithSpace(_stopTime),
        time_expend: spentTime.text,
        notes: description.text,
        project_id: selectedProjectId ?? "",
        readingID: widget.id,
        vendertype: _selectedVendorId ?? "",
        vechiceltype: _selectedVechicleNameId ?? "",
        gate_pass_no: gatePass.text,
        total_run: total_run.text,
        amount:amount.text,
      ),
    );

  }

  void _updateSpentTime() {
    if (_startTime == null || _stopTime == null) {
      return;
    }

    int startMinutes = _timeOfDayToMinutes(_startTime!);
    int stopMinutes = _timeOfDayToMinutes(_stopTime!);

    if (stopMinutes < startMinutes) stopMinutes += 24 * 60;

    int diffMinutes = stopMinutes - startMinutes;

    double decimalHours = diffMinutes / 60;

    spentTime.text = decimalHours.toStringAsFixed(2);   // example: 2.50
  }

  String formatTimeWithSpace(TimeOfDay? time) {
    if (time == null) return '';          // prevents crash
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';             // 10:45
  }

  void getDate(String inputDate) {
    if (inputDate.isEmpty) return;
    DateFormat inputFormat = DateFormat("MMMM, dd yyyy HH:mm:ss Z");
    try {
      DateTime parsedDate = inputFormat.parse(inputDate);
      DateFormat outputFormat = DateFormat("yyyy-MM-dd HH:mm:ss.SSS");
      String formattedDate = outputFormat.format(parsedDate);
      _selectedDate = parsedDate;
    } catch (e) {
      print('Error parsing date: $e');
    }
  }

  TimeOfDay? convertToTimeOfDay(String input) {
    try {
      // Parse your incoming date string
      final date = DateFormat("MMMM, dd yyyy HH:mm:ss Z").parse(input);

      // Convert to TimeOfDay
      return TimeOfDay(hour: date.hour, minute: date.minute);
    } catch (e) {
      print("Time parse error: $e");
      return null;
    }
  }

  void _calculateTotalRun() {
    final start = double.tryParse(startReading.text) ?? 0;
    final stop = double.tryParse(stopReading.text) ?? 0;

    final total = stop - start;
    total_run.text = total >= 0 ? total.toStringAsFixed(2) : "0";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.background,
      body:MultiBlocListener(
          listeners: [
            BlocListener<AddMachineReadingBloc, AddMachineReadingState>(
              listener: (context, state) {
                if (state is AddMachineReadingSuccess) {
                  Navigator.pop(context,"true");
                  Fluttertoast.showToast(msg: state.message);
                  setState(() {
                    _isSaving = false;
                  });
                } else if (state is AddMachineReadingFailed) {
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (context) => Dialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      backgroundColor: Colors.transparent,
                      child: UploadErrorCard(
                        title: "Failed to Add Machine Reading",
                        subtitle: state.message,
                        onRetry: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  );
                  setState(() {
                    _isSaving = false;
                  });
                }
              },
            ),
            BlocListener<MachineReadingByIDBloc, MachineReadingByIDState>(
              listener: (context, state) {
                if (state is MachineReadingByIDLoadSuccess) {
                  // choose which element from the list to use (first example)
                  if(widget.id!=""){
                    final reading = state.machineReadingByID.isNotEmpty
                        ? state.machineReadingByID.first
                        : null;
                    if (reading != null) {
                      setState(() {
                        selectedProjectId = reading.project_id?.toString() ?? '';
                        print("start ${reading.timestart}");
                        print("end ${reading.timeend}");
                        _startTime = convertToTimeOfDay(reading.timestart ?? "");
                        _stopTime  = convertToTimeOfDay(reading.timeend ?? "");
                        startReading.text = reading.readingstart?.toString() ?? '';
                        stopReading.text = reading.readingend?.toString() ?? '';
                        total_run.text=reading.total_run.toString();
                        amount.text=reading.amount.toString();
                        getDate(reading.readingdt??"");
                        spentTime.text = reading.expendedtime?.toString() ?? '';
                        gatePass.text=reading.gate_pass_no;
                        vehicleNo.text=reading.vehicleno.toString();
                        description.text = reading.notes?.toString() ?? '';
                        _selectedVendorId = reading.venderid?.toString() ?? '';
                        if(_selectedVendorId!=null && _selectedVendorId!.isNotEmpty){
                          BlocProvider.of<VehicleNameBloc>(context).add(FetchVehicleNameEvent(VendorId: _selectedVendorId??""));
                          _selectedVechicleNameId = reading.vehicleid?.toString() ?? '';
                        }
                      });
                    }
                  }
                }
              },
            ),
          ],
          child: BlocBuilder<AddMachineReadingBloc, AddMachineReadingState>(
            builder: (context, state) {
              return SafeArea(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  child: Column(
                    children: [
                      CustomAppbar(context,
                          title: "Add Machine Reading", subTitle: "Smart and fast operation"),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [

                                // subTitle("Tracks machine reading across daily operations."),
                                // const SizedBox(height: 20),
                                BlocBuilder<ProjectListBloc, ProjectListState>(
                                  builder: (context, state) {
                                    if (state is ProjectListLoadSuccess) {
                                      // find the coordinator whose id matches the selected id
                                      final selectedProject =
                                      state.projectLists.firstWhere((data) => data.project_id == selectedProjectId,
                                        orElse: () => ProjectListData(
                                            project_name: "",
                                          project_id: ""
                                        ),
                                      );
                                      return Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          subTitle("Mention Project Name"),
                                          TransferDropdown<ProjectListData>(
                                            title: 'Project Name',
                                            hint: 'Select Project Name',
                                            selectedVal: selectedProject.project_name ?? "",
                                            data: state.projectLists,
                                            displayText: (data) => data.project_name ?? '',
                                            onChanged: (val) {
                                              setState(() {
                                                selectedProjectId = val.project_id ?? "";
                                                print("selectedProjectId ${selectedProjectId}");
                                              });
                                            },
                                          ),
                                        ],
                                      );
                                    }
                                    return const SizedBox.shrink();
                                  },
                                ),
                                // date
                                // Divider(
                                //   color: Colors.grey.withOpacity(.2),
                                // ),
                                const SizedBox(height: 10),
                                subTitle("Mention machine Start,End Time and Date"),
                                const SizedBox(height: 10),
                                Container(
                                  // padding: const EdgeInsets.only(left: 10),
                                  child: Row(
                                    children: [
                                      CustomDateTimeTextField(
                                          onTap: pickStartTime,
                                          hint: _startTime == null
                                              ? '-- Start Time:--'
                                              : formatTimeWithSpace(_startTime!),
                                          icon: Icons.watch_later_outlined
                                      ),
                                      const SizedBox(width: 10),
                                      CustomDateTimeTextField(
                                          onTap: pickStopTime,
                                          hint: _stopTime == null
                                              ? '-- Stop Time:--'
                                              : formatTimeWithSpace(_stopTime!),
                                          icon: Icons.watch_later_outlined
                                      ),
                                    ],
                                  ),
                                ),
                                Text(
                                  "Select Date",
                                  style: const TextStyle(fontSize: 14, color: Colors.grey, fontWeight: FontWeight.w500),
                                ),
                                Row(
                                  children: [
                                    // tapping will call _pickDate via the CustomTextField onTap
                                    CustomDateTimeTextField(
                                      onTap: _pickDate,
                                      hint: _selectedDate == null ? '-- Date: --' : DateFormat("d MMMM y").format(_selectedDate!),
                                      icon: Icons.calendar_month,
                                    ),
                                  ],
                                ),
                                txtFiled(context,spentTime, "Enter spent time", "Spent Time"),
                                // const SizedBox(height: 10),
                                // Divider(
                                //   color: Colors.grey.withOpacity(.2),
                                // ),
                                const SizedBox(height: 10),
                                BlocConsumer<VendorNameBloc, VendorNameState>(
                                  listener: (context, state) {},
                                  builder: (context, state) {
                                    if (state is VendorNameLoadSuccess) {
                                      final selectedVendor = state.vendorNames.firstWhere(
                                            (coordinator) => coordinator.contractorId == _selectedVendorId,
                                        orElse: () => VendorData(
                                          contractorId: "",
                                          contractorName: "",
                                        ),
                                      );
                                      return Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          subTitle("Mention Vendor and Contractor Name",),
                                          const SizedBox(height: 10),
                                          TransferDropdown<VendorData>(
                                            title: 'Vendor/Contractor Name',
                                            hint: 'Select Vendor Name',
                                            // selectedVal: _selectedVendorId ?? '',
                                            selectedVal: selectedVendor.contractorName ?? '',
                                            data: state.vendorNames,
                                            displayText: (data) => data.contractorName ?? '',
                                            onChanged: (val) {
                                              setState(() {
                                                _selectedVendorId = val.contractorId ?? '';
                                                print("_selectedVendorId ${_selectedVendorId}");
                                              });
                                              BlocProvider.of<VehicleNameBloc>(context).add(FetchVehicleNameEvent(VendorId: _selectedVendorId??""));
                                            },
                                          ),
                                        ],
                                      );
                                    }
                                    // while loading show placeholder
                                    return Container(
                                      // margin: const EdgeInsets.only(bottom: 15),
                                      // child:  LinearProgressIndicator(
                                      //   color: ColorConstants.primary,
                                      // ),
                                    );
                                  },
                                ),
                                BlocConsumer<VehicleNameBloc, VehicleNameState>(
                                  listener: (context, state) {},
                                  builder: (context, state) {
                                    if (state is VehicleNameLoadSuccess) {
                                      final selectedVehicleName = state.data.firstWhere(
                                            (coordinator) => coordinator.VehicleID == _selectedVechicleNameId,
                                        orElse: () => VehicleData(
                                          VehicleID: "",
                                          VehicleName: "",
                                          VehicleNo: ""
                                        ),
                                      );
                                      return TransferDropdown<VehicleData>(
                                        title: 'Vehicle Name',
                                        hint: 'Select Vehicle Name',
                                        // selectedVal: selectedVehicleName.VehicleName ?? '',
                                        selectedVal: selectedVehicleName.VehicleName!.isNotEmpty
                                            ? "${selectedVehicleName.VehicleName} (${selectedVehicleName.VehicleNo})"
                                            : "",
                                        data: state.data,
                                        displayText: (data) => data.VehicleName ?? '',
                                        subDisplayText: (data) => data.VehicleNo ?? '',
                                        onChanged: (val) {
                                          setState(() {
                                            _selectedVechicleNameId = val.VehicleID ?? '';
                                            vehicleNo.text=val.VehicleName!;
                                            print("_selectedVechicleNameId ${_selectedVechicleNameId}");
                                          });
                                          // BlocProvider.of<VehicleNumberBloc>(context).add(FetchVehicleNumberEvent(VehicleId: _selectedVechicleNameId??""));
                                        },
                                      );
                                    }
                                    // while loading show placeholder
                                    return Container(
                                    );
                                  },
                                ),
                                const SizedBox(height: 10),
                                // Divider(
                                //   color: Colors.grey.withOpacity(.2),
                                // ),
                                // const SizedBox(height: 10),
                                subTitle("Mention start and stop reading",),
                                const SizedBox(height: 10),
                                txtFiled(context,startReading, "Enter reading on start", "Reading on Start", onChanged: (val) => _calculateTotalRun(),),
                                const SizedBox(height: 10),
                                txtFiled(context,stopReading, "Enter reading on stop", "Reading on Stop", onChanged: (val) => _calculateTotalRun(),),
                                const SizedBox(height: 10),
                                txtFiled(context,total_run, "Enter total run", "Total run",enable: false),
                                const SizedBox(height: 10),
                                txtFiled(context,vehicleNo, "Enter vehicle number", "Vehicle Number",enable: false),
                                const SizedBox(height: 10),
                                // description
                                txtFiled(context,description, "Enter Description", "Note", maxLines: 5),
                                const SizedBox(height: 10),
                                txtFiled(context,gatePass, "Enter Gate Pass Number ", "Gate Pass Number",),
                                const SizedBox(height: 10),
                                txtFiled(context,amount, "Enter Amount", "Amount",),
                                const SizedBox(height: 20),
                                PrimaryButton(
                                  title: _isSaving ? "Saving..." : "Save",
                                  onAction: _isSaving ? () {} : _onSavePressed,
                                ),
                                const SizedBox(height: 30),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          )
      ),
    );
  }

}
