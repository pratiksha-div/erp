import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';
import 'ERP/UI/Pages/Authentication/Login.dart';
import 'ERP/UI/Pages/Starter/Splash_Screen.dart';
import 'ERP/UI/Utils/colors_constants.dart';
import 'ERP/UI/Utils/utils.dart';
import 'ERP/api/services/add_gate_pass_service.dart';
import 'ERP/api/services/add_goods_received_notes_service.dart';
import 'ERP/api/services/add_machine_reading_service.dart';
import 'ERP/api/services/add_material_consumption.dart';
import 'ERP/api/services/add_new_entry.dart';
import 'ERP/api/services/dropdown_value_service.dart';
import 'ERP/api/services/gate_entry_service.dart';
import 'ERP/api/services/get_project_service.dart';
import 'ERP/bloc/AuthenticationBloc/authentication_bloc.dart';
import 'ERP/bloc/AuthenticationBloc/send_otp_bloc.dart';
import 'ERP/bloc/AuthenticationBloc/verify_otp_bloc.dart';
import 'ERP/bloc/DailyReporting/add_machine_reading_boc.dart';
import 'ERP/bloc/DailyReporting/add_material_consumption_bloc.dart';
import 'ERP/bloc/DailyReporting/add_new_entry_bloc.dart';
import 'ERP/bloc/DailyReporting/delete_machine_reading_bloc.dart';
import 'ERP/bloc/DailyReporting/delete_material_consumption_bloc.dart';
import 'ERP/bloc/DailyReporting/delete_new_entry_bloc.dart';
import 'ERP/bloc/DailyReporting/entry_by_id_bloc.dart';
import 'ERP/bloc/DailyReporting/machine_reading_by_id_bloc.dart';
import 'ERP/bloc/DailyReporting/material_consumption_by_id_bloc.dart';
import 'ERP/bloc/DropDownValueBloc/basic_units_bloc.dart';
import 'ERP/bloc/DropDownValueBloc/employee_type_bloc.dart';
import 'ERP/bloc/DropDownValueBloc/emplyee_list_bloc.dart';
import 'ERP/bloc/DropDownValueBloc/gate_entry_number_bloc.dart';
import 'ERP/bloc/DropDownValueBloc/material_consumption_used_bloc.dart';
import 'ERP/bloc/DropDownValueBloc/material_issued_bloc.dart';
import 'ERP/bloc/DropDownValueBloc/project_coordinator_bloc.dart';
import 'ERP/bloc/DropDownValueBloc/project_list_bloc.dart';
import 'ERP/bloc/DropDownValueBloc/project_manager_bloc.dart';
import 'ERP/bloc/DropDownValueBloc/project_type_bloc.dart';
import 'ERP/bloc/DropDownValueBloc/purchase_order_number_bloc.dart';
import 'ERP/bloc/DropDownValueBloc/registered_customer_bloc.dart';
import 'ERP/bloc/DropDownValueBloc/states_bloc.dart';
import 'ERP/bloc/DropDownValueBloc/units_bloc.dart';
import 'ERP/bloc/DropDownValueBloc/vehicle_name_bloc.dart';
import 'ERP/bloc/DropDownValueBloc/vehicle_no_bloc.dart';
import 'ERP/bloc/DropDownValueBloc/vehicle_number_bloc.dart';
import 'ERP/bloc/DropDownValueBloc/vendor_contractor_name_bloc.dart';
import 'ERP/bloc/DropDownValueBloc/warehouse_list_bloc.dart';
import 'ERP/bloc/GateEntry/add_purchase_detail_bloc.dart';
import 'ERP/bloc/GateEntry/delete_gate_entry_bloc.dart';
import 'ERP/bloc/GateEntry/gate_entry_by_id_bloc.dart';
import 'ERP/bloc/GateEntry/purchase_order_detail_bloc.dart';
import 'ERP/bloc/GatePass/add_new_gate_pass_bloc.dart';
import 'ERP/bloc/GatePass/add_warehouse_to_project.dart';
import 'ERP/bloc/GatePass/add_warehouse_transfer.dart';
import 'ERP/bloc/GatePass/delete_gate_pass_bloc.dart';
import 'ERP/bloc/GatePass/delete_gate_pass_project_bloc.dart';
import 'ERP/bloc/GatePass/delete_gate_pass_warehouse_bloc.dart';
import 'ERP/bloc/GatePass/gate_pass_by_id_bloc.dart';
import 'ERP/bloc/GoodsReceivedNotesBloc/add_goods_received_notes_bloc.dart';
import 'ERP/bloc/GoodsReceivedNotesBloc/delete_grn_bloc.dart';
import 'ERP/bloc/GoodsReceivedNotesBloc/goods_received_notes_by_id_bloc.dart';
import 'ERP/bloc/GoodsReceivedNotesBloc/grn_detail_by_id_bloc.dart';
import 'ERP/bloc/GoodsReceivedNotesBloc/grn_download.dart';
import 'ERP/bloc/ProjectBloc/add_project_bloc.dart';
import 'ERP/bloc/ProjectBloc/delete_project_bloc.dart';
import 'ERP/bloc/ProjectBloc/get_project_data_bloc.dart';
import 'ERP/data/local/AppUtils.dart';


int r = 227;
int g = 133;
int b = 4;

Map<int, Color> color = {
  50: Color.fromRGBO(r, g, b, 0.1),
  100: Color.fromRGBO(r, g, b, .2),
  200: Color.fromRGBO(r, g, b, .3),
  300: Color.fromRGBO(r, g, b, .4),
  400: Color.fromRGBO(r, g, b, .5),
  500: Color.fromRGBO(r, g, b, .6),
  600: Color.fromRGBO(r, g, b, .7),
  700: Color.fromRGBO(r, g, b, .8),
  800: Color.fromRGBO(r, g, b, .9),
  900: Color.fromRGBO(r, g, b, 1),
};


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Create the service instance (synchronous)
  final dropDownService = DropdownServices();
  final projectService = GetProjectDataService();
  final entryByIdService = GetEntryByIDService();
  final gatePassByIdService = GatePassDataByIDService();
  final machineReadingByIDService = GetMachineReadingByIDService();
  final materialConsumptionByIDService = GetMaterialConsumptionByIDService();
  final purchaseOrderService = GetPurchaseOrderDataService();
  final goodsReceivedNotesByIDService = GoodsReceivedByIDService();
  final goodsReceivedNotesDetailByIDService = GetGRNDetailByIDService();
  final gateEntryByIDService = GateEntryByIDService();

  // Create adapter that implements EmployeeService
  final employeeService = EmployeeServiceAdapter(dropDownService: dropDownService);
  final gateEntryNumberService = GateEntryNumberServiceAdapter(dropDownService: dropDownService);
  final warehouseService = WarehouseServiceAdapter(dropDownService: dropDownService);
  final projectlistService = ProjectListServiceAdapter(dropDownService: dropDownService);
  final vehicleNoService = VehicleServiceAdapter(dropDownService: dropDownService);
  final materialIssuedService = MaterialIssuedServiceAdapter(dropDownService: dropDownService);
  final projectCoordinatorService = ProjectCoordinatorServiceAdapter(dropDownService: dropDownService);
  final projectTypeService = ProjectTypeServiceAdapter(dropDownService: dropDownService);
  // final statusService = StatusServiceAdapter(dropDownService: dropDownService);
  final statesService = AllStatesServiceAdapter(dropDownService: dropDownService);
  final projectManagerService = ProjectManagerServiceAdapter(dropDownService: dropDownService);
  final employeeTypeService = EmployeeTypeServiceAdapter(dropDownService: dropDownService);
  final purchaseOrderNumber = PurchaseOrderNumberServiceAdapter(dropDownService: dropDownService);
  final unitsService = UnitsServiceAdapter(dropDownService: dropDownService);
  final basicunitsService = BasicUnitsServiceAdapter(dropDownService: dropDownService);
  final vendorService = VendorNameServiceAdapter(dropDownService: dropDownService);
  final vehicleNameService = VehicleNameServiceAdapter(dropDownService: dropDownService);
  final vehicleNumberService = VehicleNumberServiceAdapter(dropDownService: dropDownService);
  final materialConsumptionUsed = MaterialConsumptionUsedServiceAdapter(dropDownService: dropDownService);
  final projectDataService = ProjectDataServiceAdapter(projectDataService: projectService);
  final entryDataService = EntryByIDServiceAdapter(EntryByIDService:entryByIdService );
  final gatePassIdService = GatePassByIDServiceAdapter(GatePassByIDService: gatePassByIdService);
  final machineReadingIDService = MachineReadingByIDServiceAdapter(MachineReadingByIDService: machineReadingByIDService);
  final materialConsumptionIDService = MaterialConsumptionByIDServiceAdapter(MaterialConsumptionByIDService: materialConsumptionByIDService);
  final purchaseOrderDetailService = PurchaseOrderDetailServiceAdapter(PurchaseOrderDetailService: purchaseOrderService);
  final goodsReceivedByIDService = GoodsReceivedNotesByIDServiceAdapter(GoodsReceivedNotesByIDService: goodsReceivedNotesByIDService);
  final regCustomerService = RegisteredCustomerServiceAdapter(dropDownService: dropDownService);
  final grnDetailByIDServices = GRNDetailByIDServiceAdapter(GRNDetailByIDService: goodsReceivedNotesDetailByIDService);
  final gateEntryBYIDService = GateEntryBYIDServiceAdapter(GateEntryBYIDService:gateEntryByIDService);

  runApp(
      MyApp(
        employeeService: employeeService,
        warehouseService: warehouseService,
        projectListService: projectlistService,
        vehicleNoService: vehicleNoService,
        materialIssuedService: materialIssuedService,
        unitsService: unitsService,
        projectCoordinatorService: projectCoordinatorService,
        projectTypeService: projectTypeService,
        // statusService: statusService,
        statesService: statesService,
        projectManagerService: projectManagerService,
        employeeTypeService: employeeTypeService,
        purchaseOrderNumber: purchaseOrderNumber,
        vendorService: vendorService,
        vehicleNameService: vehicleNameService,
        vehicleNumberService: vehicleNumberService,
        materialConsumptionUsed: materialConsumptionUsed,
        projectDataService: projectDataService,
        entryDataService: entryDataService,
        gatePassByIdService: gatePassIdService,
        machineReadingIDService: machineReadingIDService,
        materialConsumptionByIDService: materialConsumptionIDService,
        purchaseOrderDetailService: purchaseOrderDetailService,
        ge_number_Service: gateEntryNumberService,
        goodsReceivedNotesByIDService: goodsReceivedByIDService,
        regCustomerService: regCustomerService,
        grnDetailByIDServices: grnDetailByIDServices,
        gateEntryBYIDService: gateEntryBYIDService,
        basicUnitsService: basicunitsService,
  ));

}

class MyApp extends StatefulWidget  {
   MyApp({Key? key,
     required this.employeeService,
     required this.warehouseService,
     required this.projectListService,
     required this.vehicleNoService,
     required this.materialIssuedService,
     required this.projectCoordinatorService,
     required this.projectTypeService,
     // required this.statusService,
     required this.statesService,
     required this.projectManagerService,
     required this.employeeTypeService,
     required this.purchaseOrderNumber,
     required this.unitsService,
     required this.vendorService,
     required this.vehicleNameService,
     required this.vehicleNumberService,
     required this.materialConsumptionUsed,
     required this.projectDataService,
     required this.entryDataService,
     required this.gatePassByIdService,
     required this.machineReadingIDService,
     required this.materialConsumptionByIDService,
     required this.purchaseOrderDetailService,
     required this.ge_number_Service,
     required this.goodsReceivedNotesByIDService,
     required this.regCustomerService,
     required this.grnDetailByIDServices,
     required this.gateEntryBYIDService,
     required this.basicUnitsService,

   }) : super(key: key);
   final EmployeeService employeeService;
   final WarehouseService warehouseService;
   final ProjectListService projectListService;
   final VehicleService vehicleNoService;
   final MaterialIssuedService materialIssuedService;
   final ProjectCoordinatorService projectCoordinatorService;
   final ProjectTypeService projectTypeService;
   // final StatusService statusService;
   final AllStatesService statesService;
   final ProjectManagerService projectManagerService;
   final EmployeeTypeService employeeTypeService;
   final PurchaseOrderNumberService purchaseOrderNumber;
   final UnitsService unitsService;
   final VendorNameService vendorService;
   final VehicleNameService vehicleNameService;
   final VehicleNumberService vehicleNumberService;
   final MaterialConsumptionUsedService materialConsumptionUsed;
   final ProjectDataService projectDataService;
   final EntryByIDService entryDataService;
   final GatePassByIDService gatePassByIdService;
   final MachineReadingByIDService machineReadingIDService;
   final MaterialConsumptionByIDService materialConsumptionByIDService;
   final PurchaseOrderDetailService purchaseOrderDetailService;
   final GateEntryNumberService ge_number_Service;
   final GoodsReceivedNotesByIDService goodsReceivedNotesByIDService;
   final RegisteredCustomerService regCustomerService;
   final GRNDetailByIDService grnDetailByIDServices;
   final GateEntryBYIDService gateEntryBYIDService;
   final BasicUnitsService basicUnitsService;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp>  with WidgetsBindingObserver {
  final navigatorKey = GlobalKey<NavigatorState>();

  @override
  void initState()
  {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) => checkToken());

  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      checkToken();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  void checkToken() async {
    try {
      print("checkToken: start");
      final token = await AppUtils().getToken();
      print("checkToken: token = ${token != null ? 'FOUND' : 'NULL'}");

      // If no token found, logout immediately
      if (token == null || token.isEmpty) {
        print("checkToken: no token -> logout");
        await AppUtils().logoutUser();
        Utils.navigateRemoveAll(context, LoginScreen());
        return;
      }

      // Get stored login time
      final loginTime = await AppUtils().getLoginTime();
      print("checkToken: loginTime = $loginTime");

      // If no loginTime stored, treat as stale/invalid and logout (safer)
      if (loginTime == null) {
        print("checkToken: loginTime missing -> logout for safety");
        await AppUtils().logoutUser();
        Utils.navigateRemoveAll(context, LoginScreen());
        return;
      }

      final now = DateTime.now();
      final expiryTime = loginTime.add(const Duration(hours: 8));
      final isExpired = expiryTime.isBefore(now) || expiryTime.isAtSameMomentAs(now);

      // Evening cutoff: after or equal to 7:00 PM local time
      final isEveningLogout = now.hour >= 19;

      print("checkToken: now=$now, loginTime=$loginTime, expiryTime=$expiryTime, isExpired=$isExpired, isEveningLogout=$isEveningLogout");

      if (isExpired || isEveningLogout) {
        print("checkToken: token expired or evening -> logout");
        await AppUtils().logoutUser();
        Utils.navigateRemoveAll(context, LoginScreen());
        return;
      }

      print("checkToken: token still valid");
    } catch (e, st) {
      print("checkToken: error -> $e\n$st");
      // In case of any parsing or unexpected error, logout to be safe
      await AppUtils().logoutUser();
      Utils.navigateRemoveAll(context, LoginScreen());
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthenticationBloc>(
            create: (context) => AuthenticationBloc(), lazy: false),
        BlocProvider<EmployeeBloc>(
            create: (context) => EmployeeBloc(service: widget.employeeService), lazy: false),
        BlocProvider<WarehouseBloc>(
            create: (context) => WarehouseBloc(service: widget.warehouseService), lazy: false),
        BlocProvider<ProjectListBloc>(
            create: (context) => ProjectListBloc(service: widget.projectListService), lazy: false),
        BlocProvider<VehicleBloc>(
            create: (context) => VehicleBloc(service: widget.vehicleNoService), lazy: false),
        BlocProvider<MaterialIssuedBloc>(
            create: (context) => MaterialIssuedBloc(service: widget.materialIssuedService), lazy: false),
        BlocProvider<UnitsBloc>(
            create: (context) => UnitsBloc(service: widget.unitsService), lazy: false),
        BlocProvider<BasicUnitsBloc>(
            create: (context) => BasicUnitsBloc(service: widget.basicUnitsService), lazy: false),
        BlocProvider<VendorNameBloc>(
            create: (context) => VendorNameBloc(service: widget.vendorService), lazy: false),
        BlocProvider<VehicleNameBloc>(
            create: (context) => VehicleNameBloc(service: widget.vehicleNameService), lazy: false),
        BlocProvider<VehicleNumberBloc>(
            create: (context) => VehicleNumberBloc(service: widget.vehicleNumberService), lazy: false),
        BlocProvider<ProjectCoordinatorBloc>(
            create: (context) => ProjectCoordinatorBloc(service: widget.projectCoordinatorService), lazy: false),
        // BlocProvider<StatusBloc>(
        //     create: (context) => StatusBloc(service: widget.statusService), lazy: false),
        BlocProvider<AllStatesBloc>(
            create: (context) => AllStatesBloc(service: widget.statesService), lazy: false),
        BlocProvider<ProjectManagerBloc>(
            create: (context) => ProjectManagerBloc(service: widget.projectManagerService), lazy: false),
        BlocProvider<ProjectTypeBloc>(
            create: (context) => ProjectTypeBloc(service: widget.projectTypeService), lazy: false),
        BlocProvider<EmployeeTypeBloc>(
            create: (context) => EmployeeTypeBloc(service: widget.employeeTypeService), lazy: false),
        BlocProvider<PurchaseOrderNumberBloc>(
            create: (context) => PurchaseOrderNumberBloc(service: widget.purchaseOrderNumber), lazy: false),
        BlocProvider<AddProjectBloc>(
            create: (context) => AddProjectBloc(), lazy: false),
        BlocProvider<AddNewEntryBloc>(
            create: (context) => AddNewEntryBloc(), lazy: false),
        BlocProvider<OtpBloc>(
            create: (context) => OtpBloc(), lazy: false),
        BlocProvider<VerifyOTPBloc>(
            create: (context) => VerifyOTPBloc(), lazy: false),
        BlocProvider<AddMachineReadingBloc>(
            create: (context) => AddMachineReadingBloc(), lazy: false),
        BlocProvider<AddNewGatePassBloc>(
            create: (context) => AddNewGatePassBloc(), lazy: false),
        BlocProvider<AddWarehouseToProjectBloc>(
            create: (context) => AddWarehouseToProjectBloc(), lazy: false),
        BlocProvider<AddWarehouseTransferBloc>(
            create: (context) => AddWarehouseTransferBloc(), lazy: false),
        BlocProvider<AddMaterialConsumptionBloc>(
            create: (context) => AddMaterialConsumptionBloc(), lazy: false),
        BlocProvider<DeleteProjectBloc>(
            create: (context) => DeleteProjectBloc(), lazy: false),
        BlocProvider<DeleteGatePassBloc>(
            create: (context) => DeleteGatePassBloc(), lazy: false),
        BlocProvider<DeleteGatePassWarehouseBloc>(
            create: (context) => DeleteGatePassWarehouseBloc(), lazy: false),
        BlocProvider<DeleteGatePassProjectBloc>(
            create: (context) => DeleteGatePassProjectBloc(), lazy: false),
        BlocProvider<DeleteNewEntryBloc>(
            create: (context) => DeleteNewEntryBloc(), lazy: false),
        BlocProvider<DeleteMaterialConsumptionBloc>(
            create: (context) => DeleteMaterialConsumptionBloc(), lazy: false),
        BlocProvider<DeleteMachineReadingBloc>(
            create: (context) => DeleteMachineReadingBloc(), lazy: false),
        BlocProvider<DeleteGateEntryBloc>(
            create: (context) => DeleteGateEntryBloc(), lazy: false),
        BlocProvider<ProjectDataBloc>(
            create: (context) => ProjectDataBloc(service: widget.projectDataService), lazy: false),
        BlocProvider<EntryByIDBloc>(
            create: (context) => EntryByIDBloc(service: widget.entryDataService), lazy: false),
        BlocProvider<GatePassByIDBloc>(
            create: (context) => GatePassByIDBloc(service: widget.gatePassByIdService), lazy: false),
        BlocProvider<MachineReadingByIDBloc>(
            create: (context) => MachineReadingByIDBloc(service: widget.machineReadingIDService), lazy: false),
        BlocProvider<MaterialConsumptionByIDBloc>(
            create: (context) => MaterialConsumptionByIDBloc(service: widget.materialConsumptionByIDService), lazy: false),
        BlocProvider<MaterialConsumptionUsedBloc>(
            create: (context) => MaterialConsumptionUsedBloc(service: widget.materialConsumptionUsed), lazy: false),
        BlocProvider<PurchaseOrderDetailBloc>(
            create: (context) => PurchaseOrderDetailBloc(service: widget.purchaseOrderDetailService), lazy: false),
        BlocProvider<AddPurchaseDetailBloc>(
            create: (context) => AddPurchaseDetailBloc(), lazy: false),
        BlocProvider<GateEntryNumberBloc>(
            create: (context) => GateEntryNumberBloc(service: widget.ge_number_Service), lazy: false),
        BlocProvider<GoodsReceivedNotesByIDBloc>(
            create: (context) => GoodsReceivedNotesByIDBloc(service: widget.goodsReceivedNotesByIDService), lazy: false),
        BlocProvider<AddGoodsReceivedNotesBloc>(
            create: (context) => AddGoodsReceivedNotesBloc(), lazy: false),
        BlocProvider<RegisteredCustomerBloc>(
            create: (context) => RegisteredCustomerBloc(service: widget.regCustomerService), lazy: false),
        BlocProvider<GRNDetailByIDBloc>(
            create: (context) => GRNDetailByIDBloc(service: widget.grnDetailByIDServices), lazy: false),
        BlocProvider<DeleteGRNBloc>(
            create: (context) => DeleteGRNBloc(), lazy: false),
        BlocProvider<GRNDownloadBloc>(
            create: (context) => GRNDownloadBloc(), lazy: false),
        BlocProvider<GateEntryBYIDBloc>(
            create: (context) => GateEntryBYIDBloc(service: widget.gateEntryBYIDService), lazy: false),
      ],
      child:
      Sizer(builder: (context, orientation, deviceType) {
        return MaterialApp(
          navigatorKey: navigatorKey,
          theme: ThemeData(
            primarySwatch: MaterialColor(0xFFDC8003, color),
            // fontFamily: GoogleFonts.alef().fontFamily,
            textSelectionTheme: TextSelectionThemeData(
              cursorColor: ColorConstants.primary,
              selectionHandleColor: ColorConstants.primary,
            ),
          ),
          debugShowCheckedModeBanner: false,
          home: SplashScreen(),
        );
      }),
    );
  }
}

