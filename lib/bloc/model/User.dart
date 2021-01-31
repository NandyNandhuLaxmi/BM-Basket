class UserDetail{
  String userId;
  String username;
  String userEmail;
  String contactNumber;

  UserDetail({this.username, this.userEmail, this.contactNumber,this.userId});

  Map<String,dynamic> toMap(){
    return{
      'userId' : userId,
      'username':username,
      'userEmail':userEmail,
      'contactNumber' : contactNumber,
    };
  }
  UserDetail.fromFirestore( Map<String , dynamic> firestore)
      : username =firestore['username'],
        userEmail = firestore['userEmail'],
        contactNumber = firestore['contactNumber'],
        userId = firestore['userId'];
}
