import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rider_app/com/rider/allScreens/mainScreen.dart';
import 'package:rider_app/com/rider/allScreens/registerationScreen.dart';
import 'package:email_validator/email_validator.dart';
import 'package:rider_app/main.dart';

class LoginScreen extends StatelessWidget {
  // const LoginScreen({Key? key}) : super(key: key);
  TextEditingController emailTextEditingController = new TextEditingController();
  TextEditingController passwordTextEditingController = new TextEditingController();

  static const String idScreen = "login";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Form (
          autovalidateMode: AutovalidateMode.always,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column (
              children: [
                SizedBox(height: 45.0,),
                Image(
                  image: AssetImage("riderassets/images/logo.png"),
                  width: 390.0,
                  height: 250.0,
                  alignment: Alignment.center,
                ),
                SizedBox(height: 1.0,),
                Text(
                  "Login as Rider",
                  style: TextStyle(fontSize: 24.0, fontFamily: "Brand-SemiBold"),
                  textAlign: TextAlign.center,

                ),
                Padding(padding: EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      SizedBox(height: 1.0,),
                      TextFormField(
                        controller: emailTextEditingController,
                        validator: (value) => EmailValidator.validate(value) ? null : "Please enter a valid email",
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                            labelText: "Email",
                            labelStyle: TextStyle(
                              fontSize: 14.0,
                            ),
                            hintStyle: TextStyle(
                                color: Colors.grey,
                                fontSize: 10.0
                            )
                        ),
                        style: TextStyle(
                          fontSize: 14.0,
                        ),
                      ),
                      SizedBox(height: 1.0,),
                      TextFormField(
                        controller: passwordTextEditingController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter some text';
                          }
                          if (value.length < 8) {
                            return 'Must be more than 8 charater';
                          }
                        },
                        obscureText: true,
                        decoration: InputDecoration(
                            labelText: "Password",
                            labelStyle: TextStyle(
                              fontSize: 14.0,
                            ),
                            hintStyle: TextStyle(
                                color: Colors.grey,
                                fontSize: 10.0
                            )
                        ),
                        style: TextStyle(
                          fontSize: 14.0,
                        ),
                      ),
                      SizedBox(height: 1,),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: Colors.yellow,
                            shape: new RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(24.0)
                            )
                        ),
                        onPressed: () {
                          // print("Button clicked........");
                          authenticateUser(context);
                        },
                        child: Container(
                          height: 50,
                          child: Center(
                            child: Text(
                              "Login",
                              style: TextStyle(
                                  fontSize: 18,
                                  fontFamily: "Brand-SemiBold",
                                  color: Colors.black

                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                TextButton(
                    onPressed: () {
                      Navigator.pushNamedAndRemoveUntil(context, RegisterationScreen.idScreen, (route) => false);
                    },
                    child: Text(
                      "Do not have an account, click to register!",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontFamily: "Brand-SemiBold"
                      ),
                    )
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  void authenticateUser(BuildContext context) async {
    final User user = (
        await firebaseAuth.signInWithEmailAndPassword(
            email: emailTextEditingController.text,
            password: passwordTextEditingController.text)
            .catchError((errMsg) {
          displayAlert("Error: "+errMsg);
        })
    ).user!;

    if(user != null) {
      databaseReference.child(user.uid).once().then((DataSnapshot snap) {
        if(snap.value != null) {
          Navigator.pushNamedAndRemoveUntil(context, MainScreen.idScreen, (route) => false);
          displayAlert("User successfully logged in.");
        }
      });


    } else {
      firebaseAuth.signOut();
      displayAlert("Error user signin.");
    }


  }

  void displayAlert(final String text) {
    Fluttertoast.showToast(msg: text);
  }
}
