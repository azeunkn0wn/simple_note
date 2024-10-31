import 'package:flutter/material.dart';
import 'package:simple_note/presentation/routes/router.dart';

class AppWidget extends StatelessWidget {
  AppWidget({super.key});

  final _appRouter = AppRouter();

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Simple Note Taking App',
      theme: themeData,
      routerConfig: _appRouter.config(),
    );
  }
}

final themeData = ThemeData(
  useMaterial3: false,
  colorScheme: const ColorScheme.light(
    primary: Color(0xFF364D9F),
    onPrimary: Colors.white,
    secondary: Color(0xFF84C442),
    tertiary: Color(0xFF6C757D),
    onTertiary: Colors.white,
  ),
  textTheme: const TextTheme(
    bodyMedium: TextStyle(
      color: Color(0xFF252525),
    ),
  ),
);
