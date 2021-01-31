class Coupon{
  String couponId;
  String description;
  String expiryDate;
  Coupon({this.couponId, this.description, this.expiryDate});

  Map<String,dynamic> toMap(){
    return {
      'couponId' : couponId,
      'description' : description,
      'expiryDate' : expiryDate,
    };
  }
  Coupon.fromFirestore(Map<String,dynamic> firestore)
  : couponId= firestore['couponId'],
    description = firestore['description'],
    expiryDate = firestore['expiryDate'];
}