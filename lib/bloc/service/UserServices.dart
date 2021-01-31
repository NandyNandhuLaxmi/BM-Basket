import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bmbasket/bloc/model/UserId.dart';
import 'package:bmbasket/bloc/model/Address.dart';
import 'package:bmbasket/bloc/model/User.dart';
import 'package:bmbasket/bloc/model/Order.dart';
import 'dart:developer';

class UserService{
  FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> saveUserId(UserId userId) {
    _db.collection('users').doc('userId').collection('userId').doc().set(
        userId.toMap());
  }

  Future<void> deleteAddress(String id,String s)async{
    log(s);
    var snapshot= await _db.collection('users').doc('userList').collection('userList').doc(id).collection('address').where('addressLine1',isEqualTo: s).get();
    String ID;
    snapshot.docs.forEach((element) { ID = element.id;});
    log(ID);
    await _db.collection('users').doc('userList').collection('userList').doc(id).collection('address')
        .doc(ID).delete();
  }
  Future<List<UserId>> getAllUserID() async{
    var snapshot=await _db.collection('users').doc('userId').collection('userId').get();
    List<UserId> list=[];
    snapshot.docs.forEach((element){
      list.add(UserId.fromFirestore(element.data()));
    });
    return list;
  }
  //Save
  Future<void> saveUserDetails(UserDetail user) async{
    List<UserId> id=await getAllUserID();
    int k=0;
    int i=0;
    while(i<id.length)
    {
      if(user.userId==id[i].userId)
      {
        k++;
        break;
      }
      i++;
    }
    if(k==0)
    {
      UserId userid = UserId(userId: user.userId);
      await saveUserId(userid);
    }
    await _db.collection('users').doc('userList').collection('userList').doc(user.userId).collection('details')
        .doc('UserDetails')
        .set(user.toMap());
  }
  //get
  Future<UserDetail> getUserDetails(String s) async{
      var snapshot = await _db.collection('users').doc('userList').collection('userList').doc(s).collection('details').get();
        UserDetail list;
          snapshot.docs.forEach((element){
          list = UserDetail.fromFirestore(element.data());
        });
          return list;
    }
  Future<List<UserDetail>> getAllUserDetails() async{
    List<UserId> userId = await getAllUserID();
    List<UserDetail> list=[];
    int i=0;
    while(i<userId.length)
      {
        list.add(await getUserDetails(userId[i].userId));
        i++;
      }
    return list;
  }

  Future<void> saveUserOrder(Order order, String email) {
    _db.collection('Orders').doc().set(
        order.toMap());
    _db.collection('users').doc('userList').collection('userList').doc(email).collection('order').doc().set(
        order.toMap());
  }

  Future<void> deleteUserOrder(Order order)async {
    var snapshot=await _db.collection('users').doc('userList').collection('userList').doc(order.userId).collection('order').where('orderId',isEqualTo: order.orderId).get();
    String Id,Id2;
    snapshot.docs.forEach((element) {Id=element.id;});
    await _db.collection('users').doc('userList').collection('userList').doc(order.userId).collection('order').doc(Id).delete();
    var snapshot2 =await _db.collection('Orders').where('orderId',isEqualTo: order.orderId).get();
    snapshot2.docs.forEach((element) {Id2=element.id;});
    await _db.collection('Orders').doc(Id2).delete();
  }
  //get
  Future<List<Order>> getUserOrder(String s)  async{
    var snapshot = await _db.collection('users').doc('userList').collection('userList').doc(s).collection('order').get();
    List<Order> order=[
    ];
    snapshot.docs.forEach((element) {
      order.add(Order.fromFirestore(element.data()));
    });
    log(order[0].amount);
    return order;
  }

  Future<void> saveUserAddress(Address,String s)async{
    await _db.collection('users').doc('userList').collection('userList').doc(s).collection('address')
        .doc()
        .set(Address.toMap());
  }

  Future<List<Address>> getUserAddress(String s) async{
    var snapshot=await await _db.collection('users').doc('userList').collection('userList').doc(s).collection('address').get();
    List<Address> list=[];
    snapshot.docs.forEach((element){
      list.add(Address.fromFirestore(element.data()));
    });
    return list;
  }

}
