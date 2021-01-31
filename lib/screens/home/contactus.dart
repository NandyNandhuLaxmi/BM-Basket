import 'package:bmbasket/screens/home/home.dart';
import 'package:contactus/contactus.dart';
import 'package:flutter/material.dart';

class ContactUsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text(
            'Contact Us',
            style: TextStyle(
              color: Color(0xFFFFFFFF),
              fontFamily: 'DancingScript',
              fontSize: 25,
            ),
          ),
          leading: IconButton(
            icon: Icon(Icons.arrow_back,),
            alignment: Alignment.centerLeft,
            tooltip: 'Back',
            onPressed: () {
              Navigator.pushReplacement(context, MaterialPageRoute(
                builder: (context)=>Home(),
              ));
            },
          ),

          backgroundColor: Colors.green,
        ),
        backgroundColor: Colors.white,
        body: Center(
          child: ContactUs(
            cardColor: Colors.white,
            textColor: Colors.green,
            logo: AssetImage('assets/icons/AppIcon.jpeg'),
            email: 'sara969696@gmail.com',
            companyName: 'BM Basket Farm',
            companyColor: Colors.green, taglineColor: null,
          ),
        ),
      ),
    );
  }
}
