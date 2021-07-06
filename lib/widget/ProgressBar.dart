import 'package:flutter/material.dart';

class ProgressBar extends StatelessWidget {
  String message;

  ProgressBar(this.message);

  // const ProgressBar({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.yellow,
      child: Container(
        margin: EdgeInsets.all(15.0),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6.0)
        ),
        child: Padding(
          padding: EdgeInsets.all(15.0),
          child: Row(
            children: [
              SizedBox(width: 6.0,),
              CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.black),),
              SizedBox(width: 26.0,),
              Text(
                message,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 12.0
                ),

              )
            ],
          ),
        ),
      ),
    );
  }
}
