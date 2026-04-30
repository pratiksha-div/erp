// import 'dart:convert';
// import 'package:dio/dio.dart';
// import '../../UI/Utils/messages_constants.dart';
// import '../../data/local/AppUtils.dart';
// import '../../ui/Utils/config_constants.dart';
// import '../models/AddProjectModel.dart';
//
// class AddProjectService {
//
//   Future<BaseResponse> addProject({
//     String? customerName,
//     String? projectName,
//     String? ProjectCo_ordinator,
//     String? projectManager,
//     String? projectType,
//     String? startDate,
//     String? endDate,
//     String? expectedCost,
//     String? status,
//     String? state,
//     String? address,
//     String? godownlist,
//     String? projectDescription,
//     String? projectId,
//   }) async {
//     final url = '${AppConfig.BASE_URL}${AppConfig.Add_Project_Url}${AppConfig.reload}';
//     final token = await AppUtils().getToken();
//
//     final headers = {
//       "Accept": "*/*",
//       "source": AppConfig.source,
//       "Authorization": "Bearer $token",
//     };
//     print(
//       '''
//       customerName: $customerName,
//       projectName: $projectName,
//       ProjectCo_ordinator: $ProjectCo_ordinator,
//       projectmanager: $projectManager,
//       project_type: $projectType,
//       startDate: $startDate,
//       endDate: $endDate,
//       Expected_Cost: $expectedCost,
//       Status: $status,
//       state: $state,
//       Address: $address,
//       godownlist:$godownlist,
//       project_dscription: $projectDescription,
//       projectId: $projectId
//       '''
//     );
//
//     final formData = FormData.fromMap({
//       "customerName": customerName,
//       "projectName": projectName,
//       "ProjectCo_ordinator": ProjectCo_ordinator,
//       "projectmanager": projectManager,
//       "project_type": projectType,
//       "startDate": startDate,
//       "endDate": endDate,
//       "Expected_Cost": expectedCost,
//       "Status": status,
//       "state": state,
//       "Address": address,
//       "godownlist": godownlist,
//       "project_dscription": projectDescription,
//       "projectId":projectId
//     });
//
//     try {
//       final dio = Dio();
//       final response = await dio.post(url, data: formData, options: Options(headers: headers));
//
//       print("Add Project Response: ${response.data}");
//
//       if (response.statusCode == 200) {
//         if (response.data is Map<String, dynamic>) {
//           return BaseResponse.fromJson(response.data);
//         } else if (response.data is String) {
//           // If server returns a JSON string
//           return BaseResponse.fromJson(jsonDecode(response.data));
//         }
//       }
//
//       return BaseResponse(code: "500", massage: ConstantsMessage.serveError);
//     } catch (e, st) {
//       print('Error occurred while adding project: $e\n$st');
//       return BaseResponse(code: "500", massage: ConstantsMessage.serveError);
//     }
//   }
// }
import 'dart:convert';
import 'package:dio/dio.dart';
import '../../UI/Utils/messages_constants.dart';
import '../../data/local/AppUtils.dart';
import '../../ui/Utils/config_constants.dart';
import '../models/AddProjectModel.dart';

class AddProjectService {
  Future<BaseResponse> addProject({
    String? customerName,
    String? projectName,
    String? ProjectCo_ordinator,
    String? projectManager,
    String? projectType,
    String? startDate,
    String? endDate,
    String? expectedCost,
    String? status,
    String? state,
    String? address,
    String? godownlist,
    String? projectDescription,
    String? projectId,
  }) async {
    final url =
        '${AppConfig.BASE_URL}${AppConfig.Add_Project_Url}${AppConfig.reload}';
    final token = await AppUtils().getToken();

    final headers = {
      "Accept": "*/*",
      "source": AppConfig.source,
      "Authorization": "Bearer $token",
    };

    final formData = FormData.fromMap({
      "customerName": customerName,
      "projectName": projectName,
      "ProjectCo_ordinator": ProjectCo_ordinator,
      "projectmanager": projectManager,
      "project_type": projectType,
      "startDate": startDate,
      "endDate": endDate,
      "Expected_Cost": expectedCost,
      "Status": status,
      "state": state,
      "Address": address,
      "godownlist": godownlist,
      "project_dscription": projectDescription,
      "projectId": projectId,
    });

    try {
      final dio = Dio();

      final response = await dio.post(
        url,
        data: formData,
        options: Options(headers: headers),
      );

      print("Add Project Response: ${response.data}");

      if (response.statusCode == 200) {
        if (response.data is Map<String, dynamic>) {
          return BaseResponse.fromJson(response.data);
        } else if (response.data is String) {
          return BaseResponse.fromJson(jsonDecode(response.data));
        }
      }

      return BaseResponse(
        code: response.statusCode.toString(),
        massage: ConstantsMessage.serveError,
      );
    }

    // ✅ HANDLE API ERRORS PROPERLY HERE
    on DioException catch (e) {
      print('Dio Error: ${e.response?.data}');

      if (e.response != null) {
        final statusCode = e.response?.statusCode;

        String errorMessage = ConstantsMessage.serveError;

        // ✅ Extract message from API
        if (e.response?.data is Map<String, dynamic>) {
          errorMessage =
              e.response?.data["message"] ??
                  e.response?.data["error"] ??
                  errorMessage;
        } else if (e.response?.data is String) {
          errorMessage = e.response?.data;
        }

        // ✅ Special handling for 409
        if (statusCode == 409) {
          return BaseResponse(
            code: "409",
            massage: errorMessage,
          );
        }

        return BaseResponse(
          code: statusCode.toString(),
          massage: errorMessage,
        );
      }

      return BaseResponse(
        code: "500",
        massage: "Network error",
      );
    }

    // ✅ ANY OTHER ERROR
    catch (e, st) {
      print('Error occurred while adding project: $e\n$st');
      return BaseResponse(
        code: "500",
        massage: ConstantsMessage.serveError,
      );
    }
  }
}