import 'dart:convert';
import 'package:dio/dio.dart';
import '../../UI/Utils/messages_constants.dart';
import '../../data/local/AppUtils.dart';
import '../../ui/Utils/config_constants.dart';
import '../models/AddProjectModel.dart';

class AddMaterialConsumptionService {
  Future<BaseResponse> addMaterialConsumption({
    String? project_id,
    String? date,
    String? gatePass,
    String? consumedMaterial,
    String? item,
    String? balanceQuantity,
    String? consumedUnit,
    String? usedQuantity,
    String? consumedScrap,
    String? consumedRate,
    String? consumedAmount,
    String? consumption_id,
  }) async {
    final url =
        '${AppConfig.BASE_URL}${AppConfig.Add_Material_Consumption_Url}${AppConfig.reload}';
    final token = await AppUtils().getToken();

    final headers = {
      "Accept": "*/*",
      "source": AppConfig.source,
      "Authorization": "Bearer $token",
    };

    final formData = FormData.fromMap({
      "project_id": project_id,
      "date": date,
      "gatePass": gatePass,
      "consumedMaterial": consumedMaterial,
      "item": item,
      "balanceQuantity": balanceQuantity,
      "consumedUnit": consumedUnit,
      "usedQuantity": usedQuantity,
      "consumedScrap": consumedScrap,
      "consumedRate": consumedRate,
      "consumedAmount": consumedAmount,
      "consumption_id": consumption_id
    });

    try {
      final dio = Dio();
      final response = await dio.post(url,
          data: formData, options: Options(headers: headers));
      print("addMaterialConsumption Response: ${response.data}");
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

class MaterialConsumptionService {
  Future<String> fetchMaterialConsumptionRaw(
      {required int start, required int length, required}) async {
    final url =
        '${AppConfig.BASE_URL}${AppConfig.Get_Material_Consumption_List_Url}${AppConfig.reload}';
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
      print("ProjectService Exception: $e");
      return jsonEncode(
          {"code": "500", "massage": ConstantsMessage.serveError});
    }
  }
}

class DeleteMaterialConsumptionService {
  Future<String> deleteMaterialConsumptionsData(String consumption_id,String scrap) async {
    final url ='${AppConfig.BASE_URL}${AppConfig.Delete_New_Material_Consumption_Url}${AppConfig.reload}';
    final token = await AppUtils().getToken();

    final headers = {
      "Accept": "*/*",
      "source": AppConfig.source,
      "Authorization": "Bearer $token",
    };

    final dataBody = {"consumption_id": consumption_id,"scrap":scrap};

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
      print("DeleteMaterialConsumptionService Exception: $e");
      return jsonEncode(
          {"code": "500", "massage": ConstantsMessage.serveError});
    }
  }
}

class GetMaterialConsumptionByIDService {
  Future<String> fetchMaterialConsumptionDataByID(String consumption_id) async {
    final url =
        '${AppConfig.BASE_URL}${AppConfig.Get_Material_Consumption_By_ID_Url}${AppConfig.reload}';
    final token = await AppUtils().getToken();

    final headers = {
      "Accept": "*/*",
      "source": AppConfig.source,
      "Authorization": "Bearer $token",
    };

    final dataBody = {"consumption_id": consumption_id};

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
