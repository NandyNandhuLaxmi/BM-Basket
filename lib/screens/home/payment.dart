import 'package:bmbasket/bloc/model/Order.dart';
import 'package:bmbasket/bloc/service/UserServices.dart';
import 'package:bmbasket/screens/home/checkout.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:fluttertoast/fluttertoast.dart';


class Payment extends StatefulWidget {
  int amount;
  Order order;
  Payment(this.amount,this.order);
  @override
  _PaymentState createState() => _PaymentState(amount,order);
}

class _PaymentState extends State<Payment> {
  Razorpay razorpay;
  int amount;
  Order order;
  _PaymentState(this.amount,this.order);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back,),
            alignment: Alignment.centerLeft,
            tooltip: 'Back',
            onPressed: () {
              Navigator.pushReplacement(context, MaterialPageRoute(
                builder: (context)=>CheckOut(),
              ));
            },
          ),
          backgroundColor: Colors.green,
          title: Text(
            'Payment',
            style: TextStyle(
              color: Color(0xFFFFFFFF),
              fontFamily: 'DancingScript',
              fontSize: 25,
            ),
          ),
        ),
        body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: 40,
                ),
                Text('Total Amount Payable:',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),),
                Text(
                    "₹ "+(widget.amount/100).toString(),
                  style: TextStyle(
                    fontSize: 25,
                  ),

                ),
                SizedBox(
                  height: 40,
                ),
                Container(
                  width: 200,
                  child: RaisedButton(
                      onPressed: () {
                        openCheckout();
                      },

                      color: Colors.green,
                      child: Text(
                        'Pay Now',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      )),
                ),
              ],
            )),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    razorpay = Razorpay();
    razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void dispose() {
    super.dispose();
    razorpay.clear();
  }

  void openCheckout() async {
    var options = {
      'key': 'rzp_test_rpmVUB4hUJBsqb',
      'amount': widget.amount,
      'name': 'Your Home Delivery',
      'description': 'Payment for Grocery ',
      'prefill': {'contact': '', 'email': ''},
      'external': {
        'wallets': ['paytm']
      },
    };

    try {
      print(1);
      razorpay.open(options);
      print(2);
    } catch (e) {
      print(3);
      print(e);
      print(4);
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    setState(() {
      var service = UserService();
      FirebaseAuth auth=FirebaseAuth.instance;
      service.saveUserOrder(order,auth.currentUser.uid);
    });
    Fluttertoast.showToast(

      backgroundColor: Colors.green,
      msg: "SUCCESS: " + response.paymentId,
    );

    print("ID================" + response.paymentId);
  }
  void _handlePaymentError(PaymentFailureResponse response) {
    Fluttertoast.showToast(
      backgroundColor: Colors.redAccent,
      msg: "ERROR: " + response.code.toString() + " - " + response.message,
    );
    print(5);
    print("ERROR: " +
        response.code.toString() +
        " ---------- " +
        response.message);
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    Fluttertoast.showToast(msg: "EXTERNAL_WALLET: " + response.walletName);

    print("EXTERNAL_WALLET: " + response.walletName);
  }
}

