import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'cots/controllers/recipe_controller.dart';
import 'cots/presentation/pages/dashboard_page.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => RecipeController()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'COTS Resep',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFF7F0FA), // [cite: 6]
        useMaterial3: true,
      ),
      home: const DashboardPage(),
    );
  }
}