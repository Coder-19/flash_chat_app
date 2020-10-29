import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flash_chat/reusable_component_widgets/reusable_rounded_button.dart';
import 'package:flash_chat/screens/login_screen.dart';
import 'package:flash_chat/screens/registration_screen.dart';
import 'package:flutter/material.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  // creating a variable named controller of AnimationController
  AnimationController controller; // this will help us to create different types
  // of custom animation

  // creating a new variable here called animation of type Animation
  Animation
      animation; // this will help us in creating different types of animation
  // like curved animation etc

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      duration: Duration(
        seconds: 1,
      ),
      // using the vsync property to assign a ticker for the animation which in most
      // of the cases is the current widget state object
      vsync: this, // here this refers to the current class state object meaning
      // that our current class  will act as a ticker for
      // the animation to occur
    );

    animation = ColorTween(
      begin: Colors.blueGrey,
      end: Colors.white,
    ).animate(controller);

    controller.forward();

    controller.addListener(
      () {
        setState(() {});
      },
    );
  }

  @override
  void dispose() {
    super.dispose();

    // disposing of the controller by using the dispose() method (provided by the
    // controller) when our app closes
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: animation.value,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              children: <Widget>[
                Hero(
                  tag: 'logo_image',
                  child: Container(
                    child: Image.asset('images/logo.png'),
                    height: 60.0,
                  ),
                ),
                TypewriterAnimatedTextKit(
                  speed: Duration(
                    seconds: 1,
                  ),
                  text: [
                    'Flash Chat',
                  ],
                  textStyle: TextStyle(
                    fontSize: 45.0,
                    fontWeight: FontWeight.w900,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 48.0,
            ),
            ReusableRoundedButton(
              buttonColor: Colors.lightBlueAccent,
              onPressedFunctionality: () {
                Navigator.pushNamed(context, LoginScreen.loginScreenId);
              },
              displayTextOnButton: 'Log In',
            ),
            ReusableRoundedButton(
              buttonColor: Colors.blueAccent,
              onPressedFunctionality: () {
                Navigator.pushNamed(
                    context, RegistrationScreen.registrationScreenId);
              },
              displayTextOnButton: 'Register',
            ),
          ],
        ),
      ),
    );
  }
}
