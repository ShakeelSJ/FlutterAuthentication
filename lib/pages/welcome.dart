import 'package:auth/domain/user.dart';
import 'package:auth/providers/user_provider.dart';
import 'package:flutter/material.dart'; 
import 'package:provider/provider.dart';

class Welcome extends StatelessWidget {
  final ResponseSignupModel? responseSignupModel;

  Welcome({Key? key, @required this.responseSignupModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Provider.of<UserProvider>(context).setUser(responseSignupModel!);

    return Scaffold(
      body: Container(
        child: Center(
          child: Text("WELCOME PAGE"),
        ),
      ),
    );
  }
}
