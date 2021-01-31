import 'package:bmbasket/bloc/model/Address.dart';
import 'package:bmbasket/bloc/model/Item.dart';

class Order {
  String userId;
  String name;
  String orderId;
  String paymentType;
  String amount;
  List<OrderItem> orderItem;
  Address address;
  String deliveryBoy;
  String status;
  Order(
      {this.userId,this.name,this.orderId, this.paymentType, this.amount, this.orderItem, this.address,this.deliveryBoy,this.status});

  Map<String,dynamic> toMap(){
    return {  'name': name,
      'amount': amount,
      'address' : address.toMap(),
      'orderId' : orderId,
      'items' : OrderItem.ConvertCustomStepsToMap(orderItem),
      'deliveryBoy' : deliveryBoy,
      'status': status,
      'paymentType' : paymentType,
      'userId' : userId
    };
  }

  Order.fromFirestore( Map<String,dynamic> firestore)
      : name = firestore['name'],
        deliveryBoy = firestore['deliveryBoy'],
        address = Address.fromFirestore(firestore['address']),
        paymentType = firestore['paymentType'],
        status = firestore['status'],
        orderItem = (firestore['items'] as List).map<OrderItem>((e) => OrderItem.fromFirestore(e.cast<String,dynamic>())).toList(),
        orderId = firestore['orderId'],
        amount = firestore['amount'],
        userId = firestore['userId'];
}