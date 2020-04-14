import 'package:flutter/material.dart';

import 'package:grocery_list/screens/main_screen.dart';
import 'screens/login_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      themeMode: ThemeMode.dark,
      darkTheme: ThemeData(fontFamily: 'Manslava', brightness: Brightness.dark),
      initialRoute: 'login_screen',
      routes: {
        'login_screen': (context) => LoginScreen(),
        'main_screen': (context) => MainScreen(),
      },
    );
  }
}
