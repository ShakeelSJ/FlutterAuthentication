import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:auth/domain/user.dart';
import 'package:auth/util/shared_preference.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart'; 

enum Status {
  NotLoggedIn,
  NotRegistered,
  LoggedIn,
  Registered,
  Authenticating,
  Registering,
  LoggedOut
}

class AuthProvider with ChangeNotifier {
  Status _loggedInStatus = Status.NotLoggedIn;
  Status _registeredInStatus = Status.NotRegistered;

  Status get loggedInStatus => _loggedInStatus;
  Status get registeredInStatus => _registeredInStatus;

  Future<Map<String, dynamic>> login(String email, String password) async {
    var result;

    final Map<String, dynamic> loginData = {
      'user': {'email': email, 'password': password}
    };

    _loggedInStatus = Status.Authenticating;
    notifyListeners();

    Response response = await post(
      Uri.parse(
          "https://wordpress-333031-2322349.cloudwaysapps.com/?rest_route=/simple-jwt-login/v1/auth"),
      body: json.encode(loginData),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);

      var userData = responseData['data'];

      ResponseSignupModel authUser = ResponseSignupModel.fromJson(userData);

      UserPreferences().saveUser(authUser);

      _loggedInStatus = Status.LoggedIn;
      notifyListeners();

      result = {'status': true, 'message': 'Successful', 'user': authUser};
    } else {
      _loggedInStatus = Status.NotLoggedIn;
      notifyListeners();
      result = {
        'status': false,
        'message': json.decode(response.body)['error']
      };
    }
    print(result);
    return result;
  }

  Future<FutureOr> register(
    String? email,
    String? password,
  ) async {
    final Map<String, dynamic> registrationData = {
      'user': {
        'email': email,
        'password': password,
      }
    };
    return await post(
        Uri.parse(
            "https://wordpress-333031-2322349.cloudwaysapps.com/?rest_route=/simple-jwt-login/v1/users&email=NEW_USER_EMAIL&password=NEW_USER_PASSWORD"),
        body: json.encode(registrationData),
        headers: {
          'Content-Type': 'application/json'
        }).then(onValue).catchError(onError);
  }

  static Future<FutureOr> onValue(Response response) async {
    var result;
    final Map<String, dynamic>? responseData = json.decode(response.body);

    print(response.statusCode);
    if (response.statusCode == 200) {

      var userData = responseData!['data'];

      ResponseSignupModel? authUser = ResponseSignupModel.fromJson(userData);

      UserPreferences().saveUser(authUser);
      result = {
        'status': true,
        'message': 'Successfully registered',
        'data': authUser
      };
    } else {
//      if (response.statusCode == 401) Get.toNamed("/login");
      result = {
        'status': false,
        'message': 'Registration failed',
        'data': responseData
      };
    }
print(result);
    return result;
  }

  static onError(error) {
    print("the error is $error.detail");
    return {'status': false, 'message': 'Unsuccessful Request', 'data': error};
  }
}
