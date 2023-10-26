import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_app/screens/auth/sign_in_screen.dart';
import 'package:my_app/screens/auth/sign_up_screen.dart';

import '../../blocs/authentication_bloc/authentication_bloc_bloc.dart';
import '../../blocs/sign_in_bloc/sign_in_bloc_bloc.dart';
import '../../blocs/sign_up_bloc/sign_up_bloc_bloc.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with TickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    tabController = TabController(initialIndex: 0, length: 2, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(0, 255, 255, 255),
      body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: [
              
              Stack(
                children: [
                  // Background image with opacity
                  // Opacity(
                  //   opacity: 0.1, // Adjust the opacity as needed
                  //   child: Image.network(
                  //     'assets/images/background-image_login2.jpg', // Replace with your image path
                  //     width: double.infinity,
                  //     height: double.infinity,
                  //     fit: BoxFit.contain,
                  //   ),
                  // ),
                  // Center(
                  //   child: Container(
                  //     height: 460.0, // Set the desired height
                  //     child: AppBar(
                  //       title: RichText(
                  //         text: const TextSpan(
                  //           children: <TextSpan>[
                  //             TextSpan(
                  //               text: 'Hello.\n',
                  //               style: TextStyle(
                  //                 fontSize: 30,
                  //                 fontWeight: FontWeight.w600,
                  //                 color: Colors.black,
                  //               ),
                  //             ),
                  //             TextSpan(
                  //               text: 'Welcome Back!',
                  //               style: TextStyle(
                  //                 fontSize: 30,
                  //                 fontWeight: FontWeight.w600,
                  //                 color: Colors.white,
                  //               ),
                  //             ),
                  //           ],
                  //         ),
                  //       ),
                  //       backgroundColor: Colors.transparent,
                  //       elevation: 0,
                  //     ),
                  //   ),
                  // ),

                  Align(
                    alignment: Alignment.bottomCenter,
                    child: SizedBox(
                      // height: MediaQuery.of(context).size.height / 1.6,
                      child: Column(
                        children: [
                          // Padding(
                          //   padding:
                          //       const EdgeInsets.symmetric(horizontal: 50.0),
                          //   child: TabBar(
                          //     controller: tabController,
                          //     unselectedLabelColor: Colors.black,
                          //     labelColor: Colors.black,
                          //     tabs: const [
                          //       Padding(
                          //         padding: EdgeInsets.all(13.0),
                          //         child: Text(  
                          //           'Sign In',
                          //           style: TextStyle(
                          //             fontSize: 18,
                          //           ),
                          //         ),
                          //       ),
                          //       Padding(
                          //         padding: EdgeInsets.all(13.0),
                          //         child: Text(
                          //           'Sign Up',
                          //           style: TextStyle(
                          //             fontSize: 18,
                          //           ),
                          //         ),
                          //       ),
                          //     ],
                          //   ),
                          // ),
                          Expanded(
                              child: TabBarView(
                            controller: tabController,
                            children: [
                              
                              BlocProvider<SignInBloc>(
                                create: (context) => SignInBloc(
                                    userRepository: context
                                        .read<AuthenticationBloc>()
                                        .userRepository),
                                child: const SignInScreen(),
                              ),
                              BlocProvider<SignUpBloc>(
                                create: (context) => SignUpBloc(
                                    userRepository: context
                                        .read<AuthenticationBloc>()
                                        .userRepository),
                                child: const SignUpScreen(),
                              ),
                            ],
                          ))
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
