import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_app/screens/auth/components/my_text_field.dart';
import 'package:my_app/screens/auth/components/my_text_field_sig.dart';
import 'package:my_app/screens/auth/sign_up_screen.dart';

import '../../blocs/authentication_bloc/authentication_bloc_bloc.dart';
import '../../blocs/sign_in_bloc/sign_in_bloc_bloc.dart';
import '../../blocs/sign_up_bloc/sign_up_bloc_bloc.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:my_app/screens/auth/SecondScreen.dart';


final PageController _pageController = PageController(initialPage: 0);
int _currentPage = 0;


class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
 

  @override
   Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _pageController,
            onPageChanged: (page) {
              setState(() {
                _currentPage = page;
              });
            },
            children: <Widget>[
              FirstScreen(),
              LoginScreen(),
              
            ],
          ),
        ],
      ),
    );
  }
}


class LoginScreen extends StatefulWidget {
 
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final passwordController = TextEditingController();
  final emailController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  bool signInRequired = false;
  IconData iconPassword = CupertinoIcons.eye_fill;
  bool obscurePassword = true;
  String? _errorMsg;

  @override
  Widget build(BuildContext context) {
    PageView(
      controller: _pageController,
      onPageChanged: (page) {
        setState(() {
          _currentPage = page;
        });
      },
      children: <Widget>[
        FirstScreen(),
        LoginScreen(),
        
      ],
    );
    return BlocListener<SignInBloc, SignInState>(
      listener: (context, state) {
        if (state is SignInSuccess) {
          setState(() {
            signInRequired = false;
          });
        } else if (state is SignInProcess) {
          setState(() {
            signInRequired = true;
          });
        } else if (state is SignInFailure) {
          setState(() {
            signInRequired = false;
            _errorMsg = 'Invalid Email or Password';
          });
          
        }
      },
      child: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.fill,
            image: NetworkImage('assets/images/background-image_login2.jpg'),
          ),
        ),
        child: Form(
            key: _formKey,
            child: Column(children: [
              const SizedBox(height: 80),
              Container(
                height: 200,
                width: 200,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(
                        'assets/images/logo.png'), // แทน 'your_image.png' ด้วยเส้นทางรูปภาพของคุณ
                    fit: BoxFit.cover, // ปรับตามความเหมาะสม
                  ),
                ),
              ),
              Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: const Text(
                  'WELCOME!',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 25),
              SizedBox(
                  width: MediaQuery.of(context).size.width * 0.6,
                  child: TextFormFieldSignIn(
                      controller: emailController,
                      labelTextDetail: 'Username',
                      obscureText: false,
                      keyboardType: TextInputType.emailAddress,
                      // prefixIcon: const Icon(CupertinoIcons.mail_solid),
                      errorMsg: _errorMsg,
                      validator: (val) {
                        if (val!.isEmpty) {
                          return 'Please Fill in This Field';
                        } else if (!RegExp(r'^[\w-\.]+@([\w-]+.)+[\w-]{2,4}$')
                            .hasMatch(val)) {
                          return 'Please Enter a Valid Email';
                        }
                        return null;
                      })),
              const SizedBox(height: 15),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.6,
                child: TextFormFieldSignIn(
                  controller: passwordController,
                  labelTextDetail: 'Password',
                  obscureText: obscurePassword,
                  keyboardType: TextInputType.visiblePassword,
                  // prefixIcon: const Icon(CupertinoIcons.lock_fill),
                  errorMsg: _errorMsg,
                  validator: (val) {
                    if (val!.isEmpty) {
                      return 'Please Fill in This Field';
                    } else if (!RegExp(
                            r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~`)\%\-(_+=;:,.<>/?"[{\]}\|^]).{8,}$')
                        .hasMatch(val)) {
                      return 'Please Enter a Valid Password';
                    }
                    return null;
                  },
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        obscurePassword = !obscurePassword;
                        if (obscurePassword) {
                          iconPassword = CupertinoIcons.eye_fill;
                        } else {
                          iconPassword = CupertinoIcons.eye_slash_fill;
                        }
                      });
                    },
                    icon: Icon(iconPassword),
                  ),
                ),
              ),
              const SizedBox(height: 50),
              !signInRequired
                  ? SizedBox(
                      width: MediaQuery.of(context).size.width * 0.6,
                      child: TextButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              context.read<SignInBloc>().add(SignInRequired(
                                  emailController.text,
                                  passwordController.text));
                            }
                          },
                          style: TextButton.styleFrom(
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
                          ),
                          child: const Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 25, vertical: 5),
                            child: Text(
                              'LOG IN',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600),
                            ),
                          )),
                    )
                  : const CircularProgressIndicator(),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Forgot Password",
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF114817),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.6,
                child: TextButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) {
                          return BlocProvider<SignUpBloc>(
                            create: (context) => SignUpBloc(
                              userRepository: context
                                  .read<AuthenticationBloc>()
                                  .userRepository,
                            ),
                            child: SignUpScreen(),
                          );
                        }),
                      );
                    },
                    style: TextButton.styleFrom(
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
                    ),
                    child: const Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 25, vertical: 5),
                      child: Text(
                        'SIGN UP',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w600),
                      ),
                    )),
              ),
              const SizedBox(height: 10),
              Text(
                "Don't Have an Account?",
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF114817),
                ),
              ),
            ])),
      ),
    );
  }
}


class FirstScreen extends StatefulWidget {
  FirstScreen({Key? key}) : super(key: key);

  @override
  _FirstScreenState createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> {
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
    PageView(
      controller: _pageController,
      onPageChanged: (page) {
        setState(() {
          _currentPage = page;
        });
      },
      children: <Widget>[
        FirstScreen(),
        LoginScreen(),
        
      ],
    );
    return MaterialApp(
      home: Scaffold(
        body: Stack(
          children: <Widget>[
            // Background Image
            Image.asset(
              'assets/images/background-image.jpg',
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),

            Image.asset(
              'assets/images/background-image-top.png',
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ).animate(delay: 5000.ms).fadeOut(duration: 600.ms),

            // Content on top of the background and logo with Margin
            Positioned(
              top: MediaQuery.of(context).size.height - 620,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                    child: Text(
                  'AN APP THAT REWARDS YOU AFTER AN EXERCISE,\nWHICH IS WHAT YOU DESERVE.',
                  style: TextStyle(
                    color: Color(0xFF114817),
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Montserrat',
                  ),
                  textAlign: TextAlign.center,
                ).animate(delay: 5000.ms).fadeIn(duration: 600.ms)),
              ),
            ),

            // Centered Logo with Margin
            Center(
              child: Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/logo.gif'),
                  ),
                ),
                margin: EdgeInsets.all(0),
              ),
            ),

            // Content on top of the background and logo with Margin
            Positioned(
              bottom: 130,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  width: MediaQuery.of(context).size.width - 150,
                  child: ElevatedButton(
                    onPressed: () {
                        if (_currentPage < 1) {
                          _pageController.nextPage(
                            duration: Duration(milliseconds: 400),
                            curve: Curves.easeInOut,
                            
                          );
                          setState(() {
                          _currentPage = 0;
                        });
                          
                        } setState(() {
                          _currentPage = 0;
                        });
                      },
                    style: customButtonStyle,
                    child: Text(
                      'GET STARTED',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color.fromARGB(255, 247, 242, 227),
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Montserrat',
                      ),
                    ),
                  ).animate(delay: 5500.ms).fadeIn(duration: 600.ms),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
