class CartData{
  String quantity;
  String imageId;
  String itemName;
  String rating;
  String pricePerItem;

  CartData(String quantity, String imageId, String itemName, String rating, String pricePerItem)
  {
    this.quantity= quantity;
    this.imageId= imageId;
    this.itemName= itemName;
    this.rating =rating;
    this.pricePerItem =pricePerItem;
  }
  Map<String,dynamic> toMAp(){
    return {
      'imageId' : imageId,
      'itemName' : itemName,
      'rating' : rating,
      'pricePerItem' : pricePerItem,
      'quantity' : quantity
    };
  }

  CartData.fromFirestore(Map<String,dynamic> firestore)
      : imageId = firestore['imageId'],
        itemName = firestore['itemName'],
        rating = firestore['rating'],
        pricePerItem = firestore['pricePerItem'],
        quantity = firestore['quantity'];
}