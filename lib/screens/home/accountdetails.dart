import 'package:bmbasket/bloc/model/data.dart';
import 'package:bmbasket/screens/home/profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';

class AccountDetails extends StatefulWidget {
  @override
  _AccountDetailsState createState() => _AccountDetailsState();
}

class _AccountDetailsState extends State<AccountDetails> {
  final databaseReference = FirebaseFirestore.instance;
  final firebaseuser = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          alignment: Alignment.topCenter,
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Container(
                height: 80,
                width: 80,
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: NetworkImage((userData.photoURL != null)
                          ? userData.photoURL
                          : "url")),
                  shape: BoxShape.circle,
                ),
              ),
              Text((userData.displayName != null) ? userData.displayName : "",
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 18)),
              Text((userData.email != null) ? userData.email : "",
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      fontSize: 18)),
              SizedBox(height: 15),
              InkWell(
                child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                        color: Color(0xFFE2E2E2),
                        borderRadius: BorderRadius.circular(10.0),
                        boxShadow: [
                          BoxShadow(
                              offset: Offset(10, 10),
                              color: Colors.black45.withOpacity(0.35),
                              blurRadius: 20.0),
                          BoxShadow(
                              offset: Offset(-10, -10),
                              color: Colors.white,
                              blurRadius: 20.0),
                        ]),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Address',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                                fontSize: 15)),
                        Icon(EvaIcons.edit2)
                      ],
                    )),
                onTap: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AddressFormScreen()));
                },
              ),
              Row(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height * .4,
                    // width: double.minPositive,
                    child: FutureBuilder<DocumentSnapshot>(
                      future: databaseReference
                          .collection("users")
                          .doc(firebaseuser.uid)
                          .get(),
                      builder: (BuildContext context,
                          AsyncSnapshot<DocumentSnapshot> snapshot) {
                        if (snapshot.hasError) {
                          return Text("Something went wrong");
                        }
                        if (snapshot.data == null) {
                          return Center(
                            child: Text("LOGIN AND COME BACK"),
                          );
                        }

                        if (snapshot.connectionState == ConnectionState.done) {
                          Map<String, dynamic> data = snapshot.data.data();
                          return Container(
                            child: Center(
                              child: Container(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text("${data['address']}", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                                    SizedBox(width: 5),
                                    Text("${data['city']}"),
                                    SizedBox(width: 5),
                                    Text("${data['pincode']}"),
                                    SizedBox(width: 5),
                                    // Text("${data['phone']}"),
                                    // SizedBox(width: 5),
                                  ],
                                ),
                              ),
                              // child: DataTable(
                              //   columns: [
                              //     DataColumn(label: Text("Name ")),
                              //     DataColumn(
                              //         label: Text("${data['username']}")),
                              //   ],
                              //   rows: [
                              //     DataRow(cells: [
                              //       DataCell(Text("city")),
                              //       DataCell(Text("${data['city']}"))
                              //     ]),
                              //     DataRow(cells: [
                              //       DataCell(Text("phone")),
                              //       DataCell(Text("${data['phone']}"))
                              //     ]),
                              //     DataRow(cells: [
                              //       DataCell(Text("pincode")),
                              //       DataCell(Text("${data['pincode']}"))
                              //     ]),
                              //     DataRow(cells: [
                              //       DataCell(Text("address")),
                              //       DataCell(Text("${data['address']}"))
                              //     ]),
                              //   ],
                              // ),
                            ),
                          );
                        }

                        return Text("loading");
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
