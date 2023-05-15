import 'package:flutter/material.dart';
import 'package:life_research/CommunityPage/CommunityPage.dart';
import 'package:life_research/MainPage/mainPage.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late int _selectedIndex; // 현재 선택된 페이지
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: const Text('ProfilePage'),
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: 2,
          onTap: (int index) {
            // 누르면 해당 페이지로 이동
            setState(() {
              _selectedIndex = index;
              if (_selectedIndex == 0) {
                Navigator.pushReplacement(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation1, animation2) =>
                        const ComPage(),
                    transitionDuration: const Duration(seconds: 0),
                  ),
                );
              } else if (_selectedIndex == 1) {
                Navigator.pushReplacement(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation1, animation2) =>
                        const MainPage(),
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
