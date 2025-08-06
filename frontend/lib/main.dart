import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const TecopescaApp());
}

class TecopescaApp extends StatelessWidget {
  const TecopescaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NutriPlan - Sistema de Gestión',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          elevation: 2,
        ),
        drawerTheme: const DrawerThemeData(backgroundColor: Colors.white),
      ),
      home: const HomeScreen(),
    );
  }
}
