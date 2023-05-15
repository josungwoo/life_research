import 'package:flutter/material.dart';
import 'package:life_research/MainPage/MainPage.dart';
// import 'package:firebase_auth/firebase_auth.dart'; // 사용자 인증 관련

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
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
          const TextField(
            // 컨트롤러 추가
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Email',
            ),
          ),
          const TextField(
            //컨트롤러 추가

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
                  // 로그인 버튼 클릭 시
                  // FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
                },
                child: const Text('Login'),
              ),
            ],
          ),
          const Text('Start with social'),
          OutlinedButton(
            onPressed: () {
              // 구글 로그인 버튼 클릭 시
              // FirebaseAuth.instance.signInWithPopup(GoogleAuthProvider());
              // 디버그용 이동
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const MainPage()),
              );
            },
            child: const Text('Google'),
          ),
        ],
      )),
    ));
  }
}
