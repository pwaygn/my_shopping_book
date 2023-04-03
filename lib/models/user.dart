import 'package:intl/intl.dart';

class user{
  final int? id;
  final String? UserId;
  final String? Password;

  user({
    this.id,
    this.UserId,
    this.Password,
  });

  user.fromMap(Map<String, dynamic> res)
      : id = res["id"],
        UserId = res["UserId"].toString(),
        Password = res["Password"].toString();

  Map<String, Object?> toMap() {
    return {'id':id,'UserId': UserId,'Password': Password};
  }
}