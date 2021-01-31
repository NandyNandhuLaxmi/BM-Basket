class Address {
  String addressLine1;
  String addressLine2;
  String city;
  String pinCode;
  String name;
  bool defaultDelivery;

  Address(
      { this.name,
        this.addressLine1,
        this.addressLine2,
        this.city,
        this.pinCode,
        this.defaultDelivery});
  Map<String,dynamic> toMap(){
    return {
      'name' : name,
      'addressLine1' : addressLine1,
      'addressLine2' : addressLine2,
      'city' : city,
      'pinCode' : pinCode,
      'defaultDelivery' : defaultDelivery
     };
  }
  Address.fromFirestore(Map<String,dynamic> firestore)
    :  name = firestore['name'],
       addressLine1 = firestore['addressLine1'],
       addressLine2 = firestore['addressLine2'],
       defaultDelivery = firestore['defaultDelivery'],
       city = firestore['city'],
       pinCode = firestore['pinCode'];
}
