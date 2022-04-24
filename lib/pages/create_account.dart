import 'package:flutter/material.dart';
import 'package:flutter_social_app/constants.dart';
import 'package:flutter_social_app/widgets/header.dart';
import 'package:flutter_social_app/widgets/rounded_button.dart';
import 'dart:async';

class CreateAccount extends StatefulWidget {
  @override
  _CreateAccountState createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  String username;
  submit() {
    if (_formKey.currentState.validate()) {
      SnackBar snackbar = SnackBar(
        content: Text("Welcome $username"),
      );
      _scaffoldKey.currentState.showSnackBar(snackbar);
      Timer(
        Duration(seconds: 2),
        () {
          Navigator.pop(context, username);
        },
      );
    }

    // Navigator.pop(context);
  }

  @override
  Widget build(BuildContext parentContext) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: header(context,
          titleText: 'Set up your profile', removeBackButton: true),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              'Create a Username',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 16,
            ),
            Form(
              key: _formKey,
              child: TextFormField(
                validator: (val) {
                  if (val.trim().length < 3 || val.isEmpty) {
                    return "Username too short";
                  } else if (val.trim().length > 12) {
                    return "Username too long";
                  } else
                    return null;
                },
                autovalidate: true,
                onChanged: (val) => username = val,
                onSaved: (val) => username = val,
                decoration: kInputDecoration.copyWith(hintText: 'Username'),
              ),
            ),
            RoundedButton(
              color: Theme.of(context).primaryColor,
              title: 'Next',
              textColor: Colors.white,
              onPressed: submit,
            ),
          ],
        ),
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:flutter_social_app/widgets/header.dart';
//
// class CreateAccount extends StatefulWidget {
//   @override
//   _CreateAccountState createState() => _CreateAccountState();
// }
//
// class _CreateAccountState extends State<CreateAccount> {
//   final _formKey = GlobalKey<FormState>();
//   String username;
//
//   submit() {
//     _formKey.currentState.save();
//     Navigator.pop(context, username);
//   }
//
//   @override
//   Widget build(BuildContext parentContext) {
//     return Scaffold(
//       appBar: header(context, titleText: "Set up your profile"),
//       body: ListView(
//         children: <Widget>[
//           Container(
//             child: Column(
//               children: <Widget>[
//                 Padding(
//                   padding: EdgeInsets.only(top: 25.0),
//                   child: Center(
//                     child: Text(
//                       "Create a username",
//                       style: TextStyle(fontSize: 25.0),
//                     ),
//                   ),
//                 ),
//                 Padding(
//                   padding: EdgeInsets.all(16.0),
//                   child: Container(
//                     child: Form(
//                       key: _formKey,
//                       child: TextFormField(
//                         onSaved: (val) => username = val,
//                         decoration: InputDecoration(
//                           border: OutlineInputBorder(),
//                           labelText: "Username",
//                           labelStyle: TextStyle(fontSize: 15.0),
//                           hintText: "Must be at least 3 characters",
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//                 GestureDetector(
//                   onTap: submit,
//                   child: Container(
//                     height: 50.0,
//                     width: 350.0,
//                     decoration: BoxDecoration(
//                       color: Colors.blue,
//                       borderRadius: BorderRadius.circular(7.0),
//                     ),
//                     child: Center(
//                       child: Text(
//                         "Submit",
//                         style: TextStyle(
//                             color: Colors.white,
//                             fontSize: 15.0,
//                             fontWeight: FontWeight.bold),
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }
