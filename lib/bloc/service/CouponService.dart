import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bmbasket/bloc/provider/Coupon.dart';

class CouponService{

  FirebaseFirestore _db = FirebaseFirestore.instance;

  saveCoupon(Coupon coupon){
    _db.collection('coupon').doc('Coupon Id').collection('Coupon Id').doc()
        .set(coupon.toMap());
  }
  Future<List<Coupon>> getCoupon() async{
    var snapshot = await _db.collection('coupon').doc('Coupon Id').collection('Coupon Id').get();
    List<Coupon> Id=[
    ];
    snapshot.docs.forEach((element) {
      Id.add(Coupon.fromFirestore(element.data()));
    });
    return Id;
  }
}
