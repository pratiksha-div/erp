import 'dart:io';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppUtils {

  static const _keyLoginTimeMillis = 'login_time_millis';
  static const _keyEmployeeId = 'employee_id';
  static const _keyUserRole = 'user_role';

  // user role
  Future<void> setUserRole(List<String> roles) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_keyUserRole, roles);
  }
  Future<List<String>> getUserRole() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_keyUserRole) ?? [];
  }

  // set logged
  Future<bool> getUserLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('user_logged_in') ?? false;
    return isLoggedIn;
  }
  void setUserLoggedIn(bool status) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('user_logged_in', status);
  }

  // token
  void setToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('token', token);
  }
  getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token') ?? "";
  }

  // employee id
  void setEmployeeId(String employeeId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyEmployeeId, employeeId);
  }
  Future<String> getEmployeeId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyEmployeeId) ?? "";
  }

  // user id
  void setUserID(String userID) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('user_id', userID);
  }
  Future<String> getUserID() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_id') ?? "";
  }

  // login time
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

  //logout
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
