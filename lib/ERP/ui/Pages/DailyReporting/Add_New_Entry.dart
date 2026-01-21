import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../../api/models/DAOGetEmployee.dart';
import '../../../api/models/DAOGetEmployeeType.dart';
import '../../../api/models/DAOGetProjectList.dart';
import '../../../bloc/DailyReporting/add_new_entry_bloc.dart';
import '../../../bloc/DailyReporting/entry_by_id_bloc.dart';
import '../../../bloc/DropDownValueBloc/employee_type_bloc.dart';
import '../../../bloc/DropDownValueBloc/emplyee_list_bloc.dart';
import '../../../bloc/DropDownValueBloc/project_list_bloc.dart';
import '../../Utils/colors_constants.dart';
import '../../Utils/date_picker.dart';
import '../../Widgets/Custom_Date_Time_Picker.dart';
import '../../Widgets/Custom_Dropdown.dart';
import '../../Widgets/Custom_Button.dart';
import '../../Widgets/Custom_appbar.dart';
import '../../Widgets/Custom_Dialog.dart';
import '../../Widgets/TextWidgets.dart';

class AddNewEntry extends StatefulWidget {
  AddNewEntry({super.key, required this.id});
  String id;

  @override
  State<AddNewEntry> createState() => _AddNewEntryState();
}

class _AddNewEntryState extends State<AddNewEntry> {
  DateTime? _selectedDate;
  final TextEditingController projectName = TextEditingController();
  final TextEditingController description = TextEditingController();
  final TextEditingController employeeName = TextEditingController();

  String? selectedProjectName;
  String? selectedProjectId;

  // employee type selection
  String? _selectedEmployeeTypeId;
  String? _selectedEmployeeTypeName;

  // employee selection
  String? _selectedEmployeeId;
  String? _selectedEmployeeName;

  bool _isSubmitting = false;

  // INLINE FIELD ERRORS
  String? projectError;
  String? dateError;
  String? employeeTypeError;
  String? employeeError;


  Future<void> _pickDate() async {
    DateTime now = DateTime.now();
    final date = await showAppDatePicker(
      context: context,
      initialDate: _selectedDate??now,
      firstDate: DateTime(now.year - 5),
      lastDate: DateTime(now.year + 5),
    );

    if (date != null && mounted) {
      setState(() {
        _selectedDate = date;
        dateError = null;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    BlocProvider.of<EmployeeBloc>(context).add(const FetchEmployeesEvent());
    BlocProvider.of<EmployeeTypeBloc>(context).add(const FetchEmployeeTypesEvent());
    BlocProvider.of<ProjectListBloc>(context).add(const FetchProjectListsEvent());
    if (widget.id.isNotEmpty) {
      BlocProvider.of<EntryByIDBloc>(context).add(FetchEntryByIDEvent(work_detail_id: widget.id));
    }
    print("id: ${widget.id}");
  }

  @override
  void dispose() {
    projectName.dispose();
    description.dispose();
    employeeName.dispose();
    super.dispose();
  }

  bool _validateForm() {
    bool valid = true;

    projectError = null;
    dateError = null;
    employeeTypeError = null;
    employeeError = null;

    if (selectedProjectId == null || selectedProjectId!.isEmpty) {
      projectError = "Please Select Project";
      valid = false;
    }

    if (_selectedDate == null) {
      dateError = "Please Select Date";
      valid = false;
    }

    if (_selectedEmployeeTypeId == null || _selectedEmployeeTypeId!.isEmpty) {
      employeeTypeError = "Please Select Employee Type";
      valid = false;
    }

    final type = (_selectedEmployeeTypeName ?? "").toLowerCase();

    if (type == "permanent employee" &&
        (_selectedEmployeeId == null || _selectedEmployeeId!.isEmpty)) {
      employeeError = "Please Select Employee";
      valid = false;
    }

    if (type == "contractor" && employeeName.text.trim().isEmpty) {
      employeeError = "Please Enter Employee Name";
      valid = false;
    }

    setState(() {});
    return valid;
  }

  void _onSavePressed() {
    FocusScope.of(context).unfocus();
    final validationError = _validateForm();
    if (!_validateForm()) {
      showErrorDialog(context, "Failed", "Please fill required fields");
      return;
    }

    // if (validationError != null) {
    //   showErrorDialog(context,'Failed', validationError);
    //   return;
    // }

    setState(() {
      _isSubmitting = true;
    });

    // Decide what to send for employee based on type
    String employeeToSend = "";
    final typeName = (_selectedEmployeeTypeName ?? "").toLowerCase();

    if (typeName == "permanent employee".toLowerCase()) {
      // send ID for permanent employee (or name if API expects name; adjust if needed)
      employeeToSend = _selectedEmployeeId ?? "";
    } else if (typeName == "contractor".toLowerCase()) {
      // send free-text name for contractor
      employeeToSend = employeeName.text.trim();
    } else {
      // default/fallback: if selectedEmployeeId exists send id, else send free-text
      employeeToSend = _selectedEmployeeId?.isNotEmpty == true ? (_selectedEmployeeId ?? "") : employeeName.text.trim();
    }

    // Ensure selectedProjectName exists (if not, use projectName controller or empty)
    // final projectNameToSend = selectedProjectName ?? projectName.text.trim();

    print('''
      Saving entry
      project_id: $selectedProjectId
      projectName: $selectedProjectName
      entryDate: ${_selectedDate?.toString() ?? ""}
      EmployeeType: $_selectedEmployeeTypeId
      EmployeeName: $employeeToSend
      working_notes: ${description.text}
      work_detail_id: ${widget.id}
    ''');

    context.read<AddNewEntryBloc>().add(
      SubmitAddNewEntryEvent(
        project_id: selectedProjectId ?? "",
        entryDate: _selectedDate!.toString(),
        projectName: selectedProjectName??"",
        EmployeeType: _selectedEmployeeTypeId ?? '',
        EmployeeName: employeeToSend,
        working_notes: description.text,
        work_detail_id: widget.id,
      ),
    );
  }

  void getDate(String inputDate) {
    if (inputDate.isEmpty) return;
    try {
      // Try ISO first
      final dt = DateTime.tryParse(inputDate);
      if (dt != null) {
        _selectedDate = dt;
        return;
      }
      // Fallback to known format
      DateFormat inputFormat = DateFormat("MMMM, dd yyyy HH:mm:ss Z");
      DateTime parsedDate = inputFormat.parse(inputDate);
      _selectedDate = parsedDate;
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
          BlocListener<AddNewEntryBloc, AddNewEntryState>(
            listener: (context, state) {
              if (state is AddNewEntrySuccess) {
                // success -> close and notify parent
                Navigator.pop(context, "true");
                setState(() {
                  _isSubmitting = false;
                });
              } else if (state is AddNewEntryFailed) {
                setState(() {
                  _isSubmitting = false;
                });
                showErrorDialog(context,'Failed', state.message ?? 'Save failed');
              }
            },
          ),
          BlocListener<EntryByIDBloc, EntryByIDState>(
            listener: (context, state) {
              if (state is EntryByIDLoadSuccess) {
                if (widget.id.isNotEmpty) {
                  final entry = state.entryByID.isNotEmpty ? state.entryByID.first : null;
                  if (entry != null) {
                    setState(() {
                      selectedProjectId = entry.project_id?.toString() ?? "";
                      selectedProjectName = entry.projectName ?? "";
                      _selectedEmployeeTypeId = entry.employeetype?.toString() ?? "";
                      _selectedEmployeeTypeName = entry.employeetypename ?? "";
                      if (_selectedEmployeeTypeName == "Permanent Employee") {
                        _selectedEmployeeId = entry.employeename?.toString() ?? "";
                        _selectedEmployeeName = entry.empName ?? "";
                        employeeName.text = ""; // free-text cleared for permanent
                      } else {
                        _selectedEmployeeId = null;
                        _selectedEmployeeName = entry.empName ?? entry.employeename?.toString() ?? "";
                        employeeName.text = entry.employeename ?? "";
                      }
                      getDate(entry.entryDate ?? "");
                      description.text = entry.notes ?? "";
                    });
                  }
                }
              }
            },
          ),
        ],
        child: BlocBuilder<AddNewEntryBloc, AddNewEntryState>(
          builder: (context, state) {
            return SafeArea(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                child: Column(
                  children: [
                    CustomAppbar(context, title: "Add New Entry", subTitle: "Smart, fast, and secure entry"),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 20),
                            subTitle("Mention gate entry information ", leftMargin: 5),
                            const SizedBox(height: 10),
                            // PROJECT DROPDOWN
                            BlocBuilder<ProjectListBloc, ProjectListState>(
                              builder: (context, state) {
                                if (state is ProjectListLoadSuccess) {
                                  // find selected project by id if exists
                                  final selectedProject = state.projectLists.firstWhere(
                                        (data) => data.project_id == selectedProjectId,
                                    orElse: () => ProjectListData(project_name: "", project_id: ""),
                                  );
                                  return Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      TransferDropdown<ProjectListData>(
                                        title: 'Project Name',
                                        hint: 'Select Project Name',
                                        selectedVal: selectedProject.project_name ?? selectedProjectName ?? "",
                                        data: state.projectLists,
                                        displayText: (data) => data.project_name ?? '',
                                        onChanged: (val) {
                                          setState(() {
                                            selectedProjectId = val.project_id ?? "";
                                            selectedProjectName = val.project_name ?? "";
                                            projectError = null;
                                            print("selectedProjectId $selectedProjectId");
                                            print("selectedProjectName $selectedProjectName");
                                          });
                                        },
                                      ),
                                      if (projectError != null)
                                        errorText(projectError),
                                    ],
                                  );
                                }
                                return const SizedBox.shrink();
                              },
                            ),
                            const SizedBox(height: 20),
                            // DATE PICKER
                            Row(
                              children: [
                                CustomDateTimeTextField(
                                  onTap: _pickDate,
                                  hint: _selectedDate == null ? '-- Date --' : DateFormat("d MMMM y").format(_selectedDate!),
                                  icon: Icons.calendar_month,
                                ),
                              ],
                            ),
                            if (dateError != null)errorText(dateError),
                            const SizedBox(height: 20),
                            // EMPLOYEE TYPE DROPDOWN
                            BlocBuilder<EmployeeTypeBloc, EmployeeTypeState>(
                              builder: (context, state) {
                                if (state is EmployeeTypeLoadSuccess) {
                                  final selectedEmployeeType = state.EmployeeTypes.firstWhere(
                                        (data) => data.LookupDataId == _selectedEmployeeTypeId,
                                    orElse: () => EmployeeTypeData(LookupDataId: "", LookupValue: ""),
                                  );

                                  return Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      TransferDropdown<EmployeeTypeData>(
                                        title: 'Employee Type',
                                        hint: 'Select Employee Type',
                                        selectedVal: selectedEmployeeType.LookupValue ?? _selectedEmployeeTypeName ?? "",
                                        data: state.EmployeeTypes,
                                        displayText: (data) => data.LookupValue ?? '',
                                        onChanged: (val) {
                                          setState(() {
                                            _selectedEmployeeTypeId = val.LookupDataId ?? "";
                                            _selectedEmployeeTypeName = val.LookupValue ?? "";
                                            employeeTypeError = null;
                                            employeeError = null;
                                            print("selectedEmployeeTypeId $_selectedEmployeeTypeId");
                                            print("selectedEmployeeTypeName $_selectedEmployeeTypeName");
                                          });
                                        },
                                      ),
                                      if (employeeTypeError != null)
                                        errorText(employeeTypeError),
                                    ],
                                  );
                                }
                                return const SizedBox.shrink();
                              },
                            ),

                            const SizedBox(height: 20),

                            // If Contractor or other free-text types -> show free-text field for employee name
                            if ((_selectedEmployeeTypeName ?? "").toLowerCase() == "contractor".toLowerCase() ||
                                (_selectedEmployeeTypeName ?? "").isEmpty)
                              ...[
                                txtFiled(context, employeeName, "Enter Employee Name", "Employee Name"),
                                if (employeeError != null)errorText(employeeError),
                                const SizedBox(height: 10),
                              ],

                            // If Permanent Employee -> show dropdown of employees
                            if ((_selectedEmployeeTypeName ?? "").toLowerCase() == "permanent employee".toLowerCase())
                            BlocBuilder<EmployeeBloc, EmployeeState>(
                                builder: (context, state) {
                                  if (state is EmployeeLoadSuccess) {
                                    final selectedEmp = state.employees.firstWhere(
                                          (coordinator) => coordinator.EmployeeId == _selectedEmployeeId,
                                      orElse: () => EmployeeData(EmployeeName: "", EmployeeId: ""),
                                    );
                                    return Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        TransferDropdown<EmployeeData>(
                                          title: 'Employee Name',
                                          hint: 'Select Employee',
                                          selectedVal: selectedEmp.EmployeeName ?? _selectedEmployeeName ?? "",
                                          data: state.employees,
                                          displayText: (data) => data.EmployeeName ?? '',
                                          onChanged: (val) {
                                            setState(() {
                                              _selectedEmployeeId = val.EmployeeId ?? "";
                                              _selectedEmployeeName = val.EmployeeName ?? "";
                                            });
                                          },
                                        ),
                                        if (employeeError != null)errorText(employeeError),
                                      ],
                                    );
                                  }
                                  return const SizedBox.shrink();
                                },
                            ),
                            const SizedBox(height: 10),
                            // DESCRIPTION
                            txtFiled(context, description, "Enter Description", "Note", maxLines: 5),
                            const SizedBox(height: 20),
                            PrimaryButton(
                              title: _isSubmitting ? "Saving..." : "Save",
                              onAction: _isSubmitting ? () {} : _onSavePressed,
                            ),
                            const SizedBox(height: 30),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
