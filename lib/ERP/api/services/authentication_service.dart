import 'dart:convert';
import 'package:dio/dio.dart';
import '../../UI/Utils/messages_constants.dart';
import '../../data/local/AppUtils.dart';
import '../../ui/Utils/config_constants.dart';
import '../models/AddProjectModel.dart';
import '../models/loginModel.dart';

class AuthenticationService {

  Future<dynamic> signUser(String username, String password) async {
    final url = AppConfig.BASE_URL + AppConfig.LOGIN_URL + AppConfig.reload;
    final headers = {
      "Accept": "*/*",
      "source": AppConfig.source,
    };
    final formData = FormData.fromMap({
      "Username": username,
      "Password": password,
    });

    try {
      final dio = Dio();

      final response = await dio.post(
        url,
        data: formData,
        options: Options(headers: headers),
      );

      if (response.statusCode == 200) {
        if (response.data is Map<String, dynamic>) {
          print("login response");
          print(response.data);
          return LoginResponse.fromJson(response.data as Map<String, dynamic>);
        }
        // If response is in String format, return it as is (for example, if it's raw JSON)
        if (response.data is String) {
          return response.data;  // Raw response (String)
        }
      }
      return ConstantsMessage.serveError;
    } catch (e) {
      print('Error in signUser: $e');
      return ConstantsMessage.serveError;
    }
  }

  Future<dynamic> sendOTP() async {
    final url = AppConfig.BASE_URL + AppConfig.Sent_OTP_URl + AppConfig.reload;

    final token = await AppUtils().getToken();
    final userRoleId = await AppUtils().getUserID();

    final headers = {
      "Accept": "*/*",
      "source": AppConfig.source,
      "Authorization": "Bearer $token",
    };

    final formData = FormData.fromMap({
      "UserRoleID": userRoleId,
      "companyid": "045748e5-57d7-11eb-b9f1-063127f6ced7",
    });

    try {
      final dio = Dio();

      final response = await dio.post(
        url,
        data: formData,
        options: Options(headers: headers),
      );

      if (response.statusCode == 200) {
        print("response");
        print(response);
        // print(JsonEncoder().convert(response));
        if (response.data is Map<String, dynamic>) {
          return BaseResponse.fromJson(response.data as Map<String, dynamic>);
        }
        // If response is in String format, return it as is (for example, if it's raw JSON)
        if (response.data is String) {
          return response.data;  // Raw response (String)
        }
      }
      return ConstantsMessage.serveError;
    } catch (e) {
      print('Error in signUser: $e');
      return ConstantsMessage.serveError;
    }
  }

  Future<dynamic> verifyOTPService(String otp) async {
    final url = AppConfig.BASE_URL + AppConfig.Verify_OTP_URl + AppConfig.reload;

    final token = await AppUtils().getToken();
    final userRoleId = await AppUtils().getUserID();

    final headers = {
      "Accept": "*/*",
      "source": AppConfig.source,
      "Authorization": "Bearer $token",
    };

    final formData = FormData.fromMap({
      "UserRoleID": userRoleId,
      "companyid": "045748e5-57d7-11eb-b9f1-063127f6ced7",
    });

    try {
      final dio = Dio();

      final response = await dio.post(
        url,
        data: formData,
        options: Options(headers: headers),
      );

      if (response.statusCode == 200) {
        print("verifyOTPService success");
        if (response.data is Map<String, dynamic>) {
          return BaseResponse.fromJson(response.data as Map<String, dynamic>);
        }
        // If response is in String format, return it as is (for example, if it's raw JSON)
        if (response.data is String) {
          return response.data;  // Raw response (String)
        }
      }
      return ConstantsMessage.serveError;
    } catch (e) {
      print('Error in signUser: $e');
      return ConstantsMessage.serveError;
    }
  }

}
