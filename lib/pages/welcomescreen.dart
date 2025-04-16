import 'package:flutter/material.dart';
import 'package:refresher/pages/settings.dart';
import 'package:refresher/pages/signin.dart';
import 'package:refresher/pages/signup.dart';
import 'package:refresher/widgets/customscafold.dart';
import 'package:refresher/widgets/welcomebutton.dart';
class customscafold extends StatelessWidget {
  const customscafold({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenlength = MediaQuery.of(context).size. height;
    return  CustomScaffold(
      child:   Column(
    children: [
    Flexible(
    flex: 8,
        child: Container(
          padding: const EdgeInsets.symmetric(
            vertical: 0,
            horizontal: 40.0,
          ),
          child: Center(
            child: RichText(
              textAlign: TextAlign.center,
              text: const TextSpan(
                children: [
                  TextSpan(
                      text: 'Welcome Back!\n',
                      style: TextStyle(
                        fontSize: 45.0,
                        fontWeight: FontWeight.w600,
                      )),
                  TextSpan(
                      text:
                      '\nEnter personal details to your account',
                      style: TextStyle(
                        fontSize: 20,
                        // height: 0,
                      ))
                ],
              ),
            ),
          ),
        )
    ),
    Flexible(
    flex: 1,
    child: Align(
    alignment: Alignment.bottomLeft,
    child: Row(
    children: [
     Expanded(
    child: WelcomeButton(
      buttonText: 'Sign in',
      onTap: SignInScreen(),
      color: Colors.black,
      textColor: Colors.white,
    )
    ),
    Expanded(
    child: WelcomeButton(
    buttonText: 'Sign up',
    onTap: SignUpScreen(),
    color: Colors.white,
    textColor: Colors.amber,
    ),
    ),
    ],
    ),
    ),
    ),
    ],
    ),
    );
  }
}
