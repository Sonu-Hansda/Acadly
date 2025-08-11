import 'package:flutter/material.dart';

void navigateToLogin(BuildContext context) {
  Future.delayed(const Duration(seconds: 2), () {
    Navigator.pushReplacementNamed(context, '/login');
  });
}
