import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../../api/models/DAOGetEmployee.dart';
import '../../../api/models/DAOGetMaterialIssued.dart';
import '../../../api/models/DAOGetProjectList.dart';
import '../../../api/models/DAOGetUnits.dart';
import '../../../api/models/DAOGetVehicleNo.dart';
import '../../../api/models/DAOGetWarehouse.dart';
import '../../../bloc/DropDownValueBloc/basic_units_bloc.dart';
import '../../../bloc/DropDownValueBloc/emplyee_list_bloc.dart';
import '../../../bloc/DropDownValueBloc/material_issued_bloc.dart';
import '../../../bloc/DropDownValueBloc/project_list_bloc.dart';
import '../../../bloc/DropDownValueBloc/units_bloc.dart';
import '../../../bloc/DropDownValueBloc/vehicle_no_bloc.dart';
import '../../../bloc/DropDownValueBloc/warehouse_list_bloc.dart';
import '../../../bloc/GatePass/add_new_gate_pass_bloc.dart';
import '../../../bloc/GatePass/add_warehouse_to_project.dart';
import '../../../bloc/GatePass/add_warehouse_transfer.dart';
import '../../../bloc/GatePass/gate_pass_by_id_bloc.dart';
import '../../Utils/date_picker.dart';
import '../../Widgets/Custom_Date_Time_Picker.dart';
import '../../Widgets/Custom_Dialog.dart';
import '../../Widgets/Custom_Dropdown.dart';
import '../../Widgets/Custom_Button.dart';
import '../../Widgets/Custom_appbar.dart';
import '../../Widgets/Date_Formate.dart';
import '../../Widgets/MultiSelect_DropDown.dart';
import '../../Widgets/TextWidgets.dart';
import '../../Utils/colors_constants.dart';

class MaterialLine {
  final MaterialIssuedData data;

  final TextEditingController quantityController;
  final TextEditingController usedQuantityController;
  final TextEditingController scrapController;
  final TextEditingController rateController;

  String selectedUnit;
  String? selectedUnitId;

  double originalBalance;   // ⭐ store API value permanently
  double currentBalance;
  double remainingBalance;
  double conversionFactor;     //
  bool showQualityFields;

  MaterialLine({
    required this.data,
    double? currentBalanceFromApi,
  })  : quantityController = TextEditingController(text: '0'),
        usedQuantityController = TextEditingController(),
        scrapController = TextEditingController(),
        rateController = TextEditingController(),
        selectedUnit = '',
        selectedUnitId = null,
        originalBalance = currentBalanceFromApi ??
            double.tryParse(data.current_balance?.toString() ?? '0') ?? 0.0,
        currentBalance = currentBalanceFromApi ??
            double.tryParse(data.current_balance?.toString() ?? '0') ?? 0.0,
        remainingBalance = currentBalanceFromApi ??
            double.tryParse(data.current_balance?.toString() ?? '0') ?? 0.0,
        conversionFactor = 1.0,
        showQualityFields = false;

  /// ⭐ UNIT CONVERSION METHOD
  void updateBalanceWithUnit({
    required double basic,
    required double alt,
  }) {
    if (basic == 0) return;

    /// ⭐ If basic unit selected → reset to original
    if (basic == alt) {
      currentBalance = originalBalance;
      remainingBalance = originalBalance;
      return;
    }

    /// ⭐ Apply conversion
    double converted =
        (originalBalance * alt) / basic;

    currentBalance = converted;
    remainingBalance = converted;
  }

  void dispose() {
    quantityController.dispose();
    usedQuantityController.dispose();
    scrapController.dispose();
    rateController.dispose();
  }
}

class MaterialEntry {
  final TextEditingController quantityController;
  TimeOfDay? outTime;
  List<MaterialLine> lines = [];
  String selectedMaterial;
  String? selectedMaterialId;
  String? selectedGroupId;
  String? selectedSubgroupId;
  List<MaterialIssuedData> selectedMaterialsList;
  List<String> selectedMaterialIds;
  List<String> selectedGroupIds;
  List<String> selectedSubgroupIds;
  String? selectedFromWarehouseId;
  String selectedFromWarehouseName;
  String? selectedCategoryId;
  String selectedCategoryName;
  String? selectedSubCategoryId;
  String selectedSubCategoryName;
  String selectedUnit;
  String? selectedUnitId;
  double currentBalance;
  double remainingBalance;
  bool showQualityFields;
  final TextEditingController usedQuantityController;
  final TextEditingController scrapController;
  final TextEditingController rateController;

  MaterialEntry({
    String initialMaterial = '',
    String initialUnit = '',
    this.currentBalance = 0,
    this.remainingBalance = 0,
    this.showQualityFields = false,
  })  : quantityController = TextEditingController(),
        usedQuantityController = TextEditingController(),
        scrapController = TextEditingController(),
        rateController = TextEditingController(),
        outTime = null,
        selectedMaterial = initialMaterial,
        selectedUnit = initialUnit,
        selectedMaterialsList = [],
        selectedMaterialIds = [],
        selectedGroupIds = [],
        selectedSubgroupIds = [],
        selectedFromWarehouseId = null,
        selectedFromWarehouseName = 'Select Warehouse',
        selectedCategoryId = null,
        selectedCategoryName = 'Select Category',
        selectedSubCategoryId = null,
        selectedSubCategoryName = 'Select Sub Category';

  void dispose() {
    quantityController.dispose();
    usedQuantityController.dispose();
    scrapController.dispose();
    rateController.dispose();
  }
}

class AddGatePassPage extends StatefulWidget {
  AddGatePassPage({super.key, required this.id});
  String id;

  @override
  State<AddGatePassPage> createState() => _AddGatePassPageState();
}

class _AddGatePassPageState extends State<AddGatePassPage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AddNewGatePassBloc(),
      child: AddGatePass(id: widget.id), // your form UI
    );
  }
}

class AddGatePass extends StatefulWidget {
  AddGatePass({super.key, required this.id});
  String id;

  @override
  State<AddGatePass> createState() => _AddGatePassState();
}

class _AddGatePassState extends State<AddGatePass> {
  final transferType = ['Warehouse Type', 'Project Type'];
  final category = [];
  final subCategory = [];
  List<String> selectedSubCategories = [];
  final List<MaterialEntry> materialEntries = [];
  List<MaterialIssuedData> materialIssuedList = [];
  List<UnitsData> unitsList = [];

  String selectedTransfer = "";
  String selectedCategory = "";
  String selectedSubCategoryDisplay = "";
  String currentBal = "";

  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  final TextEditingController gatePass = TextEditingController();
  final TextEditingController description = TextEditingController();
  final TextEditingController quantity = TextEditingController();
  final TextEditingController amount = TextEditingController();
  final TextEditingController scrap = TextEditingController();
  final TextEditingController rate = TextEditingController();

  bool _isSaving = false;

  WarehouseData? selectedWarehouse;
  String? selectedGodownId;
  String? selectedFromWarehouseID;
  String? selectedFromWarehouseName;
  String? selectedToWarehouseID;
  String? selectedFromWarehouseProjectListID;
  String? selectedToProjectListID;
  String? selectedIssuedToID;
  String? selectedIssuedByID;
  String? selectedVehicleNoID;

  final Map<String, List<UnitsData>> unitsByItem = {};
  final Set<String> unitsLoadingFor = {};
  bool _validationInProgress = false;

  String? err_transferType;
  String? err_dateTime;
  String? err_toWarehouse;
  String? err_toProject;
  String? err_issuedTo;
  String? err_issuedBy;
  String? err_gatePass;
  String? err_material;
  String? err_vehicle;
  List<String?> err_materialEntry = [];

  @override
  void initState() {
    super.initState();
    print("ID: ${widget.id}");
    BlocProvider.of<EmployeeBloc>(context).add(FetchEmployeesEvent());
    BlocProvider.of<WarehouseBloc>(context).add(FetchWarehouseEvent());
    BlocProvider.of<ProjectListBloc>(context).add(FetchProjectListsEvent());
    BlocProvider.of<VehicleBloc>(context).add(FetchVehiclesEvent());
    // BlocProvider.of<GatePassByIDBloc>(context).add(FetchGatePassByIDEvent(gate_pass: '', date: ''));
  }

  @override
  void dispose() {
    gatePass.dispose();
    description.dispose();
    for (var e in materialEntries) {
      e.dispose();
    }
    super.dispose();
  }

  void addMaterialField() {
    // final availableForNew = materialIssuedList.where((m) {
    //   final mid = m.item_id?.toString() ?? m.item?.toString() ?? '';
    //   if (mid.isEmpty) return true;
    //   final alreadySelected =
    //       materialEntries.any((e) => e.selectedMaterialId?.toString() == mid);
    //   return !alreadySelected;
    // }).toList();
    // if (availableForNew.isEmpty) {
    //   Fluttertoast.showToast(msg: 'No more materials available to add');
    //   return;
    // }
    setState(() {
      materialEntries.add(MaterialEntry());
      err_materialEntry.add(null);
    });
  }

  void removeMaterialField(int index) {
    if (index < 0 || index >= materialEntries.length) return;
    setState(() {
      // dispose controllers inside MaterialEntry
      materialEntries[index].dispose();
      materialEntries.removeAt(index);
      err_materialEntry.removeAt(index);
    });
  }

  Future<void> _pickDate() async {
    DateTime now = DateTime.now();
    final date = await showAppDatePicker(
      context: context,
      initialDate: _selectedDate ?? now,
      firstDate: DateTime(2000),
      lastDate: DateTime(DateTime.now().year + 5),
    );
    if (date != null && mounted) {
      setState(() {
        _selectedDate = date;
        err_dateTime=null;
      });
    }
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
        err_dateTime=null;
      });
    }
  }

  Future<TimeOfDay?> _pickTimeForEntry(int index) async {
    final time = await showTimePicker(
      context: context,
      initialTime: materialEntries[index].outTime ?? TimeOfDay.now(),
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
      setState(() => materialEntries[index].outTime = time);
    }
    return time;
  }

  bool _validateForm() {
    bool valid = true;
    // reset errors
    err_transferType = null;
    err_dateTime = null;
    err_toWarehouse = null;
    err_toProject = null;
    err_issuedTo = null;
    err_issuedBy = null;
    err_gatePass = null;
    err_material = null;
    err_materialEntry = List.filled(materialEntries.length, null);

    // Transfer Type
    if (selectedTransfer.isEmpty) {
      err_transferType = 'Please select a transfer type';
      valid = false;
    }

    // Date & Time
    if (_selectedDate == null || _selectedTime == null) {
      err_dateTime = 'Please select date and time';
      valid = false;
    }

    // Warehouse / Project validation
    if (selectedTransfer == "Warehouse Type") {
      if (selectedToWarehouseID == null ||
          selectedToWarehouseID!.isEmpty) {
        err_toWarehouse = 'Please select warehouse for Warehouse transfer';
        valid = false;
      }
    }

    if (selectedTransfer == "Project Type") {
      if (selectedToProjectListID == null ||
          selectedToProjectListID!.isEmpty) {
        err_toProject =
        'Please select project for Project transfer';
        valid = false;
      }
    }

    // Issued To / By
    if (selectedIssuedToID == null ||
        selectedIssuedToID!.isEmpty) {
      err_issuedTo = 'Please select "Issued To"';
      valid = false;
    }

    if (selectedIssuedByID == null ||
        selectedIssuedByID!.isEmpty) {
      err_issuedBy = 'Please select "Issued By"';
      valid = false;
    }

    // Gate Pass
    if (gatePass.text.trim().isEmpty) {
      err_gatePass = 'Please enter gate pass number';
      valid = false;
    }

    // Material Entries
    if (materialEntries.isEmpty) {
      err_material = 'Please add at least one material entry';
      valid = false;
    }

    // Loop through material entries
    for (int entryIndex = 0; entryIndex < materialEntries.length; entryIndex++) {
      final entry = materialEntries[entryIndex];

      // From Warehouse
      if (entry.selectedFromWarehouseId == null ||
          entry.selectedFromWarehouseId!.isEmpty) {
        err_materialEntry[entryIndex] = 'Please select From Warehouse';
        valid = false;
        continue;
      }

      // Category
      if (entry.selectedCategoryId == null ||
          entry.selectedCategoryId!.isEmpty) {
        err_materialEntry[entryIndex] = 'Please select Category';
        valid = false;
        continue;
      }

      // SubCategory
      if (entry.selectedSubCategoryId == null ||
          entry.selectedSubCategoryId!.isEmpty) {
        err_materialEntry[entryIndex] = 'Please select SubCategory';
        valid = false;
        continue;
      }

      final bool hasSelectedMaterials =
          entry.selectedMaterialsList.isNotEmpty;

      final bool hasMeaningfulLine = entry.lines.any((line) {
        final hasItem = (line.data.item ?? '').trim().isNotEmpty ||
            (line.data.item_id ?? '').trim().isNotEmpty;
        // final hasQty = line.quantityController.text.trim().isNotEmpty ||
        //     line.usedQuantityController.text.trim().isNotEmpty ||
        //     line.scrapController.text.trim().isNotEmpty;

        // return hasItem || hasQty;
        return hasItem;
      });

      if (!hasSelectedMaterials && !hasMeaningfulLine) {
        err_materialEntry[entryIndex] = 'Please add at least one item';
        valid = false;
        continue;
      }

      // Line validation
      for (final line in entry.lines) {
        final hasAnyInput =
            (line.data.item ?? '').trim().isNotEmpty ||
                (line.data.item_id ?? '').trim().isNotEmpty ||
                line.quantityController.text.trim().isNotEmpty ||
                line.usedQuantityController.text.trim().isNotEmpty ||
                line.scrapController.text.trim().isNotEmpty;

        if (!hasAnyInput) continue;

        print("Quantity ${line.quantityController.text}");

        if (line.showQualityFields && selectedTransfer == "Project Type") {
          if(line.quantityController.text.isEmpty || line.quantityController.text=="0")
            {
              err_materialEntry[entryIndex] = 'Please enter valid quantity';
              valid=false;
            }
          else if(line.usedQuantityController.text.isEmpty){
            err_materialEntry[entryIndex] = 'Please enter valid used quantity';
            valid=false;
          }
          else if(line.scrapController.text.isEmpty){
            err_materialEntry[entryIndex] = 'Please enter valid scarp value';
            valid=false;
          }
          else if(line.rateController.text.isEmpty){
            err_materialEntry[entryIndex] = 'Please enter valid rate';
            valid = false;
          }
        }
        // else if(line.quantityController.text.isEmpty || line.quantityController.text=="0"){
        //   err_materialEntry[entryIndex] = 'Please enter valid quantity';
        // }
      }
    }

    setState(() {});
    return valid;
  }

  void _onSavePressed() {
    // final validationError = _validateForm();
    if (!_validateForm()) {
      showErrorDialog(context, "Failed", "Please fill required fields");
      return;
    }
    // if (validationError != null) {
    //   showErrorDialog(context, 'Failed', validationError);
    //   return;
    // }
    final bool hasDateTime = _selectedDate != null && _selectedTime != null;
    if (!hasDateTime) {
      showDialog(
        context: context,
        builder: (context) => Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          backgroundColor: Colors.transparent,
          child: UploadErrorCard(
            title: 'Failed',
            subtitle: "Please select date and time",
            onRetry: () {
              Navigator.pop(context);
            },
          ),
        ),
      );
      return;
    }
    if (materialEntries.isEmpty) {
      showDialog(
        context: context,
        builder: (context) => Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          backgroundColor: Colors.transparent,
          child: UploadErrorCard(
            title: 'Failed',
            subtitle: "Please add at least one material entry",
            onRetry: () {
              Navigator.pop(context);
            },
          ),
        ),
      );
      return;
    }
    final String dateTimeStr = (_selectedDate != null && _selectedTime != null)
        ? dateTimeFormat(_selectedDate!, _selectedTime!)
        : "";
    String transferTypeTop = selectedTransfer;
    String gatePassNoTop = gatePass.text.trim();
    String descTop = description.text.trim();
    String vehicleNameNoTop = selectedVehicleNoID ?? "";
    String issuedToTop = selectedIssuedToID ?? "";
    String issuedByTop = selectedIssuedByID ?? "";

    print("DEBUG: selectedTransfer at save -> '$selectedTransfer'");
    setState(() {
      _isSaving = true;
    });

    for (final entry in materialEntries) {
      final List<String> materialsIdList = [];
      final List<String> issuedMaterialsList = [];
      final List<String> quantityList = [];
      final List<String> usedQuantityList = [];
      final List<String> scrapList = [];
      final List<String> rateList = [];
      final List<String> amountList = [];
      final List<String> consumedFlagList = []; // "1" or "0"
      final List<String> unitList = [];
      final List<String> currentBalanceList = [];
      final List<String> categoryList = [];
      final List<String> subCategoryList = [];
      final List<String> differenceBalanceList = [];
      String quantity = "";
      String usedQuantity = "";
      String scrap = "";
      String rate = "";
      String unit = "";
      String currentBalance = "";
      bool showQuality = false;
      double qty = 0.0;
      double usedQty = 0.0;
      double scrapQty = 0.0;
      String vehicleNameNo = "";
      String toProjectName = "";
      String fromWarehouse = "";
      String toWarehouse = "";

      final List<String> outTimeList = [];
      outTimeList.add(entry.outTime?.format(context) ?? '');

      fromWarehouse = entry.selectedFromWarehouseId ?? "";
      // fromWarehouseLists = selectedFromWarehouseProjectListID ?? "";
      if (transferTypeTop == "Warehouse Type") {
        toWarehouse = selectedToWarehouseID ?? "";
        toProjectName = "";
      } else if (transferTypeTop == "Project Type") {
        toProjectName = selectedToProjectListID ?? "";
        toWarehouse = "";
      }
      if (entry.lines.isNotEmpty) {
        for (final line in entry.lines) {
          final String materialUsed = (line.data.item ?? '') != ''
              ? (line.data.item ?? '')
              : (entry.selectedMaterial ?? "");
          final String materialUsedID = (line.data.item_id ?? '') != ''
              ? (line.data.item_id ?? '')
              : (entry.selectedMaterialId ?? "");

          quantity = line.quantityController.text.trim();
          usedQuantity = line.usedQuantityController.text.trim();
          scrap = line.scrapController.text.trim();
          rate = line.rateController.text.trim();
          unit = line.selectedUnit ?? "";
          currentBalance = line.remainingBalance.toString();
          // currentBalance = line.originalBalance.toString();
          showQuality = line.showQualityFields;
          // qty = double.tryParse(quantity) ?? 0.0;
          // usedQty = double.tryParse(usedQuantity) ?? 0.0;
          // scrapQty = double.tryParse(scrap) ?? 0.0;
          final double factor = line.conversionFactor;

// Convert entered values to BASE
          final double qtyBase =
              (double.tryParse(quantity) ?? 0.0) * factor;

          final double usedBase =
              (double.tryParse(usedQuantity) ?? 0.0) * factor;

          final double scrapBase =
              (double.tryParse(scrap) ?? 0.0) * factor;

// Always subtract from ORIGINAL BASE STOCK
          double remainingBase =
              line.originalBalance - (usedBase + scrapBase);

          if (remainingBase < 0) remainingBase = 0.0;

// Store internally in BASE
          line.remainingBalance = remainingBase;
          // double bal = qty - (usedQty + scrapQty);
          // if (bal < 0) bal = 0.0;
          // final double balance = bal.toDouble();
          // line.remainingBalance = balance;
          vehicleNameNo = selectedVehicleNoID ?? "";
          final double rateD = double.tryParse(rate) ?? 0.0;
          // final double amountD = qty * rateD;
          // final double amountD = (usedQty + scrapQty) * rateD;
          final double amountD = (usedBase + scrapBase) * rateD;
          final String amount = (amountD == amountD.roundToDouble())
              ? amountD.toInt().toString()
              : amountD.toStringAsFixed(2);

          print("Selected category id: ${entry.selectedCategoryId}");
          final String category = entry.selectedCategoryId ?? '';
          final String subCategory = entry.selectedSubCategoryId ?? '';
          materialsIdList.add(materialUsedID.replaceAll(',', ''));
          issuedMaterialsList.add(materialUsed.replaceAll(',', ''));

          rateList.add(rate.isEmpty ? "0" : rate);
          amountList.add(amount);
          consumedFlagList.add(showQuality ? "1" : "0");
          unitList.add(unit.replaceAll(',', ''));
          currentBalanceList.add(currentBalance);
          categoryList.add(category.replaceAll(',', ''));
          subCategoryList.add(subCategory.replaceAll(',', ''));
          // differenceBalanceList.add(balance.toString());
          // quantityList.add(quantity.isEmpty ? "0" : quantity);
          // usedQuantityList.add(usedQuantity.isEmpty ? "0" : usedQuantity);
          // scrapList.add(scrap.isEmpty ? "0" : scrap);
          quantityList.add(qtyBase.toStringAsFixed(2));
          usedQuantityList.add(usedBase.toStringAsFixed(2));
          scrapList.add(scrapBase.toStringAsFixed(2));
          differenceBalanceList.add(remainingBase.toStringAsFixed(2));
        }
      }
      // Build aggregated CSVs AFTER collecting everything
      final String materialsIdCsv = materialsIdList.join(',');
      final String issuedMaterialsCsv = issuedMaterialsList.join(',');
      final String quantityCsv = quantityList.join(',');
      final String usedQuantityCsv = usedQuantityList.join(',');
      final String scrapCsv = scrapList.join(',');
      final String rateCsv = rateList.join(',');
      final String amountCsv = amountList.join(',');
      final String consumedFlagCsv = consumedFlagList.join(',');
      final String unitCsv = unitList.join(',');
      final String currentBalanceCsv = currentBalanceList.join(',');
      final String categoryCsv = categoryList.join(',');
      final String subCategoryCsv = subCategoryList.join(',');
      final String differenceBalanceCsv = differenceBalanceList.join(',');
      final String outTimeCsv = outTimeList.join(',');

      String stripAmPm(String timeString) {
        final cleaned = timeString.replaceAll(
            RegExp(r'\s?(AM|PM)$', caseSensitive: false), '');
        final parts = cleaned.split(':');
        final hour = parts[0].padLeft(2, '0');
        final minute = parts.length > 1 ? parts[1].padLeft(2, '0') : '00';
        return "$hour:$minute";
      }

      // print('''
      //  ---- SUBMITTING GATE PASS (AGGREGATED) ----
      //  date: $dateTimeStr
      //  materialsId: $materialsIdCsv
      //  issuedMaterials: $issuedMaterialsCsv
      //  quantity: $quantityCsv
      //  usedQuantity: $usedQuantityCsv
      //  scrap: $scrapCsv
      //  rate: $rateCsv
      //  amount: $amountCsv
      //  consumedFlags: $consumedFlagCsv
      //  units: $unitCsv
      //  currentBalances: $currentBalanceCsv
      //  categories: $categoryCsv
      //  subCategories: $subCategoryCsv
      //  differenceBalances: $differenceBalanceCsv
      //  outTimes: ${stripAmPm(outTimeCsv)}
      //  -------------------------------------------
      // ''');
      context.read<AddNewGatePassBloc>().add(
        SubmitAddNewGatePassEvent(
          transferType: transferTypeTop == "Warehouse Type"
              ? "warehouse_type"
              : "project_type",
          date: dateTimeStr,
          toProject: selectedToProjectListID ?? "",
          toWarehouse: selectedToWarehouseID ?? "",
          vehicleNameNo: vehicleNameNoTop,
          issuedTo: issuedToTop,
          issuedBy: issuedByTop,
          gatePass: gatePassNoTop,
          description: descTop,
          fromWarehouse: fromWarehouse ?? "",
          outTime: stripAmPm(outTimeCsv),
          materialsId: materialsIdCsv,
          issuedMaterials: issuedMaterialsCsv,
          currentBalance: currentBalanceCsv,
          unit: unitCsv,
          category: categoryCsv,
          subCategory: subCategoryCsv,
          quantity: quantityCsv,
          consumed: consumedFlagCsv,
          usedQuantity: usedQuantityCsv,
          scrap: scrapCsv,
          rate: rateCsv,
          amount: amountCsv,
          differenceBalance: differenceBalanceCsv,
        ),
      );
      if (transferTypeTop == "Warehouse Type") {
        print("Warehouse Type");
        print('''
              groupid: $categoryCsv,
              subgroupid: $subCategoryCsv,
              item_id: $materialsIdCsv,
              item: $issuedMaterialsCsv,
              date: $dateTimeStr,
              unit: $unit,
              currentBalance: $currentBalanceCsv,
              quantity: $quantityCsv,
              fromWarehouse: $fromWarehouse,
              toWarehouse: $toWarehouse,
              ''');
        context.read<AddWarehouseTransferBloc>().add(
          SubmitAddWarehouseTransferEvent(
            groupid: categoryCsv,
            subgroupid: subCategoryCsv,
            item_id: materialsIdCsv,
            item: issuedMaterialsCsv,
            date: dateTimeStr,
            unit: unit,
            currentBalance: currentBalanceCsv,
            quantity: quantityCsv,
            fromWarehouse: fromWarehouse,
            towarehouse: toWarehouse,
          ),
        );
      }
      else if (transferTypeTop == "Project Type") {
        print("Project Type");
        print('''
               project_id:${toProjectName},
               date:$dateTimeStr,
               vehicle_id:$vehicleNameNo,
               issued_to_id: $issuedToTop,
               issued_by_id: $issuedByTop,
               gatePass: $gatePassNoTop,
               description: $descTop,
               fromWarehouse: $fromWarehouse,
               outTime: $outTimeCsv,
               materialsId: $materialsIdCsv,
               issuedMaterials: $issuedMaterialsCsv,
               currentBalance: $currentBalanceCsv
               quantity: $quantityCsv
               unit: $unitCsv
         ''');
        context.read<AddWarehouseToProjectBloc>().add(
          SubmitAddWarehouseToProjectEvent(
              project_id: toProjectName,
              date: dateTimeStr,
              vehicle_id: vehicleNameNo,
              issued_to_id: issuedToTop,
              issued_by_id: issuedByTop,
              gatePass: gatePassNoTop,
              description: descTop,
              fromWarehouse: fromWarehouse,
              outTime: stripAmPm(outTimeCsv),
              materialsId: materialsIdCsv,
              issuedMaterials: issuedMaterialsCsv,
              currentBalance: currentBalanceCsv,
              quantity: quantityCsv,
              unit: unitCsv
          ),
        );
      }
    }

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
            BlocListener<AddNewGatePassBloc, AddNewGatePassState>(
                listener: (context, state) {
              if (state is AddNewGatePassSuccess) {
                Navigator.pop(context, "true");
                Fluttertoast.showToast(msg: state.message);
                setState(() {
                  _isSaving = false;
                });
              }
              if (state is AddNewGatePassFailed) {
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
                setState(() {
                  _isSaving = false;
                });
              }
            }),
            BlocListener<GatePassByIDBloc, GatePassByIDState>(
              listener: (context, state) {
                if (state is GatePassByIDLoadSuccess) {
                  print("GatePassByIDLoadSuccess");
                  if (widget.id != "") {
                    final data = state.gatePassByID.isNotEmpty
                        ? state.gatePassByID.first
                        : null;
                    if (data != null) {
                      gatePass.text = data.gate_pass.toString();
                      description.text = data.description??"";
                      quantity.text = data.quantity.toString();
                      getDate(data.date ?? "");
                      selectedFromWarehouseID = data.from_warehouse??"";
                      selectedToWarehouseID = data.to_warehouse;
                      selectedToProjectListID = data.to_project??"";
                      selectedIssuedByID = data.issued_by;
                      selectedIssuedToID = data.issued_to;
                      selectedVehicleNoID = data.vehicle_no;
                      amount.text = data.amount??"";
                      scrap.text = data.scrap??"";
                      rate.text = data.rate??"";
                      setState(() {});
                    }
                  }
                }
              },
            ),
          ],
          child: BlocBuilder<AddNewGatePassBloc, AddNewGatePassState>(
              builder: (context, state) {
            return SafeArea(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                child: Column(
                  children: [
                    CustomAppbar(context,
                        title: "Add New Gate Pass",
                        subTitle: "Create and log gate passes for materials"),
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 20),
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 20),
                              subTitle("Mention Transfer Type/Date/Time",
                                  leftMargin: 10.0, bottomMargin: 5),
                              // transfer type
                              TransferDropdown<String>(
                                title: "Transfer Type",
                                hint: 'Select Transfer Type',
                                selectedVal: selectedTransfer,
                                data: transferType,
                                displayText: (t) => t,
                                onChanged: (val) {
                                  selectedTransfer = val;
                                  err_transferType=null;
                                  print("selectedTransfer $selectedTransfer");
                                  setState(() {});
                                },
                              ),
                              if (err_transferType != null)errorText(err_transferType),
                              SizedBox(
                                height: 10,
                              ),
                              // date/time row
                              Container(
                                padding: const EdgeInsets.only(left: 10),
                                child: Row(
                                  children: [
                                    CustomDateTimeTextField(
                                        onTap: _pickDate,
                                        hint: _selectedDate == null
                                            ? '-- Date --'
                                            : DateFormat("d MMMM y")
                                                .format(_selectedDate!),
                                        icon: Icons.calendar_month),
                                    const SizedBox(width: 10),
                                    CustomDateTimeTextField(
                                        onTap: _pickTime,
                                        title: "Select Time",
                                        hint: _selectedTime == null
                                            ? '-- Time --'
                                            : formatTimeWithSpace(
                                                _selectedTime!),
                                        icon: Icons.watch_later_outlined),
                                  ],
                                ),
                              ),
                              if (err_dateTime != null)errorText(err_dateTime),
                              if (selectedTransfer == "Warehouse Type") ...[
                                SizedBox(
                                  height: 20,
                                ),
                                subTitle("Select To Warehouse",
                                    leftMargin: 10.0, bottomMargin: 5),
                                BlocBuilder<WarehouseBloc, WarehouseState>(
                                  builder: (context, state) {
                                    if (state is WarehouseLoadSuccess) {
                                      // find the coordinator whose id matches the selected id
                                      final selectedToWarehouse =
                                          state.warehouses.firstWhere(
                                        (coordinator) =>
                                            coordinator.godown_id ==
                                            selectedToWarehouseID,
                                        orElse: () => WarehouseData(
                                            godown_id: "", godown_name: ""),
                                      );
                                      return Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          TransferDropdown<WarehouseData>(
                                            title: 'To Warehouse',
                                            hint: 'Select warehouse',
                                            selectedVal:
                                                selectedToWarehouse.godown_name ??
                                                    "",
                                            data: state.warehouses,
                                            displayText: (data) =>
                                                data.godown_name ?? '',
                                            onChanged: (val) {
                                              setState(() {
                                                selectedToWarehouseID = val.godown_id ?? "";
                                                err_toWarehouse=null;
                                              });
                                            },
                                          ),
                                          if (err_toWarehouse != null)errorText(err_toWarehouse),
                                        ],
                                      );
                                    }
                                    return const SizedBox.shrink();
                                  },
                                ),
                              ],
                              if (selectedTransfer == "Project Type") ...[
                              SizedBox(
                                  height: 10,
                                ),
                                BlocBuilder<ProjectListBloc, ProjectListState>(
                                  builder: (context, state) {
                                    if (state is ProjectListLoadSuccess) {
                                      // find the coordinator whose id matches the selected id
                                      final selectedToProjectList =
                                          state.projectLists.firstWhere(
                                        (coordinator) =>
                                            coordinator.project_id ==
                                            selectedToProjectListID,
                                        orElse: () => ProjectListData(
                                            project_name: "", project_id: ""),
                                      );
                                      return Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          subTitle("Mention To Project",
                                              leftMargin: 10.0,bottomMargin: 5),
                                          TransferDropdown<ProjectListData>(
                                            title: 'To Project List',
                                            hint: 'Select Project',
                                            selectedVal: selectedToProjectList
                                                    .project_name ??
                                                "",
                                            data: state.projectLists,
                                            displayText: (data) =>
                                                data?.project_name ?? '',
                                            onChanged: (val) {
                                              setState(() {
                                                selectedToProjectListID =
                                                    val.project_id ?? "";
                                                err_toProject=null;
                                              });
                                            },
                                          ),
                                          if (err_toProject != null)errorText(err_toProject),
                                        ],
                                      );
                                    }
                                    return const SizedBox.shrink();
                                  },
                                ),
                              ],
                              SizedBox(
                                height:20
                              ),
                              BlocBuilder<VehicleBloc, VehicleState>(
                                builder: (context, state) {
                                  if (state is VehicleLoadSuccess) {
                                    // find the coordinator whose id matches the selected id
                                    final selectedVehicle =
                                        state.vehicles.firstWhere(
                                      (coordinator) =>
                                          coordinator.vehicleid ==
                                          selectedVehicleNoID,
                                      orElse: () => VehicleNoData(
                                          vehicleid: "",
                                          vehiclename: "",
                                          vehicleno: ""),
                                    );
                                    return Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        subTitle("Mention Vehicle Name",
                                            leftMargin: 10.0, bottomMargin: 5),
                                        TransferDropdown<VehicleNoData>(
                                          title: 'Vehicle Name/No',
                                          hint: 'Select Vehicle Name',
                                          // selectedVal: selectedVehicle.vehiclename ?? "",
                                          selectedVal: selectedVehicle.vehiclename!.isNotEmpty
                                              ? "${selectedVehicle.vehiclename} (${selectedVehicle.vehicleno})"
                                              : "",
                                          data: state.vehicles,
                                          displayText: (data) =>
                                              data.vehiclename ?? '',
                                          subDisplayText: (data) =>
                                              data.vehicleno ?? '',
                                          onChanged: (val) {
                                            setState(() {
                                              selectedVehicleNoID =
                                                  val.vehicleid ?? "";
                                            });
                                          },
                                        ),
                                      ],
                                    );
                                  }
                                  return const SizedBox.shrink();
                                },
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              BlocBuilder<EmployeeBloc, EmployeeState>(
                                builder: (context, state) {
                                  if (state is EmployeeLoadSuccess) {
                                    // find the coordinator whose id matches the selected id
                                    final issuedTo =
                                        state.employees.firstWhere(
                                      (coordinator) =>
                                          coordinator.EmployeeId ==
                                          selectedIssuedToID,
                                      orElse: () => EmployeeData(
                                          EmployeeName: "", EmployeeId: ""),
                                    );
                                    return Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        subTitle("Mention Issued To/By Person",
                                            leftMargin: 10.0, bottomMargin: 5),
                                        TransferDropdown<EmployeeData>(
                                          title: 'Issued To',
                                          hint: 'Select Person',
                                          selectedVal:
                                          issuedTo.EmployeeName ??
                                                  "",
                                          data: state.employees,
                                          displayText: (data) =>
                                              data.EmployeeName ?? '',
                                          onChanged: (val) {
                                            setState(() {
                                              selectedIssuedToID =
                                                  val.EmployeeId ?? "";
                                              err_issuedTo=null;
                                            });
                                          },
                                        ),
                                        if (err_issuedTo != null)errorText(err_issuedTo),

                                      ],
                                    );
                                  }
                                  return const SizedBox.shrink();
                                },
                              ),
                              BlocBuilder<EmployeeBloc, EmployeeState>(
                                builder: (context, state) {
                                  if (state is EmployeeLoadSuccess) {
                                    // find the coordinator whose id matches the selected id
                                    final issuedBy =
                                        state.employees.firstWhere(
                                      (coordinator) =>
                                          coordinator.EmployeeId ==
                                          selectedIssuedByID,
                                      orElse: () => EmployeeData(
                                          EmployeeName: "", EmployeeId: ""),
                                    );
                                    return Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        TransferDropdown<EmployeeData>(
                                          title: 'Issued By',
                                          hint: 'Select Person',
                                          selectedVal:
                                          issuedBy.EmployeeName ?? "",
                                          data: state.employees,
                                          displayText: (data) =>
                                              data.EmployeeName ?? '',
                                          onChanged: (val) {
                                            setState(() {
                                              selectedIssuedByID =
                                                  val.EmployeeId ?? "";
                                              err_issuedBy=null;
                                            });
                                          },
                                        ),
                                        if (err_issuedBy != null)errorText(err_issuedBy),
                                      ],
                                    );
                                  }
                                  return const SizedBox.shrink();
                                },
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              subTitle("Description and Gate Pass Number",
                                  bottomMargin: 5),
                              txtFiled(context, gatePass,
                                  "Enter Gate Pass Number", "Gate Pass",
                                  isNumber: true),
                              if (err_gatePass != null)errorText(err_gatePass),
                              const SizedBox(height: 10),
                              txtFiled(context, description,
                                  "Enter Description", "Description",
                                  maxLines: 5),
                              const SizedBox(height: 20),
                              BlocListener<MaterialIssuedBloc, MaterialIssuedState>(
                                listener: (context, state) {
                                  if (state is MaterialIssuedLoadSuccess) {
                                    setState(() {
                                      materialIssuedList = state.materials;
                                    });
                                    print(
                                        "Parent listener updated materialIssuedList: ${materialIssuedList.length}");
                                  } else if (state is MaterialIssuedFailure) {
                                    print(
                                        "MaterialIssued fetch failed: ${state.error}");
                                    // optionally show a snackbar or toast
                                  }
                                },
                                child: const SizedBox.shrink(),
                              ),
                              for (int i = 0; i < materialEntries.length; i++)
                              Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 10),
                                  margin: const EdgeInsets.only(bottom: 15),
                                  decoration: BoxDecoration(
                                    color:
                                        ColorConstants.primary.withOpacity(.01),
                                    borderRadius: BorderRadius.circular(5),
                                    border: Border.all(
                                      width: 1,
                                      color: ColorConstants.primary
                                          .withOpacity(.2),
                                    ),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      subTitle("Select From Warehouse",
                                          leftMargin: 10.0, bottomMargin: 5),
                                      // --- Warehouse dropdown ---
                                      BlocBuilder<WarehouseBloc,
                                          WarehouseState>(
                                        builder: (context, state) {
                                          if (state is WarehouseLoadSuccess) {
                                            final currentSelectedId =
                                                materialEntries[i]
                                                        .selectedFromWarehouseId
                                                        ?.toString() ??
                                                    '';
                                            final displayName = state.warehouses
                                                    .firstWhere(
                                                      (w) =>
                                                          (w.godown_id
                                                                  ?.toString() ??
                                                              '') ==
                                                          currentSelectedId,
                                                      orElse: () =>
                                                          WarehouseData(
                                                              godown_id: "",
                                                              godown_name: ""),
                                                    )
                                                    .godown_name ??
                                                '';

                                            // final selectedIds = materialEntries
                                            //     .asMap()
                                            //     .entries
                                            //     .where((e) => e.key != i)
                                            //     .map((e) => e.value
                                            //         .selectedFromWarehouseId)
                                            //     .where((id) =>
                                            //         id != null &&
                                            //         id!.isNotEmpty)
                                            //     .map((id) => id!.toString())
                                            //     .toSet();

                                            // final filteredWarehouses =
                                            //     state.warehouses.where((w) {
                                            //   final wid =
                                            //       w.godown_id?.toString() ?? '';
                                            //   return !selectedIds
                                            //           .contains(wid) ||
                                            //       wid == currentSelectedId;
                                            // }).toList();
                                            final filteredWarehouses = state.warehouses;
                                            return Column(
                                              children: [
                                                TransferDropdown<
                                                    WarehouseData>(
                                                  title: 'From Warehouse',
                                                  hint: 'Select warehouse',
                                                  selectedVal: materialEntries[i]
                                                          .selectedFromWarehouseName
                                                          .isNotEmpty
                                                      ? materialEntries[i]
                                                          .selectedFromWarehouseName
                                                      : (displayName.isNotEmpty
                                                          ? displayName
                                                          : ''),
                                                  data: filteredWarehouses,
                                                  displayText: (data) =>
                                                      data.godown_name ?? '',
                                                  onChanged: (val) {
                                                    final selectedWarehouseId = val.godown_id?.toString() ?? '';

                                                    if (selectedWarehouseId == selectedToProjectListID) {
                                                      if (!_validationInProgress) {
                                                        _validationInProgress = true;

                                                        Fluttertoast.showToast(
                                                          msg: "Project and Warehouse cannot be the same",
                                                        );

                                                        Future.delayed(const Duration(milliseconds: 300), () {
                                                          _validationInProgress = false;
                                                        });
                                                      }
                                                      return;
                                                    }
                                                    setState(() {
                                                      if (i < err_materialEntry.length) {
                                                        err_materialEntry[i] = null;
                                                      }
                                                      materialEntries[i]
                                                              .selectedFromWarehouseId =
                                                          val.godown_id?.toString();
                                                      materialEntries[i]
                                                              .selectedFromWarehouseName =
                                                          val.godown_name ?? '';
                                                      // ALWAYS clear downstream selections when warehouse changes
                                                      materialEntries[i]
                                                              .selectedCategoryId =
                                                          null;
                                                      materialEntries[i]
                                                          .selectedCategoryName = '';
                                                      materialEntries[i]
                                                              .selectedSubCategoryId =
                                                          null;
                                                      materialEntries[i]
                                                          .selectedSubCategoryName = '';
                                                      materialEntries[i]
                                                          .selectedMaterialsList = [];
                                                      materialEntries[i]
                                                          .selectedMaterialIds = [];
                                                      materialEntries[i]
                                                          .selectedGroupIds = [];
                                                      materialEntries[i]
                                                          .selectedSubgroupIds = [];
                                                      materialEntries[i]
                                                          .selectedMaterial = '';
                                                      materialEntries[i]
                                                              .selectedMaterialId =
                                                          null;
                                                      materialEntries[i]
                                                          .selectedGroupId = null;
                                                      materialEntries[i]
                                                              .selectedSubgroupId =
                                                          null;

                                                      // dispose & clear existing lines
                                                      for (final l in List<
                                                              MaterialLine>.from(
                                                          materialEntries[i]
                                                              .lines)) {
                                                        try {
                                                          l.dispose();
                                                        } catch (_) {}
                                                      }
                                                      materialEntries[i]
                                                          .lines
                                                          .clear();

                                                      materialEntries[i]
                                                          .currentBalance = 0;
                                                      materialEntries[i]
                                                          .remainingBalance = 0;
                                                      materialEntries[i]
                                                          .quantityController
                                                          .text = '0';
                                                    });

                                                    // fetch materials for the selected warehouse
                                                    final godown_id = materialEntries[
                                                                i]
                                                            .selectedFromWarehouseId ??
                                                        "";
                                                    print("godown_id $godown_id");
                                                    if (godown_id.isNotEmpty) {
                                                      context
                                                          .read<
                                                              MaterialIssuedBloc>()
                                                          .add(
                                                            FetchMaterialIssuedEvent(
                                                                godownId:
                                                                    godown_id),
                                                          );
                                                    }
                                                  },
                                                ),

                                              ],
                                            );
                                          }
                                          return const SizedBox.shrink();
                                        },
                                      ),
                                      Builder(builder: (context) {
                                        final hasSelectedWarehouse =
                                            (materialEntries[i]
                                                        .selectedFromWarehouseId ??
                                                    '')
                                                .isNotEmpty;
                                        if (!hasSelectedWarehouse) {
                                          // show hint to user to select warehouse first
                                          return Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 8.0, horizontal: 10),
                                            child: Text(
                                              'Select a warehouse to choose category, sub-category and materials',
                                              style: TextStyle(
                                                  color: Colors.grey.shade600,
                                                  fontSize: 13),
                                            ),
                                          );
                                        }

                                        // We have a warehouse — use MaterialIssuedBloc data to build stepwise lists
                                        return BlocBuilder<MaterialIssuedBloc,
                                            MaterialIssuedState>(
                                          builder: (context, state) {
                                            if (state
                                                is! MaterialIssuedLoadSuccess) {
                                              // still loading or no materials yet
                                              return const SizedBox.shrink();
                                            }

                                            final allMaterials =
                                                state.materials;

                                            // build unique category list preserving order
                                            final Map<String,
                                                    MaterialIssuedData>
                                                uniqueByGroup = {};
                                            for (final m in allMaterials) {
                                              final key = (m.groupid
                                                          ?.toString()
                                                          .isNotEmpty ??
                                                      false)
                                                  ? m.groupid!.toString()
                                                  : (m.groupname ?? '');
                                              if (!uniqueByGroup.containsKey(
                                                  key)) uniqueByGroup[key] = m;
                                            }
                                            final uniqueCategories =
                                                uniqueByGroup.values.toList();

                                            final selectedCategoryId =
                                                materialEntries[i]
                                                    .selectedCategoryId;
                                            final selectedSubCategoryId =
                                                materialEntries[i]
                                                    .selectedSubCategoryId;

                                            // subcategories under selected category (unique subgroupid)
                                            final List<MaterialIssuedData>
                                                subCategories =
                                                selectedCategoryId != null
                                                    ? allMaterials
                                                        .where((m) =>
                                                            (m.groupid
                                                                    ?.toString() ??
                                                                '') ==
                                                            selectedCategoryId
                                                                .toString())
                                                        .fold<List<MaterialIssuedData>>(
                                                            [], (acc, m) {
                                                        final existing = acc
                                                            .indexWhere((e) =>
                                                                (e.subgroupid
                                                                        ?.toString() ??
                                                                    '') ==
                                                                (m.subgroupid
                                                                        ?.toString() ??
                                                                    ''));
                                                        if (existing == -1)
                                                          acc.add(m);
                                                        return acc;
                                                      })
                                                    : [];

                                            // issued materials under the selected category+subcategory
                                            final List<MaterialIssuedData>
                                                issuedMaterials =
                                                (selectedCategoryId != null &&
                                                        selectedSubCategoryId !=
                                                            null)
                                                    ? allMaterials.where((m) {
                                                        final matchCategory = (m
                                                                    .groupid
                                                                    ?.toString() ??
                                                                '') ==
                                                            selectedCategoryId
                                                                .toString();
                                                        final matchSub = (m
                                                                    .subgroupid
                                                                    ?.toString() ??
                                                                '') ==
                                                            selectedSubCategoryId
                                                                .toString();
                                                        return matchCategory &&
                                                            matchSub;
                                                      }).toList()
                                                    : [];

                                            return Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                // 1) CATEGORY — visible because warehouse selected
                                                TransferDropdown<
                                                    MaterialIssuedData>(
                                                  title: 'Category',
                                                  hint: 'Select Category',
                                                  selectedVal: materialEntries[
                                                              i]
                                                          .selectedCategoryName
                                                          .isNotEmpty
                                                      ? materialEntries[i]
                                                          .selectedCategoryName
                                                      : (uniqueCategories
                                                              .firstWhere(
                                                                  (w) =>
                                                                      w.groupid ==
                                                                      materialEntries[
                                                                              i]
                                                                          .selectedCategoryId,
                                                                  orElse: () =>
                                                                      MaterialIssuedData(
                                                                          groupid:
                                                                              "",
                                                                          groupname:
                                                                              ""))
                                                              .groupname ??
                                                          'Select Category'),
                                                  data: uniqueCategories,
                                                  displayText: (data) =>
                                                      data.groupname ?? '',
                                                  onChanged: (val) {
                                                    setState(() {
                                                      err_materialEntry[i]=null;
                                                      materialEntries[i]
                                                              .selectedCategoryId =
                                                          val.groupid
                                                              ?.toString();
                                                      materialEntries[i]
                                                              .selectedCategoryName =
                                                          val.groupname ??
                                                              'Select Category';

                                                      // clear downstream: subcategory, materials, lines
                                                      materialEntries[i]
                                                              .selectedSubCategoryId =
                                                          null;
                                                      materialEntries[i]
                                                          .selectedSubCategoryName = '';
                                                      materialEntries[i]
                                                          .selectedMaterialsList = [];
                                                      materialEntries[i]
                                                          .selectedMaterialIds = [];
                                                      materialEntries[i]
                                                          .selectedGroupIds = [];
                                                      materialEntries[i]
                                                          .selectedSubgroupIds = [];

                                                      for (final l in List<
                                                              MaterialLine>.from(
                                                          materialEntries[i]
                                                              .lines)) {
                                                        try {
                                                          l.dispose();
                                                        } catch (_) {}
                                                      }
                                                      materialEntries[i]
                                                          .lines
                                                          .clear();
                                                      materialEntries[i]
                                                          .currentBalance = 0;
                                                      materialEntries[i]
                                                          .remainingBalance = 0;
                                                    });
                                                  },
                                                ),

                                                const SizedBox(height: 8),

                                                // 2) SUB CATEGORY — visible only when a category is selected
                                                if (materialEntries[i]
                                                            .selectedCategoryId !=
                                                        null &&
                                                    materialEntries[i]
                                                        .selectedCategoryId!
                                                        .isNotEmpty) ...[
                                                  TransferDropdown<
                                                      MaterialIssuedData>(
                                                    title: 'Sub Category',
                                                    hint: 'Select Sub Category',
                                                    selectedVal: materialEntries[
                                                                i]
                                                            .selectedSubCategoryName
                                                            .isNotEmpty
                                                        ? materialEntries[i]
                                                            .selectedSubCategoryName
                                                        : (subCategories
                                                                .firstWhere(
                                                                    (w) =>
                                                                        w.subgroupid ==
                                                                        materialEntries[i]
                                                                            .selectedSubCategoryId,
                                                                    orElse: () => MaterialIssuedData(
                                                                        groupid:
                                                                            "",
                                                                        groupname:
                                                                            ""))
                                                                .subgroupname ??
                                                            'Select Sub Category'),
                                                    data: subCategories,
                                                    displayText: (data) =>
                                                        data.subgroupname ?? '',
                                                    onChanged: (val) {
                                                      setState(() {
                                                        err_materialEntry[i]=null;
                                                        materialEntries[i]
                                                                .selectedSubCategoryId =
                                                            val.subgroupid
                                                                ?.toString();
                                                        materialEntries[i]
                                                            .selectedSubCategoryName = val
                                                                .subgroupname ??
                                                            'Select Sub Category';

                                                        // clear downstream when subcategory changes
                                                        materialEntries[i]
                                                            .selectedMaterialsList = [];
                                                        materialEntries[i]
                                                            .selectedMaterialIds = [];
                                                        materialEntries[i]
                                                            .selectedGroupIds = [];
                                                        materialEntries[i]
                                                            .selectedSubgroupIds = [];
                                                        for (final l in List<
                                                                MaterialLine>.from(
                                                            materialEntries[i]
                                                                .lines)) {
                                                          try {
                                                            l.dispose();
                                                          } catch (_) {}
                                                        }
                                                        materialEntries[i]
                                                            .lines
                                                            .clear();
                                                        materialEntries[i]
                                                            .currentBalance = 0;
                                                        materialEntries[i]
                                                            .remainingBalance = 0;
                                                      });
                                                    },
                                                  ),
                                                  const SizedBox(height: 8),
                                                ],

                                                // 3) ISSUED MATERIAL — visible only when subcategory is selected
                                                if (materialEntries[i]
                                                            .selectedSubCategoryId !=
                                                        null &&
                                                    materialEntries[i]
                                                        .selectedSubCategoryId!
                                                        .isNotEmpty) ...[
                                                  MultiSelectDropdown<
                                                      MaterialIssuedData>(
                                                    title: 'Issued Material',
                                                    hint: 'Select Material',
                                                    data: issuedMaterials,
                                                    displayText: (d) =>
                                                        d.item ?? '',
                                                    selectedValues:
                                                        materialEntries[i]
                                                            .selectedMaterialsList,
                                                    onChanged: (List<
                                                            MaterialIssuedData>
                                                        selectedList) {
                                                      setState(() {
                                                        err_materialEntry[i]=null;
                                                        final entry =
                                                            materialEntries[i];

                                                        String keyOf(
                                                            MaterialIssuedData
                                                                d) {
                                                          if ((d.item_id
                                                                  ?.isNotEmpty ??
                                                              false))
                                                            return d.item_id!;
                                                          if ((d.item ?? '')
                                                              .isNotEmpty)
                                                            return d.item!;
                                                          return '${d.groupid}_${d.subgroupid}_${d.item}_${d.item_id}';
                                                        }

                                                        final selectedKeys =
                                                            selectedList
                                                                .map(keyOf)
                                                                .toSet();
                                                        final existingKeys =
                                                            entry
                                                                .lines
                                                                .map((l) =>
                                                                    keyOf(
                                                                        l.data))
                                                                .toSet();

                                                        final added = selectedList
                                                            .where((s) =>
                                                                !existingKeys
                                                                    .contains(
                                                                        keyOf(
                                                                            s)));
                                                        final removed = entry
                                                            .lines
                                                            .where((l) =>
                                                                !selectedKeys
                                                                    .contains(
                                                                        keyOf(l
                                                                            .data)))
                                                            .toList();

                                                        for (final r
                                                            in removed) {
                                                          try {
                                                            r.dispose();
                                                          } catch (_) {}
                                                          entry.lines.remove(r);
                                                        }

                                                        for (final a in added) {
                                                          final newLine =
                                                              MaterialLine(data: a);
                                                          // final key =
                                                          //     a.item ?? '';
                                                          final key = a.item_id ?? '';
                                                          print("key item_id ${key}");
                                                          final cached = unitsByItem[key];
                                                          if (cached != null &&
                                                              cached
                                                                  .isNotEmpty) {
                                                            final defaultUnit =
                                                                cached.first;
                                                            newLine.selectedUnit =
                                                                defaultUnit
                                                                        .unit_name ??
                                                                    '';
                                                            newLine.selectedUnitId =
                                                                defaultUnit
                                                                    .hsncode
                                                                    ?.toString();
                                                          }
                                                          entry.lines
                                                              .add(newLine);
                                                          if (key.isNotEmpty &&
                                                              !unitsByItem
                                                                  .containsKey(
                                                                      key) &&
                                                              !unitsLoadingFor
                                                                  .contains(
                                                                      key)) {
                                                            unitsLoadingFor
                                                                .add(key);
                                                            // context
                                                            //     .read<
                                                            //         UnitsBloc>()
                                                            //     .add(FetchUnitsEvent(
                                                            //         itemName: key,));
                                                            print("key : ${key}");
                                                            context
                                                                .read<
                                                                BasicUnitsBloc>()
                                                                .add(FetchBasicUnitsEvent(
                                                              itemName: key,));
                                                          }
                                                        }

                                                        // preserve selected order
                                                        entry.lines
                                                            .sort((a, b) {
                                                          final ai = selectedList
                                                              .indexWhere((s) =>
                                                                  keyOf(s) ==
                                                                  keyOf(
                                                                      a.data));
                                                          final bi = selectedList
                                                              .indexWhere((s) =>
                                                                  keyOf(s) ==
                                                                  keyOf(
                                                                      b.data));
                                                          return ai
                                                              .compareTo(bi);
                                                        });

                                                        entry.selectedMaterialsList =
                                                            List.from(
                                                                selectedList);
                                                        entry.selectedMaterial =
                                                            selectedList
                                                                .map((e) =>
                                                                    e.item ??
                                                                    '')
                                                                .join(', ');
                                                        entry.selectedMaterialIds =
                                                            selectedList
                                                                .map((e) =>
                                                                    keyOf(e))
                                                                .toList();
                                                        entry.selectedGroupIds =
                                                            selectedList
                                                                .map((e) =>
                                                                    e.groupid
                                                                        ?.toString() ??
                                                                    '')
                                                                .toList();
                                                        entry.selectedSubgroupIds =
                                                            selectedList
                                                                .map((e) =>
                                                                    e.subgroupid
                                                                        ?.toString() ??
                                                                    '')
                                                                .toList();
                                                        entry.currentBalance =
                                                            entry.lines.fold<double>(
                                                              0.0,
                                                                  (acc, l) => acc + l.currentBalance,
                                                            );

                                                        entry.remainingBalance =
                                                            entry.lines.fold<double>(
                                                              0.0,
                                                                  (acc, l) => acc + l.remainingBalance,
                                                            );
                                                        // entry.currentBalance =
                                                        //     entry.lines.fold<
                                                        //             int>(
                                                        //         0,
                                                        //         (acc, l) =>
                                                        //             acc +
                                                        //             l.currentBalance);
                                                        // entry.remainingBalance =
                                                        //     entry.lines.fold<
                                                        //             int>(
                                                        //         0,
                                                        //         (acc, l) =>
                                                        //             acc +
                                                        //             l.remainingBalance);
                                                      });
                                                    },
                                                  ),
                                                  const SizedBox(height: 8),
                                                ],
                                              ],
                                            );
                                          },
                                        );
                                      }), // end Builder
                                      const SizedBox(height: 8),
                                      Column(
                                        children: [
                                          for (int m = 0;
                                              m <
                                                  materialEntries[i]
                                                      .lines
                                                      .length;
                                              m++)
                                            _buildMaterialLine(i, m),
                                        ],
                                      ),
                                      if (i < err_materialEntry.length &&
                                          err_materialEntry[i] != null)
                                      Padding(
                                          padding: const EdgeInsets.only(left: 10, bottom: 8),
                                          child: errorText(err_materialEntry[i]),
                                      ),
                                      const SizedBox(height: 10),
                                      // Out time + remove button row
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const Text(
                                                "Out Time",
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.grey,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                              CustomDateTimeTextField(
                                                showTitle: false,
                                                onTap: () =>
                                                    _pickTimeForEntry(i),
                                                hint: materialEntries[i]
                                                            .outTime ==
                                                        null
                                                    ? '-- Time:--'
                                                    : formatTimeWithSpace(
                                                        materialEntries[i]
                                                            .outTime!),
                                                icon:
                                                    Icons.watch_later_outlined,
                                              ),
                                            ],
                                          ),
                                          InkWell(
                                            onTap: () {
                                              removeMaterialField(i);
                                            },
                                            child: Container(
                                              height: 40,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 10),
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                      width: 1,
                                                      color: ColorConstants
                                                          .primary
                                                          .withOpacity(.3)),
                                                  borderRadius:
                                                      BorderRadius.circular(5)),
                                              child: Row(
                                                children: [
                                                  cText("Remove",
                                                      color: ColorConstants
                                                          .primary),
                                                  const SizedBox(width: 10),
                                                  Icon(Icons.close,
                                                      color: ColorConstants
                                                          .primary,
                                                      size: 15),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                    ],
                                  ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  SecondaryButton(
                                      title: "Add Material",
                                      onAction: addMaterialField),
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
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        )
    );
  }

  Widget _buildMaterialLine(int entryIndex, int lineIndex) {
    final entry = materialEntries[entryIndex];
    final line = entry.lines[lineIndex];
    final itemKey = line.data.item_id ?? '';
    final availableUnits = unitsByItem[itemKey] ?? [];
    // local helper to recalculate effects of used + scrap WITHOUT changing Quantity
    void _recalcFromUsedAndScrap() {
      final double currentBalance = line.currentBalance; // immutable
      final int issued = int.tryParse(line.quantityController.text) ?? 0; // keep quantity
      int used = int.tryParse(line.usedQuantityController.text) ?? 0;
      int scrap = int.tryParse(line.scrapController.text) ?? 0;

      // Ensure used <= issued
      if (used > issued) {
        final newUsedStr = issued.toString();
        if (line.usedQuantityController.text != newUsedStr) {
          line.usedQuantityController.text = newUsedStr;
          line.usedQuantityController.selection =
              TextSelection.collapsed(offset: newUsedStr.length);
        }
        used = issued;
      }

      // Ensure scrap <= issued
      if (scrap > issued) {
        final newScrapStr = issued.toString();
        if (line.scrapController.text != newScrapStr) {
          line.scrapController.text = newScrapStr;
          line.scrapController.selection =
              TextSelection.collapsed(offset: newScrapStr.length);
        }
        scrap = issued;
      }

      // If used + scrap exceeds issued, reduce scrap to fit (prefer preserving used)
      if (used + scrap > issued) {
        scrap = issued - used;
        if (scrap < 0) scrap = 0;
        final newScrapStr = scrap.toString();
        if (line.scrapController.text != newScrapStr) {
          line.scrapController.text = newScrapStr;
          line.scrapController.selection =
              TextSelection.collapsed(offset: newScrapStr.length);
        }
      }

      // DO NOT modify quantityController here — quantity must remain what user set.
      // remainingBalance remains based on the quantity (not on used/scrap)
      final int displayedIssued = issued;
      line.remainingBalance = currentBalance - displayedIssued;
      entry.remainingBalance =
          entry.lines.fold<double>(0, (acc, l) => acc + l.remainingBalance);

      setState(() {});
    }

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: ColorConstants.primary.withOpacity(.01),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Colors.grey.withOpacity(.6)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // header: item name + remove button
          Row(
            children: [
              cText("Issued Material : ", color: Colors.black),
              Expanded(
                child: Text(
                  line.data.item ?? '',
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    // local helper to compute the same key you use for the dropdown
                    String keyOf(MaterialIssuedData d) {
                      if ((d.item_id?.isNotEmpty ?? false)) return d.item_id!;
                      if ((d.item ?? '').isNotEmpty) return d.item!;
                      return '${d.groupid}_${d.subgroupid}_${d.item}_${d.item_id}';
                    }

                    // defensive: if index out of range do nothing
                    if (lineIndex < 0 || lineIndex >= entry.lines.length)
                      return;

                    // remove the specific line
                    final removedLine = entry.lines.removeAt(lineIndex);
                    try {
                      removedLine.dispose();
                    } catch (_) {}

                    // Rebuild selectedMaterialsList from remaining lines (keeps dropdown consistent)
                    entry.selectedMaterialsList =
                        entry.lines.map((l) => l.data).toList();

                    // Rebuild other selection metadata
                    entry.selectedMaterial = entry.selectedMaterialsList
                        .map((e) => e.item ?? '')
                        .join(', ');
                    entry.selectedMaterialIds = entry.selectedMaterialsList
                        .map((e) => keyOf(e))
                        .toList();
                    entry.selectedGroupIds = entry.selectedMaterialsList
                        .map((e) => e.groupid?.toString() ?? '')
                        .toList();
                    entry.selectedSubgroupIds = entry.selectedMaterialsList
                        .map((e) => e.subgroupid?.toString() ?? '')
                        .toList();

                    // Recompute aggregates
                    entry.currentBalance = entry.lines
                        .fold<double>(0, (acc, l) => acc + l.currentBalance);
                    entry.remainingBalance = entry.lines
                        .fold<double>(0, (acc, l) => acc + l.remainingBalance);
                  });
                },
                child: const Icon(Icons.close,
                    size: 18, color: ColorConstants.primary),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Current Balance (immutable)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Balance",
                      style: TextStyle(fontSize: 12, color: Colors.grey)),
                  const SizedBox(height: 6),
                  Container(
                    width: 90,
                    height: 35,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: ColorConstants.primary.withOpacity(.09),
                    ),
                    child: Center(
                      child: Text(
                        "${line.currentBalance}",
                        style: const TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 5),
              // Remaining Balance (based on quantity)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Current Bal",
                      style: TextStyle(fontSize: 12, color: Colors.grey)),
                  const SizedBox(height: 6),
                  Container(
                    height: 35,
                    width: 70,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.white,
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Center(
                      child: Text(
                        "${line.remainingBalance}",
                        style: const TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 5),
              // Quantity (editable) - changes here can clamp used/scrap
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Quantity",
                      style: TextStyle(fontSize: 12, color: Colors.grey)),
                  const SizedBox(height: 6),
                  Container(
                    height: 35,
                    width: 100,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade400),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: TextField(
                      controller: line.quantityController,
                      keyboardType: TextInputType.numberWithOptions(
                        signed: false,
                        decimal: false,
                      ),
                      // blocks letters, special chars, minus and decimal
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      textAlignVertical: TextAlignVertical.center,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                      ),
                      onChanged: (val) {
                        // if (val.trim().isEmpty) {
                        //   return; // stop auto balance update when field is empty
                        // }
                        double entered = double.tryParse(val) ?? 0.0;
                        if (entered < 0) entered = 0;

                        // clamp to available currentBalance
                        if (entered > line.currentBalance) {
                          entered = line.currentBalance;
                          final enteredStr = entered.toString();
                          if (line.quantityController.text != enteredStr) {
                            line.quantityController.text = enteredStr;
                            line.quantityController.selection =
                                TextSelection.collapsed(
                                    offset: enteredStr.length);
                          }
                        }

                        // If used or scrap are greater than new quantity, quietly clamp them
                        final int used =
                            int.tryParse(line.usedQuantityController.text) ?? 0;
                        if (used > entered) {
                          final newUsedStr = entered.toString();
                          if (line.usedQuantityController.text != newUsedStr) {
                            line.usedQuantityController.text = newUsedStr;
                            line.usedQuantityController.selection =
                                TextSelection.collapsed(
                                    offset: newUsedStr.length);
                          }
                        }

                        final int scrap =
                            int.tryParse(line.scrapController.text) ?? 0;
                        if (scrap > entered) {
                          final newScrapStr = entered.toString();
                          if (line.scrapController.text != newScrapStr) {
                            line.scrapController.text = newScrapStr;
                            line.scrapController.selection =
                                TextSelection.collapsed(
                                    offset: newScrapStr.length);
                          }
                        }

                        // update remaining balance based on the new 'entered' (issued)
                        setState(() {
                          line.remainingBalance =
                              (line.currentBalance - entered);
                          entry.remainingBalance = entry.lines.fold<double>(
                              0, (acc, l) => acc + l.remainingBalance);
                        });
                      },
                    ),
                  )
                ],
              ),

              const SizedBox(width: 10),
            ],
          ),
          const SizedBox(height: 10),

          // Units dropdown
          // BlocListener<UnitsBloc, UnitsState>(
          //   listener: (context, state) {
          //     if (state is UnitsLoadSuccess) {
          //       final fetchedUnits = state.units;
          //       final itemNameFromState = state.itemName;
          //
          //       setState(() {
          //         unitsByItem[itemNameFromState] = fetchedUnits;
          //         unitsLoadingFor.remove(itemNameFromState);
          //
          //         for (final ent in materialEntries) {
          //           for (final ln in ent.lines) {
          //             if ((ln.data.item ?? '') == itemNameFromState &&
          //                 (ln.selectedUnit == null ||
          //                     ln.selectedUnit!.isEmpty) &&
          //                 fetchedUnits.isNotEmpty) {
          //               final defaultUnit = fetchedUnits.first;
          //               ln.selectedUnit = defaultUnit.unit_name ?? '';
          //               ln.selectedUnitId = defaultUnit.hsncode?.toString();
          //             }
          //           }
          //         }
          //       });
          //     }
          //   },
          //   child: TransferDropdown<UnitsData>(
          //     title: 'Units',
          //     hint: availableUnits.isEmpty
          //         ? 'No units available'
          //         : 'Select Units',
          //     selectedVal: line.selectedUnit,
          //     data: availableUnits,
          //     displayText: (u) => u.unit_name ?? '',
          //     onChanged: (UnitsData u) {
          //       setState(() {
          //         line.selectedUnit = u.unit_name ?? '';
          //         line.selectedUnitId = u.hsncode?.toString();
          //       });
          //     },
          //   ),
          // ),
          BlocListener<BasicUnitsBloc, BasicUnitsState>(
            listener: (context, state) {
              if (state is BasicUnitsLoadSuccess) {
                final fetchedUnits = state.basicUnits;
                final itemNameFromState = state.itemName;

                setState(() {
                  List<UnitsData> combinedUnits = [];

                  for (var unit in fetchedUnits) {

                    /// ⭐ Add Basic Unit
                    if (unit.basic_unit_name != null &&
                        unit.basic_unit_name!.isNotEmpty &&
                        !combinedUnits.any(
                                (e) => e.alt_unit_name == unit.basic_unit_name)) {

                      combinedUnits.add(
                        UnitsData(
                          alt_unit_name: unit.basic_unit_name,
                          basic_value: unit.basic_value,
                          alt_value: unit.alt_value,
                        ),
                      );
                    }

                    /// ⭐ Add Alt Unit
                    if (unit.alt_unit_name != null &&
                        unit.alt_unit_name!.isNotEmpty) {

                      combinedUnits.add(
                        UnitsData(
                          alt_unit_name: unit.alt_unit_name,
                          basic_value: unit.basic_value,
                          alt_value: unit.alt_value,
                        ),
                      );
                    }
                  }

                  /// assign units
                  unitsByItem[itemNameFromState] = combinedUnits;
                  unitsLoadingFor.remove(itemNameFromState);

                  /// ⭐ Set default + update balance (already correct ✅)
                  for (final ent in materialEntries) {
                    for (final ln in ent.lines) {
                      if ((ln.data.item ?? '') == itemNameFromState &&
                          combinedUnits.isNotEmpty &&
                          (ln.selectedUnit == null || ln.selectedUnit!.isEmpty)) {

                        final defaultUnit = combinedUnits.first;

                        ln.selectedUnit = defaultUnit.alt_unit_name ?? '';
                        ln.selectedUnitId = defaultUnit.alt_unit_name ?? '';

                        double basic =
                            double.tryParse(defaultUnit.basic_value?.toString() ?? '1') ?? 1;

                        double alt =
                            double.tryParse(defaultUnit.alt_value?.toString() ?? '1') ?? 1;

                        ln.updateBalanceWithUnit(
                          basic: basic,
                          alt: alt,
                        );
                      }
                    }
                  }
                });
              }
            },

            /// ✅ UPDATED CHILD SECTION
            child: Builder(
              builder: (context) {

                /// ✅ ADDED THIS BLOCK (IMPORTANT FIX)
                if ((line.selectedUnit == null || line.selectedUnit!.isEmpty) &&
                    availableUnits.isNotEmpty) {

                  final defaultUnit = availableUnits.first;

                  line.selectedUnit = defaultUnit.alt_unit_name ?? '';
                  line.selectedUnitId = defaultUnit.alt_unit_name ?? '';

                  double basic =
                      double.tryParse(defaultUnit.basic_value?.toString() ?? '1') ?? 1;

                  double alt =
                      double.tryParse(defaultUnit.alt_value?.toString() ?? '1') ?? 1;

                  line.updateBalanceWithUnit(
                    basic: basic,
                    alt: alt,
                  );
                }

                return TransferDropdown<UnitsData>(
                    title: 'Units',
                    hint: availableUnits.isEmpty
                        ? 'No units available'
                        : 'Select Units',

                    /// ✅ KEEP THIS (UI fallback)
                    selectedVal: line.selectedUnit.isNotEmpty
                        ? line.selectedUnit
                        : (availableUnits.isNotEmpty
                        ? availableUnits.first.alt_unit_name ?? ''
                        : ''),

                    data: availableUnits,
                    displayText: (u) => u.alt_unit_name ?? '',
                    onChanged: (UnitsData u) {
                      setState(() {
                        line.selectedUnit = u.alt_unit_name ?? '';
                        line.selectedUnitId = u.alt_unit_name ?? '';

                        double basic =
                            double.tryParse(u.basic_value?.toString() ?? '1') ?? 1;

                        double alt =
                            double.tryParse(u.alt_value?.toString() ?? '1') ?? 1;

                        if (alt != 0) {
                          line.conversionFactor = basic / alt;
                          line.currentBalance =
                              line.originalBalance / line.conversionFactor;
                        } else {
                          line.conversionFactor = 1;
                          line.currentBalance = line.originalBalance;
                        }

                        double issued =
                            double.tryParse(line.quantityController.text) ?? 0;

                        line.remainingBalance = line.currentBalance - issued;

                        entry.currentBalance =
                            entry.lines.fold(0, (sum, l) => sum + l.currentBalance);

                        entry.remainingBalance =
                            entry.lines.fold(0, (sum, l) => sum + l.remainingBalance);
                      });
                    }
                );
              },
            ),
          ),
          const SizedBox(height: 8),
          // Quality / Scrap / Rate toggle per-line
          if (selectedTransfer == "Project Type") ...[
            InkWell(
              onTap: () {
                setState(() {
                  line.showQualityFields = !line.showQualityFields;
                });
              },
              child: Row(
                children: [
                  Container(
                    width: 18,
                    height: 18,
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: line.showQualityFields
                              ? ColorConstants.primary
                              : Colors.grey),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Center(
                      child: Icon(Icons.check,
                          size: 12,
                          color: line.showQualityFields
                              ? ColorConstants.primary
                              : Colors.transparent),
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text("Add Quantity,Scrap,Rate"),
                ],
              ),
            ),
            if (line.showQualityFields) ...[
              const SizedBox(height: 20),
              // Used Quantity: on change recalc (does NOT change quantity)
              txtField(context, "Used Quantity", line.usedQuantityController,
                  onChange: (_) => _recalcFromUsedAndScrap()),
              // Scrap: on change recalc (does NOT change quantity)
              txtField(context, "Scrap", line.scrapController,
                  onChange: (_) => _recalcFromUsedAndScrap()),
              txtField(context, "Rate", line.rateController, onChange: (val) {
                setState(() {});
              }),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text("Amount: ${_computeAmount(line)}",
                      style: const TextStyle(fontWeight: FontWeight.w600)),
                ],
              ),
            ],
          ],
        ],
      ),
    );
  }

  String _computeAmount(MaterialLine line) {
    final q = int.tryParse(line.quantityController.text) ?? 0;
    final usedqty = int.tryParse(line.usedQuantityController.text) ?? 0;
    final scrap = int.tryParse(line.scrapController.text) ?? 0;
    final r = double.tryParse(line.rateController.text) ?? 0;
    final amt = (usedqty+scrap) * r;
    if (amt == amt.roundToDouble()) return amt.toInt().toString();
    return amt.toStringAsFixed(2);
  }
}
