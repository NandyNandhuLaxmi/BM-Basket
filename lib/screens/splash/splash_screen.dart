import 'package:bmbasket/bloc/model/data.dart';
import 'package:bmbasket/screens/home/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:splashscreen/splashscreen.dart';
import 'package:firebase_core/firebase_core.dart';

void main() {
  // runApp(
  //   MultiProvider(
  //     providers: [
  //       ChangeNotifierProvider(create: (context)=>UserProvider()),
  //     ],
  //     child: Scaffold(
  //       body: Splash_Screen(),
  //     ),
  //   ),
  // );
}

class Splash_Screen extends StatefulWidget {
  @override
  _Splash_ScreenState createState() => _Splash_ScreenState();
}

class _Splash_ScreenState extends State<Splash_Screen> {
  getShared() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool authSignedIn = prefs.getBool('authtoken') ?? false;
    print(authSignedIn);
    final _auth = FirebaseAuth.instance;

    final User user = _auth.currentUser;

    if (authSignedIn == true) {
      if (user != null) {
        setState(() {
          uid = user.uid;
          displayName = user.displayName;
          email = user.email;
          userData = user;
          isloggen = true;
        });
      }
    }
  }
getcart()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if(prefs.getStringList("cart") != null){
      setState(() {
       cart =  prefs.getStringList("cart");
       // cartitemlist = prefs.getStringList("cartitemlist");
      });

    }
}
  @override
  void initState() {
    super.initState();
    getShared();
    getcart();
  }

  @override
  Widget build(BuildContext context) {
    return SplashScreen(
      seconds: 2,
      // navigateAfterSeconds: FutureBuilder(
      //     // Initialize FlutterFire
      //     future: Firebase.initializeApp(),
      //     builder: (context, snapshot) {
      //       // Check for errors
      //       if (snapshot.hasError) {
      //         return null;
      //       }
      //       // Once complete, show your application
      //       if (snapshot.connectionState == ConnectionState.done){
      //         //return AuthService().handleAuth();
      //       }
      //       // Otherwise, show something whilst waiting for initialization to complete
      //       return null;
      //     },
      //   ),
      navigateAfterSeconds: Home(),
      title: Text(
        'Welcome',
        style: TextStyle(
            color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold),
      ),
      backgroundColor: Colors.green,
      photoSize: 100,
    );
  }
}
