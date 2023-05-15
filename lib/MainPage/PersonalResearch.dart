import 'package:flutter/material.dart';

class PersonalResearch extends StatefulWidget {
  const PersonalResearch({super.key});

  @override
  State<PersonalResearch> createState() => _PersonalResearchState();
}

class _PersonalResearchState extends State<PersonalResearch> {
  //현재 화면의 가로 길이를 받아오는 함수
  double getScreenWidth(BuildContext context, int number) {
    double width = MediaQuery.of(context).size.width;
    // print(width);
    width -= 16;
    width /= number;
    width -= (8 * 2);
    return width;
  }

  Widget category() {
    return Expanded(
        child: Container(
      //rounded rectangle
      margin: const EdgeInsets.only(top: 8, left: 8, right: 8, bottom: 8),
      height: getScreenWidth(context, 3), // 요소가 몇개 있는지?
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.blue[100],
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          centerTitle: true, //Title text 가운데 정렬
          title: const Text(
            'personal research',
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
        body: SafeArea(
            child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(left: 8, right: 8, top: 8),
              child: Row(
                children: [category(), category(), category()],
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 8, right: 8, top: 8),
              child: Row(
                children: [category(), category(), category()],
              ),
            ),
          ],
        )),
      ),
    );
  }
}
