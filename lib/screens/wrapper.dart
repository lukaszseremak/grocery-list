import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_list/models/user.dart';
import 'package:shopping_list/screens/authenticate/sign_in.dart';
import 'package:shopping_list/screens/main_screen.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);

    if (user == null) {
      return SingIn();
    } else {
      return MainScreen();
    }
  }
}
