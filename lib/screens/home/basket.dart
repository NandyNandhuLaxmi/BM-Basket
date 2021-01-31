import 'package:bmbasket/bloc/model/data.dart';
import 'package:bmbasket/screens/home/cart.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'orderdetails.dart';
import 'package:bmbasket/screens/home/contactus.dart';
import 'package:bmbasket/bloc/model/Item.dart';
import 'package:bmbasket/screens/home/profile.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';

class Basket extends StatefulWidget {
  @override
  _BasketState createState() => _BasketState();
}

class _BasketState extends State<Basket> with SingleTickerProviderStateMixin {
  TabController _tabController;
  int _selectedIndex = 0;
  GlobalKey<ScaffoldState> drawerKey = GlobalKey();

  @override
  void initState() {
    _tabController = new TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Color(0xFFFFFFFF),
      key: drawerKey,
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text(
          'BM Basket Farm',
          style: TextStyle(
              fontFamily: 'DancingScript',
              fontSize: 28,
              color: Colors.white,
              fontWeight: FontWeight.bold),
        ),
        brightness: Brightness.light,
        elevation: 0,
        actionsIconTheme: IconThemeData(color: Colors.white),
        iconTheme: IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            onPressed: () {  Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => Cart())); }, 
            icon: Icon(EvaIcons.shoppingBagOutline, color: Color(0xFFFFFFFF)),
          )
        ],
        bottom: TabBar(
          unselectedLabelColor: Colors.white,
          labelColor: Colors.amber,
          tabs: [
            Tab(
              child: Text(
                'Vegetables',
                style: TextStyle(
                  fontFamily: 'DancingScript',
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
            ),
            Tab(
              child: Text(
                'Fruits',
                style: TextStyle(
                  fontFamily: 'DancingScript',
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
            ),
          ],
          controller: _tabController,
          indicatorColor: Colors.white,
          indicatorSize: TabBarIndicatorSize.tab,
        ),
      ),
      drawerEdgeDragWidth: 0,
      drawer: new Drawer(
        child: ListView(
          children: [
            (isloggen == null || isloggen == false)
                ? UserAccountsDrawerHeader(
                    decoration: BoxDecoration(
                      color: Colors.green,
                    ),
                    currentAccountPicture: CircleAvatar(
                      backgroundColor: Colors.white,
                    ),
                    accountEmail: Container(
                      child: OutlineButton(
                        color: Colors.green,
                        hoverColor: Colors.black,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0)),
                        child: const Text('Login account'),
                        textColor: Colors.white,
                        onPressed: () {
                          Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (context) => Profile()));
                        },
                      ),
                    ),
                    accountName: null,
                  )
                : UserAccountsDrawerHeader(
                    decoration: BoxDecoration(
                      color: Colors.green,
                    ),
                    currentAccountPicture: CircleAvatar(
                      backgroundImage: NetworkImage((userData.photoURL != null)
                          ? userData.photoURL
                          : "url"),
                    ),
                    accountEmail:
                        Text((userData.email != null) ? userData.email : ""),
                    accountName: Text((userData.displayName != null)
                        ? userData.displayName
                        : ""),
                  ),
            Container(
              color: Color(0xFFFFFFFF),
              child: ListTile(
                  title: Text(
                    "Order Historys",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.black),
                  ),
                  leading: SvgPicture.asset(
                    'assets/icons/file.svg',
                    height: 20.0,
                    width: 20.0,
                    color: Colors.green,
                    allowDrawingOutsideViewBox: true,
                  ),
                  onTap: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => OrderDetails()));
                  }),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              color: Color(0xFFFFFFFF),
              child: ListTile(
                  title: Text(
                    "Contact Us",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.black),
                  ),
                  leading: SvgPicture.asset(
                    'assets/icons/file.svg',
                    height: 20.0,
                    width: 20.0,
                    color: Colors.green,
                    allowDrawingOutsideViewBox: true,
                  ),
                  onTap: () {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (_) => ContactUsScreen()));
                  }),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              color: Color(0xFFFFFFFF),
              child: ListTile(
                  title: Text(
                    "Settings",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.black),
                  ),
                  leading: SvgPicture.asset(
                    'assets/icons/file.svg',
                    height: 20.0,
                    width: 20.0,
                    color: Colors.green,
                    allowDrawingOutsideViewBox: true,
                  ),
                  onTap: () {
                    // Navigator.pushReplacement(context,
                    //     MaterialPageRoute(builder: (context) => CustomerDetails()));
                  }),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              color: Color(0xFFFFFFFF),
              child: ListTile(
                title: new Text(
                  isloggen ? 'Logout'.toLowerCase() : 'Login',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.black),
                ),
                leading: SvgPicture.asset(
                  'assets/icons/log_out.svg',
                  height: 20.0,
                  width: 20.0,
                  color: Colors.green,
                  allowDrawingOutsideViewBox: true,
                ),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text(isloggen ? 'Logout'.toLowerCase() : 'Login',
                            style: TextStyle(
                                color: Color(0xFF000000),
                                fontWeight: FontWeight.w800,
                                fontSize: 18)),
                        content: Text('Thank you to BM Basket Farm'),
                        actions: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              FlatButton(
                                  onPressed: () async {
                                    await FirebaseAuth.instance.signOut();
                                    setState(() {
                                      displayName = "";
                                      email = "";
                                      phoneNumber = "";
                                      uid = "";
                                      isloggen = false;
                                    });
                                    // Navigator.of(context).pop();
                                     Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Profile()));
                                  },
                                  child: Text(
                                      isloggen
                                          ? 'Logout'.toUpperCase()
                                          : 'Login'.toUpperCase(),
                                      style: TextStyle(
                                          color: Colors.green,
                                          fontWeight: FontWeight.w800,
                                          fontSize: 15))),
                              FlatButton(
                                onPressed: () => Navigator.of(context).pop(),
                                // onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => Menu(),)),
                                child: Text('Cancel'.toUpperCase(),
                                    style: TextStyle(
                                        color: Colors.red,
                                        fontWeight: FontWeight.w800,
                                        fontSize: 15)),
                              ),
                            ],
                          )
                        ],
                      );
                    },
                  );
                  //  Navigator.of(context).pop();
                },
              ),
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          TabBarView(
            controller: _tabController,
            children: [
              GroceryScreen(),
              FoodDeliveryScreen(),
            ],
          ),     
        ],
      ),
    );
  }
}

class GroceryScreen extends StatefulWidget {
  @override
  GroceryScreenState createState() => GroceryScreenState();
}

class GroceryScreenState extends State<GroceryScreen> {
  count(item) {
    int count = 0;
    cart.forEach((element) {
      if (element == item) {
        count++;
      }
    });
    return count;
  }

  List<Item> _filter = <Item>[];
  List<Item> products = <Item>[];
  final _debouncer = Debouncer(milliseconds: 500);
  DateTime _selectedValue = DateTime.now();
  DatePickerController _controller = DatePickerController();
  plus(database) async {
    print("localdatais");
    setState(() {
      cart.add(database['itemName']);
      if (!cartitemlist.contains(database['itemName'])) {
        cartitemlist.add(database['itemName']);
      }
    });

    int value = count(database['itemName']);
    String url = database['imageUrl'];
    String priceperitem = database['pricePerItem'];
    setState(() {
      cartdata[database['itemName']] = value;
      cartdataimage[database['itemName']] = url;
      price[database['itemName']] = priceperitem;
    });
    print(price);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList("cart", cart);
    prefs.setStringList("key", cartitemlist);
    for (int i = 0; i < cartitemlist.length; i++) {
      prefs.setString(cartitemlist[i], price[cartitemlist[i]]);
    }
  }

  minus(database) async {
    setState(() {
      cart.remove(database['itemName']);
      if (!cart.contains(database['itemName'])) {
        cartitemlist.remove(database['itemName']);
        cartdataimage.remove(database['itemName']);
        price.remove(database['itemName']);
      }
    });
    int value = count(database['itemName']);
    setState(() {
      cartdata[database['itemName']] = value;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList("cart", cart);
    prefs.setStringList("key", cartitemlist);
    for (int i = 0; i < cartitemlist.length; i++) {
      prefs.setString(cartitemlist[i], price[cartitemlist[i]]);
    }
  }

  final databaseReference = FirebaseFirestore.instance;
  plusdatabase(database) async {
    final firebaseuser = FirebaseAuth.instance.currentUser;
    print("excecuting database ");
    setState(() {
      cart.add(database['itemName']);
      if (!cartitemlist.contains(database['itemName'])) {
        cartitemlist.add(database['itemName']);
      }
    });

    int value = count(database['itemName']);
    String url = database['imageUrl'];
    String priceperitem = database['pricePerItem'];
    setState(() {
      cartdata[database['itemName']] = value;
      cartdataimage[database['itemName']] = url;
      price[database['itemName']] = priceperitem;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList("cart", cart);
    prefs.setStringList("key", cartitemlist);
    for (int i = 0; i < cartitemlist.length; i++) {
      prefs.setString(cartitemlist[i], price[cartitemlist[i]]);
    }
    var a = await FirebaseFirestore.instance
        .collection('cart')
        .doc(firebaseuser.uid)
        .get();
    int c = count(database['itemName']);

    if (a.exists) {
      print(a);
      await databaseReference
          .collection("cart")
          .doc(firebaseuser.uid)
          .update({database['itemName']: c}).then((value) => print("Success"));
    }
    if (!a.exists) {
      await databaseReference
          .collection("cart")
          .doc(firebaseuser.uid)
          .set({database['itemName']: c}).then((value) => print("Success"));
    }
  }

  minusdatabase(database) async {
    setState(() {
      cart.remove(database['itemName']);
      if (!cart.contains(database['itemName'])) {
        cartitemlist.remove(database['itemName']);
        cartdataimage.remove(database['itemName']);
        price.remove(database['itemName']);
      }
    });
    int value = count(database['itemName']);
    setState(() {
      cartdata[database['itemName']] = value;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList("cart", cart);
    prefs.setStringList("cartitemlist", cartitemlist);

    int c = count(database['itemName']);
    await databaseReference.collection("cart").doc(userData.uid).update(
      {database['itemName']: c},
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height * 0.1,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.0),
                image: DecorationImage(
                  image: NetworkImage(
                      'https://as2.ftcdn.net/jpg/02/48/40/11/500_F_248401150_5hzU77knfREGeMXbTMRWAHrEyTqLKTLG.jpg'),
                  fit: BoxFit.cover,
                ),
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
          ),
          // Container(
          //   child: DatePicker(DateTime.now(),
          //       controller: _controller,
          //       initialSelectedDate: DateTime.now(),
          //       selectionColor: Colors.green,
          //       selectedTextColor: Colors.white, onDateChange: (date) {
          //     setState(() {
          //       _selectedValue = date;
          //     });
          //   }),
          // ),
          Container(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                decoration: InputDecoration(
                  prefixIcon: Icon(
                    Icons.search,
                    color: Color(0xFF000000),
                  ),
                  suffixIcon: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.green, shape: BoxShape.circle),
                      child: Icon(
                        EvaIcons.navigation2Outline,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(28.0)),
                  ),
                  contentPadding: EdgeInsets.all(10.0),
                  hintStyle: TextStyle(color: Colors.black),
                  hintText: 'Search',
                ),
                onChanged: (string) {
                  _debouncer.run(() {
                    setState(() {
                      _filter = products
                          .where((u) => (u.itemName
                                  .toLowerCase()
                                  .contains(string.toLowerCase()) ||
                              u.itemName
                                  .toUpperCase()
                                  .contains(string.toUpperCase())))
                          .toList();
                    });
                  });
                },
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("seller item")
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.data == null)
                  return Center(
                      child: CircularProgressIndicator(
                          valueColor:
                              new AlwaysStoppedAnimation<Color>(Colors.green)));
                return Container(
                  child: ListView.builder(
                    itemCount: snapshot.data.docs.length,
                    itemBuilder: (BuildContext context, int index) {
                      DocumentSnapshot database = snapshot.data.docs[index];
                      return Card(
                        child: SizedBox(
                          height: 100,
                          child: Center(
                            child: ListTile(
                              leading: CircleAvatar(
                                child: Image.network(database['imageUrl']),
                                radius: 30,
                                backgroundColor: Colors.white,
                              ),
                              title: Text(database['itemName']),
                              subtitle: Container(
                                  child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  (count(database['itemName']) != 0)
                                      ? Text("Rs : " +
                                          (int.parse(database['pricePerItem']) *
                                                  count(database['itemName']))
                                              .toString() +
                                          " / ${count(database['itemName'])} kg")
                                      : Text(
                                          "Rs : ${database['pricePerItem']} / 1 kg"),
                                  Container(
                                    child: Row(
                                      children: [
                                        RaisedButton(
                                            shape: CircleBorder(),
                                            color: Colors.green,
                                            child: Icon(EvaIcons.plus, size: 15, color: Colors.white),
                                            onPressed: () {
                                              if (isloggen == false) {
                                                plus(database);
                                              } else {
                                                plusdatabase(database);
                                              }
                                            }),
                                        Text((cartdata[database['itemName']] !=
                                                null)
                                            ? cartdata[database['itemName']]
                                                .toString()
                                            : "0", style: TextStyle(fontSize: 15.8, fontWeight: FontWeight.w600, color: Colors.black)),
                                        RaisedButton(
                                            shape: CircleBorder(),
                                            color: Colors.green,
                                            child: Icon(EvaIcons.minus, size: 15, color: Colors.white),
                                            onPressed: () {
                                              if (isloggen == false) {
                                                minus(database);
                                              } else {
                                                minusdatabase(database);
                                              }
                                            })
                                      ],
                                    ),
                                  ),
                                ],
                              )),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class FoodDeliveryScreen extends StatefulWidget {
  @override
  _FoodDeliveryScreenState createState() => _FoodDeliveryScreenState();
}

class _FoodDeliveryScreenState extends State<FoodDeliveryScreen> {
  count(item) {
    int count = 0;
    cart.forEach((element) {
      if (element == item) {
        setState(() {
          count++;
        });
      }
    });
    return count;
  }

  List<Item> _filter = <Item>[];
  List<Item> products = <Item>[];
  final _debouncer = Debouncer(milliseconds: 500);
  DateTime _selectedValue = DateTime.now();
  DatePickerController _controller = DatePickerController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.1,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.0),
                  image: DecorationImage(
                    image: NetworkImage(
                        'https://as2.ftcdn.net/jpg/02/48/40/11/500_F_248401150_5hzU77knfREGeMXbTMRWAHrEyTqLKTLG.jpg'),
                    fit: BoxFit.cover,
                  ),
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
            ),
            // Container(
            //   child: DatePicker(DateTime.now(),
            //       controller: _controller,
            //       initialSelectedDate: DateTime.now(),
            //       selectionColor: Colors.green,
            //       selectedTextColor: Colors.white, onDateChange: (date) {
            //     setState(() {
            //       _selectedValue = date;
            //     });
            //   }),
            // ),
            Container(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  maxLength: 19,
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.search,
                      color: Color(0xFF000000),
                    ),
                    suffixIcon: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.green, shape: BoxShape.circle),
                        child: Icon(
                          EvaIcons.navigation2Outline,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(28.0)),
                    ),
                    contentPadding: EdgeInsets.all(10.0),
                    hintStyle: TextStyle(color: Colors.black),
                    hintText: 'Search',
                  ),
                  onChanged: (string) {
                    _debouncer.run(() {
                      setState(() {
                        _filter = products
                            .where((u) => (u.itemName
                                    .toLowerCase()
                                    .contains(string.toLowerCase()) ||
                                u.itemName
                                    .toUpperCase()
                                    .contains(string.toUpperCase())))
                            .toList();
                      });
                    });
                  },
                ),
              ),
            ),
            Expanded(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("seller item")
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.data == null)
                    return Center(
                        child: CircularProgressIndicator(
                            valueColor:
                                new AlwaysStoppedAnimation<Color>(Colors.green)));
                  return Container(
                    child: ListView.builder(
                      itemCount: snapshot.data.docs.length,
                      itemBuilder: (BuildContext context, int index) {
                        DocumentSnapshot database = snapshot.data.docs[index];
                        return Card(
                          child: SizedBox(
                            height: 100,
                            child: Center(
                              child: ListTile(
                                leading: CircleAvatar(
                                  child: Image.network(database['imageUrl']),
                                  radius: 30,
                                  backgroundColor: Colors.white,
                                ),
                                title: Text(database['itemName']),
                                subtitle: Container(
                                    child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("Rs ${database['pricePerItem']} / 1 kg"),
                                    Container(
                                      child: Row(
                                        children: [
                                          RaisedButton(
                                            shape: CircleBorder(),
                                            color: Colors.green,
                                            child: Icon(EvaIcons.plus, size: 15, color: Colors.white),
                                              onPressed: () {
                                                setState(() {
                                                  cart.add(database['itemName']);
                                                });
                                                int value =
                                                    count(database['itemName']);
                                                setState(() {
                                                  cartdata[database['itemName']] =
                                                      value;
                                                });
                                              }),
                                          Text((cartdata[database['itemName']] !=
                                                  null)
                                              ? cartdata[database['itemName']]
                                                  .toString()
                                              : "0", style: TextStyle(fontSize: 15.8, fontWeight: FontWeight.w600, color: Colors.black)),
                                          RaisedButton(
                                            shape: CircleBorder(),
                                            color: Colors.green,
                                              child: Icon(EvaIcons.minus, size: 15, color: Colors.white),
                                              onPressed: () {
                                                setState(() {
                                                  cart.remove(
                                                      database['itemName']);
                                                });
                                                int value =
                                                    count(database['itemName']);
                                                setState(() {
                                                  cartdata[database['itemName']] =
                                                      value;
                                                });
                                              })
                                        ],
                                      ),
                                    ),
                                  ],
                                )),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Debouncer {
  final int milliseconds;
  VoidCallback action;
  Timer _timer;
  Debouncer({this.milliseconds});
  run(VoidCallback action) {
    if (null != _timer) {
      _timer.cancel();
    }
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }
}
