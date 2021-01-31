import 'package:flutter/cupertino.dart';
import 'package:bmbasket/bloc/provider/Coupon.dart';
import 'package:bmbasket/bloc/service/CouponService.dart';

class CouponProvider extends ChangeNotifier{

  final firestoreService = CouponService();
  String _couponId;
  String _description;
  String _expiryDate;

  String get couponId => _couponId;

  String get description => _description;

  String get expiryDate => _expiryDate;

  ChangeexpiryDate(String value) {
    _expiryDate = value;
    ChangeNotifier();
  }

  Changedescription(String value) {
    _description = value;
    ChangeNotifier();
  }

  ChangecouponId(String value) {
    _couponId = value;
    ChangeNotifier();
  }

  saveCoupon()async{
    var coupon = Coupon(couponId: couponId,description: description,expiryDate: expiryDate);
    await firestoreService.saveCoupon(coupon);
  }
  Future<List<Coupon>> getCoupons() async{
    return await firestoreService.getCoupon();
  }
}