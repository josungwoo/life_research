import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart'; // 쿠퍼티노 디자인 위젯
import 'package:flutter/material.dart'; // 마테리얼 디자인 위젯

import 'package:firebase_auth/firebase_auth.dart'; // 사용자 인증 플러그인
import 'package:cloud_firestore/cloud_firestore.dart'; //
import 'package:flutter/services.dart';
import 'package:life_research/Auth/login_page.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image_picker/image_picker.dart'; // 이미지 선택 플러그인
import 'dart:io'; //

class PersonalInfoPage extends StatefulWidget {
  final String baseUserUid;
  final String myPhoneNumber;
  const PersonalInfoPage(this.baseUserUid, this.myPhoneNumber, {super.key});

  @override
  State<PersonalInfoPage> createState() => _PersonalInfoPageState();
}

class _PersonalInfoPageState extends State<PersonalInfoPage> {
  final List<String> _gender = ['남자', '여자'];
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

  final TextEditingController _name =
      TextEditingController(); //   이름(필수) 한글,영어, 공백불가
  final TextEditingController _displayName = TextEditingController(); // 별명 (필수)
  final TextEditingController _birthDay = TextEditingController(); // 생년월일 (필수)
  late dynamic tempBirthDay; // 임시변수
  dynamic _selectedGender; // 성별 (필수)
  late final String _phoneNumber; // 휴대폰 번호 - 자동
  final TextEditingController _photoURL = TextEditingController(); //프로필 이미지 선택
  final _profileImage = 'assets/images/LifeImage.webp';
  final _nameKey = GlobalKey<FormState>();
  final _nickNameKey = GlobalKey<FormState>();
  final _birthDayKey = GlobalKey<FormState>();
  final _genderKey = GlobalKey<FormState>();
  FirebaseFirestore userDB = FirebaseFirestore.instance; // 유저 DB
  final storageRef = FirebaseStorage.instance.ref();

  final ImagePicker _picker = ImagePicker();
  XFile? _pickedImage;

  @override
  void initState() {
    super.initState();
    _phoneNumber = widget.myPhoneNumber;
  }

  _getPhotoLibraryImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _pickedImage = pickedFile;
      });
    } else {
      print('이미지 선택안함');
    }
  }

  Widget TextFieldCustom(control, String label) {
    return SizedBox(
      child: TextField(
        controller: control,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          labelText: label,
        ),
      ),
    );
  }

  // 이미지 파일을 가져오는 함수
  Future<File> getImageFileFromAssets(String path) async {
    final byteData = await rootBundle.load('$path');

    final file = File('${(await getTemporaryDirectory()).path}/$path');
    await file.create(recursive: true);
    await file.writeAsBytes(byteData.buffer
        .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));

    return file;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(
              centerTitle: true, //Title text 가운데 정렬
              title: const Text(
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
                TextButton(
                  onPressed: () {
                    _getPhotoLibraryImage();
                    print('image picker');
                  },
                  child: Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      CircleAvatar(
                          radius: 50,
                          backgroundImage: _pickedImage != null
                              ? FileImage(File(_pickedImage!.path))
                                  as ImageProvider
                              : Image.asset(_profileImage).image),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: const Icon(Icons.edit),
                      )
                    ],
                  ),
                ),
                Form(
                  key: _nameKey,
                  child: TextFormField(
                    controller: _name,
                    textInputAction: TextInputAction.next,
                    inputFormatters: [
                      FilteringTextInputFormatter(RegExp('[a-zA-Zㄱ-ㅣ가-힣]'),
                          allow: true)
                    ],
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      labelText: '이름',
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return '이름을 입력해주세요';
                      }
                      return null;
                    },
                  ),
                ),
                Form(
                  key: _nickNameKey,
                  child: TextFormField(
                    controller: _displayName,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      labelText: '닉네임',
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return '닉네임을 입력해주세요';
                      }
                      return null;
                    },
                  ),
                ),
                Row(
                  children: [
                    //생년월일을 선택해서 반환하는 위젯
                    Expanded(
                      child: Form(
                        key: _birthDayKey,
                        child: TextFormField(
                          controller: _birthDay,
                          //can not editing text
                          readOnly: true,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return '생년월일을 선택해주세요';
                            }
                            return null;
                          },
                          onTap: () {
                            //cuperino style date picker (y-m-d) with confirm button cancle button
                            showCupertinoModalPopup(
                                context: context,
                                builder: (context) {
                                  return Container(
                                    height: 300,
                                    child: Column(
                                      children: [
                                        Container(
                                          color: Colors.white,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              TextButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: const Text('취소')),
                                              TextButton(
                                                onPressed: () {
                                                  _birthDay.text =
                                                      tempBirthDay.toString();
                                                  Navigator.pop(context);
                                                },
                                                child: const Text('확인'),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          height: 250,
                                          child: CupertinoDatePicker(
                                            backgroundColor: Colors.white,
                                            initialDateTime: DateTime.now(),
                                            onDateTimeChanged: (DateTime date) {
                                              //연월일만 저장
                                              tempBirthDay =
                                                  '${date.year}-${date.month}-${date.day}';
                                            },
                                            minimumYear: 1900,
                                            maximumYear: 2100,
                                            //date format y m d
                                            mode: CupertinoDatePickerMode.date,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                });
                          },
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            labelText: '생년월일',
                          ),
                        ),
                      ),
                    ),

                    Container(
                      width: 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey),
                      ),
                      child: Form(
                        key: _genderKey,
                        child: DropdownButtonFormField(
                          value: _selectedGender,
                          hint: const Text('성별'),
                          items: _gender
                              .map((e) => DropdownMenuItem(
                                    child: Text(e),
                                    value: e,
                                  ))
                              .toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedGender = value;
                            });
                          },
                          validator: (value) {
                            if (value == null) {
                              return '성별을 선택해주세요';
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                TextButton(
                    onPressed: () async {
                      print(FirebaseAuth.instance.currentUser!.uid);
                      //TODO: 디버깅용
                    },
                    child: const Text('debug'))
              ],
            )),
            bottomSheet: Container(
              margin: const EdgeInsets.all(8),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        //TODO: 유저 정보 업데이트
                        final nameState = _nameKey.currentState!;
                        final nickState = _nickNameKey.currentState!;
                        final birthdayState = _birthDayKey.currentState!;
                        final genderState = _genderKey.currentState!;
                        final profileImagesRef = storageRef
                            .child("users/${widget.baseUserUid}/profileImage");
                        File image = _pickedImage == null
                            ? await getImageFileFromAssets(
                                'assets/images/LifeImage.webp')
                            : File(_pickedImage!.path);

                        if (nameState.validate() &&
                            nickState.validate() &&
                            birthdayState.validate() &&
                            genderState.validate()) {
                          await userDB
                              .collection("users")
                              .doc(widget.baseUserUid)
                              .update({
                            'isVerified': true, // 본인인증 완료
                            'name': _name.text, // 이름
                            'displayName': _displayName.text, // 닉네임
                            'birthDay': _birthDay.text, // 생년월일
                            'gender': _selectedGender, // 성별
                            'phoneNumber': _phoneNumber, // 휴대폰 번호
                          });

                          await profileImagesRef.putFile(image);

                          await FirebaseAuth.instance.currentUser!.delete();
                          if (FirebaseAuth.instance.currentUser == null) {
                            print("계정 삭제 성공");
                          } else {
                            print(FirebaseAuth.instance.currentUser);
                            print("로그아웃 실패");
                          }
                          //goto LoginPage and delete user
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      const LoginPage()),
                              (route) => false);

                          print("data updated");
                        } else {
                          null;
                        }
                      },
                      child: const Text('완료'),
                    ),
                  ),
                ],
              ),
            )));
  }
}
