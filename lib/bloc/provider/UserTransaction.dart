class UserTransaction{
  String transactionType;
  String amount;
  String transactionBrief;

  UserTransaction({this.transactionType, this.amount, this.transactionBrief});

  Map<String,dynamic> toMap(){
    return {  'transactionType': transactionType,
              'amount': amount,
              'transactionBrief': transactionBrief,
         };
  }
  UserTransaction.fromFirestore(Map<String,dynamic> firestore)
    : transactionType = firestore['transactionType'],
      transactionBrief = firestore['transactionBrief'],
      amount = firestore['amount'];

}
