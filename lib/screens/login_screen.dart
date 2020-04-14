import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen();

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController passwordController = TextEditingController()..text = '';
  bool obscureText = true;
  static const String password = '123';
  bool isPasswordIncorect = false;

  void inContact(TapDownDetails details) {
    setState(() {
      obscureText = false;
    });
  }

  void outContact(TapUpDetails details) {
    setState(() {
      obscureText = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/log_screen.png"),
            fit: BoxFit.fill,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.fromLTRB(40, 145, 40, 100),
          child: ListView(
            children: <Widget>[
              Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(10),
                  child: Text(
                    'Grocery list',
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 65.0,
                      fontFamily: 'Manslava',
                    ),
                  )),
              Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(10),
                  child: Text(
                    'Sign in',
                    style: TextStyle(fontSize: 30, fontFamily: 'IndieFlower'),
                  )),
              Container(
                padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: TextField(
                  style: TextStyle(
                    fontSize: 20.0,
                    fontFamily: 'IndieFlower',
                  ),
                  obscureText: obscureText,
                  controller: passwordController,
                  decoration: InputDecoration(
                    suffixIcon: GestureDetector(
                      child: Icon(
                        Icons.remove_red_eye,
                        color: obscureText ? Colors.grey : Colors.amber[800],
                      ),
                      onTapDown: inContact,
                      onTapUp: outContact,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.yellow[200]),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    border: new OutlineInputBorder(
                      borderRadius: const BorderRadius.all(
                        const Radius.circular(10.0),
                      ),
                      borderSide: const BorderSide(
                        color: Colors.white,
                        width: 2.0,
                      ),
                    ),
                    labelStyle: TextStyle(color: Colors.red[300]),
                    labelText: 'Password',
                    errorText: isPasswordIncorect
                        ? 'Incorect password! Please, try again.'
                        : null,
                    errorStyle:
                        TextStyle(color: Colors.redAccent, fontSize: 13.5),
                  ),
                ),
              ),
              SizedBox(height: 20.0),
              Container(
                  height: 50,
                  padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(
                        10.0,
                      ),
                    ),
                    textColor: Colors.white,
                    color: Colors.red[300],
                    child: Text(
                      'Login',
                      style: TextStyle(
                        fontSize: 23.0,
                        fontFamily: 'IndieFlower',
                      ),
                    ),
                    onPressed: () {
                      print(passwordController.text);
                      if (passwordController.text == password) {
                        // przejsc do ekranu glownego
                        print('Przechodzenie do programu glownego');
                        setState(() {
                          passwordController.text = "";
                          isPasswordIncorect = false;
                        });
                        Navigator.pushNamed(context, 'main_screen');
                      } else {
                        print('Haslo nieprawidlowe');
                        setState(() {
                          passwordController.text = "";
                          isPasswordIncorect = true;
                        });
                      }
                    },
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
