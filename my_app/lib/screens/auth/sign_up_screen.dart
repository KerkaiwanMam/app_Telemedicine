import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_app/blocs/sign_up_bloc/sign_up_bloc_bloc.dart';
import 'package:my_app/screens/auth/SecondScreen.dart';
import 'package:my_app/screens/auth/components/my_text_field.dart';
import 'package:my_app/screens/auth/components/my_text_field_sig.dart';
import 'package:my_app/screens/auth/signInPage_calibrationFindFriends.dart';
import 'package:my_app/screens/auth/sign_in_screen.dart';
import 'package:user_repository/user_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../blocs/sign_in_bloc/sign_in_bloc_bloc.dart';

final passwordController = TextEditingController();
final emailController = TextEditingController();
final nameController = TextEditingController();
final heightController = TextEditingController();
final weightController = TextEditingController();
final ageController = TextEditingController();
final genderController = TextEditingController();
final passwordconfirmController = TextEditingController();

int? age;
int? weight;
int? height;

String? selectedGender;

final _formKey = GlobalKey<FormState>();

IconData iconPassword = CupertinoIcons.eye_fill;
bool obscurePassword = true;
bool obscurePasswordconfirm = true;
bool signUpRequired = false;

bool containsUpperCase = false;
bool containsLowerCase = false;
bool containsNumber = false;
bool containsSpecialChar = false;
bool contains8Length = false;
bool obscureConfirmPassword = true; // กำหนดให้รหัสผ่านยืนยันเริ่มต้นเป็นแบบสลับ
IconData iconConfirmPassword =
    CupertinoIcons.eye_fill; // ไอคอนที่ใช้แสดงสถานะของรหัสผ่านยืนยัน
bool containsConfirmPasswordMatch = false; // สถานะการตรวจสอบรหัสผ่านยืนยัน

bool isMale = false;
bool isFemale = false;
bool isOther = false;

bool isUsernameTaken = false;
String? _username;

bool isGmailTaken = false;
String? _Gmail;

final PageController _pageController = PageController(initialPage: 0);
int _currentPage = 0;

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
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
              UsernameAgeGenderPage(),
              EmailPasswordPage(),
              HeightWeightPage(),
              StartPage(),
            ],
          ),
        ],
      ),
    );
  }
}

class EmailPasswordPage extends StatefulWidget {
  @override
  _EmailPasswordPageState createState() => _EmailPasswordPageState();
}

class _EmailPasswordPageState extends State<EmailPasswordPage> {
//-----------------------------------------------
  Future<bool> checkemailAvailability(String email) async {
    final result = await FirebaseFirestore.instance
        .collection('userProfile')
        .where('email', isEqualTo: email)
        .get();
    return !result.docs.isEmpty;
  }

  Future<void> checkAndSetemail(String? val) async {
    setState(() {
      isGmailTaken = false;
    });

    if (val!.isNotEmpty) {
      bool isTaken = await checkemailAvailability(val);
      setState(() {
        isGmailTaken = isTaken;
      });
    }
  }

//-----------------------------------------------
  Future<bool> checkUsernameAvailability(String username) async {
    final result = await FirebaseFirestore.instance
        .collection('userProfile')
        .where('username', isEqualTo: username)
        .get();
    return !result.docs.isEmpty;
  }

  Future<void> checkAndSetUsername(String? val) async {
    setState(() {
      isUsernameTaken = false;
    });

    if (val!.isNotEmpty) {
      bool isTaken = await checkUsernameAvailability(val);
      setState(() {
        isUsernameTaken = isTaken;
      });
    }
  }

//-----------------------------------------------
  @override
  Widget build(BuildContext context) {
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
    PageView(
      controller: _pageController,
      onPageChanged: (page) {
        setState(() {
          _currentPage = page;
        });
      },
      children: <Widget>[
        UsernameAgeGenderPage(),
        EmailPasswordPage(),
        HeightWeightPage(),
        StartPage(),
      ],
    );

    return BlocListener<SignUpBloc, SignUpState>(
      listener: (context, state) {
        if (state is SignUpSuccess) {
          setState(() {
            signUpRequired = false;
          });
          // Navigator.pop(context);
        } else if (state is SignUpProcess) {
          setState(() {
            signUpRequired = true;
          });
        } else if (state is SignUpFailure) {
          return;
        }
      },
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 60,
          backgroundColor: Colors.transparent,
          elevation: 0,
          titleSpacing: -30,
          leadingWidth: 120,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: Colors.black, size: 24),
            onPressed: () {
              if (_currentPage > 0) {
                _pageController.previousPage(
                  duration: Duration(milliseconds: 400),
                  curve: Curves.easeInOut,
                );
              }
            },
          ),
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(5),
            child: Divider(
              color: Color.fromARGB(255, 0, 0, 0),
              thickness: 1,
              height: 5,
              indent: 40,
              endIndent: 40,
            ),
          ),
          flexibleSpace: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image:
                    NetworkImage('assets/images/background-image_signIn_1.png'),
                fit: BoxFit.cover, // ปรับตามความเหมาะสม
              ),
            ),
          ),
          title: Text(
            "Sign In",
            style: TextStyle(
              color: Colors.black,
              fontSize: 26,
            ),
          ),
        ),
        body: Container(
          height: double.infinity,
          width: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.fill,
              image:
                  NetworkImage('assets/images/background-image_signIn_2.jpg'),
            ),
          ),
          child: SingleChildScrollView(
            //เพิ่ม
            child: Form(
              // key: _formKey,
              child: Center(
                child: Column(
                  children: <Widget>[
                    Container(
                      child: Column(
                        children: [
                          SizedBox(
                            height: 20,
                          ),
                          Column(
                            children: [
                              Text(
                                "Almost there!".toUpperCase(),
                                style: TextStyle(fontSize: 16),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Transform.scale(
                                scale: 0.5, // Adjust the scale factor as needed
                                child: Image(
                                  image: NetworkImage(
                                      'assets/images/LinearProcess_almost.png'),
                                ),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          Column(
                            children: [
                              Text(
                                "General InfoRmation".toUpperCase(),
                                style: TextStyle(
                                    fontSize: 16,
                                    fontStyle: FontStyle.italic,
                                    color: Color(0xFFCF9A40)),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                "|".toUpperCase(),
                                style: TextStyle(
                                    fontSize: 16, color: Color(0xFFCF9A40)),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                "Create Account".toUpperCase(),
                                style: TextStyle(
                                  fontSize: 16,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.75,
                      child: TextFormFieldSignIn(
                          controller: emailController,
                          labelTextDetail: 'Enter your email',
                          obscureText: false,
                          keyboardType: TextInputType.emailAddress,
                          validator: (val) {
                            if (val!.isEmpty) {
                              return 'Please Fill in This Field';
                            } else if (!RegExp(
                                    r'^[\w-\.]+@([\w-]+.)+[\w-]{2,4}$')
                                .hasMatch(val)) {
                              return 'Please Enter a Valid Email';
                            } else if (isGmailTaken) {
                              return 'Email is already taken';
                            }
                            return null;
                          },
                          onChanged: (val) {
                            setState(() {
                              _Gmail = val;
                            });

                            checkAndSetemail(val);
                          }),
                    ),

                    const SizedBox(height: 15),

                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.75,
                      child: TextFormFieldSignIn(
                          controller: passwordController,
                          labelTextDetail: 'Enter your password',
                          obscureText: obscurePassword,
                          keyboardType: TextInputType.visiblePassword,
                          // prefixIcon: const Icon(CupertinoIcons.lock_fill),
                          onChanged: (val) {
                            if (val!.contains(RegExp(r'[A-Z]'))) {
                              setState(() {
                                containsUpperCase = true;
                              });
                            } else {
                              setState(() {
                                containsUpperCase = false;
                              });
                            }
                            if (val.contains(RegExp(r'[a-z]'))) {
                              setState(() {
                                containsLowerCase = true;
                              });
                            } else {
                              setState(() {
                                containsLowerCase = false;
                              });
                            }
                            if (val.contains(RegExp(r'[0-9]'))) {
                              setState(() {
                                containsNumber = true;
                              });
                            } else {
                              setState(() {
                                containsNumber = false;
                              });
                            }
                            if (val.contains(RegExp(
                                r'^(?=.*?[!@#$&*~`)\%\-(_+=;:,.<>/?"[{\]}\|^])'))) {
                              setState(() {
                                containsSpecialChar = true;
                              });
                            } else {
                              setState(() {
                                containsSpecialChar = false;
                              });
                            }
                            if (val.length >= 8) {
                              setState(() {
                                contains8Length = true;
                              });
                            } else {
                              setState(() {
                                contains8Length = false;
                              });
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
                          validator: (val) {
                            if (val!.isEmpty) {
                              return 'Please Fill in This Field';
                            } else if (!RegExp(
                                    r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~`)\%\-(_+=;:,.<>/?"[{\]}\|^]).{8,}$')
                                .hasMatch(val)) {
                              return 'Please Enter a Valid Password';
                            }
                            return null;
                          }),
                    ),
                    const SizedBox(height: 15),
                    // Container(
                    //   alignment: Alignment.centerLeft,
                    //   padding: const EdgeInsets.symmetric(horizontal: 30),
                    //   child: const Text(
                    //     'Password Confirm',
                    //     style: TextStyle(
                    //       fontSize: 18,
                    //       fontWeight: FontWeight.w600,
                    //     ),
                    //   ),
                    // ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.75,
                      child: TextFormFieldSignIn(
                        controller: passwordconfirmController,
                        labelTextDetail: 'Confirm your password',
                        obscureText: obscurePassword,
                        keyboardType: TextInputType.visiblePassword,
                        // prefixIcon: const Icon(CupertinoIcons.lock_fill),
                        onChanged: (val) {
                          if (val!.contains(RegExp(r'[A-Z]'))) {
                            setState(() {
                              containsUpperCase = true;
                            });
                          } else {
                            setState(() {
                              containsUpperCase = false;
                            });
                          }
                          if (val.contains(RegExp(r'[a-z]'))) {
                            setState(() {
                              containsLowerCase = true;
                            });
                          } else {
                            setState(() {
                              containsLowerCase = false;
                            });
                          }
                          if (val.contains(RegExp(r'[0-9]'))) {
                            setState(() {
                              containsNumber = true;
                            });
                          } else {
                            setState(() {
                              containsNumber = false;
                            });
                          }
                          if (val.contains(RegExp(
                              r'^(?=.*?[!@#$&*~`)\%\-(_+=;:,.<>/?"[{\]}\|^])'))) {
                            setState(() {
                              containsSpecialChar = true;
                            });
                          } else {
                            setState(() {
                              containsSpecialChar = false;
                            });
                          }
                          if (val.length >= 8) {
                            setState(() {
                              contains8Length = true;
                            });
                          } else {
                            setState(() {
                              contains8Length = false;
                            });
                          }
                          if (val != passwordController.text) {
                            // ถ้ารหัสผ่านยืนยันไม่ตรงกับรหัสผ่าน
                            setState(() {
                              containsConfirmPasswordMatch =
                                  false; // กำหนดให้ตัวแปร containsConfirmPasswordMatch เป็น false
                            });
                          } else {
                            setState(() {
                              containsConfirmPasswordMatch =
                                  true; // ถ้ารหัสผ่านยืนยันตรงกับรหัสผ่าน
                            });
                          }
                          return null;
                        },
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              obscureConfirmPassword = !obscureConfirmPassword;
                              if (obscureConfirmPassword) {
                                iconConfirmPassword = CupertinoIcons.eye_fill;
                              } else {
                                iconConfirmPassword =
                                    CupertinoIcons.eye_slash_fill;
                              }
                            });
                          },
                          icon: Icon(iconPassword),
                        ),
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
                      ),
                    ),
                    const SizedBox(height: 25),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "⚈  1 Uppercase",
                              style: TextStyle(
                                  color: containsUpperCase
                                      ? Colors.green
                                      : Colors.black),
                            ),
                            Text(
                              "⚈  1 Lowercase",
                              style: TextStyle(
                                  color: containsLowerCase
                                      ? Colors.green
                                      : Colors.black),
                            ),
                            Text(
                              "⚈  1 Number",
                              style: TextStyle(
                                  color: containsNumber
                                      ? Colors.green
                                      : Colors.black),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "⚈  1 Special Character",
                              style: TextStyle(
                                  color: containsSpecialChar
                                      ? Colors.green
                                      : Colors.black),
                            ),
                            Text(
                              "⚈  8 Minimum Character",
                              style: TextStyle(
                                  color: contains8Length
                                      ? Colors.green
                                      : Colors.black),
                            ),
                            Text(
                              "⚈  Passwords Match",
                              // ให้สีของข้อความเป็นสีเขียวเมื่อรหัสผ่านยืนยันตรงกับรหัสผ่าน
                              style: TextStyle(
                                color: containsConfirmPasswordMatch
                                    ? Colors.green
                                    : Colors.black,
                              ),
                            ),
                            SizedBox(
                              height: 40,
                            ),
                          ],
                        ),
                      ],
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (_currentPage < 3) {
                          _pageController.nextPage(
                            duration: Duration(milliseconds: 400),
                            curve: Curves.easeInOut,
                          );
                        }
                      },
                      child: const Text('NEXT'),
                      style: customButtonStyle,
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    Column(
                      children: [
                        Text(
                          "Verify Phone number".toUpperCase(),
                          style: TextStyle(
                              fontSize: 16,
                              fontStyle: FontStyle.italic,
                              color: Color(0xFFCF9A40)),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "|".toUpperCase(),
                          style:
                              TextStyle(fontSize: 16, color: Color(0xFFCF9A40)),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "Calibrate Heartware".toUpperCase(),
                          style: TextStyle(
                              fontSize: 16,
                              fontStyle: FontStyle.italic,
                              color: Color(0xFFCF9A40)),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class UsernameAgeGenderPage extends StatefulWidget {
  @override
  _UsernameAgeGenderPage createState() => _UsernameAgeGenderPage();
}

class _UsernameAgeGenderPage extends State<UsernameAgeGenderPage> {
//-----------------------------------------------
  Future<bool> checkemailAvailability(String email) async {
    final result = await FirebaseFirestore.instance
        .collection('userProfile')
        .where('email', isEqualTo: email)
        .get();
    return !result.docs.isEmpty;
  }

  Future<void> checkAndSetemail(String? val) async {
    setState(() {
      isGmailTaken = false;
    });

    if (val!.isNotEmpty) {
      bool isTaken = await checkemailAvailability(val);
      setState(() {
        isGmailTaken = isTaken;
      });
    }
  }

//-----------------------------------------------
  Future<bool> checkUsernameAvailability(String username) async {
    final result = await FirebaseFirestore.instance
        .collection('userProfile')
        .where('username', isEqualTo: username)
        .get();
    return !result.docs.isEmpty;
  }

  Future<void> checkAndSetUsername(String? val) async {
    setState(() {
      isUsernameTaken = false;
    });

    if (val!.isNotEmpty) {
      bool isTaken = await checkUsernameAvailability(val);
      setState(() {
        isUsernameTaken = isTaken;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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
    PageView(
      controller: _pageController,
      onPageChanged: (page) {
        setState(() {
          _currentPage = page;
        });
      },
      children: <Widget>[
        UsernameAgeGenderPage(),
        EmailPasswordPage(),
        HeightWeightPage(),
        StartPage(),
      ],
    );
    return BlocListener<SignUpBloc, SignUpState>(
      listener: (context, state) {
        if (state is SignUpSuccess) {
          setState(() {
            signUpRequired = false;
          });
          // Navigator.pop(context);
        } else if (state is SignUpProcess) {
          setState(() {
            signUpRequired = true;
          });
        } else if (state is SignUpFailure) {
          return;
        }
      },
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 60,
          backgroundColor: Colors.transparent,
          elevation: 0,
          titleSpacing: -30,
          leadingWidth: 120,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: Colors.black, size: 24),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(5),
            child: Divider(
              color: Color.fromARGB(255, 0, 0, 0),
              thickness: 1,
              height: 5,
              indent: 40,
              endIndent: 40,
            ),
          ),
          flexibleSpace: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image:
                    NetworkImage('assets/images/background-image_signIn_1.png'),
                fit: BoxFit.cover, // ปรับตามความเหมาะสม
              ),
            ),
          ),
          title: Text(
            "Sign In",
            style: TextStyle(
              color: Colors.black,
              fontSize: 26,
            ),
          ),
        ),
        body: Container(
          height: double.infinity,
          width: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.fill,
              image:
                  NetworkImage('assets/images/background-image_signIn_1.png'),
            ),
          ),
          child: SingleChildScrollView(
            //เพิ่ม

            child: Form(
              //key: _formKey,
              child: Center(
                child: Column(
                  children: [
                    const SizedBox(height: 40),
                    Column(
                      children: [
                        Text(
                          "Fitcare Savings".toUpperCase(),
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Text(
                          "Let's Get Started!",
                          style: TextStyle(fontSize: 30),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    Text(
                      "General InfoRmation".toUpperCase(),
                      style:
                          TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
                    ),
                    SizedBox(
                      height: 20,
                    ),

                    // Container(
                    //   alignment: Alignment.centerLeft,
                    //   padding: const EdgeInsets.symmetric(horizontal: 30),
                    //   child: const Text(
                    //     'Username',
                    //     style: TextStyle(
                    //       fontSize: 18,
                    //       fontWeight: FontWeight.w600,
                    //     ),
                    //   ),
                    // ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.75,
                      child: TextFormFieldSignIn(
                          controller: nameController,
                          labelTextDetail: 'Username',
                          obscureText: false,
                          keyboardType: TextInputType.name,
                          // prefixIcon: const Icon(CupertinoIcons.person_fill),
                          validator: (val) {
                            if (val!.isEmpty) {
                              return 'Please Fill in This Field';
                            } else if (val.length > 50) {
                              return 'Username too long';
                            } else if (isUsernameTaken) {
                              return 'Username is already taken';
                            }
                            return null;
                          },
                          onChanged: (val) {
                            setState(() {
                              _username = val;
                            });

                            checkAndSetUsername(val);
                          }),
                    ),

                    const SizedBox(height: 20),

                    //---------------------------------------------------------
                    Row(
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.12,
                        ),
                        Expanded(
                          child: DropDownFormFieldSignIn(
                            labelText: "Gender",
                            items: ["Male", "Female", "Other"],
                            dropdownValue: selectedGender,
                            onChanged: (value) {
                              setState(() {
                                selectedGender = value;
                                if (value == "Male") {
                                  isMale = true;
                                  isFemale = false;
                                  isOther = false;
                                  genderController.text = isMale ? 'Male' : '';
                                }
                                if (value == "Female") {
                                  isMale = false;
                                  isFemale = true;
                                  isOther = false;
                                  genderController.text =
                                      isFemale ? 'Female' : '';
                                }
                                if (value == "Other") {
                                  isMale = false;
                                  isFemale = false;
                                  isOther = true;
                                  genderController.text =
                                      isOther ? 'Other' : '';
                                }
                              });
                            },
                          ),
                        ),

                        //--------------------------------------------------

                        SizedBox(
                          width: 50,
                        ),

                        //--------------------------------------------------

                        Expanded(
                          child: TextFormFieldSignIn(
                              controller: ageController,
                              labelTextDetail: 'Age',
                              obscureText: false,
                              keyboardType: TextInputType.number,
                              // prefixIcon: const Icon(CupertinoIcons.timer_fill),
                              validator: (val) {
                                if (val!.isEmpty) {
                                  return 'Please Fill in This Field';
                                } else if (int.tryParse(val) == null) {
                                  return 'Age must be a valid number';
                                } else if (int.parse(val) > 150) {
                                  return 'Age too much';
                                }
                                return null;
                              },
                              onChanged: (val) {
                                setState(() {
                                  age = int.tryParse(val!);
                                });
                              }),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.12,
                        ),
                      ],
                    ),
                    //---------------------------------------------------------
                    SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.75,
                      child: TextFormFieldSignIn(
                          controller: heightController,
                          labelTextDetail: 'Height (cm)',
                          obscureText: false,
                          keyboardType: TextInputType.number,
                          // prefixIcon: const Icon(CupertinoIcons.arrow_up_down),
                          validator: (val) {
                            if (val!.isEmpty) {
                              return 'Please Fill in This Field';
                            } else if (int.tryParse(val) == null) {
                              return 'Height must be a valid number';
                            } else if (int.parse(val) > 400) {
                              return 'Height too high';
                            }
                            return null;
                          },
                          onChanged: (val) {
                            setState(() {
                              height = int.tryParse(val!);
                            });
                          }),
                    ),
                    const SizedBox(height: 20),

                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.75,
                      child: TextFormFieldSignIn(
                          controller: weightController,
                          labelTextDetail: 'Weight (kg)',
                          obscureText: false,
                          keyboardType: TextInputType.number,
                          // prefixIcon: const Icon(CupertinoIcons.arrow_up_bin_fill),
                          validator: (val) {
                            if (val!.isEmpty) {
                              return 'Please Fill in This Field';
                            } else if (int.tryParse(val) == null) {
                              return 'Weight must be a valid number';
                            } else if (int.parse(val) > 150) {
                              return 'Weight too much';
                            }
                            return null;
                          },
                          onChanged: (val) {
                            setState(() {
                              weight = int.tryParse(val!);
                            });
                          }),
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (_currentPage < 3) {
                          _pageController.nextPage(
                            duration: Duration(milliseconds: 400),
                            curve: Curves.easeInOut,
                          );
                        }
                      },
                      child: const Text('NEXT'),
                      style: customButtonStyle,
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Column(
                      children: [
                        Text(
                          "Create Account".toUpperCase(),
                          style: TextStyle(
                              fontSize: 16,
                              fontStyle: FontStyle.italic,
                              color: Color(0xFFCF9A40)),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "|".toUpperCase(),
                          style:
                              TextStyle(fontSize: 16, color: Color(0xFFCF9A40)),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "Verify Phone number".toUpperCase(),
                          style: TextStyle(
                              fontSize: 16,
                              fontStyle: FontStyle.italic,
                              color: Color(0xFFCF9A40)),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "|".toUpperCase(),
                          style:
                              TextStyle(fontSize: 16, color: Color(0xFFCF9A40)),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "Calibrate Heartware".toUpperCase(),
                          style: TextStyle(
                              fontSize: 16,
                              fontStyle: FontStyle.italic,
                              color: Color(0xFFCF9A40)),
                        ),
                        SizedBox(
                          height: 40,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class HeightWeightPage extends StatefulWidget {
  @override
  _HeightWeightPage createState() => _HeightWeightPage();
}

class _HeightWeightPage extends State<HeightWeightPage> {
  @override
  Widget build(BuildContext context) {
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
    PageView(
      controller: _pageController,
      onPageChanged: (page) {
        setState(() {
          _currentPage = page;
        });
      },
      children: <Widget>[
        UsernameAgeGenderPage(),
        EmailPasswordPage(),
        HeightWeightPage(),
        StartPage(),
      ],
    );

    return BlocListener<SignUpBloc, SignUpState>(
      listener: (context, state) {
        if (state is SignUpSuccess) {
          setState(() {
            signUpRequired = false;
          });
          // Navigator.pop(context);
        } else if (state is SignUpProcess) {
          setState(() {
            signUpRequired = true;
          });
        } else if (state is SignUpFailure) {
          return;
        }
      },
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 60,
          backgroundColor: Colors.transparent,
          elevation: 0,
          titleSpacing: -30,
          leadingWidth: 120,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: Colors.black, size: 24),
            onPressed: () {
              if (_currentPage > 0) {
                _pageController.previousPage(
                  duration: Duration(milliseconds: 400),
                  curve: Curves.easeInOut,
                );
              }
            },
          ),
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(5),
            child: Divider(
              color: Color.fromARGB(255, 0, 0, 0),
              thickness: 1,
              height: 5,
              indent: 40,
              endIndent: 40,
            ),
          ),
          flexibleSpace: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image:
                    NetworkImage('assets/images/background-image_signIn_1.png'),
                fit: BoxFit.cover, // ปรับตามความเหมาะสม
              ),
            ),
          ),
          title: Text(
            "Sign In",
            style: TextStyle(
              color: Colors.black,
              fontSize: 26,
            ),
          ),
        ),
        body: Container(
          height: double.infinity,
          width: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.fill,
              image:
                  NetworkImage('assets/images/background-image_signIn_3.png'),
            ),
          ),
          child: SingleChildScrollView(
            //เพิ่ม
            child: Form(
              key: _formKey,
              child: Container(
                child: Center(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 40,
                      ),
                      Text(
                        "Just a little more!".toUpperCase(),
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Transform.scale(
                        scale: 0.5, // Adjust the scale factor as needed
                        child: Image(
                          image: NetworkImage(
                              'assets/images/LinearProcess_littlemore.png'),
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Text(
                        "General InfoRmation".toUpperCase(),
                        style: TextStyle(
                            fontSize: 16,
                            fontStyle: FontStyle.italic,
                            color: Color(0xFFCF9A40)),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "|".toUpperCase(),
                        style:
                            TextStyle(fontSize: 16, color: Color(0xFFCF9A40)),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Create Account".toUpperCase(),
                        style: TextStyle(
                            fontSize: 16,
                            fontStyle: FontStyle.italic,
                            color: Color(0xFFCF9A40)),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "|".toUpperCase(),
                        style:
                            TextStyle(fontSize: 16, color: Color(0xFFCF9A40)),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Verify Phone number".toUpperCase(),
                        style: TextStyle(
                          fontSize: 16,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      Row(
                        children: [
                          SizedBox(width: 16),
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.only(
                                bottom: 17,
                                top: 17,
                                left: 40,
                              ),
                              child: Text(
                                "+66",
                              ),
                            ),
                            flex: 3,
                          ),
                          Expanded(
                            flex: 10,
                            child: Container(
                              padding: EdgeInsets.only(
                                bottom: 17,
                                top: 17,
                                right:
                                    45, // Adjust the right padding to add space
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: PhoneFormFieldSignIn(
                                      labelTextDetail: "Phone Number",
                                    ),
                                  ),
                                  SizedBox(
                                      width: 20), // Add your desired spacing
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        "Enter OTP",
                        style: TextStyle(
                          color: Color(0xFF114817),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.5,
                        child: BoxFormFieldSignIn(),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Text(
                        "Resend Code",
                        style: TextStyle(
                          decoration: TextDecoration.underline,
                          color: Color(0xFF114817),
                          fontSize: 12,
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      //ถ้าเพิ่มวิดเจ็ตระวังมัน overflow
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02),
                      !signUpRequired
                          ? SizedBox(
                              width: MediaQuery.of(context).size.width * 0.5,
                              child: TextButton(
                                onPressed: () {
                                  if (_formKey.currentState!.validate() &&
                                      (isMale || isFemale || isOther)) {
                                    if (_currentPage < 3) {
                                      // ตรวจสอบเงื่อนไขก่อนเพื่อให้กดไปหน้าถัดไปได้เฉพาะเมื่อเงื่อนไขที่คุณต้องการถูกตรวจสอบ
                                      _pageController.nextPage(
                                        duration: Duration(milliseconds: 400),
                                        curve: Curves.easeInOut,
                                      );
                                    }
                                    MyUser myUser = MyUser.empty;
                                    myUser = myUser.copyWith(
                                      // Add your data here
                                      email: emailController.text,
                                      name: nameController.text,
                                      height: height,
                                      weight: weight,
                                      age: age,
                                      gender: genderController.text,
                                    );
                                    setState(() {
                                      context.read<SignUpBloc>().add(
                                          SignUpRequired(
                                              myUser, passwordController.text));

                                      // Reset the controllers and state variables
                                      passwordController.clear();
                                      emailController.clear();
                                      nameController.clear();
                                      heightController.clear();
                                      weightController.clear();
                                      ageController.clear();
                                      genderController.clear();

                                      age = null;
                                      weight = null;
                                      height = null;

                                      iconPassword = CupertinoIcons.eye_fill;
                                      obscurePassword = true;
                                      signUpRequired = false;

                                      containsUpperCase = false;
                                      containsLowerCase = false;
                                      containsNumber = false;
                                      containsSpecialChar = false;
                                      contains8Length = false;

                                      isMale = false;
                                      isFemale = false;
                                      isOther = false;

                                      isUsernameTaken = false;
                                      _username = null;

                                      isGmailTaken = false;
                                      _Gmail = null;
                                    });
                                  }
                                },
                                style: customButtonStyle,
                                child: const Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 25, vertical: 5),
                                  child: Text(
                                    'Sign Up',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ),
                              // child: const Text('SING IN'),
                              // style: customButtonStyle,
                            )
                          : const CircularProgressIndicator(),

                      SizedBox(
                        height: 20,
                      ),
                      Column(
                        children: [
                          Text(
                            "|".toUpperCase(),
                            style: TextStyle(
                                fontSize: 16, color: Color(0xFFCF9A40)),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          InkWell(
                            onTap: () {
                              if (_currentPage < 3) {
                                // ตรวจสอบเงื่อนไขก่อนเพื่อให้กดไปหน้าถัดไปได้เฉพาะเมื่อเงื่อนไขที่คุณต้องการถูกตรวจสอบ
                                _pageController.nextPage(
                                  duration: Duration(milliseconds: 400),
                                  curve: Curves.easeInOut,
                                );
                              }
                            },
                            child: Text(
                              "Calibrate Heartware".toUpperCase(),
                              style: TextStyle(
                                fontSize: 16,
                                fontStyle: FontStyle.italic,
                                color: Color(0xFFCF9A40),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class StartPage extends StatefulWidget {
  @override
  _StartPage createState() => _StartPage();
}

class _StartPage extends State<StartPage> {
  @override
  Widget build(BuildContext context) {
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
    PageView(
      controller: _pageController,
      onPageChanged: (page) {
        setState(() {
          _currentPage = page;
        });
      },
      children: <Widget>[
        UsernameAgeGenderPage(),
        EmailPasswordPage(),
        HeightWeightPage(),
        StartPage(),
      ],
    );

    return BlocListener<SignUpBloc, SignUpState>(
      listener: (context, state) {
        if (state is SignUpSuccess) {
          setState(() {
            signUpRequired = false;
          });
          // Navigator.pop(context);
        } else if (state is SignUpProcess) {
          setState(() {
            signUpRequired = true;
          });
        } else if (state is SignUpFailure) {
          return;
        }
      },
      child: Scaffold(
        // appBar: AppBar(
        //   toolbarHeight: 60,
        //   backgroundColor: Colors.transparent,
        //   elevation: 0,
        //   titleSpacing: -30,
        //   leadingWidth: 120,
        //   leading: IconButton(
        //     icon: Icon(Icons.arrow_back_ios, color: Colors.white, size: 24),
        //     onPressed: () {
        //       if (_currentPage > 0) {
        //         _pageController.previousPage(
        //           duration: Duration(milliseconds: 400),
        //           curve: Curves.easeInOut,
        //         );
        //       }
        //     },
        //   ),
        //   bottom: PreferredSize(
        //     preferredSize: Size.fromHeight(5),
        //     child: Divider(
        //       color: Color.fromARGB(255, 255, 255, 255),
        //       thickness: 1,
        //       height: 5,
        //       indent: 40,
        //       endIndent: 40,
        //     ),
        //   ),
        //   flexibleSpace: Container(
        //     decoration: BoxDecoration(
        //       image: DecorationImage(
        //         image:
        //             NetworkImage('assets/images/bgImage_calibrationBefore.png'),
        //         fit: BoxFit.fitWidth, // ปรับตามความเหมาะสม
        //         alignment: Alignment.topCenter,
        //       ),
        //     ),
        //   ),
        //   // title: Text(
        //   //   "Sign In",
        //   //   style: TextStyle(
        //   //     color: Colors.white,
        //   //     fontSize: 26,
        //   //   ),
        //   // ),
        // ),
        body: Container(
          height: double.infinity,
          width: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.fill,
              image:
                  NetworkImage('assets/images/bgImage_calibrationBefore.png'),
            ),
          ),
          child: SingleChildScrollView(
            //เพิ่ม
            child: Form(
              // key: _formKey,
              child: Container(
                child: Center(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 80,
                      ),
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
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.02,
                          ),
                          !signUpRequired
                              ? SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.5,
                                  child: IconButton(
                                    icon: Image(
                                      image: NetworkImage(
                                        'assets/images/buttonStart_calibrationBefore.png',
                                      ),
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
                                )
                              : CircularProgressIndicator(),
                          SizedBox(
                            height: 50,
                          ),
                          Image(
                            image: NetworkImage(
                                'assets/images/image_calibrationBefore.png'),
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

                      //ถ้าเพิ่มวิดเจ็ตระวังมัน overflow
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
