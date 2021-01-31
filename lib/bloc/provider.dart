import 'package:bmbasket/bloc/model/Item.dart';

class CartProvider
{
  List<Item> items=[];

  List<Item> addToList(Item item)
  {
    items.add(item);
    return items;
  }

  List<Item> removeFromList(Item item)
  {
    items.remove(item);
    return items;
  }
}