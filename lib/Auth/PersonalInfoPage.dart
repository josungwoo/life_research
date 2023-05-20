import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart'; // 데이터베이스

class PersonalInfoPage extends StatefulWidget {
  final String baseUserUid;
  final String myPhoneNumber;
  const PersonalInfoPage(this.baseUserUid, this.myPhoneNumber, {super.key});

  @override
  State<PersonalInfoPage> createState() => _PersonalInfoPageState();
}

class _PersonalInfoPageState extends State<PersonalInfoPage> {
/*
User/uid/
  displayName "캬하"
  isVerified false
  gender "남"
  name "조성우"
  email "cso3297@gmail.com"
  phoneNumber 1051563297
  photoURL ""
 */

  final TextEditingController _name = TextEditingController();
  final TextEditingController _displayName = TextEditingController();
  final TextEditingController _gender = TextEditingController();
  late final String _phoneNumber;
  final TextEditingController _photoURL = TextEditingController();
  FirebaseFirestore userDB = FirebaseFirestore.instance; // 유저 DB

  @override
  void initState() {
    super.initState();
    _phoneNumber = widget.myPhoneNumber;
  }

  Widget TextFieldCustom(control, String label) {
    return TextField(
      controller: control,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        labelText: label,
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
                '휴대폰 본인인증',
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
                TextFieldCustom(_name, '이름'),
                TextFieldCustom(_displayName, '닉네임'),
                TextFieldCustom(_gender, '성별'),
                TextFieldCustom(_photoURL, '프로필 사진'),
              ],
            )),
            bottomSheet: Container(
              margin: const EdgeInsets.all(8),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        if (true) {}
                        userDB
                            .collection("users")
                            .doc(widget.baseUserUid)
                            .update({
                          'isVerified': true,
                          'name': _name.text,
                          'displayName': _displayName.text,
                          'gender': _gender.text,
                          'phoneNumber': _phoneNumber,
                        });
                        print("data updated");
                      },
                      child: const Text('완료'),
                    ),
                  ),
                ],
              ),
            )));
  }
}
