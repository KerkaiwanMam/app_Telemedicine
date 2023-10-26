import 'package:flutter/material.dart';
import 'package:my_app/screens/auth/CartPage.dart';
import 'package:my_app/screens/auth/WalletPage.dart';
import 'package:my_app/screens/auth/components/cardSocials.dart';
import 'package:my_app/screens/auth/components/navBarBottom.dart';

import 'signInPage_calibrationBefore.dart';

class ProfilePage extends StatelessWidget {
  ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: SingleChildScrollView(
        child: Expanded(
          child: Container(
            // width: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.fill,
                image: NetworkImage('assets/images/bgImage_profile.png'),
              ),
            ),
            child: Column(
              children: [
                AppBar(
                  toolbarHeight: 80,
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  titleSpacing: -30,
                  centerTitle: true,
                  title: Column(
                    children: [
                      RotationTransition(
                        turns: AlwaysStoppedAnimation(270 / 360),
                        child: IconButton(
                          icon: Icon(Icons.arrow_back_ios,
                              color: Color(0xFFF7F2E3), size: 24),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Text(
                        "@aNDAMANSPEAKS".toUpperCase(),
                        style: TextStyle(
                          fontSize: 18,
                          color: Color(0xffF7F2E3),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  leadingWidth: 80,
                  actions: [
                    Column(
                      children: [
                        SizedBox(
                          height: 44,
                        ),
                        Row(
                          children: [
                            InkWell(
                              onTap: () {
                                // ดำเนินการเมื่อคลิกปุ่มค้นหา
                              },
                              child: Padding(
                                padding: EdgeInsets.only(right: 10.0),
                                child: Icon(
                                  Icons.search,
                                  color: Color(0xFFF7F2E3),
                                  size: 30,
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                 Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    // นี่คือหน้าปลายทางที่คุณต้องการไป
                    // เช่น หน้า ProfilePage()
                    return WalletPage();
                  },
                ),
              );
                              },
                              child: Padding(
                                padding: EdgeInsets.only(right: 10.0),
                                child: Icon(
                                  Icons.wallet_outlined,
                                  color: Color(0xFFF7F2E3),
                                  size: 30,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(
                  height: 80,
                ),
                Stack(
                  children: [
                    Column(
                      children: [
                        const SizedBox(
                          height: 80,
                        ),
                        Stack(
                          children: [
                            Expanded(
                              child: Container(
                                // width: double.infinity,
                                decoration: const BoxDecoration(
                                  color: Color.fromARGB(55, 247, 242, 227),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 20.0, right: 20),
                                  child: Column(
                                    children: [
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "BUDDIER".toUpperCase(),
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                                fontSize: 14,
                                                color: Colors.white),
                                          ),
                                          Text(
                                            "BUDDYING".toUpperCase(),
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                                fontSize: 14,
                                                color: Colors.white),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "30K".toUpperCase(),
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                                fontSize: 28,
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            "233".toUpperCase(),
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                                fontSize: 28,
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 40,
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            "MY FITCARE REWARDS",
                                            style: const TextStyle(
                                                fontSize: 16,
                                                color: Colors.white),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Image(
                                        image: NetworkImage(
                                            'assets/images/profileAward.png'),
                                      ),
                                      SizedBox(
                                        height: 40,
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            "PERSONAL POST",
                                            style: const TextStyle(
                                                fontSize: 16,
                                                color: Colors.white),
                                          ),
                                        ],
                                      ),
                                      CardSocialText(
                                          accountName: "@aNDAMANSPEAKS",
                                          textContent: "mARATHON ft.@HMPH",
                                          timePost: "AUG 23, 2023",
                                          imageAccount:
                                              "assets/images/socials/profile/profile.jpg"),
                                      CardSocialText(
                                          accountName: "@aNDAMANSPEAKS",
                                          textContent: "Bball sesh ft.@tt",
                                          timePost: "JULY 23, 2023",
                                          imageAccount:
                                              "assets/images/socials/profile/profile.jpg"),
                                      CardSocialImage(
                                          accountName: "@aNDAMANSPEAKS",
                                          textContent: "ft.@noone",
                                          timePost: "JUN 3, 2023",
                                          titleText: "Birthday Run",
                                          imagePath:
                                              "assets/images/socials/images/cake.jpg",
                                          imageAccount:
                                              "assets/images/socials/profile/profile.jpg"),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Center(
                        child: Container(
                      width:
                          160, // Set a specific width to maintain a circular shape
                      height:
                          160, // Set a specific height to maintain a circular shape
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white, // Border color
                          width: 10.0, // Border width
                        ),
                      ),
                      child: const CircleAvatar(
                        radius: 80,
                        backgroundImage: NetworkImage(
                            'assets/images/socials/profile/profile.jpg'),
                      ),
                    )),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: const BottomAppBar(
        color: Color(0xff85896B),
        elevation: 0.0,
        child: NavBarBottom(),
      ),
    );
  }
}
