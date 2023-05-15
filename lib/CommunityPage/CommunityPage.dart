import 'package:flutter/material.dart';
import 'package:life_research/ProfilePage/ProfilePage.dart';
import 'package:life_research/MainPage/mainPage.dart';

class ComPage extends StatefulWidget {
  const ComPage({super.key});

  @override
  State<ComPage> createState() => _ComPageState();
}

class _ComPageState extends State<ComPage> {
  late int _selectedIndex; // 현재 선택된 페이지
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: SafeArea(child: Container()),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: 0,
          onTap: (int index) {
            // 누르면 해당 페이지로 이동
            setState(() {
              _selectedIndex = index;
              if (_selectedIndex == 1) {
                Navigator.pushReplacement(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation1, animation2) =>
                        const MainPage(),
                    transitionDuration: const Duration(seconds: 0),
                  ),
                );
              } else if (_selectedIndex == 2) {
                Navigator.pushReplacement(
                  context,
                  //noslide effect
                  PageRouteBuilder(
                    pageBuilder: (context, animation1, animation2) =>
                        const ProfilePage(),
                    transitionDuration: const Duration(seconds: 0),
                  ),
                );
              } else {
                //not work
              }
            });
          },
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.chat),
              label: 'Chats',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
