import 'package:flutter_kundol/constants/app_constants.dart';
import 'package:flutter_kundol/models/user.dart';

class RegisterResponse {
  String? status;
  User? data;
  String? message;

  RegisterResponse({this.status, this.data, this.message});

  RegisterResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? User.fromJson(json['data']) : null;
    message = json['message'];
  }

  RegisterResponse.withError(String error) {
    status = AppConstants.STATUS_ERROR;
    data = null;
    message = error;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    if (this.data != null) {
      data['data'] = this.data?.toJson();
    }
    data['message'] = message;
    return data;
  }
}
