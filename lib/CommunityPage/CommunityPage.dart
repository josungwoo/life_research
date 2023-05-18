import 'package:flutter/material.dart';
import 'package:life_research/CommunityPage/SearchPage.dart';
import 'package:life_research/ProfilePage/ProfilePage.dart';
import 'package:life_research/MainPage/mainPage.dart';

import 'NewPostPage.dart';

class ComPage extends StatefulWidget {
  const ComPage({super.key});

  @override
  State<ComPage> createState() => _ComPageState();
}

class _ComPageState extends State<ComPage> {
  late int _selectedIndex; // 현재 선택된 페이지

  @override
  void initState() {
    super.initState();
  }

  //================qna 박스 양식
  Widget qna([
    like,
    comment,
    img = null,
  ]) {
    //이미지가 있는지 없는지 확인
    Widget is_image() {
      if (img != null) {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            //crop image for roundbox
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                img,
                width: 60,
                height: 60,
                fit: BoxFit.cover,
              ),
            ),
          ],
        );
      } else {
        return const SizedBox();
      }
    }

    Widget is_like() {
      if (like != 0 && like != null) {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const Icon(Icons.favorite_border, size: 15),
            Text(like.toString()),
          ],
        );
      } else {
        return const SizedBox();
      }
    }

    Widget is_comment() {
      if (comment != 0 && comment != null) {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const Icon(Icons.comment, size: 15),
            Text(comment.toString()),
          ],
        );
      } else {
        return const SizedBox();
      }
    }

    // 기본 qna 박스
    return Container(
      //질문 게시글의 요소 한개
      margin: const EdgeInsets.only(top: 4, left: 8, right: 8),
      height: 95, // 각 요소 높이 지정해 줘야함
      decoration: const BoxDecoration(
        //only top line
        border: Border(
          top: BorderSide(
            color: Colors.grey,
            width: 0.5,
          ),
        ),
        color: Colors.white,
      ),
      //질문 게시글의 요소 한개
      child: TextButton(
        //no margin
        style: TextButton.styleFrom(
          padding: const EdgeInsets.all(0),
        ),
        onPressed: () {},
        child: Column(
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Expanded(
                child: Container(
                  height: 60,
                  margin: const EdgeInsets.only(left: 8, top: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      const Text(
                        '제목입니다',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Text(
                        '내용을 여기다가 작성할 예정입니다',
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: TextStyle(
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              is_image(), // row : 최 상단
            ]),
            Container(
              height: 25,
              padding: const EdgeInsets.only(left: 8, right: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    children: [
                      const Text('닉네임', style: TextStyle(fontSize: 13)),
                      Container(
                          margin: EdgeInsets.only(left: 4, right: 4),
                          child: const Icon(Icons.circle, size: 5)),
                      const Text('21시간 전', style: TextStyle(fontSize: 13)),
                      const Icon(Icons.circle, size: 5),
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          ),
                          color: Colors.blue,
                        ),
                        child: const Text(
                          '건강',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [is_like(), is_comment()],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
  //================qna박스양식 끝

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        // 탭바
        length: 3, //탭의 갯수
        child: Scaffold(
          //search bar
          appBar: AppBar(
            centerTitle: true, //Title text 가운데 정렬
            title: const Text(
              'community',
              style: TextStyle(color: Colors.black),
            ),
            actions: [
              IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SearchPage()));
                },
                icon: const Icon(Icons.search),
                color: Colors.black,
              ),
            ],
            backgroundColor: Colors.transparent, //appBar 투명색
            elevation: 0.0, //appBar 그림자 농도 설정 (값 0으로 제거)
          ),
          // 메인 화면
          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.only(left: 8, right: 8),
                    child: const TabBar(tabs: [
                      Tab(
                        child: Text(
                          'qna',
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                      Tab(
                          child: Text(
                        'tips',
                        style: TextStyle(color: Colors.black),
                      )),
                      Tab(
                          child: Text(
                        'free',
                        style: TextStyle(color: Colors.black),
                      )),
                    ]),
                  ),
                  SizedBox(
                    //height: 로딩된 데이터의 갯수 * 68(qna 박스의 높이),
                    height: 99 * 8,
                    child: TabBarView(
                      children: [
                        //================qna 박스
                        Column(
                          children: [
                            qna(0, 0,
                                "https://cdn.pixabay.com/photo/2015/04/23/22/00/tree-736885__480.jpg"),
                            qna(1, 2),
                            qna(123, 0),
                            qna(3, 0),
                            qna(0, 4),
                            qna(1, 1,
                                "https://cdn.pixabay.com/photo/2015/04/23/22/00/tree-736885__480.jpg"),
                            qna(0, 0),
                            qna(0, 0),
                          ],
                        ),
                        Container(
                          color: Colors.yellow,
                        ),

                        //================qna 박스 끝
                        Container(
                          color: Colors.blue,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          //게시물 작성 플로팅 액션 버튼
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const NewPostPage()),
              );
            },
            backgroundColor: Colors.blue,
            child: const Icon(Icons.add),
          ),
          // 바텀 네비게이션 바
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
      ),
    );
  }
}
