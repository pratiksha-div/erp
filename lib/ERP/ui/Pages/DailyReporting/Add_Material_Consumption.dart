
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../../api/models/DAOGetMaterialConsumption.dart';
import '../../../api/models/DAOGetProjectList.dart';
import '../../../api/models/GetMaterialConsumptionByID.dart';
import '../../../bloc/DailyReporting/add_material_consumption_bloc.dart';
import '../../../bloc/DailyReporting/material_consumption_by_id_bloc.dart';
import '../../../bloc/DropDownValueBloc/material_consumption_used_bloc.dart';
import '../../../bloc/DropDownValueBloc/project_list_bloc.dart';
import '../../Utils/colors_constants.dart';
import '../../Utils/date_picker.dart';
import '../../Widgets/Custom_Button.dart';
import '../../Widgets/Custom_Date_Time_Picker.dart';
import '../../Widgets/Custom_Dialog.dart';
import '../../Widgets/Custom_Dropdown.dart';
import '../../Widgets/Custom_appbar.dart';
import '../../Widgets/Date_Formate.dart';
import '../../Widgets/TextWidgets.dart';

class MaterialEntry {
  final TextEditingController quantityController;
  TimeOfDay? outTime;
  String selectedMaterial;
  String? selectedMaterialId;
  String selectedUnit;
  String? selectedUnitId;
  int currentBalance;
  int remainingBalance;
  bool showQualityFields;
  final TextEditingController usedQuantityController;
  final TextEditingController scrapController;
  final TextEditingController rateController;
  final TextEditingController amountController;
  String? consumptionId; // server-side consumption id to track updates

  MaterialEntry({
    String initialMaterial = '',
    String initialUnit = '',
    this.currentBalance = 0,
    this.remainingBalance = 0,
    this.showQualityFields = false,
    this.consumptionId,
  })  : quantityController = TextEditingController(),
        usedQuantityController = TextEditingController(),
        scrapController = TextEditingController(),
        rateController = TextEditingController(),
        outTime = null,
        selectedMaterial = initialMaterial,
        selectedUnit = initialUnit,
        amountController = TextEditingController();

  void dispose() {
    quantityController.dispose();
    usedQuantityController.dispose();
    scrapController.dispose();
    rateController.dispose();
    amountController.dispose();
  }
}

// Page wrapper: provides AddMaterialConsumptionBloc locally (scoped to this page)
class AddMaterialConsumptionPage extends StatefulWidget {
  AddMaterialConsumptionPage({super.key, required this.id});
  String id;

  @override
  State<AddMaterialConsumptionPage> createState() => _AddMaterialConsumptionPageState();
}

class _AddMaterialConsumptionPageState extends State<AddMaterialConsumptionPage> {
  @override
  Widget build(BuildContext context) {
    // The other blocs (ProjectListBloc, MaterialConsumptionUsedBloc, MaterialConsumptionByIDBloc)
    // are assumed to be provided higher in the tree (main.dart).
    return BlocProvider<AddMaterialConsumptionBloc>(
      create: (_) => AddMaterialConsumptionBloc(),
      child: AddMaterialConsumption(id: widget.id),
    );
  }
}

// The main form widget
class AddMaterialConsumption extends StatefulWidget {
  AddMaterialConsumption({super.key, required this.id});
  String id;

  @override
  State<AddMaterialConsumption> createState() => _AddMaterialConsumptionState();
}

class _AddMaterialConsumptionState extends State<AddMaterialConsumption> {

  DateTime? _selectedDate;
  final TextEditingController gatePass = TextEditingController();
  final TextEditingController description = TextEditingController();
  final TextEditingController quantity = TextEditingController();
  final List<MaterialEntry> materialEntries = [];
  List<MaterialConsumptionUsedData> materialIssuedList = [];
  String? selectedProjectName;
  String? selectedProjectId;
  bool _isSaving = false;
  TimeOfDay? _selectedTime;
  bool _materialContextLocked = false;
  bool err_project=false;
  bool err_date_time=false;


  int _tryParseInt(dynamic v, {int fallback = 0}) {
    if (v == null) return fallback;
    if (v is int) return v;
    if (v is double) return v.toInt();
    return int.tryParse(v.toString()) ?? fallback;
  }

  double _tryParseDouble(dynamic v, {double fallback = 0}) {
    if (v == null) return fallback;
    if (v is double) return v;
    if (v is int) return v.toDouble();
    return double.tryParse(v.toString()) ?? fallback;
  }

  void getDate(String inputDate) {
    if (inputDate.isEmpty) return;

    // Define the input format (the format of the incoming date string)
    DateFormat inputFormat = DateFormat("MMMM, dd yyyy HH:mm:ss Z");
    try {
      DateTime parsedDate = inputFormat.parse(inputDate);
      DateFormat outputFormat = DateFormat("yyyy-MM-dd HH:mm:ss.SSS");
      String formattedDate = outputFormat.format(parsedDate);
      print(formattedDate);
      _selectedDate = parsedDate;
      _selectedTime = TimeOfDay(
        hour: parsedDate.hour,
        minute: parsedDate.minute,
      );
    } catch (e) {
      print('Error parsing date: $e');
    }
  }

  void _populateFromConsumption(List<MaterialConsumptionByID> items) {
    if (items.isEmpty) return;
    // Clear existing entries (dispose first)
    for (final me in materialEntries) {
      me.dispose();
    }
    materialEntries.clear();
    // Convert each returned row into a MaterialEntry
    for (final c in items) {
      final usedQtyStr = c.used_qauntity?.toString() ?? '';
      final balanceStr = c.balance_quantity?.toString() ?? '';
      final scrapStr = c.scrap?.toString() ?? '';
      final rateStr = c.rate?.toString() ?? '';
      final itemName = c.item?.toString() ?? '';
      final unitName = c.unit?.toString() ?? '';
      final currentBal = _tryParseInt(c.balance_quantity);
      final usedVal = _tryParseInt(c.used_qauntity);
      final scrapVal = _tryParseInt(c.scrap);
      final entry = MaterialEntry(
        initialMaterial: itemName,
        initialUnit: unitName,
        currentBalance: currentBal,
        remainingBalance: currentBal - usedVal - scrapVal,
        consumptionId: c.consumption_id?.toString(),
      );
      // set controller values
      entry.usedQuantityController.text = usedQtyStr;
      entry.quantityController.text = balanceStr;
      entry.scrapController.text = scrapStr;
      entry.rateController.text = rateStr;
      // calculate amount if possible
      final amt = _tryParseDouble(usedQtyStr) * _tryParseDouble(rateStr);
      entry.amountController.text = (amt == amt.roundToDouble()) ? amt.toInt().toString() : amt.toStringAsFixed(2);
      // set ids and unit
      entry.selectedMaterialId = c.material_id?.toString();
      entry.selectedUnit = c.unit?.toString() ?? '';
      if (entry.remainingBalance < 0) entry.remainingBalance = 0;
      materialEntries.add(entry);
    }
    final first = items.first;
    if (first.gatePass != null) gatePass.text = first.gatePass?.toString() ?? "";
    if (first.project_id != null && first.project_id.toString().isNotEmpty) {
      print("project id : ${first.project_id}");
      selectedProjectId = first.project_id?.toString();
    }
    if (first.date != null && first.date.toString().isNotEmpty) {
      print("date ${first.date}");
      getDate(first.date??"");
    }
    if (mounted) setState(() {});
  }

  Future<void> _pickDate() async {
    DateTime now = DateTime.now();

    final date = await showAppDatePicker(
      context: context,
      initialDate: _selectedDate??now,
      firstDate: DateTime(now.year - 5),
      lastDate: DateTime(now.year + 5),
    );

    if (date != null) {
      setState(() => _selectedDate = date);
      _tryFetchMaterialUsed();
    }
  }

  void addMaterialField() {
    if (!_materialContextLocked) {
      Fluttertoast.showToast(
        msg: "Please select Project, Date and Time first",
      );
      if (selectedProjectId == null || selectedProjectId!.isEmpty) {
        setState(() {
          err_project=true;
        });
      }
      if (_selectedDate == null){
        setState(() {
          err_date_time=true;
        });
      }
      return;
    }
    setState(() {
      materialEntries.add(MaterialEntry());
    });
  }

  void removeMaterialField(int index) {
    setState(() {
      materialEntries[index].dispose();
      materialEntries.removeAt(index);
    });
  }

  String? _validateForm() {
    if (selectedProjectId == null || selectedProjectId!.isEmpty) {
      return 'Please select a project';
    }
    if (_selectedDate == null) {
      return 'Please select a date';
    }
    if (materialEntries.isEmpty) {
      return 'Please add at least one material entry';
    }
    return null; // OK
  }

  void _onSavePressed() {
    final validationError = _validateForm();
    if (validationError != null) {
      showDialog(
        context: context,
        builder: (context) => Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          backgroundColor: Colors.transparent,
          child: UploadErrorCard(
            title: 'Failed',
            subtitle: validationError,
            onRetry: () {
              Navigator.pop(context);
            },
          ),
        ),
      );
      return;
    }
    setState(() {
      _isSaving = true;
    });

    final formattedDate = DateFormat('yyyy-MM-dd').format(_selectedDate!);
    for (final e in materialEntries) {
      final usedQty = e.usedQuantityController.text.trim().isNotEmpty
          ? e.usedQuantityController.text.trim()
          : e.quantityController.text.trim();

      final rateStr = e.rateController.text.trim();
      final double usedQnum = double.tryParse(usedQty) ?? 0;
      final double rateNum = double.tryParse(rateStr) ?? 0;
      final double amtNum = usedQnum * rateNum;
      final String consumedAmount = amtNum == amtNum.roundToDouble()
          ? amtNum.toInt().toString()
          : amtNum.toStringAsFixed(2);
      final String project_id = selectedProjectId ?? "";
      final String date = formattedDate;
      final String gatePassValue = gatePass.text.trim();
      final String consumedMaterialValue = e.selectedMaterialId ?? e.selectedMaterial;
      final String item = e.selectedMaterial;
      // final String balanceQuantity = e.currentBalance.toString();
      final String balanceQuantity = e.remainingBalance.toString();
      final String consumedUnit = e.selectedUnit ?? "";
      final String usedQuantity = usedQty;
      final String consumedScrap = e.scrapController.text.trim();
      final String consumedRate = rateStr;
      final String consumedAmountStr = consumedAmount;

      print("balanceQuantity ${balanceQuantity}");
      context.read<AddMaterialConsumptionBloc>().add(
        SubmitAddMaterialConsumptionEvent(
          project_id: project_id,
          date: date,
          gatePass: gatePassValue,
          consumedMaterial: consumedMaterialValue,
          item: item,
          balanceQuantity: balanceQuantity,
          consumedUnit: consumedUnit,
          usedQuantity: usedQuantity,
          consumedScrap: consumedScrap,
          consumedRate: consumedRate,
          consumedAmount: consumedAmountStr,
          consumption_id: e.consumptionId ?? widget.id,
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    print("ID : ${widget.id}");
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProjectListBloc>().add(const FetchProjectListsEvent());
      if (widget.id.isNotEmpty) {
        try {
          context.read<MaterialConsumptionByIDBloc>().add(FetchMaterialConsumptionByIDEvent(consumption_id: widget.id));
        } catch (_) {}
      }
      context.read<ProjectListBloc>().add(const FetchProjectListsEvent());
      // context.read<MaterialConsumptionUsedBloc>().add(FetchMaterialConsumptionUsedEvent(projectId: '',consumedDate: ''));
    });
  }

  @override
  void dispose() {
    gatePass.dispose();
    description.dispose();
    quantity.dispose();
    for (final me in materialEntries) {
      me.dispose();
    }
    materialEntries.clear();
    super.dispose();
  }

  void _tryFetchMaterialUsed() {
    if (selectedProjectId == null || _selectedDate == null) {
      return;
    }

    // If time is required, enforce it
    if (_selectedTime == null) {
      return;
    }

    final DateTime combinedDateTime = DateTime(
      _selectedDate!.year,
      _selectedDate!.month,
      _selectedDate!.day,
      _selectedTime!.hour,
      _selectedTime!.minute,
    );

    final String isoDate =
    DateFormat("yyyy-MM-dd'T'HH:mm").format(combinedDateTime);

    print("API DATE → $isoDate");

    context.read<MaterialConsumptionUsedBloc>().add(
      FetchMaterialConsumptionUsedEvent(
        projectId: selectedProjectId!,
        consumedDate: isoDate,
      ),
    );
  }

  String convertToIsoFormat(String input) {
    DateFormat inputFormat = DateFormat("yyyy-MM-dd HH:mm");
    DateTime dateTime = inputFormat.parse(input);
    DateFormat outputFormat = DateFormat("yyyy-MM-dd'T'HH:mm");
    print("outputFormat ${outputFormat}");
    return outputFormat.format(dateTime);
  }

  Future<void> _pickTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: ColorConstants.primary,
              tertiary: ColorConstants.primary,
              secondary: ColorConstants.primary,
              onPrimary: Colors.white,
              onSurface: ColorConstants.primary,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: ColorConstants.primary,
              ),
            ),
            timePickerTheme: TimePickerThemeData(
              backgroundColor: Colors.white,
              hourMinuteTextStyle: GoogleFonts.poppins(
                fontSize: 25,
                color: ColorConstants.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (time != null) {
      setState(() {
        _selectedTime = time;
        err_date_time=false;
      });
      print("_selectedTime ${_selectedTime}");
      _tryFetchMaterialUsed();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.background,
      body: MultiBlocListener(
        listeners: [
          BlocListener<AddMaterialConsumptionBloc, AddMaterialConsumptionState>(
            listener: (context, state) {
              if (state is AddMaterialConsumptionSuccess) {
                // If saved successfully, pop back
                Navigator.pop(context,"true");
                Fluttertoast.showToast(msg: state.message);
                setState(() {
                  _isSaving = false;
                });
              }
              else if (state is AddMaterialConsumptionFailed) {
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) => Dialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    backgroundColor: Colors.transparent,
                    child: UploadErrorCard(
                      title: "Failed to Add Material Consumption",
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
          BlocListener<MaterialConsumptionByIDBloc, MaterialConsumptionByIDState>(
            listener: (context, state) {
              if (state is MaterialConsumptionByIDLoadSuccess) {
                if (widget.id != "") {
                  final list = state.materialConsumptionByID;
                  if (list.isNotEmpty) {
                    // populate UI fields and entries
                    _populateFromConsumption(list);
                  }
                }
              } else if (state is MaterialConsumptionByIDFailure) {
                // Fluttertoast.showToast(msg: state.message ?? "Failed to load consumption data");
              }
            },
          ),
        ],
        child: BlocBuilder<AddMaterialConsumptionBloc, AddMaterialConsumptionState>(
          builder: (context, state) {
            return SafeArea(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                child: Column(
                  children: [
                    CustomAppbar(context, title: "Add Material Consumption", subTitle: "Tracks material inflow and consumption"),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 20),
                            BlocBuilder<ProjectListBloc, ProjectListState>(
                              builder: (context, state) {
                                if (state is ProjectListLoadSuccess) {
                                  final selectedProject = state.projectLists.firstWhere(
                                        (data) => data.project_id == selectedProjectId,
                                    orElse: () => ProjectListData(project_name: "", project_id: ""),
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
                                        onChanged: _materialContextLocked
                                            ? null // 🔒 disable
                                            : (val) {
                                          setState(() {
                                            selectedProjectId = val.project_id ?? "";
                                            err_project=false;
                                          });
                                          _tryFetchMaterialUsed();
                                        },
                                      ),
                                      if(err_project)
                                      errorText("Please select project")
                                    ],
                                  );
                                }
                                return const SizedBox.shrink();
                              },
                            ),
                            const SizedBox(height: 10),
                            txtFiled(context, gatePass, "Gate Pass(daily Usage)", "Gate Pass"),
                            const SizedBox(height: 20),
                            Row(
                              children: [
                                CustomDateTimeTextField(
                                    onTap: _materialContextLocked ? null : _pickDate,
                                    hint: _selectedDate == null
                                        ? '-- Date --'
                                        : DateFormat("d MMMM y")
                                        .format(_selectedDate!),
                                    icon: Icons.calendar_month),
                                const SizedBox(width: 10),
                                CustomDateTimeTextField(
                                    onTap: _materialContextLocked ? null : _pickTime,
                                    title: "Select Time",
                                    hint: _selectedTime == null
                                        ? '-- Time --'
                                        : formatTimeWithSpace(
                                        _selectedTime!),
                                    icon: Icons.watch_later_outlined),
                              ],
                            ),
                            if(err_date_time)
                              errorText("Please select date and time"),
                            const SizedBox(height: 10),
                            BlocListener<MaterialConsumptionUsedBloc, MaterialConsumptionUsedState>(
                              listener: (context, state) {
                                if (state is MaterialConsumptionUsedLoadSuccess) {
                                  setState(() {
                                    materialIssuedList = state.materials;
                                    _materialContextLocked = true;
                                  });
                                } else if (state is MaterialConsumptionUsedFailure) {
                                  // Fluttertoast.showToast(msg: "Failed to load issued materials");
                                }
                              },
                              child: const SizedBox.shrink(),
                            ),
                            for (int i = 0; i < materialEntries.length; i++) _buildMaterialEntryCard(i),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                SecondaryButton(title: "Add Material", onAction: addMaterialField),
                              ],
                            ),
                            const SizedBox(height: 20),
                            PrimaryButton(
                              title: _isSaving ? "Saving..." : "Save",
                              onAction: _isSaving ? () {} : _onSavePressed,
                            ),
                            const SizedBox(height: 30),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildMaterialEntryCard(int i) {
    final entry = materialEntries[i];
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: ColorConstants.primary.withOpacity(.01),
        borderRadius: BorderRadius.circular(5),
        border: Border.all(width: 1, color: ColorConstants.primary.withOpacity(.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TransferDropdown<MaterialConsumptionUsedData>(
            title: 'Material Used',
            hint: 'Select Material',
            selectedVal: entry.selectedMaterial,
            data: materialIssuedList,
            displayText: (d) => d.material_used ?? '',
            onChanged: (MaterialConsumptionUsedData selected) {
              final display = selected.material_used ?? '';
              setState(() {
                entry.selectedMaterial = display;
                entry.selectedMaterialId = selected.material_id?.toString();
                entry.currentBalance = int.tryParse(selected.balance?.toString() ?? '0') ?? 0;
                entry.quantityController.text = '0';
                entry.remainingBalance = entry.currentBalance;
              });
            },
          ),
          Text(
           "${entry.selectedMaterial}",
            style: const TextStyle(fontSize: 14, color: Colors.black),
          ),
          // Text(
          //   _materialContextLocked
          //       ? "(Project, date & time locked)"
          //       : "(Please select project name, date, time)",
          //   style: const TextStyle(fontSize: 12, color: Colors.grey),
          // ),
          const SizedBox(height: 20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Current Bal", style: TextStyle(fontSize: 14, color: Colors.grey, fontWeight: FontWeight.w500)),
                  const SizedBox(height: 5),
                  Container(
                    width: 100,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: ColorConstants.primary.withOpacity(.1)),
                    child: Center(
                      child: Text("${entry.currentBalance}", style: const TextStyle(fontSize: 14, color: Colors.black, fontWeight: FontWeight.w500)),
                    ),
                  )
                ],
              ),
              const SizedBox(width: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Used Quantity", style: TextStyle(fontSize: 14, color: Colors.grey, fontWeight: FontWeight.w500)),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      Container(
                        height: 35,
                        width: 100,
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade400), borderRadius: BorderRadius.circular(5)),
                        child: TextField(
                          controller: entry.usedQuantityController,
                          keyboardType: TextInputType.number,
                          cursorColor: ColorConstants.primary,
                          style: const TextStyle(color: Colors.black54, fontSize: 14),
                          decoration: const InputDecoration(border: InputBorder.none, contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10)),
                          onChanged: (val) {
                            int entered = int.tryParse(val) ?? 0;
                            final current = entry.currentBalance;
                            if (entered < 0) entered = 0;
                            if (entered > current) {
                              entered = current;
                              entry.usedQuantityController.text = entered.toString();
                              entry.usedQuantityController.selection = TextSelection.collapsed(offset: entered.toString().length);
                              Fluttertoast.showToast(msg: 'Quantity cannot exceed balance ($current)');
                            }
                            setState(() {
                              final scrapNow = int.tryParse(entry.scrapController.text) ?? 0;
                              entry.remainingBalance = current - entered - scrapNow;
                              if (entry.remainingBalance < 0) entry.remainingBalance = 0;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Scrap", style: TextStyle(fontSize: 14, color: Colors.grey, fontWeight: FontWeight.w500)),
                  const SizedBox(height: 5),
                  Container(
                    height: 35,
                    width: 100,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade400), borderRadius: BorderRadius.circular(5)),
                    child: TextField(
                      controller: entry.scrapController,
                      keyboardType: TextInputType.number,
                      cursorColor: ColorConstants.primary,
                      style: const TextStyle(color: Colors.black54, fontSize: 14),
                      decoration: const InputDecoration(border: InputBorder.none, contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10)),
                      onChanged: (val) {
                        int scrapEntered = int.tryParse(val) ?? 0;
                        final current = entry.currentBalance;
                        if (scrapEntered < 0) scrapEntered = 0;
                        final usedNow = int.tryParse(entry.usedQuantityController.text) ?? 0;
                        final maxAllowedForScrap = (current - usedNow) < 0 ? 0 : (current - usedNow);

                        if (scrapEntered > maxAllowedForScrap) {
                          scrapEntered = maxAllowedForScrap;
                          entry.scrapController.text = scrapEntered.toString();
                          entry.scrapController.selection = TextSelection.collapsed(offset: scrapEntered.toString().length);
                          Fluttertoast.showToast(msg: 'Scrap cannot make used+scrap exceed balance ($current)');
                        }

                        setState(() {
                          entry.remainingBalance = current - usedNow - scrapEntered;
                          if (entry.remainingBalance < 0) entry.remainingBalance = 0;
                        });
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 20),
              txtField(context, "Rate", entry.rateController, onChange: (val) {
                final rate = double.tryParse(val) ?? 0;
                final usedQty = int.tryParse(entry.usedQuantityController.text) ?? 0;
                final amt = rate * usedQty;
                setState(() {
                  entry.amountController.text = amt.toStringAsFixed(2);
                });
              }),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                const Text("Amount", style: TextStyle(fontSize: 14, color: Colors.grey, fontWeight: FontWeight.w500)),
                const SizedBox(height: 5),
                Container(
                  width: 100,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: ColorConstants.primary.withOpacity(.1)),
                  child: Center(
                    child: Text(
                          () {
                        final q = double.tryParse(entry.usedQuantityController.text) ?? 0;
                        final r = double.tryParse(entry.rateController.text) ?? 0;
                        final amt = q * r;
                        if (amt == amt.roundToDouble()) return amt.toInt().toString();
                        return amt.toStringAsFixed(2);
                      }(),
                      style: const TextStyle(fontSize: 14, color: Colors.black, fontWeight: FontWeight.w500),
                    ),
                  ),
                )
              ]),
              InkWell(
                onTap: () => removeMaterialField(i),
                child: Container(
                  height: 40,
                  margin: const EdgeInsets.only(top: 15),
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(border: Border.all(width: 1, color: ColorConstants.primary.withOpacity(.3)), borderRadius: BorderRadius.circular(5)),
                  child: Row(children: [cText("Remove", color: ColorConstants.primary), const SizedBox(width: 10), Icon(Icons.close, color: ColorConstants.primary, size: 15)]),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

}
