import 'package:bmbasket/bloc/model/Item.dart';
import 'package:flutter/cupertino.dart';

class OrderItemProvider extends ChangeNotifier{
  List<OrderItem>  cart=[];

  AddToCart(OrderItem value) {
    cart.add(value);
    notifyListeners();
  }
}