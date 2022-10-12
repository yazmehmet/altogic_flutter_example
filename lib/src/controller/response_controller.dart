import 'dart:convert';

import 'package:altogic_flutter/altogic_flutter.dart';
import 'package:flutter/cupertino.dart';

class ResponseViewController with ChangeNotifier {
  ResponseViewController();

  String? _value;

  String get value => _value ?? "No response";

  set value(String? value) {
    _value = value;
    notifyListeners();
  }

  void loading() {
    value = "Loading...";
  }

  void error(APIError? error) {
    if (error == null) {
      value = "No error";
    } else {
      value = error.toString();
    }
  }

  void success(String? data) {
    value = data;
  }

  void clear() {
    value = null;
  }

  void response(APIResponse data) {
    if (data.errors != null) {
      error(data.errors);
    } else {
      success(const JsonEncoder.withIndent("    ").convert(data.data));
    }
  }
}
