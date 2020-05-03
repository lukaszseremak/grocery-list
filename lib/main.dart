import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_list/models/user.dart';
import 'package:shopping_list/screens/wrapper.dart';
import 'package:shopping_list/services/auth.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<User>.value(
      value: AuthService().user,
      child: MaterialApp(
        themeMode: ThemeMode.dark,
        darkTheme:
            ThemeData(fontFamily: 'Manslava', brightness: Brightness.dark),
        home: Wrapper(),
      ),
    );
  }
}
