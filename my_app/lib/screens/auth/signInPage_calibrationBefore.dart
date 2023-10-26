import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_app/blocs/sign_in_bloc/sign_in_bloc_bloc.dart';
import 'package:my_app/screens/auth/SecondScreen.dart';
import 'package:my_app/screens/auth/sign_in_screen.dart';
import 'signInPage_calibrationFindFriends.dart';

class SignInPage_calibrationBefore extends StatelessWidget {
  const SignInPage_calibrationBefore({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        toolbarHeight: 80,
        backgroundColor: Colors.transparent,
        elevation: 0,
        titleSpacing: -30,
        // title: Text(
        //   "Sign In",
        //   style: TextStyle(
        //     color: Color(0xFFF7F2E3),
        //     fontSize: 26,
        //   ),
        // ),
        // leadingWidth: 120,
        // leading: IconButton(
        //   icon: Icon(Icons.arrow_back_ios, color: Color(0xFFF7F2E3), size: 24),
        //   onPressed: () {

        //   },
        // ),
        actions: [
          Padding(
            padding: EdgeInsets.only(
                right: 28), // เพิ่มช่องว่าง 16 พิกเซลหลังจาก IconButton
            child: IconButton(
                onPressed: () {
                  context.read<SignInBloc>().add(const SignOutRequired());
                  
                },
                icon: Icon(Icons.login, color: Color(0xFFF7F2E3), size: 30)),
          ),
        ],
      ),
      // appBar: AppBar(

      // 	actions: [ //ปุ่มออกปกติ
      // 		IconButton(
      // 			onPressed: () {
      // 				context.read<SignInBloc>().add(const SignOutRequired());
      // 			},
      // 			icon: Icon(Icons.login)
      // 		)
      // 	],
      // ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.fill,
            image: NetworkImage('assets/images/bgImage_calibrationBefore.png'),
          ),
        ),
        child: Column(
          children: [
            SizedBox(
              height: 80,
            ),
            // const Divider(
            //   color: Color(0xFFF7F2E3),
            //   height: 25,
            //   thickness: 1,
            //   indent: 40,
            //   endIndent: 40,
            // ),

            Column(
              children: [
                Text(
                  "Calibration".toUpperCase(),
                  style: TextStyle(
                    fontSize: 36,
                    color: Color(0xFFF7F2E3),
                  ),
                ),
                SizedBox(
                  height: 4,
                ),
                Text(
                  "of Heart rate wearable".toUpperCase(),
                  style: TextStyle(
                    fontSize: 24,
                    color: Color(0xFFF7F2E3),
                  ),
                ),
                SizedBox(
                  height: 40,
                ),
                Text(
                  "This will only take a Minute".toUpperCase(),
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFFF7F2E3),
                    fontStyle: FontStyle.italic,
                  ),
                ),
                SizedBox(
                  height: 70,
                ),
                IconButton(
                  // Adjust the scale factor as needed
                  icon: Image(
                    image: NetworkImage(
                        'assets/images/buttonStart_calibrationBefore.png'),
                  ),
                  iconSize: 150,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              SecondScreen()),
                    );
                  },
                ),
                SizedBox(
                  height: 50,
                ),
                Image(
                  image:
                      NetworkImage('assets/images/image_calibrationBefore.png'),
                ),
                SizedBox(
                  height: 40,
                ),
                RichText(
                  text: TextSpan(
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFFF7F2E3),
                      fontFamily: 'Montserrat',
                    ),
                    children: [
                      TextSpan(
                        text: "Don't have a ",
                      ),
                      TextSpan(
                        text: 'HEARTWARE?',
                        style: TextStyle(
                          decoration: TextDecoration.underline,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) =>
                                    SignInPage_calibrationFindFriends(),
                              ),
                            );
                          },
                      ),
                    ],
                  ),
                )
              ],
            ),
            SizedBox(
              height: 30,
            ),
          ],
        ),
      ),
    );
  }
}
