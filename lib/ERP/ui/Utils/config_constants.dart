class AppConfig {
  // static String BASE_URL = "http://api.divyaltech.com/index.cfm?action=";
  static String BASE_URL = "http://dev-api.divyaltech.com/dev-backend/index.cfm?action=";
  static String reload = "&reload=1";
  static String source = "appSide";

  static String LOGIN_URL = "login.login";
  static String Sent_OTP_URl = "login.send_email_otp";
  static String Verify_OTP_URl = "login.verify_otp";

  //drop down values url
  static String Get_Employee_Url= "hr.getEmployee";
  static String Get_Warehouse_Url= "project.getWarehouselists";
  static String Get_ProjectList_Url= "project.getAllProjectsLists";
  static String Get_Vehicle_No_Url= "project.getVehicleslists";
  static String Get_Materal_Issued_Url= "project.getWarehouseFromInventory";
  static String Get_Project_Coordinator_Url= "hr.getEmployeebyRole";
  static String Get_Project_Manager_Url= "hr.getEmployeebyRole";
  static String Get_Project_Type_Url= "hr.getloockupdata";
  static String Get_Status_Url= "hr.getloockupdata";
  static String Get_States_Url= "admin.getAllStates";
  static String Get_Employee_Type_Url= "hr.getloockupdata";
  static String Get_Units_Url= "project.getUnitsByMaterial";
  static String Get_Vendor_Name_Url= "hr.fetch_contractor";
  static String Get_Vehicle_Number_Url= "hr.getVehiclename";
  static String Get_Vehicle_Name_Url= "machine.getvechicalList";
  static String Get_Material_Consumption_Url= "project.getMaterialsUsedLists";
  static String Get_Purchase_Order_Number_Url= "stock.getDispatchedPOLists";
  static String Get_GE_Number_Url= "stock.fetchGenData";
  static String Get_Registered_Customer_Url= "CrmVisitorMangement.getRegCustomerLists";

  //Project
  static String Add_Project_Url= "project.Add_Projects";
  static String Get_Project_Url= "project.fetch_ProjectList";
  static String Get_Project_Data_Url= "project.edit_ProjectList";
  static String Delete_Project_Url= "project.project_delete";

  //daily reporting
  static String Add_New_Entry_Url= "project.saveWorkDetails";
  static String Get_New_Entry_By_ID_Url= "project.fetchWorkDetails";
  static String Delete_New_Entry_Url= "project.deleteWorkDetail";
  static String Get_New_Entry_Url= "project.fetchWorkDetailsEntry";

  static String Add_New_Machine_Reading_Url= "machine.setMachineReadingData";
  static String Delete_New_Machine_Reading_Url= "machine.deletemachineByid";
  static String Get_Machine_Reading_By_ID_Url= "machine.fetchMachineDataById";
  static String Get_New_Machine_Reading_Url= "hr.fetchMachineReadingAndDailyDairy";

  static String Add_Material_Consumption_Url= "project.savematerialConsumption";
  static String Get_Material_Consumption_List_Url= "project.fetchMaterialConsumption";
  static String Delete_New_Material_Consumption_Url= "project.deleteMaterialConsume";
  static String Get_Material_Consumption_By_ID_Url= "project.getConsumedMaterials";

  static String Get_Gate_Pass_Url= "stock.fetchgatePassData";

  //Add Gate Pass0
  static String Add_Gate_Pass_Url= "stock.saveGatePassDetails";
  static String Get_Gate_Pass_By_ID_Url= "stock.fetchGatePassById";
  static String Delete_Gate_Pass_Url= "stock.removeGatePass";
  static String Delete_Gate_Pass_Warehouse_Url= "stock.updateWarehouseBalanceAfterDelete";
  static String Delete_Gate_Pass_Project_Url= "stock.updateProjectBalanceAfterDelete";
  static String Gate_Pass_Warehouse_To_Project_Url= "project.saveWarehouseToProject";
  static String Gate_Pass_Warehouse_Transfer_Url= "project.saveWarehouseToWarehouse";

  //gate entry
  static String Get_Gate_Entry_Url= "stock.fetchEntryPassData";
  static String Get_Purchase_Order_Url= "stock.onPOSelectionChange";
  static String Delete_Gate_Entry_Url= "stock.removeGateEntry";
  static String Save_Gate_Entry_Url= "stock.saveGateEntryForm";
  static String Gate_Entry_By_ID_Url= "stock.fetchGateEntryById";

  //goods received notes
  static String Get_Goods_Received_By_ID_Url= "stock.fetchGENByName";
  static String Add_Goods_Received_Notes_Url= "stock.saveGRN";
  static String Get_Goods_Received_Notes_Url= "stock.fetchgrnData";
  static String Get_Goods_Received_Notes_By_ID_Url= "stock.getGrnDetailsById";
  static String Delete_Goods_Received_Notes_Url= "stock.removeGRN";
  static String Goods_Received_Notes_Download_Url= "stock.downloadGRN";
}
