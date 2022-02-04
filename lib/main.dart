import 'package:auth/pages/dashboard.dart';
import 'package:auth/pages/login.dart';
import 'package:auth/pages/register.dart';
import 'package:auth/pages/welcome.dart';
import 'package:auth/providers/auth.dart';
import 'package:auth/providers/user_provider.dart';
import 'package:auth/util/shared_preference.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; 
import 'domain/user.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Future<ResponseSignupModel> getUserData() => UserPreferences().getUser();

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            primarySwatch: Colors.blue,
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          home: FutureBuilder<ResponseSignupModel>(
              future: getUserData(),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                  case ConnectionState.waiting:
                    return CircularProgressIndicator();
                  default:
                    if (snapshot.hasError)
                      return Text('Error: ${snapshot.error}');
                    else if (snapshot.data!.jwt == null)
                      return Login();
                    else
                      UserPreferences().removeUser();
                    return Welcome(
                      responseSignupModel: snapshot.data,
                    );
                }
              }),
          routes: {
            '/dashboard': (context) => DashBoard(),
            '/login': (context) => Login(),
            '/register': (context) => Register(),
          }),
    );
  }
}
