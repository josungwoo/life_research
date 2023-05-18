import 'package:flutter/material.dart';
import 'package:life_research/MainPage/MainPage.dart'; // 메인페이지로 이동
import 'package:firebase_auth/firebase_auth.dart'; // 사용자 인증
import 'package:google_sign_in/google_sign_in.dart'; // 구글 로그인
import 'package:cloud_firestore/cloud_firestore.dart'; // 데이터베이스

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // 컨트롤러 추가
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  FirebaseFirestore userDB = FirebaseFirestore.instance;
  bool _isVerifed = false;

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
  // 만약 로그인 했으면
  // User콜렉션에 기본 유저정보가 있는지 확인하고 없으면 생성
  Future<void> _checkUser() async {
    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid.toString())
        .get();
    final bool doesDocExist = doc.exists;
    if (FirebaseAuth.instance.currentUser != null) {
      print('로그인함');
      // 로그인 했는지 확인
      // 로그인 했으면
      if (doesDocExist == true) {
        print('문서있음');
        //본인인증 여부를 확인하고 인증되지 않았으면 본인인증 페이지로 이동 | 인증되었으면 메인페이지로 이동
        if (doc['isVerified'] == false) {
          // 본인인증 페이지로 이동
          print('본인인증 안됨');
        } else {
          // 메인페이지로 이동
          print('본인인증 됨');
        }
      } else {
        // 로그인 했는데 문서가 없으면
        print('문서없음');
        await userDB
            .collection("users")
            .doc(FirebaseAuth.instance.currentUser!.uid.toString())
            .set({
          'isVerified': false,
          'email': "${FirebaseAuth.instance.currentUser!.email}",
        });
        print('문서생성');
      }
    } else {
      print("로그인안함");
    }
    // User콜렉션에 기본 유저정보가 있는지 확인하고 없으면 생성
    // 있으면 본인인증 여부를 확인하고 인증되지 않았으면 본인인증 페이지로 이동 | 인증되었으면 메인페이지로 이동
  }

  //구글 로그인 함수
  Future<UserCredential> signInWithGoogle() async {
    //구글 로그인을 위해 사용자에게 허용을 요청합니다.
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Ko: 사용자가 허용을 하면, 사용자의 정보를 가져옵니다.
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Ko : 사용자의 정보를 이용해, 자격 증명을 만듭니다.
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Ko : 자격 증명을 이용해, Firebase에 로그인합니다.
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // FirebaseAuth.instance.authStateChanges().listen((User? user) {
    //   if (user != null) {
    //     print(user.photoURL); flutter: https://lh3.googleusercontent.com/a/AGNmyxb2bfN0W8hz5Q4ybmI-L1QWR-qcQyIgdtOsr9hn=s96-c
    //     print(user.displayName); flutter: Kya-Ha
    //     print(user.email);flutter: cso3297@gmail.com
    //     print(user.emailVerified); true
    //     print(user.phoneNumber); null
    //     print(user.isAnonymous); false
    //   }
    // });

    return MaterialApp(
        home: Scaffold(
      body: SafeArea(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          //logo image, text, email, password, row(register, login), text(start with social), google button
          Image.network(
            //life research logo
            'https://logos.flamingtext.com/Name-Logos/Life-design-sketch-name.webp',
            width: 100,
            height: 100,
          ),
          const Text('Life Research'),
          TextField(
            // 컨트롤러 추가
            controller: emailController,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Email',
            ),
          ),
          TextField(
            //컨트롤러 추가
            controller: passwordController,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Password',
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                onPressed: () {},
                child: const Text('Register'),
              ),
              TextButton(
                onPressed: () {
                  //logout
                  FirebaseAuth.instance.signOut();
                  // 로그인 버튼 클릭 시
                  // FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
                },
                child: const Text('Login'),
              ),
            ],
          ),
          const Text('Start with social'),
          OutlinedButton(
            onPressed: () async {
              // 구글 로그인 버튼 클릭 시
              await signInWithGoogle();
              setState(() {});
              _checkUser();
              // 만약 로그인 했으면
              // User콜렉션에 기본 유저정보가 있는지 확인하고 없으면 생성
              // 있으면 본인인증 여부를 확인하고 인증되지 않았으면 본인인증 페이지로 이동 | 인증되었으면 메인페이지로 이동

              // 디버그용 이동
            },
            child: const Text('Google'),
          ),
        ],
      )),
    ));
  }
}
