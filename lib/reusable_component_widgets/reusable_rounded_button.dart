import 'package:flutter/material.dart';

// the widget below contains the code for the Login button , Register
// button used in the app
class ReusableRoundedButton extends StatelessWidget {
  // creating a property named buttonColor for the color of the button
  final Color buttonColor;
  // creating a new property here named onPressedFunctionality for giving the
  // button some functionality
  final Function onPressedFunctionality;
  // creating a new property here for displaying the text on the button
  final String displayTextOnButton;

  ReusableRoundedButton({
    this.buttonColor,
    @required this.onPressedFunctionality,
    this.displayTextOnButton,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Material(
        elevation: 5.0,
        color: buttonColor,
        borderRadius: BorderRadius.circular(30.0),
        child: MaterialButton(
          onPressed: onPressedFunctionality,
          minWidth: 200.0,
          height: 42.0,
          child: Text(
            displayTextOnButton,
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
