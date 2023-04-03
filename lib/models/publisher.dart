import 'package:intl/intl.dart';

class publisher{
  final int? id;
  late String Name;

  publisher({
    this.id,
    required this.Name
  });

  publisher.fromMap(Map<String, dynamic> res)
      : id = res["id"],
        Name = res["Name"].toString();

  Map<String, Object?> toMap() {
    return {'id':id,'Name': Name};
  }
}