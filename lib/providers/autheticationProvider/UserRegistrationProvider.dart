import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../../Handlers/api.dart';
import '../../Helper/helper.dart';

import '../../Utils/Preferences.dart';
import '../../Utils/colors.dart';
import '../../auth/login.dart';

class AuthProvider with ChangeNotifier {
  bool isRegisterLoading = false;
  bool isRegisterSuccess = false;

  registerPost(data, url, context) async {
    print(data);
    print(url);
    print(isRegisterLoading);
    isRegisterLoading = true;
    notifyListeners();

    print(isRegisterLoading);
    final Uri uri = Uri.parse(API.register + url);
    final response = await http.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode(data),
    );
    print(uri);
    print(response.body);

    var body = json.decode(response.body);
    Preferences.setUserId(body['id']);

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await Preferences.setUserId(body['id']);
    print('User ID set: ${body['id']}');
    prefs.setString('idUser', body['id']);
    print(body['id']);
    print("body of login and register ${body}");
    if (response.statusCode == 201 && body["st"] == "Success") {

      print(isRegisterLoading);
      isRegisterLoading = false;
      print(isRegisterLoading);
      notifyListeners();

      if (body['st'] == "Success") {
        isRegisterSuccess = true;

      }
      //
      // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      //   content: Text(body['msg']),
      // ));
      notifyListeners();
    } else {
      print(isRegisterLoading);
      isRegisterLoading = false;
      isRegisterSuccess = false;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(body['msg']),
      ));
      // Navigator.pop(context);
      notifyListeners();
    }
  }

  bool isLoginLoading = false;
  bool isLoginSuccess = false;

  loginPost(data, url, context) async {
    print(data);
    print(url);

    isLoginLoading = true;
    notifyListeners();
    // final response = await http.post(Uri.parse(API.register+${url}));

    final Uri uri = Uri.parse(API.login + url);
    final response = await http.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode(data),
    );
    print(uri);
    print(response.body);

    print('come to here${response.body}');

    print("body of login  ${response.statusCode}");
    if (response.statusCode == 200) {
      var body = json.decode(response.body);

      // SharedPreferences prefs = await SharedPreferences.getInstance();
      await Preferences.setUserId(body['id']);
      // Preferences.setUserId(body['id']);

      print('come to here${body['id']}');
      if (body["st"] == "Success") {
        print('come to here${body}');

        isLoginLoading = false;
        isLoginSuccess = true;
        notifyListeners();
        print("its true");

        print("body of token  ${body['token']}");
        print("body of token  ${body['msg']}");

        // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        //   content: Text(body['msg']),
        // ));

        print("user login or login response-${body['msg']}");

        notifyListeners();

        return body;
      }
    } else {
      isLoginLoading = false;
      isLoginSuccess = false;
      print("come to here");
      // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      //   content: Text("Incorrect Password"),
      // ));
      // Navigator.pop(context);
      print("Login  or Login Post Api Error !!");
      notifyListeners();
    }
  }


  bool isgetLoading = false;
  bool isgetSuccess = false;
  getUserById(String userId, context) async {
    var userIdutils;
    String? userId = await Preferences.getUserId();
    print('User ID retrieved: $userId');
    // userIdutils = Preferences.getUserId();
    print(userIdutils);
    print(isgetLoading);
    isgetLoading = true;
    // notifyListeners();

    final Uri uri = Uri.parse(API.idgetDetails +"users/"+ userId.toString()); // Assuming getUserById endpoint
 print("urii ${uri}");
    final response = await http.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
        // Add any additional headers if required
      },
    );
    print(uri);
    print(response.body);

    var body = json.decode(response.body);
    print("body of get user by ID: $body");
    if (response.statusCode == 200 && body["st"] == "Success") {
      isgetLoading = false;
      notifyListeners();

      if (body['st'] == "Success") {
      return body['user'];
        // Handle the user data as needed
      }
      // You may want to notify listeners or update state with user data here
    } else {
      isgetLoading = false;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(body['msg']),
      ));
      notifyListeners();
    }
  }


}
