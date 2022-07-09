import 'dart:convert';

import 'package:flutter/cupertino.dart';

class ExceptionHandle with ChangeNotifier {
  List exception = [];

  List get exceptionData {
    return exception;
  }

  void handleException(var response) {
    var responseData = json.decode(response.body) as Map<String, dynamic>;
    exception.clear();
    responseData.forEach((key, value) {
      exception.add({
        'Key': key,
        'Value': value[0],
      });
    });
    notifyListeners();
  }
}
