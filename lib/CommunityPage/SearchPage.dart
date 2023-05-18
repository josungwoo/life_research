import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final _searchText = TextEditingController();

  Widget recommendItem(text) {
    return TextButton(
      onPressed: () {
        //goto "text search page"
      },
      child: Container(
        margin: const EdgeInsets.only(left: 8),
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          border: Border.all(color: Colors.black, width: 1),
        ),
        child: Text(
          text, // show recommend text
          style: const TextStyle(fontSize: 20),
        ),
      ),
    );
  }

  // recomend search content and show last search text
  Widget firstPage() {
    return Container(
      margin: const EdgeInsets.fromLTRB(8, 8, 8, 0),
      color: Colors.amber,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
              margin: const EdgeInsets.fromLTRB(8, 8, 0, 0),
              child: const Text(
                '인기있는 검색어',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              )),
          Container(
            margin: const EdgeInsets.fromLTRB(8, 8, 8, 0),
            height: 60,
            color: Colors.white,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal, // 가로로 스크롤 가능하게 변경
              child: Row(
                children: [
                  recommendItem('text'),
                  recommendItem('teasdasdadadt'),
                  recommendItem('asdasdasdasdasdassadasd'),
                ],
              ),
            ),
          ),
          Container(
              margin: const EdgeInsets.fromLTRB(8, 8, 0, 0),
              child: const Text(
                '최근 검색어',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              )),
          //저장된 최근 검색어 표시 해주는 부분
          Container(
            margin: EdgeInsets.fromLTRB(8, 8, 8, 0),
            color: Colors.white,
            child: SizedBox(
              width: double.infinity,
              child: Text('검색'),
              height: 30,
            ),
          )
        ],
      ),
    );
  }

  // 검색어를 입력 했을때 비슷한 결과를 알려주는 컨테이너 위젯
  Widget simmilarContent(String text) {
    return Container(
      margin: const EdgeInsets.fromLTRB(8, 8, 8, 0),
      color: Colors.cyan,
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.fromLTRB(8, 8, 8, 0),
            height: 60,
            color: Colors.white,
            child: TextButton(
                onPressed: () {
                  //go to text search page 구현해야함
                },
                child: Row(
                  children: [const Icon(Icons.search), Text(_searchText.text)],
                )),
          ),
        ],
      ),
    );
  }

  // 검색창에 값이 들어왔는지 확인하고 변화에 따른 화면을 바꿔주는 위젯
  Widget isText(searchText) {
    if (searchText == "") {
      // 아무것도 작성하지 않았을때
      return firstPage();
    } else {
      // 무언가 작성 했을 때
      return simmilarContent(_searchText.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        //search bar
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.cancel_outlined,
              color: Colors.black,
            ),
          ),
          //search bar
          title: TextField(
            controller: _searchText,
            onChanged: (value) {
              setState(() {});
            },
            decoration: const InputDecoration(
              hintText: 'Search',
              hintStyle: TextStyle(color: Colors.black),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.black),
              ),
              focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black)),
              border: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black)),
            ),
          ),
          backgroundColor: Colors.transparent, //appBar 투명색
          elevation: 0.0, //appBar 그림자 농도 설정 (값 0으로 제거)
        ),
        body: SafeArea(child: isText(_searchText.text)),
      ),
    );
  }
}
