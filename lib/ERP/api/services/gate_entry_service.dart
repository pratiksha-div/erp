import 'dart:convert';
import 'package:dio/dio.dart';
import '../../UI/Utils/messages_constants.dart';
import '../../data/local/AppUtils.dart';
import '../../ui/Utils/config_constants.dart';
import '../models/AddProjectModel.dart';

class GateEntryService {

  Future<String> fetchGateEntryRaw(
      {required int start, required int length}) async {
    final url =
        '${AppConfig.BASE_URL}${AppConfig.Get_Gate_Entry_Url}${AppConfig.reload}';
    final token = await AppUtils().getToken();

    final headers = {
      "Accept": "*/*",
      "source": AppConfig.source,
      "Authorization": "Bearer $token",
    };

    final dataBody = {
      "companyid": "045748e5-57d7-11eb-b9f1-063127f6ced7",
      "start": start,
      "length": length,
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
      print("GateEntryService Exception: $e");
      return jsonEncode(
          {"code": "500", "massage": ConstantsMessage.serveError});
    }
  }

}

class GetPurchaseOrderDataService {

  Future<String> fetchPurchaseOrderData(String poValue) async {
    final url = '${AppConfig.BASE_URL}${AppConfig.Get_Purchase_Order_Url}${AppConfig.reload}';
    final token = await AppUtils().getToken();

    final headers = {
      "Accept": "*/*",
      "source": AppConfig.source,
      "Authorization": "Bearer $token",
    };

    final dataBody = {
      "poValue":poValue
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

      return jsonEncode({"code": "500", "massage": ConstantsMessage.serveError});
    } catch (e) {
      print("Get Purchase Order Exception: $e");
      return jsonEncode({"code": "500", "massage": ConstantsMessage.serveError});
    }
  }

}

class AddPurchaseDetailService {
  Future<BaseResponse> addPurchaseDetail({
    String? gate_entry_id,
    String? challanNo,
    String? billNo,
    String? vehicleNo,
    String? poNumber,
    String? vendor,
    String? orderedBy,
    String? toWarehouse,
    String? itemNames,
    String? itemQuantities,
    String? itemIds,
    String? groupIds,
    String? subGroupId,
    String? company_name,
    String? unit,
    String? to_warehouse_id,
    String? gate_entry_date,
    String? bill_date,
    String? project_id,
    String? rate,
    String? grand_total
  }) async {
    final url =
        '${AppConfig.BASE_URL}${AppConfig.Save_Gate_Entry_Url}${AppConfig.reload}';
    final token = await AppUtils().getToken();
    final headers = {
      "Accept": "*/*",
      "source": AppConfig.source,
      "Authorization": "Bearer $token",
    };
    print(
      '''
      "gate_entry_id":$gate_entry_id,
      "challanNo":$challanNo,
      "billNo":$billNo,
      "vehicleNo":$vehicleNo,
      "poNumber":$poNumber,
      "vendor":$vendor,
      "orderedBy":$orderedBy,
      "toWarehouse":$toWarehouse,
      "itemNames":$itemNames,
      "itemQuantities":$itemQuantities,
      "itemIds":$itemIds,
      "groupIds":$groupIds,
      "subGroupIds":$subGroupId,
      "company_name":$company_name,
      "unit":$unit,
      "to_warehouse_id":$to_warehouse_id,
      "gate_entry_date":$gate_entry_date,
      "bill_date":$bill_date,
      "project_id":$project_id
      "rate":$rate,
      "grand_total":$grand_total
      '''
    );

    final formData = FormData.fromMap({
      "gate_entry_id":gate_entry_id,
      "challanNo":challanNo,
      "billNo":billNo,
      "vehicleNo":vehicleNo,
      "poNumber":poNumber,
      "vendor":vendor,
      "orderedBy":orderedBy,
      "toWarehouse":toWarehouse,
      "itemNames":itemNames,
      "itemQuantities":itemQuantities,
      "itemIds":itemIds,
      "groupIds":groupIds,
      "subGroupIds":subGroupId,
      "company_name":company_name,
      "unit":unit,
      "to_warehouse_id":to_warehouse_id,
      "gate_entry_date":gate_entry_date,
      "bill_date":bill_date,
      "project_id":project_id,
      "rate":rate,
      "grand_total":grand_total
    });

    try {
      final dio = Dio();
      final response = await dio.post(url,
          data: formData, options: Options(headers: headers));
      // print("Add New Entry Response: ${response.data}");
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

class DeleteGateEntryService {
  Future<String> deleteGateEntryService(String gate_entry_id) async {
    final url =
        '${AppConfig.BASE_URL}${AppConfig.Delete_Gate_Entry_Url}${AppConfig.reload}';
    final token = await AppUtils().getToken();

    final headers = {
      "Accept": "*/*",
      "source": AppConfig.source,
      "Authorization": "Bearer $token",
    };

    final dataBody = {"gate_entry_id": gate_entry_id};

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
      print("DeleteEntryService Exception: $e");
      return jsonEncode(
          {"code": "500", "massage": ConstantsMessage.serveError});
    }
  }
}

class GateEntryByIDService {
  Future<String> fetchEntryByID(String gate_entry_id) async {
    final url =
        '${AppConfig.BASE_URL}${AppConfig.Gate_Entry_By_ID_Url}${AppConfig.reload}';
    final token = await AppUtils().getToken();

    final headers = {
      "Accept": "*/*",
      "source": AppConfig.source,
      "Authorization": "Bearer $token",
    };

    final dataBody = {"gate_entry_id": gate_entry_id};

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