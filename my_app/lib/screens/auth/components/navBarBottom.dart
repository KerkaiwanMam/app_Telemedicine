import 'package:flutter/material.dart';
import 'package:my_app/screens/auth/CartPage.dart';
import 'package:my_app/screens/auth/ProfilePage.dart';
import 'package:my_app/screens/auth/achievementsPage.dart';
import 'package:my_app/screens/auth/socialPage.dart';

class NavBarBottom extends StatelessWidget {
  const NavBarBottom({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: const Color.fromARGB(255, 0, 0, 0),
            width: 2.0,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            icon: Image.network('assets/images/icons/profile.png'),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    // นี่คือหน้าปลายทางที่คุณต้องการไป
                    // เช่น หน้า ProfilePage()
                    return ProfilePage();
                  },
                ),
              );
            },
            iconSize: 50,
            padding: EdgeInsets.all(20),
          ),
          IconButton(
            icon: Image.network('assets/images/icons/commu.png'),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    // นี่คือหน้าปลายทางที่คุณต้องการไป
                    // เช่น หน้า ProfilePage()
                    return SocialPage();
                  },
                ),
              );
            },
            iconSize: 50,
            padding: EdgeInsets.all(20),
          ),
          IconButton(
            icon: Image.network('assets/images/icons/cart.png'),
             onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    // นี่คือหน้าปลายทางที่คุณต้องการไป
                    // เช่น หน้า ProfilePage()
                    return CartPage();
                  },
                ),
              );
            },
            iconSize: 50,
            padding: EdgeInsets.all(20),
          ),
          IconButton(
            icon: Image.network('assets/images/icons/setting.png'),
           onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    // นี่คือหน้าปลายทางที่คุณต้องการไป
                    // เช่น หน้า ProfilePage()
                    return AchievementsPage();
                  },
                ),
              );
            },
            iconSize: 50,
            padding: EdgeInsets.all(20),
          ),
        ],
      ),
    );
  }
}
