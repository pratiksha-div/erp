
class LoginResponse {
  List<String> userRole;
  String message;
  String token;
  int updatedDt;
  String employeeId;
  String roleId;
  int code;
  String companyName;
  String username;

  // Constructor
  LoginResponse({
    required this.userRole,
    required this.message,
    required this.token,
    required this.updatedDt,
    required this.employeeId,
    required this.roleId,
    required this.code,
    required this.companyName,
    required this.username,
  });

  // Factory constructor to create a LoginResponse object from a JSON map
  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      userRole: List<String>.from(json['USERROLE'] ?? []),  // Handling list of roles
      message: json['MESSAGE'] ?? '',
      token: json['TOKEN'] ?? '',
      updatedDt: json['UPDATEDDT'] ?? 0,
      employeeId: json['EMPLOYEEID'] ?? '',
      roleId: json['ROLEID'] ?? '',
      code: json['CODE'] ?? 0,
      companyName: json['COMPANYNAME'] ?? '',
      username: json['USERNAME'] ?? '',
    );
  }

  // Method to convert LoginResponse object back to a JSON map (optional, for requests)
  Map<String, dynamic> toJson() {
    return {
      'USERROLE': userRole,
      'MESSAGE': message,
      'TOKEN': token,
      'UPDATEDDT': updatedDt,
      'EMPLOYEEID': employeeId,
      'ROLEID': roleId,
      'CODE': code,
      'COMPANYNAME': companyName,
      'USERNAME': username,
    };
  }
}
