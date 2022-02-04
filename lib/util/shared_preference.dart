 
import 'package:auth/domain/user.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

class UserPreferences {
  Future<bool> saveUser(ResponseSignupModel responseSignupModel) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setInt("id", responseSignupModel.id!);
    prefs.setString("email", responseSignupModel.user!.userEmail!);
    prefs.setString("jwt", responseSignupModel.jwt!);

    print("object prefere jwt");
    print(responseSignupModel.jwt);

    // ignore: deprecated_member_use
    return prefs.commit();
  }

  Future<ResponseSignupModel> getUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    int? id = prefs.getInt("id");
    String? email = prefs.getString("email");
    String? jwt = prefs.getString("jwt");
    // String renewalToken = prefs.getString("renewalToken");

    return ResponseSignupModel(
      id: id,
      jwt: jwt,
    );
  }

  void removeUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    // prefs.remove("name");
    prefs.remove("email");
    // prefs.remove("phone");
    // prefs.remove("");
    prefs.remove("jwt");
  }

  Future<String> getToken(args) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? jwt = prefs.getString("jwt");
    return jwt!;
  }
}
