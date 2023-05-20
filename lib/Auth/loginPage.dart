import 'package:flutter/material.dart';
import 'package:life_research/Auth/PhoneAuth.dart';
//pages
import 'package:life_research/Auth/RegisterPage.dart';
import 'package:life_research/MainPage/MainPage.dart'; // 메인페이지로 이동
//plugins
import 'package:firebase_auth/firebase_auth.dart'; // 사용자 인증
import 'package:cloud_firestore/cloud_firestore.dart'; // 데이터베이스
import 'package:google_sign_in/google_sign_in.dart'; // 구글 로그인

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // 컨트롤러 추가
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  FirebaseFirestore userDB = FirebaseFirestore.instance; // 유저정보 데이터베이스
  late String baseUserUid; // 로그인한 유저의 uid

  Future<void> loginUser() async {
    await FirebaseAuth.instance
        .signInWithEmailAndPassword(
            email: _emailController.text, password: _passwordController.text)
        .catchError((e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    });
    baseUserUid = FirebaseAuth.instance.currentUser!.uid.toString();
    print("asdasdasdadas" + baseUserUid);
  }

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
            print('본인인증 됨 정보제공 동의함 => 메인페이지로 이동');
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => MainPage()));
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
          MaterialPageRoute(builder: (context) => PhoneAuth(baseUserUid)),
        );
      }
    } else {
      print("로그인안함");
    }
    // User콜렉션에 기본 유저정보가 있는지 확인하고 없으면 생성
    // 있으면 본인인증 여부를 확인하고 인증되지 않았으면 본인인증 페이지로 이동 | 인증되었으면 메인페이지로 이동
  }
//if 로그인
  //  if 유저정보 있으면
  //    if 본인인증 되어있으면
  //      메인페이지로 이동
  //    else
  //      본인인증 페이지로 이동
  //  else
  //    유저정보 생성
  //    본인인증 페이지로 이동
  //else
  //  로그인 페이지로 이동

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
            controller: _emailController,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Email',
            ),
          ),
          TextField(
            //컨트롤러 추가
            controller: _passwordController,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Password',
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                onPressed: () {
                  //register
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const RegisterPage()),
                  );
                },
                child: const Text('Register'),
              ),
              TextButton(
                onPressed: () async {
                  // FirebaseAuth.instance.signInWithEmailAndPassword(
                  //     email: _emailController.text,
                  //     password: _passwordController.text);
                  // _checkUser();
                  // FirebaseAuth.instance.signOut();
                  //로그인 -> baseUserUid에 로그인한 유저의 uid 저장 -> _checkUser()로 유저정보 확인
                  print(FirebaseAuth.instance.currentUser);
                  await loginUser();
                  _checkUser();
                },
                child: const Text('Login'),
              ),
            ],
          ),
          const Text('Start with social'),
          OutlinedButton(
            onPressed: () async {
              // 구글 로그인 버튼 클릭 시
              await signInWithGoogle(); // 구글 회원가입 OR 로그인
              setState(() {
                baseUserUid = FirebaseAuth.instance.currentUser!.uid.toString();
                print(baseUserUid);
              }); // 화면 갱신
              _checkUser(); // 유저정보 확인
            },
            child: const Text('Google'),
          ),
        ],
      )),
    ));
  }
}
