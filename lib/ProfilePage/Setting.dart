import 'package:flutter/material.dart';
import 'TestPage.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  // 설정 제목
  Widget settingTitle(String name) {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      child: Text(name,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
    );
  }

  // 설정 내부 요소
  Widget goDetailPage(String name, Widget page) {
    return Container(
      margin: const EdgeInsets.only(top: 8),
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
          Text(
            name,
            style: const TextStyle(fontSize: 18),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => page),
              );
            },
            icon: const Icon(Icons.arrow_forward_ios),
            color: Colors.black,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(
              centerTitle: true, //Title text 가운데 정렬
              title: const Text(
                'Setting',
                style: TextStyle(color: Colors.black),
              ),
              backgroundColor: Colors.transparent, //appBar 투명색
              elevation: 0.0, //appBar 그림자 농도 설정 (값 0으로 제거)
              leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.arrow_back_ios_new),
                color: Colors.black,
              ),
            ),
            /*setting 에 필요한 것들
            1. 알림 설정
            1.1. 푸시 알림
            1.2. 이메일 알림
            1.3. 알림음
            2. 회원 정보
            2.1. 회원 정보 수정
            2.2. 회원 탈퇴
            3. 기타
            3.1. 이용약관
            3.2. 개인정보 처리방침
            3.3. 오픈소스 라이선스
            3.4. 문의하기
            3.5. 앱 정보
            4. 로그아웃
            */
            body: SafeArea(
              child: SingleChildScrollView(
                child: Container(
                  margin: EdgeInsets.only(left: 8, right: 8, top: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      settingTitle('알림 설정'),
                      Container(
                        margin: EdgeInsets.only(top: 8, bottom: 8),
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
                            Text('푸시 알림'),
                            Switch(
                              value: true,
                              onChanged: (value) {},
                              activeTrackColor: Colors.lightBlueAccent,
                              activeColor: Colors.blue,
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 8, bottom: 8),
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
                            Text('이메일 알림'),
                            Switch(
                              value: true,
                              onChanged: (value) {},
                              activeTrackColor: Colors.lightBlueAccent,
                              activeColor: Colors.blue,
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 8, bottom: 8),
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
                            Text('알림음'),
                            Switch(
                              value: true,
                              onChanged: (value) {},
                              activeTrackColor: Colors.lightBlueAccent,
                              activeColor: Colors.blue,
                            ),
                          ],
                        ),
                      ),
                      settingTitle('회원 정보'),
                      goDetailPage('회원 정보 수정', TestPage()),
                      goDetailPage('회원 탈퇴', TestPage()),
                      settingTitle('기타'),
                      goDetailPage('이용약관', TestPage()),
                      goDetailPage('개인정보 처리방침', TestPage()),
                      goDetailPage('오픈소스 라이선스', TestPage()),
                      goDetailPage('문의하기', TestPage()),
                      goDetailPage('앱 정보', TestPage()),
                      Container(
                        margin: EdgeInsets.only(top: 8, bottom: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text('로그아웃'),
                            IconButton(
                              onPressed: () {},
                              icon: const Icon(Icons.logout),
                              color: Colors.black,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )));
  }
}
