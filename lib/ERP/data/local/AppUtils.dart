import 'dart:io';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppUtils {

  static const _keyToken = 'token';
  static const _keyLoginTimeMillis = 'login_time_millis';
  static const _keyEmployeeId = 'employee_id';
  static const _keyUserId = 'user_id';

  Future<bool> getUserLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('user_logged_in') ?? false;
    return isLoggedIn;
  }

  void setUserLoggedIn(bool status) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('user_logged_in', status);
  }

  ///=================for status change for fault list=================================////////////////////////


  void setToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('token', token);
  }

  getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token') ?? "";
  }

  void setEmployeeId(String employeeId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyEmployeeId, employeeId);
  }

  Future<String> getEmployeeId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyEmployeeId) ?? "";
  }

  void setUserID(String userID) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('user_id', userID);
  }

  Future<String> getUserID() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_id') ?? "";
  }
  ///=================t=================================////////////////////////

  Future<void> setLoginTime(DateTime dateTime) async {
    final prefs = await  await SharedPreferences.getInstance();
    await prefs.setInt(_keyLoginTimeMillis, dateTime.toUtc().millisecondsSinceEpoch);
  }

  Future<DateTime?> getLoginTime() async {
    final prefs = await  await SharedPreferences.getInstance();
    final millis = prefs.getInt(_keyLoginTimeMillis);
    if (millis == null) return null;
    return DateTime.fromMillisecondsSinceEpoch(millis, isUtc: true).toLocal();
  }

  Future<bool> logoutUser() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setBool('user_logged_in', false);

      return true;
    } catch (e) {
      return false;
    }
  }

}
