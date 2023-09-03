import 'package:flutter/material.dart';

class AppConstants {
  static String appName = 'sample';

  // navigator key
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  static const String dbName = 'sample_app.db';

  static const int kVersion = 1;

  static const String columnName = 'name';
  static const String columnId = 'id';
  static const String columnNationality = 'nationality';
  static const String columnEmployeeId = 'employeeId';
  static const String columnImgUrl = 'imgUrl';
  static const String columnDob = 'dob';

  static const String tableName = 'user_tbl';
}
