import 'package:flutter/cupertino.dart';
import 'package:foot_steps/core/presentation/pages/landing_page.dart';
import 'package:foot_steps/features/bottom_navbar/presentation/pages/bottom_navbar.dart';
import 'package:foot_steps/utilities/routes/routes.dart';

Route<dynamic> onGenerate(RouteSettings settings) {
  switch (settings.name) {
    case AppRoutes.homePageRoute:
      return CupertinoPageRoute(
        builder: (_) => const BottomNavbar(),
        settings: settings,
      );
    case AppRoutes.landingPageRoute:
    default:
      return CupertinoPageRoute(
        builder: (_) => const LandingPage(),
        settings: settings,
      );
  }
}
