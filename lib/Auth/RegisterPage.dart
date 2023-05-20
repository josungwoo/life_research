import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart'; // 사용자 인증
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:life_research/Auth/PhoneAuth.dart'; // 데이터베이스

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordController2 = TextEditingController();
  FirebaseFirestore userDB = FirebaseFirestore.instance; // 유저 db에 접속
  bool hiddenPassword = true, hiddenPassword2 = true;
  late String baseUserUid;

  Future<void> _checkUser() async {
    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid.toString())
        .get();
    final bool doesDocExist = doc.exists;
    // 로그인 했는지 확인
    if (FirebaseAuth.instance.currentUser != null) {
      // 로그인 했으면
      if (doesDocExist == true) {
        print('문서있음');
        //본인인증 여부를 확인하고 인증되지 않았으면 본인인증 페이지로 이동 | 인증되었으면 메인페이지로 이동
        if (doc['isVerified'] == false) {
          // 본인인증 페이지로 이동
          print('본인인증 안됨');
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => PhoneAuth(baseUserUid)),
          );
        } else {
          // 메인페이지로 이동
          if (doc['infoAgree'] == false) {
            print('본인인증 됨 == 정보제공 동의 안함');
          } else
            print('본인인증 됨\n정보제공 동의함');
        }
      } else {
        // 로그인 했는데 문서가 없으면
        print('문서없음');
        await userDB
            .collection("users")
            .doc(FirebaseAuth.instance.currentUser!.uid.toString())
            .set({
          'isVerified': false,
          'infoAgree': false,
          'email': "${FirebaseAuth.instance.currentUser!.email}",
        });
        print('문서생성, 본인인증하러가기');
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  PhoneAuth(baseUserUid)), // baseUserUid 가 초기화 되지 않고 넘어가는 현상 발생
        );
      }
    } else {
      print("로그인안함");
    }
    // User콜렉션에 기본 유저정보가 있는지 확인하고 없으면 생성
    // 있으면 본인인증 여부를 확인하고 인증되지 않았으면 본인인증 페이지로 이동 | 인증되었으면 메인페이지로 이동
  }

  Future<String> loginUser() async {
    await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text, password: _passwordController.text);
    setState(() {
      baseUserUid = FirebaseAuth.instance.currentUser!.uid.toString();
    });
    print("asdasdasdadas" + baseUserUid);
    return FirebaseAuth.instance.currentUser!.uid.toString();
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
          body: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextField(
                  // 컨트롤러 추가
                  controller: _emailController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Email',
                  ),
                ),
                TextField(
                  //컨트롤러 추가
                  obscureText: hiddenPassword,
                  controller: _passwordController,
                  decoration: InputDecoration(
                    //visibility icon 추가
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          hiddenPassword = !hiddenPassword;
                        });
                      },
                      icon: Icon(hiddenPassword
                          ? Icons.visibility_off
                          : Icons.visibility),
                    ),
                    border: OutlineInputBorder(),
                    labelText: 'Password',
                  ),
                ),
                TextField(
                  //컨트롤러 추가
                  obscureText: hiddenPassword2,
                  controller: _passwordController2,
                  decoration: InputDecoration(
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          hiddenPassword2 = !hiddenPassword2;
                        });
                      },
                      icon: Icon(hiddenPassword2
                          ? Icons.visibility_off
                          : Icons.visibility),
                    ),
                    border: OutlineInputBorder(),
                    labelText: 'Password',
                  ),
                ),
              ],
            ),
          ),
          bottomSheet: SafeArea(
            child: Container(
                width: MediaQuery.of(context).size.width,
                height: 70,
                decoration: const BoxDecoration(
                  border: Border(
                    top: BorderSide(
                      color: Colors.grey,
                      width: 1.0,
                    ),
                  ),
                ),
                child: TextButton(
                  onPressed: () async {
                    //if password == password2
                    //register
                    //email 과 password 를 통해 firebaseAuth 회원가임
                    await FirebaseAuth.instance
                        .createUserWithEmailAndPassword(
                            email: _emailController.text,
                            password: _passwordController.text)
                        .then((value) {
                      baseUserUid =
                          FirebaseAuth.instance.currentUser!.uid.toString();
                      loginUser();

                      _checkUser();
                      //회원가입 성공
                      //회원가입 성공시 User 콜렉션에 기본 유저정보가 있는지 확인하고 없으면 생성

                      //회원가입 성공시 firebaseAuth 에서 자동으로 로그인 되기 때문에
                      //로그인 페이지로 이동
                      print("회원과입 성공");
                    }).catchError((e) {
                      if (e.code == 'weak-password') {
                        print('The password provided is too weak.');
                      } else if (e.code == 'email-already-in-use') {
                        print('이미 회원가입 한 계정입니다');
                      } else if (e.code == 'invalid-email') {
                        print('The email address is badly formatted.');
                      } else if (e.code == 'operation-not-allowed') {
                        print('operation-not-allowed');
                      }
                      print(e.message);
                      //회원가입 실패
                      //회원가입 실패시 에러 메시지 출력
                      //에러 메시지는 e.message 에 있음
                    });
                    _passwordController.text == _passwordController2.text
                        ? print("same")
                        : print("not same");
                  },
                  child: Text("다음"),
                )),
          )),
    );
  }
}
