import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:life_research/Auth/PersonalInfoPage.dart';

class PhoneAuth extends StatefulWidget {
  final String baseUserUid;
  const PhoneAuth(this.baseUserUid, {Key? key}) : super(key: key);

  @override
  State<PhoneAuth> createState() => _PhoneAuthState();
}

class _PhoneAuthState extends State<PhoneAuth> {
  final TextEditingController _phone1 = TextEditingController(); // 전화번호 010
  final TextEditingController _phone2 = TextEditingController(); // 전화번호 0000(1)
  final TextEditingController _phone3 = TextEditingController(); // 전화번호 0000(2)
  final TextEditingController _authNumber = TextEditingController(); //인증번호 입력
  late String _myPhoneNumber;
  bool _isCalled = false; // 인증번호 전송 버튼을 눌렀는가? 인증번호 전송박스를 표시하기 위해
  bool _isVerified = false; // 본인인증이 되었는가?
  bool _isOver14 = false; // 만 14세 이상인가?
  bool _nextButton = false; // 다음 버튼 활성화
  bool _canVerified = false; // 인증번호를 받을 수 있는가?
  bool _canSendAuth = false; // 인증번호를 보낼 수 있는가?
  late String _verificationId; // 인증번호
  FirebaseFirestore userDB = FirebaseFirestore.instance; // 유저정보 데이터베이스

  void infoAgree() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('알림'),
            content: Text('개인정보 제공 동의가 필요합니다.'),
            actions: [
              TextButton(
                  onPressed: () {
                    print("개인정보 제공 동의 없으면 로그인 불가");
                    Navigator.pop(context);
                  },
                  child: Text('취소')),
              TextButton(
                  onPressed: () {
                    userDB
                        .collection('users')
                        .doc(widget.baseUserUid)
                        .update({'infoAgree': true});
                    Navigator.pop(context);
                  },
                  child: Text('확인'))
            ],
          );
        });
  }

  @override
  void initState() {
    super.initState();
    var userdb = userDB.collection('users').doc(widget.baseUserUid).get();
    userdb.then((value) {
      // 정보 제공 동의여부
      if (value['infoAgree'] == true) {
        print('정보 제공 동의함');
        //동의했으면
      } else {
        //동의하지 않았으면
        print('정보 제공 미동의');
        infoAgree();
      }
    });
  }

  Widget isCalled(isCalled) {
    // 인증번호 전송 박스
    if (isCalled == true) {
      return Container(
        margin: const EdgeInsets.all(8),
        child: Row(
          children: [
            Text('인증번호'),
            Expanded(
              child: Container(
                margin: EdgeInsets.all(8),
                child: TextField(
                  controller: _authNumber,
                  keyboardType: TextInputType.phone,
                  autocorrect: false,
                  maxLength: 6,
                  //if textfield is full go to next textfield
                  onChanged: (control) {
                    _authNumber.text.length == 6
                        ? setState(() {
                            _canSendAuth = true;
                          })
                        : setState(() {
                            _canSendAuth = false;
                          });
                    if (control.length == 6) {
                      // 최대 길이에 도달 다음 Textfield로 포커스 이동
                    }
                  },
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                      counterText: '',
                      hintText: '인증번호',
                      //phone number type
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      )),
                ),
              ),
            ),
            ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        _canSendAuth ? Colors.blue : Colors.grey.shade300)),
                onPressed: () {
                  setState(() {
                    FirebaseAuth auth = FirebaseAuth.instance;
                    // 인증번호 확인만 하고 로그인은 하지않기
                    PhoneAuthCredential credential = //credential 은 자격증명
                        PhoneAuthProvider.credential(
                            verificationId: _verificationId,
                            smsCode: _authNumber.text);

                    auth.signInWithCredential(credential).then((value) {
                      // 인증번호 확인
                      setState(() {
                        _isVerified = true;
                        _nextButton = _isVerified && _isOver14 == true;
                      });
                      print("인증번호 확인");
                    }).catchError((e) {
                      print(e);
                    });

                    // 보낸 인증번호와 _authNumber.text가 같은지 확인
                    // _verificationId == _authNumber.text
                    //     ? print("승인")
                    //     : print(
                    //         "인증번호가 틀립니다.${_authNumber.text}, $_verificationId");

                    _nextButton = _isVerified && _isOver14 == true;
                  });
                  //verified _authNumber.text == 인증번호
                },
                child: Text('인증하기'))
          ],
        ),
      );
    } else {
      return const SizedBox();
    }
  }

  Future<void> phoenAuth(phoneNumber) async {
    // 인증번호 보내기
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: '+82$phoneNumber', // 전화번호
      verificationCompleted: (PhoneAuthCredential credential) {
        // 인증 완료
        print(credential);
      }, // 인증 완료
      verificationFailed: (FirebaseAuthException e) {
        // 인증 실패

        print(e);
      }, // 인증 실패
      codeSent: (String verificationId, int? resendToken) {
        setState(() {
          _verificationId = verificationId;
        });
        // 인증번호 전송
        print("인증번호 전송");
      }, // 인증번호 전송
      codeAutoRetrievalTimeout: (String verificationId) {
        print("입력시간 초과");
      }, // 인증번호 입력시간 초과
    );
  }

  Widget phoneBox(flexNumber, index) {
    var control = index == 1
        ? _phone1
        : index == 2
            ? _phone2
            : _phone3;
    return Expanded(
      flex: flexNumber,
      child: Container(
        margin: const EdgeInsets.all(8),
        child: TextField(
          controller: control,
          keyboardType: TextInputType.phone,
          autocorrect: false,
          maxLength: flexNumber == 3 ? 3 : 4,
          //if textfield is full go to next textfield
          onChanged: (control) {
            _phone1.text.length == 3 &&
                    _phone2.text.length == 4 &&
                    _phone3.text.length == 4
                ? setState(() {
                    _canVerified = true;
                  })
                : setState(() {
                    _canVerified = false;
                  });
            if (control.length == flexNumber) {
              // 최대 길이에 도달 다음 Textfield로 포커스 이동
            }
          },
          textAlign: TextAlign.center,
          decoration: InputDecoration(
              counterText: '',
              hintText: flexNumber == 3 ? '010' : '0000',
              //phone number type
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              )),
        ),
      ),
    );
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
              child: Container(
            margin: const EdgeInsets.all(8),
            child: Column(
              children: [
                SizedBox(
                  height: 30,
                ),
                Row(
                  children: [
                    const Text('휴대폰 번호'),
                    phoneBox(3, 1), // 상자 크기, 인덱스
                    phoneBox(4, 2),
                    phoneBox(4, 3),
                    ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                _canVerified
                                    ? Colors.blue
                                    : Colors.grey.shade300)),
                        //textfield 박스가 모두 최대 길이에 도달하면 _canVerified = true; 로 변경

                        onPressed: () {
                          _phone1.text.length != 3 ||
                                  _phone2.text.length != 4 ||
                                  _phone3.text.length != 4
                              ? null
                              : setState(() {
                                  _myPhoneNumber =
                                      '${_phone1.text}${_phone2.text}${_phone3.text}';
                                  _isCalled =
                                      true; // 인증번호 전송 버튼을 눌렀는가? 인증번호 전송박스를 표시하기 위해
                                  phoenAuth(_myPhoneNumber);
                                  //인증번호 보내기
                                });
                        },
                        child: Container(
                          child: const Text('인증번호\n발송'),
                        ))
                  ],
                ),
                isCalled(_isCalled), // 인증번호 전송 박스
                // 컨테이너(체크박스, 만14세 이상이신가요?)
                Container(
                  margin: const EdgeInsets.all(8),
                  child: Row(
                    children: [
                      Checkbox(
                          value: _isOver14,
                          onChanged: (value) {
                            setState(() {
                              _nextButton = _isVerified && value! == true; //
                              _isOver14 = value!;
                            });
                          }),
                      const Text('만 14세 이상이신가요?'),
                    ],
                  ),
                ),
              ],
            ),
          )),
          bottomSheet: Container(
            margin: const EdgeInsets.all(8),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            _nextButton ? Colors.blue : Colors.grey.shade300)),
                    onPressed: () {
                      (_isVerified && _isOver14) == true
                          ? userDB
                              .collection('users')
                              .doc(widget.baseUserUid)
                              .get()
                              .then((value) => value['infoAgree'] == true
                                  ? Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              PersonalInfoPage(
                                                  widget.baseUserUid,
                                                  _myPhoneNumber)))
                                  : infoAgree())
                          : print("인증번호 확인 및 만 14세 이상이 아님");
                    },
                    child: const Text('다음'),
                  ),
                ),
              ],
            ),
          )),
    );
  }
}

void next() {
  // 휴대폰 인증 계정을 삭제 하고
  // 다음페이지로
}
