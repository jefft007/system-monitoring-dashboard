import 'package:flutter/material.dart';
import 'pages/dashboard_page.dart';
import 'pages/details_page.dart';
import 'pages/settings_page.dart';

void main() {
  runApp(const ServerMonitorApp());
}

class ServerMonitorApp extends StatelessWidget {
  const ServerMonitorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Server Monitor',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: Colors.blue,
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const DashboardPage(),
        '/details': (context) => const DetailsPage(),
        '/settings': (context) => const SettingsPage(),
      },
    );
  }
}