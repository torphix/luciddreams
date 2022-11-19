import 'package:flutter/material.dart';
import 'package:luciddreams/ui/image_browser.dart';

import 'main.dart';


class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (context) => MyApp());

      // Image Views
      case '/browseImages':
        return MaterialPageRoute(builder: (context) => const ImageBrowser());
      default:
        return MaterialPageRoute(builder: (context) => MyApp());
    }
  }
}