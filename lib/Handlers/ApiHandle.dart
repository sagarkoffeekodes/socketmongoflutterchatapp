import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

import '../Helper/helper.dart';

class ApiHandler {
  static Future<dynamic> post(
      BuildContext context, MultipartRequest request) async {

    Map<String, String> headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
    };

    // _setHeadersPost() => {
    //         'Content-type': 'application/json',
    //         'Accept': 'application/json'
    //   };

    // var baseUrl = Uri.http(Utils.url, '/apis/$url');

    request.headers.addAll(headers);
    return request.send();
    // print(baseUrl);
    // http.Response response = await http.post(
    //     baseUrl,
    //     headers: _setHeadersPost(),
    //     body: jsonEncode(body)
    // );
    //
    // print("response ---> ${response.body}");
    // return response;
  }

  // static Future<dynamic> refreshToken(BuildContext context) async {
  //   print("refreshToken called 1");
  //
  //   AuthProvider authProvider =
  //       Provider.of<AuthProvider>(context, listen: false);
  //
  //   authProvider.changeValueExpire(true);
  //
  //   print("authProvider.ischeckExpire ${authProvider.ischeckExpire}");
  //
  //   final uri = '${Utils.fullUrl}uTR';
  //
  //   MultipartRequest request = http.MultipartRequest('POST', Uri.parse(uri));
  //
  //   Map<String, String> headers = {
  //     'Content-type': 'application/json',
  //     'Accept': 'application/json',
  //   };
  //   request.headers.addAll(headers);
  //
  //   request.fields['refresh_token'] = Utils.refreshToken;
  //
  //   var response = await request.send();
  //
  //   final respStr = await response.stream.bytesToString();
  //   var body = json.decode(respStr);
  //   print(
  //       "new access token => $body ${response.statusCode}  ${body["new_access_token"]}");
  //
  //   SharedPreferences preferences = await SharedPreferences.getInstance();
  //
  //   if (body["new_access_token"] == "") {
  //     print("goes to  ");
  //     preferences.clear();
  //
  //     Navigator.of(context).pushAndRemoveUntil(
  //       MaterialPageRoute(
  //         builder: (context) {
  //           return const LoginScreen();
  //         },
  //       ),
  //       (route) => false,
  //     );
  //   } else {
  //     await preferences.setString("accessToken", body['new_access_token']);
  //
  //     Utils.headers = {
  //       'Content-type': 'application/json',
  //       'Accept': 'application/json',
  //       'Authorization': "Bearer ${preferences.getString("accessToken")}"
  //     };
  //
  //     Utils.userId = "${preferences.getInt("userId")}";
  //     Utils.refreshToken = "${preferences.getString("refreshToken")}";
  //     Utils.acceessToken = "${preferences.getString("accessToken")}";
  //     Utils.expireInToken = "${preferences.getString("expiresInToken")}";
  //
  //     Navigator.of(context).pushAndRemoveUntil(
  //       MaterialPageRoute(
  //         builder: (context) {
  //           return const SplashScreen();
  //         },
  //       ),
  //       (route) => false,
  //     );
  //   }
  //
  //   // Provider.of<AuthProvider>(context,listen: false).ischeckExpire = false;
  // }
}
