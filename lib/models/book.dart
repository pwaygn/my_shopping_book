import 'package:intl/intl.dart';

class book{
  final int? id;
  final String? Date;
  final String? Title;
  final String? Artist;
  final String? Publisher;
  final String? Link;
  final double? Price;
  final String? Status;

  book({
    this.id,
    this.Date,
    this.Title,
    this.Artist,
    this.Publisher,
    this.Link,
    this.Price,
    this.Status
  });

  book.fromMap(Map<String, dynamic> res)
      : id = res["id"],
        Date = DateFormat("dd-MM-yyyy").format(DateTime.parse(res["Date"].toString())),
        Title = res["Title"].toString(),
        Artist = res["Artist"].toString(),
        Publisher = res["Publisher"].toString(),
        Link = res["Link"].toString(),
        Price = double.parse(res["Price"].toString()),
        Status = res["Status"];

  Map<String, Object?> toMap() {
    return {'id':id,'Date': Date, 'Title': Title, 'Artist': Artist, 'Publisher': Publisher, 'Link': Link, 'Price': Price,"Status": Status};
  }
}