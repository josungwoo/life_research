import 'package:flutter/material.dart';
import 'package:life_research/CommunityPage/CommunityPage.dart';
import 'package:life_research/ProfilePage/ProfilePage.dart';
import 'package:life_research/MainPage/PersonalResearch.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

//========test code area========

Widget listitem(number) {
  return Container(
    margin: const EdgeInsets.only(top: 8, left: 16, right: 16, bottom: 8),
    height: 100,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(20),
      color: Colors.blue[number],
    ),
  );
}

//=================================================================

class _MainPageState extends State<MainPage> {
  late int _selectedIndex; // 현재 선택된 페이지
  var name = "이름";
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 24, left: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "$name\n님을 위해 연구해 봤어요 :)",
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const PersonalResearch()),
                        );
                      },
                      icon: const Icon(Icons.chevron_right_sharp),
                      iconSize: 20,
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  Row(
                    children: [
                      //rounded 2box in icon and text
                      Expanded(
                        child: Container(
                          height: 100,
                          margin: const EdgeInsets.only(
                              top: 16, left: 16, right: 8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.blue[800],
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          height: 100,
                          margin: const EdgeInsets.only(
                              top: 16, left: 8, right: 16),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.blue[200],
                          ),
                          // child: const Text('값 넣을 예정임'),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 100,
                          margin: const EdgeInsets.only(
                              top: 16, left: 16, right: 8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.lightBlue[400],
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          height: 100,
                          margin: const EdgeInsets.only(
                              top: 16, left: 8, right: 16),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.blue,
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
              Container(
                margin: const EdgeInsets.only(top: 24, left: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Hot한 정보들이에요!",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.chevron_right_sharp),
                      iconSize: 20,
                    ),
                  ],
                ),
              ),
              // 아이템들을 스크롤 하면 각각의 요소들이 글자요소에 붙게 만들어줘
              Expanded(
                child: ListView(
                  children: [
                    listitem(100),
                    listitem(200),
                    listitem(300),
                    listitem(400),
                    listitem(500),
                  ],
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: 1,
          onTap: (int index) {
            // 누르면 해당 페이지로 이동
            setState(() {
              //0 = comPage
              //2 = profilePage
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
              } else if (_selectedIndex == 2) {
                Navigator.pushReplacement(
                  context,
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
