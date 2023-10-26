// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_app/blocs/sign_in_bloc/sign_in_bloc_bloc.dart';
import 'package:my_app/screens/auth/signInPage_calibrationFindFriends.dart';
import 'signInPage_calibrationBefore.dart';

class SettingPage extends StatelessWidget {
  SettingPage({Key? key}) : super(key: key);

  final ButtonStyle customButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: Color(0xFF114817),
    minimumSize: Size(200, 50),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(5),
        bottomLeft: Radius.circular(35),
        topRight: Radius.circular(35),
        bottomRight: Radius.circular(5),
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        toolbarHeight: 80,
        backgroundColor: Color(0xfff9e8cb),
        elevation: 0,
        titleSpacing: -30,
        centerTitle: true,
        title: Icon(
          Icons.settings_outlined,
          color: Color(0xFFCF9A40),
          size: 36,
        ),
        leadingWidth: 120,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Color(0xFFCF9A40), size: 24),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        actions: [
          Icon(
            Icons.search,
            color: Color(0xFFCF9A40),
            size: 30,
          ),
          Padding(
            padding: EdgeInsets.only(right: 40),
          ),
        ],
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
          color: Color(0xffF7F2E3),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 80,
              ),
              Stack(
                children: [
                  Image.network('assets/images/bgImageTop_settingPage.png'),
                  Positioned(
                    bottom: 30,
                    right: 0,
                    left: 0,
                    child: FractionallySizedBox(
                      widthFactor: 0.5, // Set the width to 50%
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) =>
                                  SignInPage_calibrationBefore(),
                            ),
                          );
                        },
                        child: Text('LOG OUT'),
                        style: customButtonStyle,
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 20,
              ),
              IconButton(
                onPressed: () {
                  context.read<SignInBloc>().add(const SignOutRequired());
                },
                icon: Icon(Icons.login, color: Color(0xFFF7F2E3), size: 30),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Image.network(
                    'assets/images/bgImageBottom_settingPage.png'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
