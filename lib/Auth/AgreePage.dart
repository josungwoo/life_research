import 'package:flutter/material.dart';

class AgreePage extends StatefulWidget {
  const AgreePage({super.key});

  @override
  State<AgreePage> createState() => _AgreePageState();
}

class _AgreePageState extends State<AgreePage> {
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
      ),
    );
  }
}
