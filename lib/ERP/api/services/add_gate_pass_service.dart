import 'dart:convert';
import 'package:dio/dio.dart';
import '../../UI/Utils/messages_constants.dart';
import '../../data/local/AppUtils.dart';
import '../../ui/Utils/config_constants.dart';
import '../models/AddProjectModel.dart';

class AddGatePassService {
  Future<BaseResponse> addNewGatePassService({
    String? transferType,
    String? date,
    String? toProject,
    String? toWarehouse,
    String? vehicleNameNo,
    String? issuedTo,
    String? issuedBy,
    String? gatePass,
    String? description,
    String? fromWarehouse,
    String? outTime,
    String? materialsId,
    String? issuedMaterials,
    String? currentBalance,
    String? unit,
    String? category,
    String? subCategory,
    String? quantity,
    String? consumed,
    String? usedQuantity,
    String? scrap,
    String? rate,
    String? amount,
    String? differenceBalance,
  }) async {
    final url =
        '${AppConfig.BASE_URL}${AppConfig.Add_Gate_Pass_Url}${AppConfig.reload}';
    final token = await AppUtils().getToken();

    final headers = {
      "Accept": "*/*",
      "source": AppConfig.source,
      "Authorization": "Bearer $token",
    };

    final formData = FormData.fromMap({
      "transferType":transferType,
      "date":date,
      "toProject":toProject,
      "toWarehouse":toWarehouse,
      "vehicleNameNo":vehicleNameNo,
      "issuedTo":issuedTo,
      "issuedBy":issuedBy,
      "gatePass":gatePass,
      "description":description,
      "fromWarehouse":fromWarehouse,
      "outTime":outTime,
      "materialsId":materialsId,
      "issuedMaterials":issuedMaterials,
      "currentBalance":currentBalance,
      "unit":unit,
      "category":category,
      "subCategory":subCategory,
      "quantity":quantity,
      "consumed":consumed,
      "usedQuantity":usedQuantity,
      "scrap":scrap,
      "rate":rate,
      "amount":amount,
      "differenceBalance":differenceBalance,
    });

    try {
      final dio = Dio();
      final response = await dio.post(url,
          data: formData, options: Options(headers: headers));
      print("Add Gate Pass Response: ${response.data}");
      if (response.statusCode == 200) {
        if (response.data is Map<String, dynamic>) {
          return BaseResponse.fromJson(response.data);
        } else if (response.data is String) {
          return BaseResponse.fromJson(jsonDecode(response.data));
        }
      }
      return BaseResponse(code: "500", massage: ConstantsMessage.serveError);
    } catch (e, st) {
      print('Error occurred while adding new entry: $e\n$st');
      return BaseResponse(code: "500", massage: ConstantsMessage.serveError);
    }
  }
}

class GatePassWarehouseToProjectService {
  Future<BaseResponse> addWarehouseToProjectService({
    String? project_id,
    String? date,
    String? vehicle_id,
    String? issued_to_id,
    String? issued_by_id,
    String? gatePass,
    String? description,
    String? fromWarehouse,
    String? outTime,
    String? materialsId,
    String? issuedMaterials,
    String? currentBalance,
    String? quantity,
    String? unit,
  }) async {
    final url =
        '${AppConfig.BASE_URL}${AppConfig.Gate_Pass_Warehouse_To_Project_Url}${AppConfig.reload}';
    final token = await AppUtils().getToken();

    final headers = {
      "Accept": "*/*",
      "source": AppConfig.source,
      "Authorization": "Bearer $token",
    };

    final formData = FormData.fromMap({
      "project_id":project_id,
      "date":date,
      "vehicle_id":vehicle_id,
      "issued_to_id":issued_to_id,
      "issued_by_id":issued_by_id,
      "gatePass":gatePass,
      "description":description,
      "fromWarehouse":fromWarehouse,
      "outTime":outTime,
      "materialsId":materialsId,
      "issuedMaterials":issuedMaterials,
      "currentBalance":currentBalance,
      "quantity":quantity,
      "unit":unit,
    });

    try {
      final dio = Dio();
      final response = await dio.post(url,
          data: formData, options: Options(headers: headers));
      if (response.statusCode == 200) {
        if (response.data is Map<String, dynamic>) {
          return BaseResponse.fromJson(response.data);
        } else if (response.data is String) {
          return BaseResponse.fromJson(jsonDecode(response.data));
        }
      }
      return BaseResponse(code: "500", massage: ConstantsMessage.serveError);
    } catch (e, st) {
      print('Error occurred while adding GatePassWarehouseToProjectService: $e\n$st');
      return BaseResponse(code: "500", massage: ConstantsMessage.serveError);
    }
  }
}

class GatePassWarehouseTransferService {
  Future<BaseResponse> addWarehouseTransferService({
    String? groupid,
    String? subgroupid,
    String? item_id,
    String? item,
    String? date,
    String? unit,
    String? currentBalance,
    String? warehouse,
    String? quantity,
    String? fromWarehouse,
    String? towarehouse,
  }) async {
    final url =
        '${AppConfig.BASE_URL}${AppConfig.Gate_Pass_Warehouse_Transfer_Url}${AppConfig.reload}';
    final token = await AppUtils().getToken();

    final headers = {
      "Accept": "*/*",
      "source": AppConfig.source,
      "Authorization": "Bearer $token",
    };

    final formData = FormData.fromMap({
      "groupid":groupid,
      "subgroupid":subgroupid,
      "item_id":item_id,
      "item":item,
      "date":date,
      "unit":unit,
      "currentBalance":currentBalance,
      "warehouse":warehouse,
      "quantity":quantity,
      "fromWarehouse":fromWarehouse,
      "towarehouse":towarehouse,
    });

    try {
      final dio = Dio();
      final response = await dio.post(url,
          data: formData, options: Options(headers: headers));
      if (response.statusCode == 200) {
        if (response.data is Map<String, dynamic>) {
          return BaseResponse.fromJson(response.data);
        } else if (response.data is String) {
          return BaseResponse.fromJson(jsonDecode(response.data));
        }
      }
      return BaseResponse(code: "500", massage: ConstantsMessage.serveError);
    } catch (e, st) {
      print('Error occurred while adding GatePassWarehouseTransferService: $e\n$st');
      return BaseResponse(code: "500", massage: ConstantsMessage.serveError);
    }
  }
}

class GatePassService {
  Future<String> fetchGatePassRaw(
      {
       required int start,
       required int length,
       required String from,
       required String to,
       required String gate_pass_number,
       required String transferType,
       required String item,
      }) async {
    final url =
        '${AppConfig.BASE_URL}${AppConfig.Get_Gate_Pass_Url}${AppConfig.reload}';
    final token = await AppUtils().getToken();

    final headers = {
      "Accept": "*/*",
      "source": AppConfig.source,
      "Authorization": "Bearer $token",
    };
    print(
      '''
      url : $url,
      start: $start,
      length: $length,
      from $from,
      to $to,
      gate_passnumber $gate_pass_number,
      transferType $transferType,
      item $item
      '''
    );

    final dataBody = {
      "companyid": "045748e5-57d7-11eb-b9f1-063127f6ced7",
      "start": start,
      "length": length,
      "from": from,
      "to": to,
      "gate_pass_number": gate_pass_number,
      "transferType": transferType,
      "item": item,
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
        if (response.data is String) {
          return response.data;
        }
      }

      return jsonEncode(
          {"code": "500", "massage": ConstantsMessage.serveError});
    } catch (e) {
      print("ProjectService Exception: $e");
      return jsonEncode(
          {"code": "500", "massage": ConstantsMessage.serveError});
    }
  }
}

class DeleteGatePassService {

  Future<String> deleteGatePassWarehouse(
      String from_warehouse_id,
      String to_warehouse_id,
      String issued_material,
      String quantity,
      )
  async {
    final url =
        '${AppConfig.BASE_URL}${AppConfig.Delete_Gate_Pass_Warehouse_Url}${AppConfig.reload}';
    final token = await AppUtils().getToken();

    final headers = {
      "Accept": "*/*",
      "source": AppConfig.source,
      "Authorization": "Bearer $token",
    };

    final dataBody = {
      "from_warehouse_id": from_warehouse_id,
      "to_warehouse_id": to_warehouse_id,
      "issued_material": issued_material,
      "quantity": quantity
    };

    try {
      final dio = Dio();
      final response = await dio.post(
        url,
        data: dataBody,
        options: Options(headers: headers),
      );

      if (response.statusCode == 200) {
        print("Gate Pass Warehouse Deleted");
        if (response.data is Map<String, dynamic>) {
          return jsonEncode(response.data);
        }
        if (response.data is String) {
          return response.data;
        }
      }

      return jsonEncode(
          {"code": "500", "massage": ConstantsMessage.serveError});
    } catch (e) {
      print("DeleteGatePassService Exception: $e");
      return jsonEncode(
          {"code": "500", "massage": ConstantsMessage.serveError});
    }
  }

  Future<String> deleteGatePasssData(String gatepass_id) async {
    final url =
        '${AppConfig.BASE_URL}${AppConfig.Delete_Gate_Pass_Url}${AppConfig.reload}';
    final token = await AppUtils().getToken();

    final headers = {
      "Accept": "*/*",
      "source": AppConfig.source,
      "Authorization": "Bearer $token",
    };

    final dataBody = {"gatepass_id": gatepass_id};

    try {
      final dio = Dio();
      final response = await dio.post(
        url,
        data: dataBody,
        options: Options(headers: headers),
      );

      if (response.statusCode == 200) {
        print("Gate Pass Deleted");
        if (response.data is Map<String, dynamic>) {
          return jsonEncode(response.data);
        }
        if (response.data is String) {
          return response.data;
        }
      }

      return jsonEncode(
          {"code": "500", "massage": ConstantsMessage.serveError});
    } catch (e) {
      print("DeleteGatePassService Exception: $e");
      return jsonEncode(
          {"code": "500", "massage": ConstantsMessage.serveError});
    }
  }

  Future<String> deleteGatePassProject(
      String gate_pass,
      String from_warehouse_id,
      String to_project_name,
      String issued_material,
      String quantity,
      String out_time,
      String consumed,
      String date,
      ) async {
    final url =
        '${AppConfig.BASE_URL}${AppConfig.Delete_Gate_Pass_Project_Url}${AppConfig.reload}';
    final token = await AppUtils().getToken();

    final headers = {
      "Accept": "*/*",
      "source": AppConfig.source,
      "Authorization": "Bearer $token",
    };

    final dataBody = {
      "gate_pass":gate_pass,
      "from_warehouse_id":from_warehouse_id,
      "to_project_name":to_project_name,
      "issued_material":issued_material,
      "quantity":quantity,
      "out_time":out_time,
      "consumed":consumed,
      "date":date,
    };

    try {
      final dio = Dio();
      final response = await dio.post(
        url,
        data: dataBody,
        options: Options(headers: headers),
      );

      if (response.statusCode == 200) {
        print("Gate Pass Project Deleted");
        if (response.data is Map<String, dynamic>) {
          return jsonEncode(response.data);
        }
        if (response.data is String) {
          return response.data;
        }
      }

      return jsonEncode(
          {"code": "500", "massage": ConstantsMessage.serveError});
    } catch (e) {
      print("DeleteGatePassService Exception: $e");
      return jsonEncode(
          {"code": "500", "massage": ConstantsMessage.serveError});
    }
  }

}

class GatePassDataByIDService {
  Future<String> fetchGatePassDataByID(String gate_pass,String date) async {
    final url =
        '${AppConfig.BASE_URL}${AppConfig.Get_Gate_Pass_By_ID_Url}${AppConfig.reload}';
    final token = await AppUtils().getToken();
    final headers = {
      "Accept": "*/*",
      "source": AppConfig.source,
      "Authorization": "Bearer $token",
    };

    final dataBody = {"gate_pass": gate_pass,"date":date};

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
        if (response.data is String) {
          return response.data;
        }
      }

      return jsonEncode(
          {"code": "500", "massage": ConstantsMessage.serveError});
    } catch (e) {
      print("fetchGatePassDataByID Exception: $e");
      return jsonEncode(
          {"code": "500", "massage": ConstantsMessage.serveError});
    }
  }
}


