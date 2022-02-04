import 'package:auth/domain/user.dart';
import 'package:auth/providers/auth.dart';
import 'package:auth/providers/user_provider.dart';
import 'package:auth/util/widgets.dart'; 
import 'package:flutter/material.dart'; 
import 'package:provider/provider.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final formKey = new GlobalKey<FormState>();

  String? _username, _password, _confirmPassword;

  @override
  Widget build(BuildContext context) {
    AuthProvider auth = Provider.of<AuthProvider>(context);

    final usernameField = TextFormField(
      autofocus: false,
      validator: (value) {
        if (value!.isEmpty) {
          return "Please enter Email";
        }
        if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]").hasMatch(value)) {
          return 'Please a valid Email';
        }
        return null;
      },
      onSaved: (value) => _username = value,
      decoration: buildInputDecoration("Confirm password", Icons.email),
    );

    final passwordField = TextFormField(
      autofocus: false,
      obscureText: true,
      validator: (value) => value!.isEmpty ? "Please enter password" : null,
      onSaved: (value) => _password = value,
      decoration: buildInputDecoration("Confirm password", Icons.lock),
    );

    final confirmPassword = TextFormField(
      autofocus: false,
      validator: (value) => value!.isEmpty ? "Your password is required" : null,
      onSaved: (value) => _confirmPassword = value,
      obscureText: true,
      decoration: buildInputDecoration("Confirm password", Icons.lock),
    );

    var loading = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        const CircularProgressIndicator(),
        const Text("Registering ... Please wait")
      ],
    );

    // ignore: prefer_function_declarations_over_variables
    var doRegister = () {
      final form = formKey.currentState;
      if (form!.validate()) {
        form.save();
        // ignore: unused_local_variable
        final successfulMessage = auth.register(
          _username!,
          _password!,
        )
         as Future<Map<String, dynamic>>;

        successfulMessage.then((response) {
          if (response['status']) {
            ResponseSignupModel responseSignupModel = response['data'];
            Provider.of<UserProvider>(context, listen: false)
                .setUser(responseSignupModel);
            Navigator.pushReplacementNamed(context, '/dashboard');
          } else {
            AlertDialog(
              title: Container(
                color: Colors.white,
                padding: const EdgeInsets.all(4),
                child: Text(
                  "Registration Failed" + response.toString(),
                ),
              ),
            );
          }
        });
      }
      // if (form!.validate()) {
      //   form.save();
      //   auth.register(_username!, _password!, ).then((response) {
      //     if (response!['userStatus']) {
      //      ResponseSignupModel responseSignupModel = response!['data'];
      //       Provider.of<UserProvider>(context, listen: false).setUser(responseSignupModel);
      //       Navigator.pushReplacementNamed(context, '/dashboard');
      //     } else {
      //       Flushbar(
      //         title: "Registration Failed",
      //         message: response.toString(),
      //         duration: Duration(seconds: 10),
      //       ).show(context);
      //     }
      //   });
      // }
      else {
        // Flushbar(
        //   title: "Invalid form",
        //   message: "Please Complete the form properly",
        //   duration: Duration(seconds: 10),
        // ).show(context);
      }
    };

    return SafeArea(
      child: Scaffold(
        body: Container(
          padding: const EdgeInsets.all(40.0),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 15.0),
                label("Email"),
                const SizedBox(height: 5.0),
                usernameField,
                const SizedBox(height: 15.0),
                label("Password"),
                const SizedBox(height: 10.0),
                passwordField,
                const SizedBox(height: 15.0),
                label("Confirm Password"),
                const SizedBox(height: 10.0),
                confirmPassword,
                const SizedBox(height: 20.0),
                auth.loggedInStatus == Status.Authenticating
                    ? loading
                    : longButtons("Login", doRegister),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
