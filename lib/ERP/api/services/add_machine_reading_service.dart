import 'dart:convert';
import 'package:dio/dio.dart';
import '../../UI/Utils/messages_constants.dart';
import '../../data/local/AppUtils.dart';
import '../../ui/Utils/config_constants.dart';
import '../models/AddProjectModel.dart';

class AddMachineReadingService {
  Future<BaseResponse> addMachineReading({
    String? date,
    String? reading_start,
    String? reading_stop,
    String? machine_Start,
    String? machine_Stop,
    String? time_expend,
    String? notes,
    String? project_id,
    String? readingID,
    String? vendertype,
    String? vechiceltype,
    String? gate_pass_no,
    String? total_run,
    String? amount
  }) async {
    final url =
        '${AppConfig.BASE_URL}${AppConfig.Add_New_Machine_Reading_Url}${AppConfig.reload}';
    final token = await AppUtils().getToken();
    print("url ${url}");
    print("token ${token}");

    final headers = {
      "Accept": "*/*",
      "source": AppConfig.source,
      "Authorization": "Bearer $token",
    };

    // print(
    //   '''
    //     date: $date,
    //     reading_start: $reading_start,
    //     reading_stop: $reading_stop,
    //     machine_Start: $machine_Start,
    //     machine_Stop: $machine_Stop,
    //     time_expend: $time_expend,
    //     notes: $notes,
    //     project_id: ${project_id},
    //     vendertype: ${vendertype},
    //     vechiceltyp: ${vechiceltype},
    //     readingId: ${readingID},
    //     gatePass: ${gatePass},
    //   '''
    // );

    final formData = FormData.fromMap({
      "date": date,
      "reading_start": reading_start,
      "reading_stop": reading_stop,
      "machine_Start": machine_Start,
      "machine_Stop": machine_Stop,
      "time_expend": time_expend,
      "notes": notes,
      "project_id": project_id,
      "readingID": readingID,
      "vendertype": vendertype,
      "vechiceltype": vechiceltype,
      "gate_pass_no": gate_pass_no,
      "total_run": total_run,
      "amount": amount,
    });

    try {
      final dio = Dio();
      final response = await dio.post(url,
          data: formData, options: Options(headers: headers));
      // print("Add New machine Response");
      // print(JsonEncoder(response.data));
      if (response.statusCode == 200) {
        if (response.data is Map<String, dynamic>) {
          return BaseResponse.fromJson(response.data);
        } else if (response.data is String) {
          return jsonDecode(response.data);
        }
      }
      return BaseResponse(code: "500", massage: ConstantsMessage.serveError);
    } catch (e, st) {
      print('Error occurred while adding new entry: $e\n$st');

      return BaseResponse(code: "500", massage: ConstantsMessage.serveError);
    }
  }
}

class MachineReadingService {
  Future<String> fetchMachineReadingRaw(
      {required int start, required int length, required}) async {
    final url =
        '${AppConfig.BASE_URL}${AppConfig.Get_New_Machine_Reading_Url}${AppConfig.reload}';
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

class DeleteMachineReadingService {
  Future<String> deleteMachineReadingsData(String readingid) async {
    final url =
        '${AppConfig.BASE_URL}${AppConfig.Delete_New_Machine_Reading_Url}${AppConfig.reload}';
    final token = await AppUtils().getToken();

    final headers = {
      "Accept": "*/*",
      "source": AppConfig.source,
      "Authorization": "Bearer $token",
    };

    final dataBody = {"readingid": readingid};

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
      print("DeleteMachineReadingService Exception: $e");
      return jsonEncode(
          {"code": "500", "massage": ConstantsMessage.serveError});
    }
  }
}

class GetMachineReadingByIDService {
  Future<String> fetchMachineRedaingDataByID(String readingid) async {
    final url =
        '${AppConfig.BASE_URL}${AppConfig.Get_Machine_Reading_By_ID_Url}${AppConfig.reload}';
    final token = await AppUtils().getToken();

    final headers = {
      "Accept": "*/*",
      "source": AppConfig.source,
      "Authorization": "Bearer $token",
    };

    final dataBody = {"readingid": readingid};

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
