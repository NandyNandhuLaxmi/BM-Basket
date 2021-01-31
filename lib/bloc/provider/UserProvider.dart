import 'package:bmbasket/bloc/model/User.dart';
import 'package:bmbasket/bloc/service/UserService.dart';
import 'package:flutter/cupertino.dart';

class UserProvider extends ChangeNotifier{
  String _userId;
  String _username;
  String _userEmail;
  String _contactNumber;

  String get userId => _userId;

  String get username => _username;

  String get userEmail => _userEmail;

  String get contactNumber => _contactNumber;


  ChangecontactNumber(String value) {
    _contactNumber = value;
    notifyListeners();
  }

  ChangeuserEmail(String value) {
    _userEmail = value;
    notifyListeners();
  }

  Changeusername(String value) {
    _username = value;
    notifyListeners();
  }

  ChangeuserId(String value) {
    _userId = value;
    notifyListeners();
  }

  saveDetails(){
    UserDetail user = UserDetail(username: username,userEmail: userEmail,userId:userId,contactNumber: contactNumber);
    var services = UserService();
    services.saveUserDetails(user);
    notifyListeners();
  }

  Future<UserDetail> getUserDetails(String s)async{
    var firebase = UserService();
    return await firebase.getUserDetails(s);
  }

}