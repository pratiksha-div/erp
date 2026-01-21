import 'dart:convert';
import 'package:dio/dio.dart';
import '../../data/local/AppUtils.dart';
import '../../ui/Utils/config_constants.dart';
import '../../ui/Utils/messages_constants.dart';

class ProjectService {
  /// Fetch projects with pagination
  Future<String> fetchProjectsRaw({required int start, required int length,required String project_name}) async {
    final url = '${AppConfig.BASE_URL}${AppConfig.Get_Project_Url}${AppConfig.reload}';
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
      "project_name": project_name,
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
      print("ProjectService Exception: $e");
      return jsonEncode({"code": "500", "massage": ConstantsMessage.serveError});
    }
  }

}

class GetProjectDataService {

  Future<String> fetchProjectsData(String project_id) async {
    final url = '${AppConfig.BASE_URL}${AppConfig.Get_Project_Data_Url}${AppConfig.reload}';
    final token = await AppUtils().getToken();

    final headers = {
      "Accept": "*/*",
      "source": AppConfig.source,
      "Authorization": "Bearer $token",
    };

    final dataBody = {
      "companyid": "045748e5-57d7-11eb-b9f1-063127f6ced7",
      "project_id":project_id
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
      print("ProjectService Exception: $e");
      return jsonEncode({"code": "500", "massage": ConstantsMessage.serveError});
    }
  }

}

class DeleteProjectService {

  Future<String> deleteProjectsData(String project_id) async {
    final url = '${AppConfig.BASE_URL}${AppConfig.Delete_Project_Url}${AppConfig.reload}';
    final token = await AppUtils().getToken();

    final headers = {
      "Accept": "*/*",
      "source": AppConfig.source,
      "Authorization": "Bearer $token",
    };

    final dataBody = {
      "project_id":project_id
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
      print("DeleteProjectService Exception: $e");
      return jsonEncode({"code": "500", "massage": ConstantsMessage.serveError});
    }
  }

}


