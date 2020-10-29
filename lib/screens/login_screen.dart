import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat/constants.dart';
import 'package:flash_chat/reusable_component_widgets/reusable_rounded_button.dart';
import 'package:flash_chat/screens/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class LoginScreen extends StatefulWidget {
  static const loginScreenId = '/LoginScreen';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // the property created below is used to store the email that the
  // user has entered in the text field widget
  String userEmail;
  // the property created below is used to store the password that
  // the user has entered in the text field widget
  String userPassword;

  // creating an object of FirebaseAuth class to help the user to
  // authenticate and login into the chat app
  final FirebaseAuth _auth = FirebaseAuth.instance;
  // creating a new property of type bool to show the
  // spinner wheel when the user is trying to login and navigate to the chat
  // screen
  bool showSpinner = false; // since the spinner will not spin initially that
  // is when the login screen loads up so making the value of showSpinner as false

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: ModalProgressHUD(
          inAsyncCall: showSpinner,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Flexible(
                  child: Hero(
                    tag: 'logo_image',
                    child: Container(
                      height: 200.0,
                      child: Image.asset('images/logo.png'),
                    ),
                  ),
                ),
                SizedBox(
                  height: 48.0,
                ),
                TextField(
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.emailAddress,
                  onChanged: (value) {
                    userEmail = value;
                  },
                  decoration: kTextFieldDecoration.copyWith(
                    hintText: 'Enter your email',
                  ),
                ),
                SizedBox(
                  height: 8.0,
                ),
                TextField(
                  textAlign: TextAlign.center,
                  obscureText: true,
                  onChanged: (value) {
                    userPassword = value;
                  },
                  decoration: kTextFieldDecoration.copyWith(
                    hintText: 'Enter your password',
                  ),
                ),
                SizedBox(
                  height: 24.0,
                ),
                ReusableRoundedButton(
                  displayTextOnButton: 'Log In',
                  buttonColor: Colors.lightBlueAccent,
                  onPressedFunctionality: () async {
                    setState(() {
                      showSpinner = true;
                    });

                    try {
                      UserCredential loggedInUser =
                          await _auth.signInWithEmailAndPassword(
                        email: userEmail,
                        password: userPassword,
                      );

                      if (loggedInUser != null) {
                        // navigating the user to the chat screen
                        Navigator.pushNamed(
                          context,
                          ChatScreen.chatScreenId,
                        );
                      }

                      setState(() {
                        showSpinner = false;
                      });
                    } catch (e) {
                      print('The error is: $e');
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
