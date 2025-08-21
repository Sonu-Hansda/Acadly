import 'dart:io';
import 'package:flutter/foundation.dart';

class ApiConfig{
  static String getBaseURL(){
    if (kIsWeb) {
      return "http://localhost:3000";
    } else if (Platform.isAndroid) {
      return "http://10.0.2.2:3000";
    } else {
      return "http://192.168.x.x:3000";
    }
  }
}