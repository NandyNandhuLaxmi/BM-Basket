import 'package:bmbasket/bloc/model/data.dart';
import 'package:bmbasket/screens/home/profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:bmbasket/screens/home/cart.dart';
import 'package:bmbasket/screens/home/home.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:sweetsheet/sweetsheet.dart';

class CheckOut extends StatefulWidget {
  @override
  _CheckOutState createState() => _CheckOutState();
}

class _CheckOutState extends State<CheckOut> {
  count(item) {
    int count = 1;
    cart.forEach((element) {
      if (element == item) {
        count++;
      }
    });
    print("returnis" + count.toString());
    return count;
  }

  static const duration = const Duration(seconds: 1);

  int secondsPassed = 0;
  bool isActive = false;
  Timer timer;

  final SweetSheet _sweetSheet = SweetSheet();

  void handleTick() {
    if (isActive) {
      setState(() {
        secondsPassed = secondsPassed + 1;
      });
    }
  }

  plus(index) {
    setState(() {
      cart.add(cartitemlist[index]);
    });

    int value = count(cartitemlist[index]);

    setState(() {
      cartdata[cartitemlist[index]] = value;
    });
  }

  plusdatabase(index) async {
    final databaseReference = FirebaseFirestore.instance;
    final firebaseuser = FirebaseAuth.instance.currentUser;
    setState(() {
      cart.add(cartitemlist[index]);
    });

    int value = count(cartitemlist[index]);

    setState(() {
      cartdata[cartitemlist[index]] = value;
    });

    var a = await FirebaseFirestore.instance
        .collection('cart')
        .doc(firebaseuser.uid)
        .get();
    int c = count(cartitemlist[index]);

    if (a.exists) {
      print(a);
      await databaseReference
          .collection("cart")
          .doc(firebaseuser.uid)
          .update({cartitemlist[index]: c}).then((value) => print("Success"));
    }
    if (!a.exists) {
      await databaseReference
          .collection("cart")
          .doc(firebaseuser.uid)
          .set({cartitemlist[index]: c}).then((value) => print("Success"));
    }
  }

  minus(index) {
    setState(() {
      cart.remove(cartitemlist[index]);
    });

    int value = count(cartitemlist[index]);

    setState(() {
      cartdata[cartitemlist[index]] = value;
    });
  }

  minusdatabase(index) async {
    final databaseReference = FirebaseFirestore.instance;
    final firebaseuser = FirebaseAuth.instance.currentUser;
    setState(() {
      cart.remove(cartitemlist[index]);
    });

    int value = count(cartitemlist[index]);

    setState(() {
      cartdata[cartitemlist[index]] = value;
    });
    int c = count(cartitemlist[index]);
    await databaseReference
        .collection("cart")
        .doc(firebaseuser.uid)
        .update({cartitemlist[index]: c}).then((value) => print("Success"));
  }

  totalamount() {
    int rate = 0;
    for (int i = 0; i < cartitemlist.length; i++) {
      rate = rate + (int.parse(price[cartitemlist[i]]) * cartdata[cartitemlist[i]]);
    }
    return rate;
  }

  String name = "";
  String city = "";
  String phone = "";
  String pincode = "";
  String address = "";
  getaddress() async {
    if (isloggen == true) {
      final firebaseuser = FirebaseAuth.instance.currentUser;
      var data = await FirebaseFirestore.instance
          .collection('users')
          .doc(firebaseuser.uid)
          .get();
      setState(() {
        name = data['username'];
        city = data['city'];
        phone = data['phone'];
        pincode = data['pincode'];
        address = data['address'];
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getaddress();
  }

  String valueindex = "";
  @override
  Widget build(BuildContext context) {
    if (timer == null)
      timer = Timer.periodic(duration, (Timer t) {
        handleTick();
      });
    UserAddress userAddress = UserAddress();
    int seconds = secondsPassed * 60;
    int minutes = secondsPassed ~/ 60;
    int hours = secondsPassed ~/ (60 * 60);
    return WillPopScope(
      onWillPop: () => Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => Cart())),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.green,
          title: Text(
            'Check Out',
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
                    context, MaterialPageRoute(builder: (context) => Cart()));
              }),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                alignment: Alignment.topCenter,
                padding: const EdgeInsets.all(10.0),
                margin: const EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                    color: Color(0xFFFFFFFF),
                    borderRadius: BorderRadius.circular(20.0),
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
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomTextContainer(
                            label: 'HRS',
                            value: hours.toString().padLeft(2, '0')),
                        CustomTextContainer(
                            label: 'MIN',
                            value: minutes.toString().padLeft(2, '0')),
                        CustomTextContainer(
                            label: 'SEC',
                            value: seconds.toString().padLeft(2, '0')),
                      ],
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 20),
                      child: RaisedButton(
                        color: Colors.yellowAccent,
                        child: Text(
                          isActive ? 'SHOP ALL DEALS' : 'END ALL DEALS',
                          style: TextStyle(
                              color: Color(0xFF000000),
                              fontWeight: FontWeight.bold),
                        ),
                        onPressed: () {
                          setState(() {
                            isActive = !isActive;
                          });
                        },
                      ),
                    )
                  ],
                ),
              ),
              Container(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          alignment: Alignment.topLeft,
                          margin: EdgeInsets.only(
                              left: 12.0, top: 5.0, right: 0.0, bottom: 5.0),
                          child: Text(
                            'Delivery Address',
                            style: TextStyle(
                                color: Colors.black87,
                                fontWeight: FontWeight.bold,
                                fontSize: 20.0),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(10.0),
                          child: RaisedButton(
                            // borderSide: BorderSide(color: Colors.amber.shade500),
                            color: Colors.red,
                            hoverColor: Colors.black,
                            shape: RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(30.0)),
                            child: const Text('Price below 299'),
                            textColor: Colors.white,
                            onPressed: () {
                              _sweetSheet.show(
                                context: context,
                                title: Text("BM Basket Policy",
                                    style: TextStyle(color: Color(0xFF000000))),
                                description: Text(
                                    "Popup on cart page saying minimum order value is 299 (Only when price is below 299)",
                                    style: TextStyle(color: Color(0xff2D3748))),
                                color: CustomSheetColor(
                                  main: Colors.white,
                                  accent: Colors.green,
                                  icon: Colors.green,
                                ),
                                icon: Icons.local_shipping,
                                positive: SweetSheetAction(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  title: 'CONTINUE',
                                ),
                                negative: SweetSheetAction(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  title: 'CANCEL',
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                    Container(
                      width: double.infinity,
                      // height: 150,
                      margin: const EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                          color: Color(0xFFFFFFFF),
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
                      child: Center(
                        child: Container(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            children: [
                              Container(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(address, style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                                    SizedBox(width: 5),
                                    Text(city),
                                    SizedBox(width: 5),
                                    Text(pincode),
                                    SizedBox(width: 5),
                                    // Text(phone),
                                  ],
                                ),
                                // child: Center(
                                //   child: DataTable(
                                //     columns: [
                                //       DataColumn(label: Text("Name ")),
                                //       DataColumn(label: Text(name)),
                                //     ],
                                //     rows: [
                                //       DataRow(cells: [
                                //         DataCell(Text("city")),
                                //         DataCell(Text(city))
                                //       ]),
                                //       DataRow(cells: [
                                //         DataCell(Text("phone")),
                                //         DataCell(Text(phone))
                                //       ]),
                                //       DataRow(cells: [
                                //         DataCell(Text("pincode")),
                                //         DataCell(Text(pincode))
                                //       ]),
                                //       DataRow(cells: [
                                //         DataCell(Text("address")),
                                //         DataCell(Text(address))
                                //       ]),
                                //     ],
                                //   ),
                                // ),
                              ),
                              RaisedButton(
                                // borderSide: BorderSide(color: Colors.amber.shade500),
                                color: Colors.green,
                                hoverColor: Colors.black,
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                        new BorderRadius.circular(30.0)),
                                child: const Text('Change the Address'),
                                textColor: Colors.white,
                                onPressed: () {
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              AddressFormScreen()));
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Container(
                        alignment: Alignment.topLeft,
                        margin: const EdgeInsets.all(10.0),
                        child: Text('Order Summary',
                            style: TextStyle(
                                color: Color(0xFF000000),
                                fontWeight: FontWeight.bold,
                                fontSize: 20))),
                    Container(
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height * 0.3,
                      margin: const EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                          color: Color(0xFFFFFFFF),
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
                      child: Container(
                          child: (cartitemlist.isNotEmpty)
                              ? ListView.builder(
                                  itemCount: cartitemlist.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    print(cartdata);
                                    return Card(
                                      child: ListTile(
                                        leading: CircleAvatar(
                                          child: Image.network(cartdataimage[
                                              cartitemlist[index]]),
                                          radius: 30,
                                          backgroundColor: Colors.white,
                                        ),
                                        title: Text(cartitemlist[index]),
                                        subtitle: Container(
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              (count(cartitemlist[index]) != 0)
                                                  ? Text("Rs : " +
                                                      (int.parse(price[
                                                                  cartitemlist[
                                                                      index]]) *
                                                              cartdata[
                                                                  cartitemlist[
                                                                      index]])
                                                          .toString() +
                                                      " / ${cartdata[cartitemlist[index]]} kg")
                                                  : Text(
                                                      "Rs : ${price[cartitemlist[index]]} / 1 kg"),
                                              Container(
                                                child: Row(
                                                  children: [
                                                    RaisedButton(
                                                      shape: CircleBorder(),
                                                      color: Colors.green,
                                                        child: Icon(
                                                            EvaIcons.plus, size: 15, color: Color(0xFFFFFFFF)),
                                                        onPressed: () {
                                                          if (isloggen ==
                                                              false) {
                                                            plus(index);
                                                          } else {
                                                            plusdatabase(index);
                                                          }
                                                        }),
                                                    Text((cartdata[cartitemlist[
                                                                index]] !=
                                                            null)
                                                        ? cartdata[cartitemlist[
                                                                index]]
                                                            .toString()
                                                        : "0", style: TextStyle(fontSize: 15.8, fontWeight: FontWeight.w600, color: Colors.black)),
                                                    RaisedButton(
                                                      shape: CircleBorder(),
                                                      color: Colors.green,
                                                        child: Icon(
                                                            EvaIcons.minus, size: 15, color: Color(0xFFFFFFFF)),
                                                        onPressed: () {
                                                          if (isloggen ==
                                                              false) {
                                                            minus(index);
                                                          } else {
                                                            minusdatabase(
                                                                index);
                                                          }
                                                        })
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                )
                              : Center(
                                  child: Text("Add items to to cart"),
                                )),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: RaisedButton(
                              color: Colors.red,
                              hoverColor: Colors.black,
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      new BorderRadius.circular(30.0)),
                              child: const Text('Clear a cart'),
                              textColor: Colors.white,
                              onPressed: () async {
                                if (isloggen == false) {
                                  setState(() {
                                    cart.clear();
                                    cartdata.clear();
                                    cartdataimage.clear();
                                    cartitemlist.clear();
                                    price.clear();
                                  });
                                } else {
                                  setState(() {
                                    cart.clear();
                                    cartdata.clear();
                                    cartdataimage.clear();
                                    cartitemlist.clear();
                                    price.clear();
                                  });
                                  await FirebaseFirestore.instance
                                      .collection("cart")
                                      .doc(
                                          FirebaseAuth.instance.currentUser.uid)
                                      .set({});
                                }
                              },
                            ),
                          ),
                          SizedBox(width: 5),
                          Expanded(
                            child: RaisedButton(
                              color: Colors.green,
                              hoverColor: Colors.black,
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      new BorderRadius.circular(30.0)),
                              child: const Text('Update a cart'),
                              textColor: Colors.white,
                              onPressed: () {
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Home()));
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                              alignment: Alignment.topLeft,
                              margin: const EdgeInsets.all(10.0),
                              child: Text('Amount Payable',
                                  style: TextStyle(
                                      color: Color(0xFF000000),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20))),
                          Text(totalamount().toString(),
                              style: TextStyle(
                                  color: Color(0xFF000000),
                                  fontWeight: FontWeight.w300,
                                  fontSize: 20)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: SafeArea(
          child: BottomAppBar(
            child: Container(
              alignment: Alignment.bottomLeft,
              height: 60.0,
              child: Card(
                child: Column(
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: OutlineButton(
                            borderSide:
                                BorderSide(color: Colors.amber.shade500),
                            shape: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            child: const Text('Cash On Delivery'),
                            textColor: Colors.red,
                            onPressed: () async {
                              if (totalamount() < 299) {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: Text(
                                            "Order price should be greater than 299"),
                                        content:
                                            Text("Go back and add more items"),
                                        actions: [
                                          RaisedButton(
                                            onPressed: () =>
                                                Navigator.of(context).pop(),
                                            child: Text("GO BACK"),
                                          )
                                        ],
                                      );
                                    });
                              } else {
                                if (isloggen == true) {
                                  final databaseReference =
                                      FirebaseFirestore.instance;
                                  final firebaseuser =
                                      FirebaseAuth.instance.currentUser;
                                  await databaseReference
                                      .collection("Orders")
                                      .doc()
                                      .set({
                                    "order": [
                                      cartdata,
                                      {
                                        "username": name,
                                        "address": address,
                                        "phone": phone,
                                        "city": city,
                                        "pincode": pincode,
                                        "totalprice": totalamount().toString(),
                                        "type": "cash on Delivery"
                                      },
                                    ],
                                  });
                                  var a = await databaseReference
                                      .collection("local")
                                      .doc(firebaseuser.uid)
                                      .get();
                                  try {
                                    await databaseReference
                                        .collection("local")
                                        .doc(firebaseuser.uid)
                                        .get()
                                        .then((val) {
                                      setState(() {
                                        if (val.data != null) {
                                          valueindex = "data" +
                                              ((val.data().length) + 1)
                                                  .toString();
                                        } else {
                                          valueindex = "data1";
                                        }
                                      });

                                      return;
                                    });
                                  } catch (e) {
                                    setState(() {
                                      valueindex = "data1";
                                    });
                                  }
                                  if (a.exists) {
                                    await databaseReference
                                        .collection("local")
                                        .doc(firebaseuser.uid)
                                        .update({
                                      valueindex.toString(): [
                                        cartdata,
                                        {
                                          "username": name,
                                          "address": address,
                                          "phone": phone,
                                          "city": city,
                                          "pincode": pincode,
                                          "totalprice":
                                              totalamount().toString(),
                                          "type": "cash on Delivery"
                                        },
                                      ],
                                    });
                                  } else {
                                    await databaseReference
                                        .collection("local")
                                        .doc(firebaseuser.uid)
                                        .get()
                                        .then((val) {
                                      print("valueis" +
                                          val.data().length.toString());
                                      return;
                                    });
                                    await databaseReference
                                        .collection("local")
                                        .doc(firebaseuser.uid)
                                        .set({
                                      valueindex.toString(): [
                                        cartdata,
                                        {
                                          "username": name,
                                          "address": address,
                                          "phone": phone,
                                          "city": city,
                                          "pincode": pincode,
                                          "totalprice":
                                              totalamount().toString(),
                                          "type": "cash on Delivery"
                                        },
                                      ],
                                    });
                                  }

                                  _sendOrder(context);
                                }
                              }
                            },
                          ),
                        ),
                        Expanded(
                          child: OutlineButton(
                              borderSide:
                                  BorderSide(color: Colors.amber.shade500),
                              shape: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                              child: const Text('pay now'),
                              textColor: Colors.red,
                              onPressed: () async {
                                if (totalamount() < 299) {
                                   _sweetSheet.show(
                                    context: context,
                                    title: Text("BM Basket Policy",
                                      style: TextStyle(color: Color(0xFF000000))),
                                    description: Text(
                                      "Popup on cart page saying minimum order value is 299 (Only when price is below 299)",
                                      style: TextStyle(color: Color(0xff2D3748))),
                                      color: CustomSheetColor(
                                        main: Colors.white,
                                        accent: Colors.green,
                                        icon: Colors.green,
                                      ),
                                      icon: Icons.local_shipping,
                                      positive: SweetSheetAction(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      title: 'CONTINUE',
                                    ),
                                    negative: SweetSheetAction(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    title: 'CANCEL',
                                   ),
                                  );
                                } else {
                                  if (isloggen == true) {
                                    final databaseReference =
                                        FirebaseFirestore.instance;
                                    final firebaseuser =
                                        FirebaseAuth.instance.currentUser;
                                    await databaseReference
                                        .collection("Orders")
                                        .doc()
                                        .set({
                                      "order": [
                                        cartdata,
                                        {
                                          "username": name,
                                          "address": address,
                                          "phone": phone,
                                          "city": city,
                                          "pincode": pincode,
                                          "totalprice":
                                              totalamount().toString(),
                                          "type": "pay now"
                                        },
                                      ],
                                    });
                                    var a = await databaseReference
                                        .collection("local")
                                        .doc(firebaseuser.uid)
                                        .get();
                                    try {
                                      await databaseReference
                                          .collection("local")
                                          .doc(firebaseuser.uid)
                                          .get()
                                          .then((val) {
                                        setState(() {
                                          if (val.data != null) {
                                            valueindex = "data" +
                                                ((val.data().length) + 1)
                                                    .toString();
                                          } else {
                                            valueindex = "data1";
                                          }
                                        });

                                        return;
                                      });
                                    } catch (e) {
                                      setState(() {
                                        valueindex = "data1";
                                      });
                                    }

                                    if (a.exists) {
                                      await databaseReference
                                          .collection("local")
                                          .doc(firebaseuser.uid)
                                          .update({
                                        valueindex.toString(): [
                                          cartdata,
                                          {
                                            "username": name,
                                            "address": address,
                                            "phone": phone,
                                            "city": city,
                                            "pincode": pincode,
                                            "totalprice":
                                                totalamount().toString(),
                                            "type": "pay now"
                                          },
                                        ],
                                      });
                                    } else {
                                      await databaseReference
                                          .collection("local")
                                          .doc(firebaseuser.uid)
                                          .set({
                                        valueindex.toString(): [
                                          cartdata,
                                          {
                                            "username": name,
                                            "address": address,
                                            "phone": phone,
                                            "city": city,
                                            "pincode": pincode,
                                            "totalprice":
                                                totalamount().toString(),
                                            "type": "pay now"
                                          },
                                        ],
                                      });
                                    }

                                    _sendOrder(context);
                                  }
                                }
                              }),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

_sendOrder(context) {
  showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return Stack(
          children: <Widget>[
            Container(
              height: 30.0,
              width: double.infinity,
              color: Colors.black54,
            ),
            Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  )),
            ),
            Column(
              children: [
                SizedBox(
                  height: 50,
                ),
                Container(
                    child: Column(
                  children: [
                    Text('Thank you for',
                        style: TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.w800,
                            fontSize: 28)),
                    Text('your order',
                        style: TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.w800,
                            fontSize: 28)),
                  ],
                )),
                SizedBox(
                  height: 20,
                ),
                Container(
                    alignment: Alignment.center,
                    child: Column(
                      children: [
                        Text('You can track the delivery',
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: Colors.black54)),
                        Text('the "Orders" section.',
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: Colors.black54)),
                      ],
                    )),
                SizedBox(height: 20),
                Container(
                  width: 410,
                  height: 52.0,
                  child: RaisedButton(
                    hoverColor: Colors.black,
                    shape: RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(30.0)),
                    child: Text(
                      "Track my Order",
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.white),
                    ),
                    color: Colors.green,
                    textColor: Colors.black,
                    splashColor: Colors.white,
                    onPressed: () {
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(builder: (context) => Track_Order()),
                      // );
                    },
                  ),
                ),
                SizedBox(height: 10.0),
                Container(
                  width: 410,
                  height: 52.0,
                  child: RaisedButton(
                    hoverColor: Colors.black,
                    shape: RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(30.0)),
                    child: Text(
                      "Order something else",
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: Colors.black),
                    ),
                    color: Color(0xFFFFFFFF),
                    textColor: Colors.black,
                    splashColor: Colors.white,
                    onPressed: () {
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(builder: (context) => Category()),
                      // );
                    },
                  ),
                ),
              ],
            ),
          ],
        );
      });
}

class CustomTextContainer extends StatelessWidget {
  CustomTextContainer({this.label, this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5),
      padding: EdgeInsets.all(20),
      decoration: new BoxDecoration(
        borderRadius: new BorderRadius.circular(10),
        color: Colors.green,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            '$value',
            style: TextStyle(
                color: Colors.white, fontSize: 34, fontWeight: FontWeight.bold),
          ),
          Text(
            '$label',
            style: TextStyle(
              color: Colors.white70,
            ),
          )
        ],
      ),
    );
  }
}
