import 'dart:convert';
import 'package:dio/dio.dart';
import '../../UI/Utils/messages_constants.dart';
import '../../data/local/AppUtils.dart';
import '../../ui/Utils/config_constants.dart';
import '../models/DAOGRNResponse.dart';

class GoodsReceivedByIDService {
  Future<String> fetchGoodsReceivedNotesByID(String id) async {
    final url =
        '${AppConfig.BASE_URL}${AppConfig.Get_Goods_Received_By_ID_Url}${AppConfig.reload}';
    final token = await AppUtils().getToken();
    final headers = {
      "Accept": "*/*",
      "source": AppConfig.source,
      "Authorization": "Bearer $token",
    };

    final dataBody = {"gen_id": id};

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

class AddGoodsReceivedNotesService {
  Future<DAOGRNResponse> addGoodsReceivedNotes({
    String? grn_date,
    String? gen_no,
    String? bill_no,
    String? challan_no,
    String? vehcile_no,
    String? po_no,
    String? from_vendor,
    String? company_name,
    String? to_warehouse,
    String? to_warehouse_id,
    String? requested_by,
    String? contact,
    String? item_names,
    String? quantities,
    String? received_qty,
    String? short_qty,
    String? excess_qty,
    String? rejected_qty,
    String? accepted_qty,
    String? po_balance,
    String? rate,
    String? discount,
    String? amount,
    String? item_id,
    String? group_id,
    String? sub_group_id,
    String? unit,
    String? grand_total,
    String? remarks,
    String? item_description
  }) async {
    final url =
        '${AppConfig.BASE_URL}${AppConfig.Add_Goods_Received_Notes_Url}${AppConfig.reload}';
    final token = await AppUtils().getToken();

    final headers = {
      "Accept": "*/*",
      "source": AppConfig.source,
      "Authorization": "Bearer $token",
    };

    final formData = FormData.fromMap({
      "grn_date":grn_date,
      "gen_no":gen_no,
      "bill_no":bill_no,
      "challan_no":challan_no,
      "vehcile_no":vehcile_no,
      "po_no":po_no,
      "from_vendor":from_vendor,
      "company_name":company_name,
      "to_warehouse":to_warehouse,
      "to_warehouse_id":to_warehouse_id,
      "requested_by":requested_by,
      "contact":contact,
      "item_names":item_names,
      "quantities":quantities,
      "received_qty":received_qty,
      "short_qty":short_qty,
      "excess_qty":excess_qty,
      "rejected_qty":rejected_qty,
      "accepted_qty":accepted_qty,
      "po_balance":po_balance,
      "rate":rate,
      "discount":discount,
      "amount":amount,
      "item_id":item_id,
      "group_id":group_id,
      "sub_group_id":sub_group_id,
      "unit":unit,
      "grand_total":grand_total,
      "remarks":remarks,
      "item_description":item_description,
    });

    try {
      final dio = Dio();
      final response = await dio.post(url,
          data: formData, options: Options(headers: headers));
      print("Add Goods Received Notes Response: ${response.data}");
      if (response.statusCode == 200) {
        if (response.data is Map<String, dynamic>) {
          return DAOGRNResponse.fromJson(response.data);
        } else if (response.data is String) {
          return DAOGRNResponse.fromJson(jsonDecode(response.data));
        }
      }
      return DAOGRNResponse(code: "500", message: ConstantsMessage.serveError);
    } catch (e, st) {
      print('Error occurred while adding new entry: $e\n$st');
      return DAOGRNResponse(code: "500", message: ConstantsMessage.serveError);
    }
  }
}

class GoodsReceivedNotesService{

  Future<String> fetchGoodsReceivedNotesRaw(
      {required int start,
        required int length,
        required String from,
        required String to,
        required String grn_no,
        required String gate_entry_no,
        required String vehicle_no
      }) async {
    final url =
        '${AppConfig.BASE_URL}${AppConfig.Get_Goods_Received_Notes_Url}${AppConfig.reload}';
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
      "from":from,
      "to":to,
      "grn_no":grn_no,
      "gate_entry_no":gate_entry_no,
      "vehicle_no":vehicle_no
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

class GetGRNDetailByIDService{
  Future<String> fetchGRNDetialByID(String grn_id) async {
    final url =
        '${AppConfig.BASE_URL}${AppConfig.Get_Goods_Received_Notes_By_ID_Url}${AppConfig.reload}';
    final token = await AppUtils().getToken();

    final headers = {
      "Accept": "*/*",
      "source": AppConfig.source,
      "Authorization": "Bearer $token",
    };

    final dataBody = {"grn_id": grn_id};

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
      print("GRNDetailByIDService Exception: $e");
      return jsonEncode(
          {"code": "500", "massage": ConstantsMessage.serveError});
    }
  }
}

class DeleteGRNService {
  Future<String> deleteGRNData(String grn_id,String accepted_qty) async {
    final url =
        '${AppConfig.BASE_URL}${AppConfig.Delete_Goods_Received_Notes_Url}${AppConfig.reload}';
    final token = await AppUtils().getToken();

    final headers = {
      "Accept": "*/*",
      "source": AppConfig.source,
      "Authorization": "Bearer $token",
    };

    final dataBody = {
      "grn_id": grn_id,
      "accepted_qty": accepted_qty,
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
      print("DeleteEntryService Exception: $e");
      return jsonEncode(
          {"code": "500", "massage": ConstantsMessage.serveError});
    }
  }
}


class GRNDownloadService{
  Future<String> fetchGRNDownload(String grn_id) async {
    final url =
        '${AppConfig.BASE_URL}${AppConfig.Goods_Received_Notes_Download_Url}${AppConfig.reload}';
    final token = await AppUtils().getToken();

    final headers = {
      "Accept": "*/*",
      "source": AppConfig.source,
      "Authorization": "Bearer $token",
    };

    final dataBody = {"grn_id": grn_id};

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
      print("GRNDetailByIDService Exception: $e");
      return jsonEncode(
          {"code": "500", "massage": ConstantsMessage.serveError});
    }
  }
}