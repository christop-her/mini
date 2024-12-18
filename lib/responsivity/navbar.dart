import 'package:flutter/material.dart';
import 'package:mini/musermessage.dart';
import 'package:mini/responsivity/mobileFirstPage_2.dart';
import 'package:mini/responsivity/mobileUserStore.dart';
import 'package:mini/responsivity/profile.dart';
import 'package:mini/responsivity/selectStore.dart';




class NavBar extends StatefulWidget {
  @override
  NavBarState createState() => NavBarState();
}

class NavBarState extends State<NavBar> { 

  final _pages = [
    firstPage_2(),
    // mobileUserStore(),
    Selectstore(),
    umessage_tab_all(),
    // messagingpart(), // You can replace this with your actual pages
    // pracbookings(),
    ProfileScreen(),

  ];

  var _currentIndex = 0;

  @override
 
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 247, 247, 247),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.blue.shade900,
        backgroundColor: Color.fromARGB(255, 247, 247, 247),
        unselectedItemColor: Colors.green.shade900,
        currentIndex: _currentIndex,
        selectedLabelStyle:
        TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        items: [
          BottomNavigationBarItem(
            label: '',
            icon: Image.asset(
              _currentIndex == 0 ? 'images/s1.png' : 'images/Home.png',
              height: 24,
            ),
          ),
          BottomNavigationBarItem(
            label: '',
            icon: Image.asset(
              _currentIndex == 1 ? 'images/s2.png' : 'images/Message.png',
              height: 24,
            ),
          ),
          BottomNavigationBarItem(
            label: '',
            icon: Image.asset(
              _currentIndex == 2 ? 'images/Cal.png' : 'images/Calendar.png',
              height: 24,
            ),
          ),
          BottomNavigationBarItem(
            label: '',
            icon: Image.asset(
              _currentIndex == 3 ? 'images/s3.png' : 'images/Profile.png',
              height: 24,
            ),
          ),
        ],
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
      body: _pages[_currentIndex],
    );
  }
}