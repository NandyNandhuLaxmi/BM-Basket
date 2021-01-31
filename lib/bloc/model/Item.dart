class Item {
  String imageUrl;
  String itemName;
  String itemCategory;
  String pricePerItem;
  Item({this.itemName, this.itemCategory, this.pricePerItem, this.imageUrl});

  Map<String, dynamic> toMap() {
    return {
      'imageUrl': imageUrl,
      'itemCategory': itemCategory,
      'itemName': itemName,
      'pricePerItem': pricePerItem
    };
  }

  static List<Map> ConvertCustomStepsToMap(List<Item> customSteps) {
    List<Map> steps = [];
    customSteps.forEach((Item customStep) {
      Map step = customStep.toMap();
      steps.add(step);
    });
    return steps;
  }

  Item.fromFirestore(Map<String, dynamic> firestore)
      : itemName = firestore['itemName'],
        itemCategory = firestore['itemCategory'],
        imageUrl = firestore['imageUrl'],
        pricePerItem = firestore['pricePerItem'];
}

class OrderItem {
  Item item;
  int quantity;

  OrderItem({this.item, this.quantity});

  Map<String, dynamic> toMap() {
    return {
      'item': item.toMap(),
      'quantity': quantity,
    };
  }

  static List<Map> ConvertCustomStepsToMap(List<OrderItem> customSteps) {
    List<Map> steps = [];
    customSteps.forEach((OrderItem customStep) {
      Map step = customStep.toMap();
      steps.add(step);
    });
    return steps;
  }

  OrderItem.fromFirestore(Map<String, dynamic> firestore)
      : quantity = int.parse(firestore['quantity']),
        item = Item.fromFirestore(firestore['item']);
}
