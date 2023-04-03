import 'package:intl/intl.dart';

class artist{
  final int? id;
  late String Name;

  artist({
    this.id,
    required this.Name
  });

  artist.fromMap(Map<String, dynamic> res)
      : id = res["id"],
        Name = res["Name"].toString();

  Map<String, Object?> toMap() {
    return {'id':id,'Name': Name};
  }
}