import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:tes_praktek_daya_rekadigital/ui/screens/main_screen.dart';

void main() {
  initializeDateFormatting("id_ID");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tes Praktek Mobile Developer',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            brightness: Brightness.light,
            seedColor: Colors.deepPurple
        ),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            brightness: Brightness.dark,
            seedColor: Colors.deepPurple
        ),
        useMaterial3: true,
      ),
      home: const MainScreen(),
    );
  }
}