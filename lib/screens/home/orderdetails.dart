import 'package:bmbasket/bloc/model/data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:bmbasket/screens/home/home.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrderDetails extends StatefulWidget {
  @override
  _OrderDetailsState createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
  List<String> order = [];
  getShared() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getStringList("order") != null) {
      setState(() {
        order = prefs.getStringList("order");
      });
    } else {}
  }

  @override
  void initState() {
    super.initState();
    getShared();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.green,
          title: Text(
            'Order Historys',
            style: TextStyle(
              color: Color(0xFFFFFFFF),
              fontFamily: 'DancingScript',
              fontSize: 25,
            ),
          ),
          leading: IconButton(
              icon: Icon(EvaIcons.arrowBack, color: Color(0xFFFFFFFF)),
              onPressed: () {
                Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (context) => Home()));
              }),
        ),
        body: (isloggen == true)
            ? Container(
                child: FutureBuilder<DocumentSnapshot>(
                  future: FirebaseFirestore.instance
                      .collection("local")
                      .doc(FirebaseAuth.instance.currentUser.uid)
                      .get(),
                  builder: (BuildContext context,
                      AsyncSnapshot<DocumentSnapshot> snapshot) {
                    if (snapshot.hasError) {
                      return Text("Something went wrong");
                    }

                    if (snapshot.connectionState == ConnectionState.done) {
                      Map<String, dynamic> data = snapshot.data.data();
                      return ListView.builder(
                        itemCount: data.length,
                        itemBuilder: (BuildContext context, int index) {
                          var remaindata =
                              data["data" + (index + 1).toString()][1];
                          return Card(
                            child: Column(
                              children: [
                                ListTile(
                                  title:
                                      Text("order : " + (index + 1).toString()),
                                  subtitle: Text(
                                      (data["data" + (index + 1).toString()][0])
                                          .toString()),
                                ),
                                DataTable(
                                  columns: <DataColumn>[
                                    DataColumn(
                                      label: Text(
                                        'Name',
                                        style: TextStyle(
                                            fontStyle: FontStyle.italic),
                                      ),
                                    ),
                                    DataColumn(
                                      label: Text(
                                        remaindata['username'],
                                        style: TextStyle(
                                            fontStyle: FontStyle.italic),
                                      ),
                                    ),
                                  ],
                                  rows: <DataRow>[
                                    DataRow(
                                      cells: <DataCell>[
                                        DataCell(Text('totalprice')),
                                        DataCell(
                                            Text(remaindata['totalprice'])),
                                      ],
                                    ),
                                    DataRow(
                                      cells: <DataCell>[
                                        DataCell(Text('phone')),
                                        DataCell(Text(remaindata['phone']))
                                      ],
                                    ),
                                    DataRow(
                                      cells: <DataCell>[
                                        DataCell(Text('Address')),
                                        DataCell(Text(remaindata['address'])),
                                      ],
                                    ),
                                    DataRow(
                                      cells: <DataCell>[
                                        DataCell(Text('type')),
                                        DataCell(Text(remaindata['type'])),
                                      ],
                                    ),
                                  ],
                                )
                              ],
                            ),
                          );
                        },
                      );
                    }

                    return Text("loading");
                  },
                ),
              )
            : Container());
  }
}
