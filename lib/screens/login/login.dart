import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:bmbasket/bloc/provider/UserProvider.dart';
import 'package:bmbasket/screens/home/home.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bmbasket/bloc/model/data.dart';

class Login extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<Login> {
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  FirebaseAuth firebase = FirebaseAuth.instance;
  GoogleSignIn googleSignIn = GoogleSignIn();
  String userName;
  String userEmail;
  String userImageUrl;
  String phoneNo, verificationId, smsCode;
  bool codeSent = false;
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        body: Container(
          child: Stack(
            children: [
              Positioned(
                top: -MediaQuery.of(context).size.height * .25,
                right: -MediaQuery.of(context).size.width * .4,
                child: BezierContainer(),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(height: height * .2),
                      Column(
                        children: [
                          SizedBox(
                            height: 20,
                          ),
                          Image.asset('assets/icons/AppIcon.jpeg'),
                        ],
                      ),
                      SizedBox(height: height * .05),
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              'Phone Number',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 15),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            TextField(
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                fillColor: Color(0xfff3f3f4),
                                filled: true,
                              ),
                              onChanged: (val) {
                                setState(() {
                                  val = '+91 ' + val;
                                  this.phoneNo = val;
                                  Provider.of<UserProvider>(context,
                                          listen: false)
                                      .ChangecontactNumber(phoneNo);
                                });
                              },
                            )
                          ],
                        ),
                      ),
                      codeSent
                          ? Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(25),
                                  border: Border.symmetric(),
                                  color: Colors.white,
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Center(
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: TextField(
                                            keyboardType: TextInputType.number,
                                            textAlign: TextAlign.center,
                                            decoration: InputDecoration(
                                                fillColor: Colors.black,
                                                hintText: 'Enter OTP',
                                                hintStyle: TextStyle(
                                                  color: Colors.black,
                                                )),
                                            maxLengthEnforced: false,
                                            onChanged: (val) {
                                              setState(() {
                                                this.smsCode = val;
                                              });
                                            },
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          : Container(),
                      MaterialButton(
                        onPressed: () {
                          codeSent
                              ? AuthService()
                                  .signInWithOTP(smsCode, verificationId)
                              : verifyPhone(phoneNo);
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.5,
                          padding: EdgeInsets.symmetric(vertical: 15),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5)),
                              boxShadow: <BoxShadow>[
                                BoxShadow(
                                    color: Colors.grey.shade200,
                                    offset: Offset(2, 4),
                                    blurRadius: 5,
                                    spreadRadius: 2)
                              ],
                              gradient: LinearGradient(
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                  colors: [
                                    Color(0xff38ef7d),
                                    Color(0xff11998e)
                                  ])),
                          child: Text(
                            'Verify',
                            style: TextStyle(fontSize: 20, color: Colors.white),
                          ),
                        ),
                      ),
                      SizedBox(height: height * .03),
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 10),
                        child: Row(
                          children: <Widget>[
                            SizedBox(
                              width: 20,
                            ),
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                child: Divider(
                                  thickness: 1,
                                ),
                              ),
                            ),
                            Text('or'),
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                child: Divider(
                                  thickness: 1,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 20,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: height * .03),
                      // sign in with google
                      Container(
                        child: MaterialButton(
                          onPressed: () async {
                            if (await signInwithGoogle() != false) {
                              Navigator.of(context).push(
                                  MaterialPageRoute(builder: (_) => Home()));
                            }
                          },
                          child: Container(
                            width: size.width * 0.6,
                            padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: Row(
                              children: [
                                Image.asset(
                                  "assets/icons/googleIcon.png",
                                  width: 50,
                                ),
                                SizedBox(width: 5),
                                Text('SignIn with Google')
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> verifyPhone(phoneNo) async {
    final PhoneVerificationCompleted verified = (AuthCredential authResult) {
      AuthService().signIn(phoneNo);
    };
    final PhoneVerificationFailed verificationFailed =
        (FirebaseAuthException authException) {
      print('${authException.message}');
    };

    final PhoneCodeSent smsSent = (String verId, [int forceResend]) {
      this.verificationId = verId;
      setState(() {
        this.codeSent = true;
      });
    };

    final PhoneCodeAutoRetrievalTimeout autoTimeout = (String verId) {
      this.verificationId = verId;
    };

    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phoneNo,
      verificationCompleted: verified,
      verificationFailed: verificationFailed,
      codeSent: smsSent,
      codeAutoRetrievalTimeout: autoTimeout,
      timeout: const Duration(seconds: 5),
    );
  }

  signInwithGoogle() async {
    await Firebase.initializeApp();
    final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;
    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    final UserCredential authResult =
        await firebaseAuth.signInWithCredential(credential);
    final User user = authResult.user;

    if (user != null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString("displayname", user.displayName);
      prefs.setString("email", user.email);
      prefs.setString("phone", user.phoneNumber);
      prefs.setString("userid", user.uid);
      prefs.setBool("authtoken", true);
      setState(() {
        displayName = user.displayName;
        email = user.email;
        phoneNumber = user.phoneNumber;
        uid = user.uid;
        isloggen = true;
        userData = user;
      });

      // if (user.displayName != null) {
      //   Provider.of<UserProvider>(context, listen: false)
      //       .Changeusername(user.displayName);
      // }
      // if (user.email != null) {
      //   Provider.of<UserProvider>(context, listen: false)
      //       .ChangeuserEmail(user.email);
      // }
      assert(user.displayName != null);
      assert(user.email != null);
      assert(!user.isAnonymous);
      assert(await user.getIdToken() != null);
      final User currentUser = firebaseAuth.currentUser;
      assert(user.uid == currentUser.uid);
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => Home()));
    }
  }
}

class AuthService {
  FirebaseAuth firebase = FirebaseAuth.instance;

  handleAuth() {
    return StreamBuilder(
        stream: FirebaseAuth.instance.idTokenChanges(),
        builder: (BuildContext context, snapshot) {
          if (snapshot.hasData) {
            //log(snapshot.runtimeType.toString());
            //log('1');
            return Home();
          } else {
            //log('2');
            return Login();
          }
        });
  }

  //Sign out
  signOut() {
    FirebaseAuth.instance.signOut();
  }

  //SignIn
  signIn(AuthCredential authCreds) {
    //log('4');
    FirebaseAuth.instance.signInWithCredential(authCreds);
  }

  signInWithOTP(smsCode, verId) {
    //log('3');
    AuthCredential authCreds =
        PhoneAuthProvider.credential(verificationId: verId, smsCode: smsCode);
    signIn(authCreds);
  }
}

class BezierContainer extends StatelessWidget {
  const BezierContainer({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Transform.rotate(
      angle: -5 / 3.5,
      child: ClipPath(
        clipper: ClipPainter(),
        child: Container(
          height: MediaQuery.of(context).size.height * .5,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xff38ef7d), Color(0xff11998e)])),
        ),
      ),
    ));
  }
}

class ClipPainter extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var height = size.height;
    var width = size.width;
    var path = new Path();

    path.lineTo(0, size.height);
    path.lineTo(size.width, height);
    path.lineTo(size.width, 0);

    /// [Top Left corner]
    var secondControlPoint = Offset(0, 0);
    var secondEndPoint = Offset(width * .2, height * .3);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondEndPoint.dx, secondEndPoint.dy);

    /// [Left Middle]
    var fifthControlPoint = Offset(width * .3, height * .5);
    var fiftEndPoint = Offset(width * .23, height * .6);
    path.quadraticBezierTo(fifthControlPoint.dx, fifthControlPoint.dy,
        fiftEndPoint.dx, fiftEndPoint.dy);

    /// [Bottom Left corner]
    var thirdControlPoint = Offset(0, height);
    var thirdEndPoint = Offset(width, height);
    path.quadraticBezierTo(thirdControlPoint.dx, thirdControlPoint.dy,
        thirdEndPoint.dx, thirdEndPoint.dy);

    path.lineTo(0, size.height);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    // TODO: implement shouldReclip
    return true;
  }
}
