import 'dart:convert';
import 'package:dio/dio.dart';
import '../../UI/Utils/messages_constants.dart';
import '../../data/local/AppUtils.dart';
import '../../ui/Utils/config_constants.dart';
import '../models/AddProjectModel.dart';

class AddNewEntryService {
  Future<BaseResponse> addNewEntry({
    String? project_id,
    String? entryDate,
    String? projectName,
    String? EmployeeType,
    String? EmployeeName,
    String? working_notes,
    String? work_detail_id,
  }) async {
    final url =
        '${AppConfig.BASE_URL}${AppConfig.Add_New_Entry_Url}${AppConfig.reload}';
    final token = await AppUtils().getToken();
    final headers = {
      "Accept": "*/*",
      "source": AppConfig.source,
      "Authorization": "Bearer $token",
    };

    final formData = FormData.fromMap({
      "project_id": project_id,
      "entryDate": entryDate,
      "projectName": projectName,
      "EmployeeType": EmployeeType,
      "EmployeeName": EmployeeName,
      "working_notes": working_notes,
      "work_detail_id": work_detail_id
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

class NewEntryService {
  Future<String> fetchNewEntryRaw(
      {required int start, required int length,}) async {
    final url =
        '${AppConfig.BASE_URL}${AppConfig.Get_New_Entry_Url}${AppConfig.reload}';
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

class DeleteEntryService {
  Future<String> deleteEntrysData(String work_detail_id) async {
    final url =
        '${AppConfig.BASE_URL}${AppConfig.Delete_New_Entry_Url}${AppConfig.reload}';
    final token = await AppUtils().getToken();

    final headers = {
      "Accept": "*/*",
      "source": AppConfig.source,
      "Authorization": "Bearer $token",
    };

    final dataBody = {"work_detail_id": work_detail_id};

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

class GetEntryByIDService {
  Future<String> fetchEntryByID(String work_detail_id) async {
    final url =
        '${AppConfig.BASE_URL}${AppConfig.Get_New_Entry_By_ID_Url}${AppConfig.reload}';
    final token = await AppUtils().getToken();

    final headers = {
      "Accept": "*/*",
      "source": AppConfig.source,
      "Authorization": "Bearer $token",
    };

    final dataBody = {"work_detail_id": work_detail_id};

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
