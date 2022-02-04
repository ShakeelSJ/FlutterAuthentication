import 'package:auth/domain/user.dart';
import 'package:auth/providers/user_provider.dart';
import 'package:flutter/material.dart'; 
import 'package:provider/provider.dart';

class DashBoard extends StatefulWidget {
  @override
  _DashBoardState createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  @override
  Widget build(BuildContext context) {
    ResponseSignupModel responseSignupModel =
        Provider.of<UserProvider>(context).user;

    return Scaffold(
      appBar: AppBar(
        title: Text("DASHBOARD PAGE"),
        elevation: 0.1,
      ),
      body: Column(
        children: [
          SizedBox(
            height: 100,
          ),
          Center(
            child: Text(responseSignupModel.user!.userEmail!),
          ),
          SizedBox(height: 100),
          RaisedButton(
            onPressed: () {},
            child: Text("Logout"),
            color: Colors.lightBlueAccent,
          )
        ],
      ),
    );
  }
}
