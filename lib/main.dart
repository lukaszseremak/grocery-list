import 'package:flutter/material.dart';

import 'screens/login_screen.dart';
import 'screens/main_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shopping List',
      themeMode: ThemeMode.dark,
      darkTheme: ThemeData(fontFamily: 'Manslava', brightness: Brightness.dark),
      initialRoute: 'main_screen',
      routes: {
        'login_screen': (context) => LoginScreen(),
        'main_screen': (context) => MainScreen(),
      },
    );
  }
}
