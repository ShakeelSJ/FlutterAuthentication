import 'package:auth/domain/user.dart';
import 'package:flutter/foundation.dart';

class UserProvider with ChangeNotifier {
  ResponseSignupModel _responseSignupModel = new ResponseSignupModel();

  ResponseSignupModel get user => _responseSignupModel;

  void setUser(ResponseSignupModel responseSignupModel) {
    _responseSignupModel = responseSignupModel;
    notifyListeners();
  }
}
