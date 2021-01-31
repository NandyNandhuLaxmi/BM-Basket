import 'package:bmbasket/bloc/model/Item.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:developer';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';

class ItemService{

  FirebaseFirestore _db = FirebaseFirestore.instance;

  SaveId(ItemId itemId){
    _db.collection('Item Id').doc().set(
        itemId.toMAp());
  }

  Future<List<ItemId>> getItemId() async{
    var snapshot= await _db.collection('Item Id').get();
    List<ItemId> menu=[];
    snapshot.docs.forEach((element) {
      menu.add(ItemId.fromFirestore(element.data()));
    });
    return menu;
  }

  Future<List<Item>> getAllItemDetails() async {
    List<ItemId> list = await getItemId();
    log("Item ID" +list.length.toString());
    List<Item> details=[];
    int i=0;
    while(i<list.length)
    {
      details.add(await getItem(list[i].name));
      i++;
    }
    log("All Item" +details.length.toString());
    return details;
  }

  Future<void> saveItems(Item menu) async{
    List<ItemId> id= await getItemId();
    int k=0,i=0;
    while(i<id.length)
    {
      if( menu.itemName== id[i].name)
      {
        k++;
        break;
      }
      i++;
    }
    if(k==0)
    {
      ItemId restid = ItemId(name: menu.itemName);
      SaveId(restid);
    }
    _db.collection('seller item').doc(menu.itemName).collection('details').doc('details').set(
        menu.toMap());
  }
  //get
  Future<Item> getItem(String s) async{
    var snapshot= await _db.collection('seller item').doc(s).collection('details').get();
    Item menu;
    snapshot.docs.forEach((element) {
      menu=Item.fromFirestore(element.data());
    });
    return menu;
  }

  Future<List<Item>> getfruits()async {
    List<ItemId> ID=await getItemId();
    int i=0;
    List<Item> vegetables=[];
    log("fruits");
    log(ID.length.toString());
    while(i<ID.length) {
      log("fruits");
      QuerySnapshot snapshot=await _db.collection('seller item').doc(ID[i].name).collection('details').get();
      snapshot.docs.forEach((element) {
        Item i = Item.fromFirestore(element.data());
        if(i.itemCategory =='fruits')
        {
          vegetables.add(i);
        }
      });
      i++;
    }
    log("fruits" +vegetables.length.toString());
    return vegetables;
  }

  deleteItem(String s)async{
    var snapshot= await _db.collection('Item Id').where('name',isEqualTo: s).get();
    _db.collection('Item Id').doc(snapshot.docs.first.id).delete();
    await _db.collection('seller item').doc(s).collection('details').doc('details').delete();
  }


  Future<List<Item>> getVegetables()async {
    List<ItemId> ID=await getItemId();
    int i=0;
    List<Item> vegetables=[];
    while(i<ID.length) {
      QuerySnapshot snapshot=await _db.collection('seller item').doc(ID[i].name).collection('details').where('itemCategory',isEqualTo: 'vegetables').get();
       snapshot.docs.forEach((element) {
           vegetables.add(Item.fromFirestore(element.data()));
           log("Vegetables" +vegetables[i].itemName.toString());
       });
       i++;
    }
    log("Vegetables" +vegetables.length.toString());
    return vegetables;
  }

  Future<dynamic> loadImage(BuildContext context,String Image) async{
    return await FirebaseStorage.instance.ref().child('Items').child(Image).getDownloadURL();
  }
}

class ItemId{
  String name;

  ItemId({this.name});
  Map<String,dynamic> toMAp() {
    return {
      'name': name
    };
  }
  ItemId.fromFirestore(Map<String,dynamic> toMAp)
   : name = toMAp['name'];


}