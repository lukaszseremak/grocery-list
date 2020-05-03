import 'package:flutter/material.dart';
import 'package:shopping_list/services/auth.dart';
import 'package:shopping_list/shared/constants.dart';
import 'package:shopping_list/shared/loading.dart';

class SingIn extends StatefulWidget {
  @override
  _SingInState createState() => _SingInState();
}

class _SingInState extends State<SingIn> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

  String error = '';
  bool loading = false;
  bool passwordObscureText = true;

  String email = '';
  String password = '';

  void inContact(TapDownDetails details) {
    setState(() {
      passwordObscureText = false;
    });
  }

  void outContact(TapUpDetails details) {
    setState(() {
      passwordObscureText = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
            resizeToAvoidBottomInset: false,
            body: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/log_screen.png"),
                  fit: BoxFit.fill,
                ),
              ),
              child: Container(
                padding: EdgeInsets.fromLTRB(40, 145, 40, 100),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      Container(
                        alignment: Alignment.center,
                        padding: EdgeInsets.all(10),
                        child: Text(
                          'Shopping list',
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 65.0,
                          ),
                        ),
                      ),
                      Container(
                        alignment: Alignment.center,
                        padding: EdgeInsets.all(10),
                        child: Text(
                          'Sign in',
                          style: TextStyle(
                              fontSize: 30, fontFamily: 'IndieFlower'),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                        child: TextFormField(
                          decoration:
                              formDecoration.copyWith(labelText: "Email"),
                          style: TextStyle(
                            fontSize: 20.0,
                            fontFamily: 'IndieFlower',
                          ),
                          validator: (val) =>
                              val.isEmpty ? 'Enter an email' : null,
                          onChanged: (val) {
                            setState(() => email = val);
                          },
                        ),
                      ),
                      SizedBox(
                        height: 8.0,
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                        child: TextFormField(
                          style: TextStyle(
                            fontSize: 20.0,
                            fontFamily: 'IndieFlower',
                          ),
                          obscureText: passwordObscureText,
                          decoration: formDecoration.copyWith(
                            labelText: "Password",
                            suffixIcon: GestureDetector(
                              child: Icon(
                                Icons.remove_red_eye,
                                color: passwordObscureText
                                    ? Colors.grey
                                    : Colors.amber[800],
                              ),
                              onTapDown: inContact,
                              onTapUp: outContact,
                            ),
                          ),
                          validator: (val) => val.length < 6
                              ? 'Enter a password 6+ chars long'
                              : null,
                          onChanged: (val) {
                            setState(() => password = val);
                          },
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
                          onPressed: () async {
                            if (_formKey.currentState.validate()) {
                              setState(() => loading = true);
                              dynamic result = await _auth
                                  .signInWithEmailAndPassword(email, password);
                              if (result == null) {
                                setState(() {
                                  loading = false;
                                  error =
                                      'Could not sign in with those credentials';
                                });
                              }
                            }
                          },
                        ),
                      ),
                      SizedBox(height: 12.0),
                      Text(
                        error,
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 18.0,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
  }
}
