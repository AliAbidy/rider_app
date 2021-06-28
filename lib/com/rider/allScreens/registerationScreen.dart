import 'dart:ui';

import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rider_app/com/rider/allScreens/loginScreen.dart';
import 'package:rider_app/com/rider/allScreens/mainScreen.dart';
import 'package:rider_app/main.dart';

class RegisterationScreen extends StatelessWidget {
  // const RegisterationScreen({Key? key}) : super(key: key);

  static const String idScreen = "register";

  TextEditingController nameTextEditingController = new TextEditingController();
  TextEditingController emailTextEditingController = new TextEditingController();
  TextEditingController phoneTextEditingController = new TextEditingController();
  TextEditingController passwordTextEditingController = new TextEditingController();
  TextEditingController confirmPasswordTextEditingController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Form(
        child: SingleChildScrollView(
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
                  "Register as Cartel Rider",
                  style: TextStyle(fontSize: 24.0, fontFamily: "Brand-SemiBold"),
                  textAlign: TextAlign.center,

                ),
                Padding(padding: EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      SizedBox(height: 1.0,),
                      TextFormField(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter some text';
                          }
                          if (value.length < 3) {
                            return 'Must be more than 2 charater';
                          }
                        },
                        controller: nameTextEditingController,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                            labelText: "Name",
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
                      TextFormField(
                        validator: (value) => EmailValidator.validate(value) ? null : "Please enter a valid email",
                        controller: emailTextEditingController,
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
                      TextFormField(
                        controller: phoneTextEditingController,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                            labelText: "Phone",
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
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter some text';
                          }
                          if (value.length < 8) {
                            return 'Must be more than 8 charater';
                          }
                        },
                        controller: passwordTextEditingController,
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
                      SizedBox(height: 1.0,),
                      TextFormField(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter some text';
                          }
                          if (value.length < 8) {
                            return 'Must be more than 8 charater';
                          }
                          if(passwordTextEditingController.text != value) {
                            return 'Password & confirm password are not same.';
                          }
                        },
                        obscureText: true,
                        decoration: InputDecoration(
                            labelText: "Confirm Password",
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
                          registerNewUser(context);
                        },
                        child: Container(
                          height: 50,
                          child: Center(
                            child: Text(
                              "Register",
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
                      Navigator.pushNamedAndRemoveUntil(context, LoginScreen.idScreen, (route) => false);
                    },
                    child: Text(
                      "Already have an account, please login!",
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

  void registerNewUser(BuildContext context) async {
    final User user = (
        await firebaseAuth.createUserWithEmailAndPassword(
          email: emailTextEditingController.text,
          password: passwordTextEditingController.text)
        .catchError((errMsg) {
          displayAlert("Error: "+errMsg);
        })
    ).user!;

    if(user != null) {



      Map userDataMap = {
        "name": nameTextEditingController.text.trim(),
        "email": emailTextEditingController.text.trim(),
        "phone": phoneTextEditingController.text.trim(),
      };

      databaseReference.child(user.uid).set(userDataMap);

      displayAlert("Congratulations, account is created.");

      Navigator.pushNamedAndRemoveUntil(context, MainScreen.idScreen, (route) => false);

    } else {
      displayAlert("Error creating user.");
    }
  }

  void displayAlert(final String text) {
    Fluttertoast.showToast(msg: text);
  }
}