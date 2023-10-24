import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_app/blocs/sign_up_bloc/sign_up_bloc_bloc.dart';
import 'package:my_app/screens/auth/components/my_text_field.dart';
import 'package:user_repository/user_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

final passwordController = TextEditingController();
final emailController = TextEditingController();
final nameController = TextEditingController();
final heightController = TextEditingController();
final weightController = TextEditingController();
final ageController = TextEditingController();
final genderController = TextEditingController();

int? age;
int? weight;
int? height;

final _formKey = GlobalKey<FormState>();

IconData iconPassword = CupertinoIcons.eye_fill;
bool obscurePassword = true;
bool signUpRequired = false;

bool containsUpperCase = false;
bool containsLowerCase = false;
bool containsNumber = false;
bool containsSpecialChar = false;
bool contains8Length = false;

bool isMale = false;
bool isFemale = false;
bool isOther = false;

bool isUsernameTaken = false;
String? _username;

bool isGmailTaken = false;
String? _Gmail;

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 39, 181, 56), 
      appBar: AppBar(
        title: Text('Sign Up'),
        backgroundColor: const Color.fromARGB(255, 214, 218, 221), 
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: (page) {
          setState(() {
            _currentPage = page;
          });
        },
        children: <Widget>[
          EmailPasswordPage(),
          UsernameAgeGenderPage(),
          HeightWeightPage(),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            if (_currentPage > 0)
              TextButton(
                onPressed: () {
                  _pageController.previousPage(
                    duration: Duration(milliseconds: 400),
                    curve: Curves.easeInOut,
                  );
                },
                child: Text('Previous'),
              ),
            if (_currentPage <
                2) // Adjust the number based on the number of pages
              TextButton(
                onPressed: () {
                  _pageController.nextPage(
                    duration: Duration(milliseconds: 400),
                    curve: Curves.easeInOut,
                  );
                },
                child: Text('Next'),
              ),
          ],
        ),
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
      child: SingleChildScrollView(
        //เพิ่ม
        child: Form(
          // key: _formKey,
          child: Center(
            child: Column(
              children: [
                const SizedBox(height: 25),
                Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: const Text(
                    'E-mail',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: MyTextField(
                      controller: emailController,
                      hintText: 'Enter your email',
                      obscureText: false,
                      keyboardType: TextInputType.emailAddress,
                      prefixIcon: const Icon(CupertinoIcons.mail_solid),
                      validator: (val) {
                        if (val!.isEmpty) {
                          return 'Please Fill in This Field';
                        } else if (!RegExp(r'^[\w-\.]+@([\w-]+.)+[\w-]{2,4}$')
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
                Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: const Text(
                    'Password',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: MyTextField(
                      controller: passwordController,
                      hintText: 'Enter your password',
                      obscureText: obscurePassword,
                      keyboardType: TextInputType.visiblePassword,
                      prefixIcon: const Icon(CupertinoIcons.lock_fill),
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
                              color:
                                  containsNumber ? Colors.green : Colors.black),
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
                      ],
                    ),
                  ],
                ),
              ],
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
      child: SingleChildScrollView(
        //เพิ่ม
        child: Form(
          //key: _formKey,
          child: Center(
            child: Column(
              children: [
                const SizedBox(height: 15),
                Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: const Text(
                    'Username',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: MyTextField(
                      controller: nameController,
                      hintText: 'Enter your name',
                      obscureText: false,
                      keyboardType: TextInputType.name,
                      prefixIcon: const Icon(CupertinoIcons.person_fill),
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
                const SizedBox(height: 15),
                Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: const Text(
                    'Age',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: MyTextField(
                      controller: ageController,
                      hintText: 'Enter your age',
                      obscureText: false,
                      keyboardType: TextInputType.number,
                      prefixIcon: const Icon(CupertinoIcons.timer_fill),
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
                const SizedBox(height: 15),
                Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: const Text(
                    'Gender',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Checkbox(
                      value: isMale,
                      onChanged: (value) {
                        setState(() {
                          isMale = value ?? false;
                          isFemale = false;
                          isOther = false;
                          genderController.text = isMale ? 'Male' : '';
                        });
                      },
                    ),
                    const Text('Male'),
                    Checkbox(
                      value: isFemale,
                      onChanged: (value) {
                        setState(() {
                          isMale = false;
                          isFemale = value ?? false;
                          isOther = false;
                          genderController.text = isFemale ? 'Female' : '';
                        });
                      },
                    ),
                    const Text('Female'),
                    Checkbox(
                      value: isOther,
                      onChanged: (value) {
                        setState(() {
                          isMale = false;
                          isFemale = false;
                          isOther = value ?? false;
                          genderController.text = isOther ? 'Other' : '';
                        });
                      },
                    ),
                    const Text('Other'),
                  ],
                ),
                if (!(isMale || isFemale || isOther))
                  const Text(
                    'Please Select a Gender',
                    style: TextStyle(color: Colors.red),
                  ),
              ],
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
      child: SingleChildScrollView(
        //เพิ่ม
        child: Form(
          key: _formKey,
          child: Center(
            child: Column(
              children: [
                const SizedBox(height: 15),
                Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: const Text(
                    'Height',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: MyTextField(
                      controller: heightController,
                      hintText: 'Enter your height',
                      obscureText: false,
                      keyboardType: TextInputType.number,
                      prefixIcon: const Icon(CupertinoIcons.arrow_up_down),
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
                const SizedBox(height: 15),
                Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: const Text(
                    'Weight',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: MyTextField(
                      controller: weightController,
                      hintText: 'Enter your weight',
                      obscureText: false,
                      keyboardType: TextInputType.number,
                      prefixIcon: const Icon(CupertinoIcons.arrow_up_bin_fill),
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
                //ถ้าเพิ่มวิดเจ็ตระวังมัน overflow
                SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                !signUpRequired
                    ? SizedBox(
                        width: MediaQuery.of(context).size.width * 0.5,
                        child: TextButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate() &&
                                  (isMale || isFemale || isOther)) {
                                MyUser myUser = MyUser.empty;
                                myUser = myUser.copyWith(
                                  //เพิ่มลง data ได้
                                  email: emailController.text,
                                  name: nameController.text,
                                  height: height,
                                  weight: weight,
                                  age: age,
                                  gender: genderController.text,
                                );
                                setState(() {
                                  context.read<SignUpBloc>().add(SignUpRequired(
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
                            style: TextButton.styleFrom(
                                elevation: 3.0,
                                backgroundColor:
                                    const Color.fromARGB(255, 186, 55, 71),
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(60))),
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
                            )),
                      )
                    : const CircularProgressIndicator(),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
