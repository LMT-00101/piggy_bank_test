import 'package:flutter/material.dart';

import 'routes/app_routes.dart';

void main() {
  runApp(const SmartJarsApp());
}

class SmartJarsApp extends StatelessWidget {
  const SmartJarsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Smart Jars',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.green,
        scaffoldBackgroundColor: Colors.white,
      ),
      initialRoute: AppRoutes.welcome,
      onGenerateRoute: AppRoutes.generateRoute,
    );
  }
}