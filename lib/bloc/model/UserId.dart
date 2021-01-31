class UserId{
  String userId;
  UserId({this.userId});
  Map<String,dynamic> toMap(){
    return {'userId':userId};
  }

  UserId.fromFirestore(Map<String,dynamic> firestore)
    : userId = firestore['userId'];

}
