import 'package:flutter/cupertino.dart';

import '../main.dart';
import '../modules/user/view/dashboard_screen.dart';

Route<dynamic>? routeGenerator(settings) {
  switch (settings.name) {
    case Routes.dashboardScreen:
      return CupertinoPageRoute(builder: (context) => const DashboardScreen());

    case Routes.splashScreen:
      return CupertinoPageRoute(builder: (context) => const SplashScreen());
    default:
      return null;
  }
}

class Routes {
  static const String dashboardScreen = '/dashboard';
  static const String splashScreen = '/';
}
