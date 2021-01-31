import 'dart:async';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:bmbasket/bloc/provider.dart';
import 'package:rxdart/rxdart.dart';

import 'model/Item.dart';

class CartListBloc extends BlocBase
{
  CartListBloc();

  CartProvider provider=CartProvider();

  var _listController= BehaviorSubject<List<Item>>.seeded([]);

  Stream<List<Item>> get listStream=> _listController.stream;

  Sink<List<Item>> get listSink => _listController.sink;


  removeFromList(Item item)
  {
    listSink.add(provider.removeFromList(item));
  }

  addToList(Item item)
  {
    listSink.add(provider.addToList(item));
  }
}