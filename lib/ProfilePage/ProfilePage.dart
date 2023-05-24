import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:flutter/material.dart';
import 'package:life_research/CommunityPage/CommunityPage.dart';
import 'package:life_research/MainPage/mainPage.dart';
import 'package:life_research/ProfilePage/Setting.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  FirebaseFirestore userDB = FirebaseFirestore.instance; // 유저 DB
  late int _selectedIndex; // 현재 선택된 페이지
  final References = FirebaseStorage.instance;

  final _userRank = 'unRanked';

  @override
  void initState() {
    super.initState();
  }

  getUserData() async {
    var datas = await userDB
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid.toString())
        .get()
        .then((value) => value.data() as Map<String, dynamic>);
    return datas; // 현재 유저 정보를 Map 형태로 반환 함
  }

  //========================프로필start========================
  Future<dynamic> downloadURLExample() async {
    String downloadURL = await References.ref(
            'users/${FirebaseAuth.instance.currentUser!.uid.toString()}/profileImage')
        .getDownloadURL();
    print(downloadURL);
    return downloadURL;
  }

  Widget _profile_image(url) {
    return Container(
      width: 100,
      height: 100,
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        image: DecorationImage(
            fit: BoxFit.fill,
            // 프로필 이미지 설정에 따른 변화
            image: NetworkImage(url)),
      ),
    );
  }
  //========================프로필end========================

  Widget loadingPage() {
    return Center(
      child: Container(
        color: Colors.white,
        child: const Text('loading'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          centerTitle: true, //Title text 가운데 정렬
          title: Text(
            'Profile',
            style: TextStyle(color: Colors.black),
          ),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SettingPage()),
                );
              },
              icon: const Icon(Icons.settings),
              color: Colors.black,
            ),
          ],
          backgroundColor: Colors.transparent, //appBar 투명색
          elevation: 0.0, //appBar 그림자 농도 설정 (값 0으로 제거)
        ),
        body: FutureBuilder(
          future: getUserData(),
          builder: (context, snapshot) {
            if (snapshot.hasData == false) {
              return Center(child: CircularProgressIndicator());
            }
            //error가 발생하게 될 경우 반환하게 되는 부분
            else if (snapshot.hasError) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Error: ${snapshot.error}',
                  style: TextStyle(fontSize: 15),
                ),
              );
            } else {
              var userdata = snapshot.data as Map<String, dynamic>;
              return SingleChildScrollView(
                //contents outfit
                child: Container(
                  margin: EdgeInsets.only(left: 8, right: 8, top: 8),
                  //inner contents
                  child: Column(
                    children: [
                      Container(
                        decoration: const BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: Colors.grey,
                              width: 1.0,
                            ),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                //profile 설정에 따른 이미지 변화 함수
                                FutureBuilder(
                                  future: downloadURLExample(),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      return _profile_image(snapshot.data);
                                    } else {
                                      return Center(
                                          child: CircularProgressIndicator());
                                    }
                                  },
                                ),

                                //이름과 이메일
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Text(
                                      //load name and show it
                                      '${userdata['name']}',
                                      style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      '${userdata['email']}',
                                      style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              //rank system
                              children: [
                                Image.network(
                                    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQiS3ZUuPNHJR0eRIQIDT2C5pa-ywIejAj4abLKe5fQ&s',
                                    width: 50),
                                Text(
                                  _userRank,
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          TextButton(
                              onPressed: () async {
                                var userdata =
                                    await getUserData() as Map<String, dynamic>;
                                print(userdata['name']);
                              },
                              child: Text('test'))
                        ],
                      )
                    ],
                  ),
                ),
              );
            }
          },
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: 2, // 현재 선택된 페이지
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
