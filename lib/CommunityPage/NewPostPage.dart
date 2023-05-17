import 'package:flutter/material.dart';

class NewPostPage extends StatefulWidget {
  const NewPostPage({super.key});

  @override
  State<NewPostPage> createState() => _NewPostPageState();
}

class _NewPostPageState extends State<NewPostPage> {
  dynamic category = ['QnA', 'Tips', 'Free'];
  var defaultCategory;
  //화면의 가로길이

  @override
  void initState() {
    super.initState();
    //after page load open category page
    defaultCategory = category[0];
    chooseCategory();
  }

  void chooseCategory() {
    return WidgetsBinding.instance.addPostFrameCallback((_) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('카테고리 선택'),
            content: SingleChildScrollView(
              child: ListBody(
                children: const <Widget>[
                  Text('카테고리를 선택해주세요.'),
                ],
              ),
            ),
            actions: [
              TextButton(
                child: const Text('QnA'),
                onPressed: () {
                  defaultCategory = category[0];
                  setState(() {});
                  Navigator.pop(context);
                },
              ),
              TextButton(
                child: const Text('Tips'),
                onPressed: () {
                  defaultCategory = category[1];
                  setState(() {});
                  Navigator.pop(context);
                },
              ),
              TextButton(
                child: const Text('Free'),
                onPressed: () {
                  defaultCategory = category[2];
                  setState(() {});
                  Navigator.pop(context);
                },
              ),
            ],
          );
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SafeArea(
        child: Scaffold(
            appBar: AppBar(
              centerTitle: true, //Title text 가운데 정렬
              title: const Text(
                '새 글 작성',
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
              actions: [
                IconButton(
                  onPressed: () {
                    //if post is able to post
                    //post
                    //pop page
                    Navigator.pop(context);
                    //else
                    //show error message
                  },
                  icon: const Icon(Icons.check),
                  color: Colors.black,
                ),
              ],
            ),
            body: Container(
              margin: const EdgeInsets.only(left: 8, right: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //카테고리 선택 부분
                  TextButton(
                    onPressed: () {
                      chooseCategory();
                    },
                    child: Container(
                      //underline
                      decoration: const BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: Colors.grey,
                            width: 1.0,
                          ),
                        ),
                      ),
                      width: double.infinity,
                      height: 30,
                      child: Text(defaultCategory),
                    ),
                  ),
                  //제목 입력 부분
                  Container(
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Colors.grey,
                          width: 1.0,
                        ),
                      ),
                    ),
                    child: const TextField(
                      decoration: InputDecoration(
                        hintText: '제목',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      //width = 화면의 가로 길이
                      width: MediaQuery.of(context).size.width,
                      decoration: const BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: Colors.grey,
                            width: 1.0,
                          ),
                        ),
                      ),
                      child: const TextField(
                        maxLines: null,
                        decoration: InputDecoration(
                          hintText: '내용을 입력해 주세요',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            //키보드가 올라와도 따라오는 이미지 추가 버튼
            bottomSheet: Container(
              width: MediaQuery.of(context).size.width,
              height: 50,
              decoration: const BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: Colors.grey,
                    width: 1.0,
                  ),
                ),
              ),
              child: Row(children: [
                const SizedBox(
                  width: 16,
                ),
                IconButton(
                  onPressed: () {},
                  alignment: Alignment.centerLeft,
                  icon: const Icon(Icons.image),
                  color: Colors.black,
                ),
              ]),
            )),
      ),
    );
  }
}
