import 'package:firebase_auth/firebase_auth.dart';

List<String> cart = [];
Map cartdata = {};
Map cartdataimage = {};
List<String> cartitemlist = [];
Map price = {};

String displayName = "";
String email = "";
String phoneNumber = "";
String uid = "";
bool isloggen = false;
User userData;

class UserAddress {
  String name = "";
  String city = "";
  String phone = "";
  String pincode = "";
  String address = "";
  UserAddress({this.name, this.city, this.phone, this.pincode, this.address});
}
