import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../../api/models/DAOGetProjectCoordinator.dart';
import '../../../api/models/DAOProjectType.dart';
import '../../../bloc/DropDownValueBloc/project_coordinator_bloc.dart';
import '../../../bloc/DropDownValueBloc/project_type_bloc.dart';
import '../../../bloc/DropDownValueBloc/registered_customer_bloc.dart';
import '../../../bloc/ProjectBloc/add_project_bloc.dart';
import '../../../bloc/ProjectBloc/get_project_data_bloc.dart';
import '../../Utils/date_picker.dart';
import '../../Widgets/Custom_appbar.dart';
import '../../Widgets/TextWidgets.dart';
import '../../../api/models/DAOGetStates.dart';
import '../../../bloc/DropDownValueBloc/project_manager_bloc.dart';
import '../../../bloc/DropDownValueBloc/states_bloc.dart';
import '../../Widgets/Custom_Date_Time_Picker.dart';
import '../../Widgets/Custom_Dialog.dart';
import '../../Widgets/Custom_Dropdown.dart';
import '../../Widgets/Custom_Button.dart';
import '../../Utils/colors_constants.dart';

class AddProject extends StatefulWidget {
  AddProject({super.key, required this.projectId,this.isEditable=true});
  String projectId;
  bool isEditable;

  @override
  State<AddProject> createState() => _AddProjectState();
}

class _AddProjectState extends State<AddProject> {
  DateTime? _selectedStartDate;
  DateTime? _selectedEndDate;
  final TextEditingController customerName = TextEditingController();
  final TextEditingController projectName = TextEditingController();
  final TextEditingController expectedCost = TextEditingController();
  final TextEditingController description = TextEditingController();
  final TextEditingController address = TextEditingController();
  String? selectedCoordinatorId;
  String? selectedManagerId;
  String? selectedProjectTypeId;
  String? selectedStatusId;
  String? selectedStateId;
  bool godown_list = false;
  bool _isSubmitting = false;
  String selectedstatus = "";


  String? err_customerName;
  String? err_projectName;
  String? err_status;
  String? err_project_type;
  String? err_start_date;

  final status = ['Enabled', 'Disabled'];

  Future<void> _pickStartDate() async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    DateTime firstDate = DateTime(1900, 1, 1);
    DateTime lastDate = DateTime(2100, 12, 31);

    DateTime initial = _selectedStartDate ?? today;

    if (initial.isBefore(firstDate)) initial = firstDate;
    if (initial.isAfter(lastDate)) initial = lastDate;

    final picked = await showAppDatePicker(
      context: context,
      initialDate: initial,
      firstDate: firstDate,
      lastDate: lastDate,
    );

    if (picked != null) {
      setState(() {
        _selectedStartDate = picked;
        err_start_date=null;

        if (_selectedEndDate != null &&
            _selectedEndDate!.isBefore(_selectedStartDate!)) {
          _selectedEndDate = null;
        }
      });
    }
  }

  Future<void> _pickEndDate() async {
    final now = DateTime.now();
    DateTime firstDate = now;
    DateTime lastDate = DateTime(now.year + 5);
    if (_selectedStartDate != null) {
      firstDate = _selectedStartDate!;
    }
    DateTime initial = _selectedEndDate ?? firstDate;
    if (initial.isBefore(firstDate)) initial = firstDate;
    if (initial.isAfter(lastDate)) initial = lastDate;
    final picked = await showAppDatePicker(
      context: context,
      initialDate: initial,
      firstDate: firstDate,
      lastDate: lastDate,
    );

    if (picked != null) {
      setState(() {
        _selectedEndDate = picked;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    BlocProvider.of<ProjectCoordinatorBloc>(context).add(FetchProjectCoordinatorsEvent());
    BlocProvider.of<ProjectManagerBloc>(context).add(FetchProjectManagersEvent());
    BlocProvider.of<AllStatesBloc>(context).add(FetchAllStatesEvent());
    BlocProvider.of<ProjectTypeBloc>(context).add(FetchProjectTypesEvent());
    BlocProvider.of<ProjectDataBloc>(context).add(FetchProjectDataEvent(projectId: widget.projectId));
    BlocProvider.of<RegisteredCustomerBloc>(context).add(FetchRegisteredCustomerEvent(value: ""));
    print("Product Id: ${widget.projectId}");
  }

  bool _validateForm() {

    bool valid = true;
    err_customerName = null;
    err_projectName=null;
    err_project_type=null;
    err_status=null;
    err_start_date=null;

    if(customerName.text.isEmpty){
      err_customerName="Please Select Customer Name";
      valid=false;
    }
    if (projectName.text.isEmpty) {
      err_projectName = "Please Select Project";
      valid = false;
    }
    if (_selectedStartDate == null) {
      err_start_date = "Please Select Date";
      valid = false;
    }
    // if (selectedProjectTypeId == null || selectedProjectTypeId!.isEmpty) {
    //   err_project_type = "Please Select Project Type";
    //   valid = false;
    // }
    if(selectedstatus==null || selectedstatus!.isEmpty){
      err_status="Please select Status";
      valid=false;
    }
    setState(() {
      _isSubmitting = false;
    });
    return valid;
  }

  void _onSavePressed() {
    setState(() { _isSubmitting = true; });
    if (!_validateForm()) {
      showErrorDialog(context, "Failed", "Please fill required fields");
      return;
    }
    print("projectId ${widget.projectId}");
    print("selectedstatus ${selectedstatus}");
    context.read<AddProjectBloc>().add(
          SubmitAddProjectEvent(
            customerName: customerName.text,
            projectName: projectName.text,
            projectCoordinator: selectedCoordinatorId ?? "",
            projectManager: selectedManagerId ?? "",
            projectType: selectedProjectTypeId ?? "",
            endDate: DateFormat('dd-MM-yyyy').format(_selectedEndDate!),
            startDate: DateFormat('dd-MM-yyyy').format(_selectedStartDate!),
            Expected_Cost: expectedCost.text,
            Status: (selectedstatus=="Enabled" || selectedstatus=="enabled")? "enabled":"disabled",
            state: selectedStateId ?? "",
            Address: address.text,
            godownlist: godown_list ? "1" : "0",
            project_dscription: description.text,
            project_id: widget.projectId.isNotEmpty? widget.projectId:""
          ),
    );
  }

  void getDate(String inputDate) {
    if (inputDate.isEmpty) return;
    DateFormat inputFormat = DateFormat("MMMM, dd yyyy HH:mm:ss Z");
    try {
      DateTime parsedDate = inputFormat.parse(inputDate);
      DateFormat outputFormat = DateFormat("yyyy-MM-dd HH:mm:ss.SSS");
      String formattedDate = outputFormat.format(parsedDate);
      print(formattedDate);
      _selectedStartDate = parsedDate;
      _selectedEndDate = parsedDate;
    } catch (e) {
      print('Error parsing date: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.background,
      body: MultiBlocListener(
        listeners: [
          BlocListener<AddProjectBloc, AddProjectState>(
            listener: (context, state) {
              if (state is AddProjectSuccess) {
                Navigator.pop(context, "true");
                setState(() { _isSubmitting = false; });
              }
              else if (state is AddProjectFailed) {
                setState(() { _isSubmitting = false; });
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) => Dialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    backgroundColor: Colors.transparent,
                    child: UploadErrorCard(
                      title: "Failed to Add Project",
                      subtitle: state.message,
                      onRetry: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                );
                // show failure dialog
              } else if (state is AddProjectLoading) {
                // optionally set _isSubmitting = true;
              }
            },
          ),
          BlocListener<ProjectDataBloc, ProjectDataState>(
            listener: (context, state) {
              if (state is ProjectDataLoadSuccess) {
                // choose which element from the list to use (first example)
                if(widget.projectId!=""){
                final projectData = state.projectData.isNotEmpty
                    ? state.projectData.first
                    : null;
                if (projectData != null) {
                  customerName.text = projectData.customerName ?? '';
                  projectName.text = projectData.project_name ?? '';
                  expectedCost.text = projectData.Expected_Cost ?? "";
                  description.text = projectData.project_dscription ?? "";
                  address.text = projectData.Address ?? "";

                  selectedCoordinatorId = projectData.ProjectCo_ordinator;
                  selectedManagerId = projectData.project_manager;
                  selectedProjectTypeId = projectData.project_type;
                  // selectedStatusId = projectData.Status;
                  selectedstatus=projectData.Status??"";
                  selectedStateId = projectData.state;
                  getDate(projectData.project_start_date??"");
                  getDate(projectData.project_end_date??"");
                  godown_list = projectData.godownlist == "1";
                  setState(() {});
                }
              }}
              // if (state is ProjectDataFailure) {
              //   // Optionally show an error
              //   ScaffoldMessenger.of(context).showSnackBar(
              //     SnackBar(
              //         content:
              //             Text('Failed to load project data: ${state.error}')),
              //   );
              // }
            },
          ),
        ],
        child: BlocBuilder<AddProjectBloc, AddProjectState>(
            builder: (context, state) {
          final bool isLoading = state is AddProjectLoading;
          final bool isSuccess = state is AddProjectSuccess;
          return SafeArea(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  // 🔹 App Bar
                  CustomAppbar(
                    context,
                    title: "Add New Project",
                    subTitle: "Manage your construction projects",
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 20),
                            subTitle("Mention project information"),
                            // 🔹 Customer Name
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              txtFiled(
                                context,
                                customerName,
                                "Enter Customer Name",
                                "Customer Name",
                                onChanged: (value) {
                                  setState(() {
                                    err_customerName=null;
                                  });
                                  if (value.trim().isEmpty) {
                                    context
                                        .read<RegisteredCustomerBloc>()
                                        .add(ClearRegisteredCustomerEvent());
                                    return;
                                  }

                                  if (value.trim().length >= 2) {
                                    context.read<RegisteredCustomerBloc>().add(
                                      FetchRegisteredCustomerEvent(value: value),
                                    );
                                  }
                                },
                                enable: widget.isEditable
                              ),
                              if(err_customerName != null)
                                errorText("Please enter customer name"),
                              BlocBuilder<RegisteredCustomerBloc, RegisteredCustomerState>(
                                builder: (context, state) {
                                  // ❌ hide if text empty
                                  if (customerName.text.trim().isEmpty) {
                                    return const SizedBox();
                                  }

                                  if (state is RegisteredCustomerLoading) {
                                    return Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: LinearProgressIndicator(
                                        color: ColorConstants.primary,
                                        backgroundColor: Colors.grey.withOpacity(.3),
                                      ),
                                    );
                                  }

                                  if (state is RegisteredCustomerLoadSuccess &&
                                      state.regCustomer.isNotEmpty) {
                                    return txtSuggestionList(
                                      customerName,
                                      state.regCustomer,
                                      context,
                                    );
                                  }

                                  return const SizedBox();
                                },
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                            // 🔹 Project Name
                            txtFiled(context, projectName, "Enter Project Name",
                                "Project Name",onChanged: (val){
                                  setState(() {
                                    err_projectName=null;
                                  });
                                },enable: widget.isEditable),
                            if(err_projectName != null)
                              errorText("Please enter project name"),
                            const SizedBox(height: 10),
                            // 🔹 Project Coordinator Dropdown
                            BlocBuilder<ProjectCoordinatorBloc, ProjectCoordinatorState>(
                              builder: (context, state) {
                                if (state is ProjectCoordinatorLoadSuccess) {
                                  // find the coordinator whose id matches the selected id
                                  final selectedCoordinator = state.ProjectCoordinators.firstWhere(
                                        (coordinator) => coordinator.EmployeeId == selectedCoordinatorId,
                                    orElse: () => ProjectCoordinateData(
                                      EmployeeId: "",
                                      EmployeeName: "",
                                    ),
                                  );

                                  return TransferDropdown<ProjectCoordinateData>(
                                    title: 'Project Co-ordinator',
                                    hint: 'Select Project Co-ordinator',
                                    selectedVal: selectedCoordinator.EmployeeName ?? "",
                                    data: state.ProjectCoordinators,
                                    displayText: (data) => data.EmployeeName ?? '',
                                    isEditable:widget.isEditable,
                                    onChanged: (val) {
                                      setState(() {
                                        selectedCoordinatorId = val.EmployeeId ?? "";
                                      });
                                    },
                                  );
                                }
                                return const SizedBox.shrink();
                              },
                            ),
                            // 🔹 Project Manager Dropdown
                            BlocBuilder<ProjectManagerBloc,
                                ProjectManagerState>(
                              builder: (context, state) {
                                if (state is ProjectManagerLoadSuccess) {
                                  final selectedManager = state.ProjectManagers.firstWhere(
                                        (data) => data.EmployeeId == selectedManagerId,
                                    orElse: () => ProjectCoordinateData(EmployeeId: "", EmployeeName: ""),
                                  );
                                  return TransferDropdown<
                                      ProjectCoordinateData>(
                                    title: 'Project Manager',
                                    hint: 'Select Project Manager',
                                    selectedVal: selectedManager.EmployeeName??"",
                                    // selectedVal: selectedManagerId ?? '',
                                    data: state.ProjectManagers,
                                    displayText: (employee) =>
                                        employee.EmployeeName ?? '',
                                    isEditable:widget.isEditable,
                                    onChanged: (val) {
                                      setState(() {
                                        selectedManagerId = val.EmployeeId ?? "";
                                      });
                                    },
                                  );
                                }
                                return const SizedBox.shrink();
                              },
                            ),
                            // 🔹 Project Type
                            BlocBuilder<ProjectTypeBloc, ProjectTypeState>(
                              builder: (context, state) {
                                if (state is ProjectTypeLoadSuccess) {
                                  final selectedProjectType = state.ProjectTypes.firstWhere(
                                        (data) => data.LookupDataId == selectedProjectTypeId,
                                    orElse: () => ProjectTypeData(LookupDataId: "", LookupValue: ""),
                                  );
                                  // print("state.ProjectTypes ${jsonEncode(state.ProjectTypes)}");
                                  // print("selectedProjectTypeId ${selectedProjectTypeId}");
                                  // print("selectedProjectType ${selectedProjectType.LookupDataId} ${selectedProjectType.LookupValue}");
                                  return TransferDropdown<ProjectTypeData>(
                                    title: 'Project Type',
                                    hint: 'Select Project Type',
                                    // selectedVal: selectedProjectTypeId ?? '',
                                    selectedVal: selectedProjectType.LookupValue ?? '',
                                    data: state.ProjectTypes,
                                    displayText: (employee) => employee.LookupValue ?? '',
                                    isEditable:widget.isEditable,
                                    onChanged: (val) {
                                      setState(() {
                                        selectedProjectTypeId = val.LookupDataId ?? "";
                                        err_project_type=null;
                                        // print("selectedProjectTypeId $selectedProjectTypeId");
                                      });
                                    },
                                  );
                                }

                                return Container(
                                  margin: const EdgeInsets.only(bottom: 15),
                                  child: const LinearProgressIndicator(
                                    color: ColorConstants.primary,
                                  ),
                                );
                              },
                            ),
                            const SizedBox(height: 10),
                            subTitle("Mention Status & Cost Detail"),
                            // 🔹 Expected Cost
                            txtFiled(context, expectedCost,
                                "Enter Expected Cost", "Expected Cost",isNumber:true),
                            const SizedBox(height: 10),
                            TransferDropdown<String>(
                              title: "Status",
                              hint: 'Select status',
                              selectedVal: selectedstatus,
                              data: status,
                              displayText: (t) => t,
                              isEditable:widget.isEditable,
                              onChanged: (val) {
                                selectedstatus = val;
                                err_status=null;
                                print("selectedstatus $selectedstatus");
                                setState(() {});
                              },
                            ),
                            if(err_status != null)
                             errorText("Please select status"),
                             // Divider(color: Colors.grey.withOpacity(.4)),
                            const SizedBox(height: 10),
                            // 🔹 Dates
                            subTitle("Mention start and end date"),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CustomDateTimeTextField(
                                      onTap: _pickStartDate,
                                      hint: _selectedStartDate == null
                                          ? 'Start Date'
                                          : DateFormat("d MMMM y")
                                          .format(_selectedStartDate!),
                                      title: "Start Date",
                                      showTitle: true,
                                      icon: Icons.calendar_month,
                                      isEdit: widget.isEditable,
                                    ),
                                    if(err_start_date != null)
                                    errorText("Start date is required"),
                                  ],
                                ),
                                const SizedBox(width: 10),
                                CustomDateTimeTextField(
                                  onTap: _pickEndDate,
                                  hint: _selectedEndDate == null
                                      ? 'End Date'
                                      : DateFormat("d MMMM y")
                                      .format(_selectedEndDate!),
                                  showTitle: true,
                                  title: "End Date",
                                  icon: Icons.calendar_month,
                                  isEdit: widget.isEditable,
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            // 🔹 Description
                            txtFiled(context, description, "Enter Description", "Project Description", maxLines: 3,enable: widget.isEditable),
                            const SizedBox(height: 10),
                            BlocBuilder<AllStatesBloc, AllStatesState>(
                              builder: (context, state) {
                                if (state is AllStatesLoadSuccess) {
                                  final selectedState = state.allstates.firstWhere(
                                        (data) => data.state_id == selectedStateId,
                                    orElse: () => StatesData(state_id: "", state_name: ""),
                                  );
                                  return TransferDropdown<StatesData>(
                                    title: 'States',
                                    hint: 'Select State',
                                    selectedVal: selectedState.state_name ?? '',
                                    data: state.allstates,
                                    displayText: (employee) =>
                                    employee.state_name ?? '',
                                    isEditable:widget.isEditable,
                                    onChanged: (val) {
                                      setState(() {
                                        selectedStateId = val.state_id ?? "";
                                      });
                                    },
                                  );
                                }
                                return const SizedBox.shrink();
                              },
                            ),
                            // 🔹 Address
                            txtFiled(
                                context, address, "Enter Address", "Address",enable: widget.isEditable),
                            const SizedBox(height: 20),
                            // 🔹 Godown Listing
                            InkWell(
                              onTap: () {
                                godown_list = !godown_list;
                                setState(() {});
                              },
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 20,
                                    height: 20,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      gradient: godown_list
                                          ? const LinearGradient(
                                              colors: [
                                                ColorConstants.primary,
                                                ColorConstants.secondary,
                                              ],
                                              begin: Alignment.topCenter,
                                              end: Alignment.bottomCenter,
                                            )
                                          : null,
                                      color: godown_list
                                          ? ColorConstants.primary
                                          : Colors.transparent,
                                      border: Border.all(
                                        color: godown_list
                                            ? ColorConstants.primary
                                            : Colors.black54,
                                      ),
                                    ),
                                    child: Center(
                                      child: Icon(
                                        Icons.check,
                                        color: godown_list
                                            ? Colors.black
                                            : Colors.black,
                                        size: 13,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    "Godown Listing",
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 20),
                            // 🔹 Submit Button
                            if(widget.isEditable)
                            PrimaryButton(
                              title:
                              _isSubmitting ? "Saving..." : "Save",
                              onAction:
                              _isSubmitting ? () {} : _onSavePressed,
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
        }),
      ),
    );
  }
}
