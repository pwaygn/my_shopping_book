import 'package:flutter/material.dart';
import 'package:my_shopping_book/models/book.dart';
import 'package:my_shopping_book/db/DatabaseHandler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyData extends DataTableSource {
  DatabaseHandler handler;
  List<book> _book;
  MyData(this._book, this.handler);

  bool get isRowCountApproximate => false;
  int get rowCount => _book.length;
  int get selectedRowCount => 0;
  double total=0;

  late SharedPreferences sharedPreferences;

  DataRow getRow(int index) {
    return DataRow(cells: [
      DataCell(Text(_book[index].Date.toString())),
      DataCell(Text(_book[index].Title.toString())),
      DataCell(Text(_book[index].Artist.toString())),
      DataCell(Text(_book[index].Publisher.toString())),
      DataCell(Text(_book[index].Link.toString())),
      DataCell(Text(_book[index].Price.toString())),
      DataCell(IconButton(
        icon: Icon(Icons.edit),
        onPressed: () async {
          int vId = int.parse(_book[index].id.toString());
          print('vId : ' + vId.toString());
          sharedPreferences = await SharedPreferences.getInstance();
          sharedPreferences.setInt('id', vId);
          handler.updateActive(vId);
        },)),
      DataCell(IconButton(
        icon: Icon(Icons.delete),
        onPressed: () async {
          var f = _book[index].id.toString();
          handler.deleteBook(int.parse(_book[index].id.toString()));
          sharedPreferences = await SharedPreferences.getInstance();
          sharedPreferences.setInt('id', 0);
        },)),
    ]);
  }

  List<DataRow> getRows(List<book> users) => users.map((book _books) {
    final cells = [
      _books.Date,
      _books.Title,
      _books.Artist,
      _books.Publisher,
      _books.Link,
      _books.Price
    ];

    return DataRow(cells: getCells(cells));
  }).toList();

  List<DataCell> getCells(List<dynamic> cells) =>
      cells.map((data) => DataCell(Text('$data'))).toList();

}