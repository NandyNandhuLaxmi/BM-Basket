import 'package:bmbasket/bloc/model/data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:bmbasket/screens/home/home.dart';
import 'package:bmbasket/screens/home/checkout.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';



class Cart extends StatefulWidget {
  @override
  _CartState createState() => _CartState();
}

// class Item {
//   final String itemName;
//   int itemQun;
//   int itemPrice;

//   Item({this.itemName, this.itemQun, this.itemPrice});
// }

// Order order = Order();

class _CartState extends State<Cart> {
  
  @override
  Widget build(BuildContext context) {
    // int _total = 0;
    // var cart = Provider.of<OrderItemProvider>(context);
    
    // getTotal() {
    //   for (int i = 0; i < cart.cart.length; i++) {
    //     _total = _total + 
    //         ((cart.cart[i].quantity) *
    //             (int.parse(cart.cart[i].item.pricePerItem)));
    //   }
    //   return _total;
    // }
    // print(getTotal());
       
    
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text(
          'Your Cart',
          style: TextStyle(
            color: Color(0xFFFFFFFF),
            fontFamily: 'DancingScript',
            fontSize: 25,
          ),
        ),
        leading: IconButton(
          icon: Icon(EvaIcons.arrowBack, color: Color(0xFFFFFFFF)),
          onPressed: () {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => Home()));
          }
        ),
      ),
      body: CartBody(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => CheckOut()));
        },
        backgroundColor: Colors.green,
        child: Icon(EvaIcons.arrowForward),
      ),
    );
  }
}


class CartBody extends StatefulWidget {
  @override
  _CartBodyState createState() => _CartBodyState();
}

class _CartBodyState extends State<CartBody> {
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
  plus(index){
    setState(() {
      cart.add(cartitemlist[index]);
    });

    int value = count(cartitemlist[index]);

    setState(() {
      cartdata[cartitemlist[index]] = value;
    });
  }
  plusdatabase(index)async{
    final databaseReference = FirebaseFirestore.instance;
    final firebaseuser = FirebaseAuth.instance.currentUser;
    setState(() {
      cart.add(cartitemlist[index]);
    });

    int value = count(cartitemlist[index]);

    setState(() {
      cartdata[cartitemlist[index]] = value;
    });

    var a = await FirebaseFirestore.instance.collection('cart').doc(firebaseuser.uid).get();
    int c = count(cartitemlist[index]);

    if(a.exists){
      print(a);
      await databaseReference.collection("cart").doc(firebaseuser.uid).update({
        cartitemlist[index] : c
      }).then((value) => print("Success"));
    }
    if(!a.exists){
      await databaseReference.collection("cart").doc(firebaseuser.uid).set({
        cartitemlist[index] : c
      }).then((value) => print("Success"));
    }

  }

  minus(index){
    setState(() {
      cart.remove(cartitemlist[index]);
    });

    int value = count(cartitemlist[index]);

    setState(() {
      cartdata[cartitemlist[index]] = value;
    });
  }

  minusdatabase(index)async{
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
    await databaseReference.collection("cart").doc(firebaseuser.uid).update({
      cartitemlist[index] : c
    }).then((value) => print("Success"));
  }


  totalamount() {
    int rate = 0;
    for (int i = 0; i < cartitemlist.length; i++) {
      rate = rate +
          (int.parse(price[cartitemlist[i]]) * cartdata[cartitemlist[i]]);
    }
    return rate;
  }

  

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: [
            Container(
              alignment: Alignment.topLeft,
              margin: EdgeInsets.only(
                  left: 12.0, top: 5.0, right: 12.0, bottom: 5.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Amount Payable',
                    style: TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0),
                  ),
                  Text(totalamount().toString(),
                    style: TextStyle(
                    color: Color(0xFF000000),
                    fontWeight: FontWeight.w300,
                    fontSize: 20)),
                ],
              ),
            ),
            Expanded(
              child: Container(
                child: ListView.builder(
                  itemCount: cartitemlist.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Card(
                      child: ListTile(
                        leading: CircleAvatar(
                          child:
                              Image.network(cartdataimage[cartitemlist[index]]),
                          radius: 30,
                          backgroundColor: Colors.white,
                        ),
                        title: Text(cartitemlist[index]),
                        subtitle: Container(
                            child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            (count(cartitemlist[index]) != 0)
                                ? Text("Rs : " +
                                    (int.parse(price[cartitemlist[index]]) *
                                            cartdata[cartitemlist[index]])
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
                                      child: Icon(EvaIcons.plus, size: 15, color: Color(0xFFFFFFFF)),
                                      onPressed: () {
                                       if(isloggen == false){
                                         plus(index);
                                       }else{
                                         plusdatabase(index);
                                       }
                                      }),
                                  Text((cartdata[cartitemlist[index]] != null)
                                      ? cartdata[cartitemlist[index]].toString()
                                      : "0", style: TextStyle(fontSize: 15.8, fontWeight: FontWeight.w600, color: Colors.black)),
                                  RaisedButton(
                                    shape: CircleBorder(),
                                    color: Colors.green,
                                      child: Icon(EvaIcons.minus, size: 15, color: Color(0xFFFFFFFF)),
                                      onPressed: () {
                                        if(isloggen == false){
                                          minus(index);
                                        }else{
                                          minusdatabase(index);
                                        }
                                      })
                                ],
                              ),
                            ),
                          ],
                        )),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

 