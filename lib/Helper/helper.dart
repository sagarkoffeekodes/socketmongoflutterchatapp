
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';


import '../Utils/colors.dart';

// show toast with messages and loading toast


class Helper {
  static final Helper dialogCall = Helper._();

  Helper._();

  showAlertDialog(BuildContext context){
    AlertDialog alert=AlertDialog(
      backgroundColor: ApplicationColors.blackbackcolor,
      content: Row(
        children: [
          const CircularProgressIndicator(
            backgroundColor: Colors.white,
            valueColor: AlwaysStoppedAnimation<Color>(ApplicationColors.yellowColorD21),
          ),
          Container(
              margin: const EdgeInsets.only(left: 5),
              child: Padding(
                padding: EdgeInsets.only(left: 10.0),
                child: Text(
                  "loading",
                  // " Loading ...",
                  style: TextStyle(
                    fontSize: 18,
                    color: ApplicationColors.whiteColor,
                  ),
                ),
              )
          ),
        ],
      ),
    );
    showDialog(barrierDismissible: false,
      context:context,
      builder:(BuildContext context){
        return alert;
      },
    );
  }



  showLoader(){
    return SpinKitThreeBounce(
      color: ApplicationColors.yellowColorD21,
      size: 25,
    );
  }


}