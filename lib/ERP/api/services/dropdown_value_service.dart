import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import '../../data/local/AppUtils.dart';
import '../../ui/Utils/config_constants.dart';
import '../../ui/Utils/messages_constants.dart';
import '../models/DAOGetEmployee.dart';

class DropdownServices {

  getEmployeeList() async {
    final url = AppConfig.BASE_URL + AppConfig.Get_Employee_Url + AppConfig.reload;
    final token = await AppUtils().getToken();
    Map<String, String> headers = {
      "Accept": "*/*",
      "source": AppConfig.source,
      "Authorization": "Bearer ${token}"
    };

    // Remove leading space
    var dataBody = {"companyid": "045748e5-57d7-11eb-b9f1-063127f6ced7"};

    try {
      final dio = Dio();

      final response = await dio.post(
        url,
        data: dataBody,
        options: Options(headers: headers),
      );

      if (response.statusCode == 200) {
        if (response.data is Map<String, dynamic>) {
          return jsonEncode(response.data);
          // return DAOGetEmployee.fromJson(response.data as Map<String, dynamic>);
        }
        // If response is in String format, return it as is (for example, if it's raw JSON)
        if (response.data is String) {
          return response.data;  // Raw response (String)
        }
      }
    } catch (e) {
      print("Exception: $e");
      return ConstantsMessage.serveError;
    }
  }

  getWarehouseList() async {
    final url = AppConfig.BASE_URL + AppConfig.Get_Warehouse_Url + AppConfig.reload;
    final token = await AppUtils().getToken();
    Map<String, String> headers = {
      "Accept": "*/*",
      "source": AppConfig.source,
      "Authorization": "Bearer ${token}"
    };

    // Remove leading space
    var dataBody = {"companyid": "045748e5-57d7-11eb-b9f1-063127f6ced7"};

    try {
      final dio = Dio();

      final response = await dio.post(
        url,
        data: dataBody,
        options: Options(headers: headers),
      );

      if (response.statusCode == 200) {
        if (response.data is Map<String, dynamic>) {
          return jsonEncode(response.data);
          // return DAOGetEmployee.fromJson(response.data as Map<String, dynamic>);
        }
        // If response is in String format, return it as is (for example, if it's raw JSON)
        if (response.data is String) {
          return response.data;  // Raw response (String)
        }
      }
    } catch (e) {
      print("Exception: $e");
      return ConstantsMessage.serveError;
    }
  }

  getProjectList() async {
    final url = AppConfig.BASE_URL + AppConfig.Get_ProjectList_Url + AppConfig.reload;
    final token = await AppUtils().getToken();
    Map<String, String> headers = {
      "Accept": "*/*",
      "source": AppConfig.source,
      "Authorization": "Bearer ${token}"
    };

    // Remove leading space
    var dataBody = {"companyid": "045748e5-57d7-11eb-b9f1-063127f6ced7"};

    try {
      final dio = Dio();

      final response = await dio.post(
        url,
        data: dataBody,
        options: Options(headers: headers),
      );

      if (response.statusCode == 200) {
        if (response.data is Map<String, dynamic>) {
          return jsonEncode(response.data);
          // return DAOGetEmployee.fromJson(response.data as Map<String, dynamic>);
        }
        // If response is in String format, return it as is (for example, if it's raw JSON)
        if (response.data is String) {
          return response.data;  // Raw response (String)
        }
      }
    } catch (e) {
      print("Exception: $e");
      return ConstantsMessage.serveError;
    }
  }

  getVehicleNo() async {
    final url = AppConfig.BASE_URL + AppConfig.Get_Vehicle_No_Url + AppConfig.reload;
    final token = await AppUtils().getToken();
    Map<String, String> headers = {
      "Accept": "*/*",
      "source": AppConfig.source,
      "Authorization": "Bearer ${token}"
    };

    // Remove leading space
    var dataBody = {"companyid": "045748e5-57d7-11eb-b9f1-063127f6ced7"};

    try {
      final dio = Dio();

      final response = await dio.post(
        url,
        data: dataBody,
        options: Options(headers: headers),
      );

      if (response.statusCode == 200) {
        if (response.data is Map<String, dynamic>) {
          return jsonEncode(response.data);
        }
        // If response is in String format, return it as is (for example, if it's raw JSON)
        if (response.data is String) {
          return response.data;  // Raw response (String)
        }
      }
    } catch (e) {
      print("Exception: $e");
      return ConstantsMessage.serveError;
    }
  }

  getMaterialIssued(String godownId) async {
    final url = AppConfig.BASE_URL + AppConfig.Get_Materal_Issued_Url + AppConfig.reload;
    final token = await AppUtils().getToken();
    Map<String, String> headers = {
      "Accept": "*/*",
      "source": AppConfig.source,
      "Authorization": "Bearer ${token}"
    };

    // Remove leading space
    var dataBody = {"godown_id": godownId};

    try {
      final dio = Dio();

      final response = await dio.post(
        url,
        data: dataBody,
        options: Options(headers: headers),
      );

      if (response.statusCode == 200) {
        if (response.data is Map<String, dynamic>) {
          return jsonEncode(response.data);
        }
        // If response is in String format, return it as is (for example, if it's raw JSON)
        if (response.data is String) {
          return response.data;  // Raw response (String)
        }
      }
    } catch (e) {
      print("Exception: $e");
      return ConstantsMessage.serveError;
    }
  }

  getProjectCoordinator() async {
    final url = AppConfig.BASE_URL + AppConfig.Get_Project_Coordinator_Url + AppConfig.reload;
    final token = await AppUtils().getToken();
    Map<String, String> headers = {
      "Accept": "*/*",
      "source": AppConfig.source,
      "Authorization": "Bearer ${token}"
    };

    // Remove leading space
    var dataBody = {"companyid": "045748e5-57d7-11eb-b9f1-063127f6ced7","roleName":"Project Coordinator"};

    try {
      final dio = Dio();

      final response = await dio.post(
        url,
        data: dataBody,
        options: Options(headers: headers),
      );

      if (response.statusCode == 200) {
        if (response.data is Map<String, dynamic>) {
          return jsonEncode(response.data);
        }
        // If response is in String format, return it as is (for example, if it's raw JSON)
        if (response.data is String) {
          return response.data;  // Raw response (String)
        }
      }
    } catch (e) {
      print("Exception: $e");
      return ConstantsMessage.serveError;
    }
  }

  getProjectTypes() async {
    final url = AppConfig.BASE_URL + AppConfig.Get_Project_Type_Url + AppConfig.reload;
    final token = await AppUtils().getToken();
    Map<String, String> headers = {
      "Accept": "*/*",
      "source": AppConfig.source,
      "Authorization": "Bearer ${token}"
    };

    // Remove leading space
    var dataBody = {"companyid": "045748e5-57d7-11eb-b9f1-063127f6ced7","lookupname":"Project Type"};

    try {
      final dio = Dio();

      final response = await dio.post(
        url,
        data: dataBody,
        options: Options(headers: headers),
      );

      if (response.statusCode == 200) {
        if (response.data is Map<String, dynamic>) {
          return jsonEncode(response.data);
        }
        // If response is in String format, return it as is (for example, if it's raw JSON)
        if (response.data is String) {
          return response.data;  // Raw response (String)
        }
      }
    } catch (e) {
      print("Exception: $e");
      return ConstantsMessage.serveError;
    }
  }

  getStatus() async {
    final url = AppConfig.BASE_URL + AppConfig.Get_Status_Url + AppConfig.reload;
    final token = await AppUtils().getToken();
    Map<String, String> headers = {
      "Accept": "*/*",
      "source": AppConfig.source,
      "Authorization": "Bearer ${token}"
    };

    // Remove leading space
    var dataBody = {"companyid": "045748e5-57d7-11eb-b9f1-063127f6ced7","lookupname":"Status"};

    try {
      final dio = Dio();

      final response = await dio.post(
        url,
        data: dataBody,
        options: Options(headers: headers),
      );

      if (response.statusCode == 200) {
        if (response.data is Map<String, dynamic>) {
          return jsonEncode(response.data);
        }
        // If response is in String format, return it as is (for example, if it's raw JSON)
        if (response.data is String) {
          return response.data;  // Raw response (String)
        }
      }
    } catch (e) {
      print("Exception: $e");
      return ConstantsMessage.serveError;
    }
  }

  getStates() async {
    final url = AppConfig.BASE_URL + AppConfig.Get_States_Url + AppConfig.reload;
    final token = await AppUtils().getToken();
    Map<String, String> headers = {
      "Accept": "*/*",
      "source": AppConfig.source,
      "Authorization": "Bearer ${token}"
    };

    // Remove leading space
    var dataBody = {"companyid": "045748e5-57d7-11eb-b9f1-063127f6ced7"};

    try {
      final dio = Dio();

      final response = await dio.post(
        url,
        data: dataBody,
        options: Options(headers: headers),
      );

      if (response.statusCode == 200) {
        if (response.data is Map<String, dynamic>) {
          return jsonEncode(response.data);
        }
        // If response is in String format, return it as is (for example, if it's raw JSON)
        if (response.data is String) {
          return response.data;  // Raw response (String)
        }
      }
    } catch (e) {
      print("Exception: $e");
      return ConstantsMessage.serveError;
    }
  }

  getProjectManager() async {
    final url = AppConfig.BASE_URL + AppConfig.Get_Project_Manager_Url + AppConfig.reload;
    final token = await AppUtils().getToken();
    Map<String, String> headers = {
      "Accept": "*/*",
      "source": AppConfig.source,
      "Authorization": "Bearer ${token}"
    };

    // Remove leading space
    var dataBody = {"companyid": "045748e5-57d7-11eb-b9f1-063127f6ced7","roleName":"Project Manager"};

    try {
      final dio = Dio();

      final response = await dio.post(
        url,
        data: dataBody,
        options: Options(headers: headers),
      );

      if (response.statusCode == 200) {
        if (response.data is Map<String, dynamic>) {
          return jsonEncode(response.data);
        }
        // If response is in String format, return it as is (for example, if it's raw JSON)
        if (response.data is String) {
          return response.data;  // Raw response (String)
        }
      }
    } catch (e) {
      print("Exception: $e");
      return ConstantsMessage.serveError;
    }
  }

  getEmployeeType() async {
    final url = AppConfig.BASE_URL + AppConfig.Get_Employee_Type_Url + AppConfig.reload;
    final token = await AppUtils().getToken();
    Map<String, String> headers = {
      "Accept": "*/*",
      "source": AppConfig.source,
      "Authorization": "Bearer ${token}"
    };

    // Remove leading space
    var dataBody = {"lookupname": "Employee Type"};

    try {
      final dio = Dio();

      final response = await dio.post(
        url,
        data: dataBody,
        options: Options(headers: headers),
      );

      if (response.statusCode == 200) {
        if (response.data is Map<String, dynamic>) {
          return jsonEncode(response.data);
        }
        // If response is in String format, return it as is (for example, if it's raw JSON)
        if (response.data is String) {
          return response.data;  // Raw response (String)
        }
      }
    } catch (e) {
      print("Exception: $e");
      return ConstantsMessage.serveError;
    }
  }

  getUnits(String itemName) async {
    final url = AppConfig.BASE_URL + AppConfig.Get_Units_Url + AppConfig.reload;
    final token = await AppUtils().getToken();
    Map<String, String> headers = {
      "Accept": "*/*",
      "source": AppConfig.source,
      "Authorization": "Bearer ${token}"
    };

    // Remove leading space
    var dataBody = {"itemName": itemName};

    try {
      final dio = Dio();

      final response = await dio.post(
        url,
        data: dataBody,
        options: Options(headers: headers),
      );

      if (response.statusCode == 200) {
        if (response.data is Map<String, dynamic>) {
          return jsonEncode(response.data);
        }
        // If response is in String format, return it as is (for example, if it's raw JSON)
        if (response.data is String) {
          return response.data;  // Raw response (String)
        }
      }
    } catch (e) {
      print("Exception occurred while getting units: $e");
      return ConstantsMessage.serveError;
    }
  }

  getVendorName() async {
    final url = AppConfig.BASE_URL + AppConfig.Get_Vendor_Name_Url + AppConfig.reload;
    final token = await AppUtils().getToken();
    Map<String, String> headers = {
      "Accept": "*/*",
      "source": AppConfig.source,
      "Authorization": "Bearer ${token}"
    };

    // Remove leading space
    var dataBody = {"companyid": "045748e5-57d7-11eb-b9f1-063127f6ced7"};

    try {
      final dio = Dio();

      final response = await dio.post(
        url,
        data: dataBody,
        options: Options(headers: headers),
      );

      if (response.statusCode == 200) {
        if (response.data is Map<String, dynamic>) {
          return jsonEncode(response.data);
          // return DAOGetEmployee.fromJson(response.data as Map<String, dynamic>);
        }
        // If response is in String format, return it as is (for example, if it's raw JSON)
        if (response.data is String) {
          return response.data;  // Raw response (String)
        }
      }
    } catch (e) {
      print("Exception: $e");
      return ConstantsMessage.serveError;
    }
  }

  getVehicleName(String vendorId) async {
    final url = AppConfig.BASE_URL + AppConfig.Get_Vehicle_Name_Url + AppConfig.reload;
    final token = await AppUtils().getToken();
    Map<String, String> headers = {
      "Accept": "*/*",
      "source": AppConfig.source,
      "Authorization": "Bearer ${token}"
    };

    // Remove leading space
    var dataBody = {"VendorId": vendorId};

    try {
      final dio = Dio();

      final response = await dio.post(
        url,
        data: dataBody,
        options: Options(headers: headers),
      );

      if (response.statusCode == 200) {
        if (response.data is Map<String, dynamic>) {
          return jsonEncode(response.data);
        }
        // If response is in String format, return it as is (for example, if it's raw JSON)
        if (response.data is String) {
          return response.data;  // Raw response (String)
        }
      }
    } catch (e) {
      print("Exception occurred while getting units: $e");
      return ConstantsMessage.serveError;
    }
  }

  getVehicleNumber(String vehicleId) async {
    final url = AppConfig.BASE_URL + AppConfig.Get_Vehicle_Number_Url + AppConfig.reload;
    final token = await AppUtils().getToken();
    Map<String, String> headers = {
      "Accept": "*/*",
      "source": AppConfig.source,
      "Authorization": "Bearer ${token}"
    };

    // Remove leading space
    var dataBody = {"VehicleId": vehicleId};

    try {
      final dio = Dio();

      final response = await dio.post(
        url,
        data: dataBody,
        options: Options(headers: headers),
      );

      if (response.statusCode == 200) {
        if (response.data is Map<String, dynamic>) {
          return jsonEncode(response.data);
        }
        // If response is in String format, return it as is (for example, if it's raw JSON)
        if (response.data is String) {
          return response.data;  // Raw response (String)
        }
      }
    } catch (e) {
      print("Exception occurred while getting units: $e");
      return ConstantsMessage.serveError;
    }
  }

  getMaterialConsumptionUsed(String projectID,String consumedDate) async {
    final url = AppConfig.BASE_URL + AppConfig.Get_Material_Consumption_Url + AppConfig.reload;
    final token = await AppUtils().getToken();
    Map<String, String> headers = {
      "Accept": "*/*",
      "source": AppConfig.source,
      "Authorization": "Bearer ${token}"
    };

    // Remove leading space
    var dataBody = {
      "project_id": projectID,
      "consumedDate": consumedDate
    };

    try {
      final dio = Dio();

      final response = await dio.post(
        url,
        data: dataBody,
        options: Options(headers: headers),
      );

      if (response.statusCode == 200) {
        if (response.data is Map<String, dynamic>) {
          return jsonEncode(response.data);
        }
        // If response is in String format, return it as is (for example, if it's raw JSON)
        if (response.data is String) {
          return response.data;  // Raw response (String)
        }
      }
    } catch (e) {
      print("Exception occurred while getting getMaterialConsumption: $e");
      return ConstantsMessage.serveError;
    }
  }

  getPurchaseOrderNumber() async {
    final url = AppConfig.BASE_URL + AppConfig.Get_Purchase_Order_Number_Url + AppConfig.reload;
    final token = await AppUtils().getToken();
    Map<String, String> headers = {
      "Accept": "*/*",
      "source": AppConfig.source,
      "Authorization": "Bearer ${token}"
    };

    // Remove leading space
    var dataBody = {"dispatched": "1"};

    try {
      final dio = Dio();

      final response = await dio.post(
        url,
        data: dataBody,
        options: Options(headers: headers),
      );

      if (response.statusCode == 200) {
        if (response.data is Map<String, dynamic>) {
          return jsonEncode(response.data);
        }
        // If response is in String format, return it as is (for example, if it's raw JSON)
        if (response.data is String) {
          return response.data;  // Raw response (String)
        }
      }
    } catch (e) {
      print("Exception: $e");
      return ConstantsMessage.serveError;
    }
  }

  getGENumber() async {
    final url = AppConfig.BASE_URL + AppConfig.Get_GE_Number_Url + AppConfig.reload;
    final token = await AppUtils().getToken();
    Map<String, String> headers = {
      "Accept": "*/*",
      "source": AppConfig.source,
      "Authorization": "Bearer ${token}"
    };

    // Remove leading space
    var dataBody = {"company_id": "045748e5-57d7-11eb-b9f1-063127f6ced7"};

    try {
      final dio = Dio();

      final response = await dio.post(
        url,
        data: dataBody,
        options: Options(headers: headers),
      );

      if (response.statusCode == 200) {
        if (response.data is Map<String, dynamic>) {
          return jsonEncode(response.data);
        }
        // If response is in String format, return it as is (for example, if it's raw JSON)
        if (response.data is String) {
          return response.data;  // Raw response (String)
        }
      }
    } catch (e) {
      print("Exception: $e");
      return ConstantsMessage.serveError;
    }
  }

  getRegisteredCustomer(String value) async {
    final url = AppConfig.BASE_URL + AppConfig.Get_Registered_Customer_Url + AppConfig.reload;
    final token = await AppUtils().getToken();
    Map<String, String> headers = {
      "Accept": "*/*",
      "source": AppConfig.source,
      "Authorization": "Bearer ${token}"
    };

    // Remove leading space
    var dataBody = {"value": value};

    try {
      final dio = Dio();

      final response = await dio.post(
        url,
        data: dataBody,
        options: Options(headers: headers),
      );

      if (response.statusCode == 200) {
        if (response.data is Map<String, dynamic>) {
          return jsonEncode(response.data);
        }
        // If response is in String format, return it as is (for example, if it's raw JSON)
        if (response.data is String) {
          return response.data;  // Raw response (String)
        }
      }
    } catch (e) {
      print("Exception occurred while getting registered customer: $e");
      return ConstantsMessage.serveError;
    }
  }

}
