import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:locksy/crypto/cryptography_handler.dart';
import 'package:locksy/screens/login_screen.dart';
import 'package:locksy/screens/welcome_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF274c77);
    const Color secondaryColor = Color(0xFF6096ba);
    const Color tertiaryColor = Color(0xFF8b8c89);
    const Color backgroundColor = Color(0xFFa3cef1);
    const Color surfaceColor = Color(0xFFe7ecef); // White
    const Color errorColor = Color(0xFFB00020);


    final ColorScheme lightColorScheme = ColorScheme(
      brightness: Brightness.light,
      primary: primaryColor,
      onPrimary: Colors.white,
      secondary: secondaryColor,
      onSecondary: Colors.black,
      tertiary: tertiaryColor,
      onTertiary: Colors.black,
      shadow: backgroundColor,
      surface: surfaceColor,
      onSurface: Colors.black,
      error: errorColor,
      onError: Colors.white,
    );

    final ThemeData customTheme = ThemeData(
      colorScheme: lightColorScheme,
      primaryColor: lightColorScheme.primary,
      scaffoldBackgroundColor: lightColorScheme.surface,
      appBarTheme: AppBarTheme(
        backgroundColor: lightColorScheme.primary,
        foregroundColor: lightColorScheme.onPrimary,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: lightColorScheme.secondary,
        ),
      ),
      textTheme: TextTheme(
        bodyLarge: TextStyle(color: lightColorScheme.onSurface),
        bodyMedium: TextStyle(color: Colors.grey[800]),
      ),
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Locksy',
      theme: customTheme,
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});


  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _isMasterKeySet = false;

  void goToPage() async {
    bool isMasterKeySet = await CryptographyHandler.getInstance.getMasterKey();
    if (mounted) {
      setState(() {
        _isMasterKeySet = isMasterKeySet;
      });
    }
    if (isMasterKeySet) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => WelcomeScreen()),
      );
    }
  }

  @override
  void initState() {
    super.initState();

    Timer(Duration(seconds: 2), () {
      goToPage();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset('assets/logo.png'),
    )
    );
  }
}
