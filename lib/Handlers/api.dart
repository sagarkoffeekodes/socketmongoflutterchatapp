import 'dart:io';

import '../Utils/Preferences.dart';


class API {

  static const apiKey = "base64:9wMwQDEBjAK5OVvehRlQhF5PE1dNk6xK3RRIUkcDyGA=";
  static const baseUrl = "https://chatapp1-d12f.onrender.com/"; // live

  static Map<String, String> authheader = {
    HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
    'apikey': apiKey,
  };
  static Map<String, String> header = {
    // HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
    // 'apikey': apiKey,
    'Authorization': "Bearer ${Preferences.getString(Preferences.accesstoken)}"
  };


  static const login = "${baseUrl}api/auth/";
  static const register = "${baseUrl}api/auth/";

}
