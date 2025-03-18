import 'package:flutter/material.dart';
import 'constants.dart';
import 'screens/start_screen.dart';

void main() {
  runApp(const MedocFanTanApp());
}

class MedocFanTanApp extends StatelessWidget {
  const MedocFanTanApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = ThemeData(
      colorScheme: ColorScheme(
        brightness: Brightness.dark,
        primary: assortColor,
        onPrimary: baseColor,
        secondary: accentColor,
        onSecondary: assortColor,
        background: baseColor,
        onBackground: assortColor,
        surface: assortColor,
        onSurface: baseColor,
        error: Colors.red,
        onError: Colors.white,
      ),
      scaffoldBackgroundColor: baseColor,
      appBarTheme: AppBarTheme(
        backgroundColor: assortColor,
        foregroundColor: baseColor,
        iconTheme: IconThemeData(color: accentColor),
        titleTextStyle: const TextStyle(
          color: baseColor,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          primary: assortColor,
          onPrimary: baseColor,
        ),
      ),
      textTheme: const TextTheme(
        bodyText1: TextStyle(color: assortColor),
        bodyText2: TextStyle(color: assortColor),
      ),
      fontFamily: 'Georgia',
    );

    return MaterialApp(
      title: 'Médoc 61 Fan Tan (1855)',
      theme: theme,
      home: const StartScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
