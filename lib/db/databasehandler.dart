import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:my_shopping_book/models/book.dart';
import 'package:my_shopping_book/models/artist.dart';
import 'package:my_shopping_book/models/publisher.dart';
import 'package:my_shopping_book/models/user.dart';

class DatabaseHandler{
  Future<Database> initializeDB() async {
    String path = await getDatabasesPath();
    return openDatabase(
      join(path, 'myshoppingbook.db'),
      onCreate: (database, version) async {
        await database.execute(
          "CREATE TABLE book(id INTEGER PRIMARY KEY AUTOINCREMENT, Date DateTime NOT NULL, Title TEXT, Artist TEXT, Publisher TEXT, Link TEXT, Price DECIMAL(18,2), Status TEXT)",
        );
        await database.execute(
          "CREATE TABLE artist(id INTEGER PRIMARY KEY AUTOINCREMENT, Name TEXT)",
        );
        await database.rawUpdate("INSERT INTO artist (Name) VALUES ('Default')");
        await database.execute(
          "CREATE TABLE publisher(id INTEGER PRIMARY KEY AUTOINCREMENT, Name TEXT)",
        );
        await database.rawUpdate("INSERT INTO publisher (Name) VALUES ('Default')");
        await database.execute(
          "CREATE TABLE user(id INTEGER PRIMARY KEY AUTOINCREMENT, UserId TEXT, Password TEXT)",
        );
      },
      version: 1,
    );
  }

  //book
  Future<int> insertBook(book _book) async {
    int result = 0;
    final Database db = await initializeDB();

    print('inserting!!');

    result = await db.insert('book', _book.toMap());
    return result;
  }

  Future<int> updateBook(book _book) async {
    int result = 0;
    final Database db = await initializeDB();

    print('updating!!');

    int id = int.parse(_book.id.toString());

    result = await db.update('book', _book.toMap(), where: 'id = ?', whereArgs: [id]);
    return result;
  }

  Future<List<book>> retrieveBook(String _Month, String _Year) async {
    final Database db = await initializeDB();
    final List<Map<String, Object?>> queryResult = await db.rawQuery("SELECT * FROM book WHERE strftime('%Y', Date) = ? and strftime('%m', Date) + 0  = ? + 0 ORDER BY Date DESC", [_Year, _Month]);
    return queryResult.map((e) => book.fromMap(e)).toList();
  }

  Future<book> activeBook() async {
    book result = new book();
    final Database db = await initializeDB();
    var queryResult = await db.rawQuery("Select * FROM book where status = 'Active'");
    var data = queryResult.first;
    result = book.fromMap(data);
    return result;
  }

  Future<book> getBook(int id) async {
    book result = new book();
    final Database db = await initializeDB();
    final List<Map<String, dynamic>> maps =
    await db.query('book', where: 'id = ?', whereArgs: [id]);
    result = book.fromMap(maps[0]);
    return result;
  }

  Future<int> updateStatus() async {
    int result = 0;
    final Database db = await initializeDB();
    result = await db.rawUpdate("UPDATE book SET status = 'InActive'");
    return result;
  }

  Future<int> updateActive(int id) async {
    int result = 0;
    final Database db = await initializeDB();
    result = await db.rawUpdate("UPDATE book SET status = 'Active' WHERE id = " + id.toString());
    return result;
  }

  Future<void> deleteBook(int id) async {
    final db = await initializeDB();
    await db.delete(
      'book',
      where: "id = ?",
      whereArgs: [id],
    );
  }

  //artist
  Future<int> insertArtist(artist _artist) async {
    int result = 0;
    final Database db = await initializeDB();

    print('inserting!!');

    result = await db.insert('artist', _artist.toMap());
    return result;
  }

  Future<int> updateArtist(artist _artist) async {
    int result = 0;
    final Database db = await initializeDB();

    print('updating!!');

    int id = int.parse(_artist.id.toString());

    result = await db.update('artist', _artist.toMap(), where: 'id = ?', whereArgs: [id]);
    return result;
  }

  Future<List<artist>> retrieveArtist() async {
    final Database db = await initializeDB();
    final List<Map<String, Object?>> queryResult = await db.query('artist');
    return queryResult.map((e) => artist.fromMap(e)).toList();
  }

  Future<artist> getArtist(int id) async {
    artist result = new artist(Name:'');
    final Database db = await initializeDB();
    final List<Map<String, dynamic>> maps =
    await db.query('artist', where: 'id = ?', whereArgs: [id]);
    result = artist.fromMap(maps[0]);
    return result;
  }

  Future<void> deleteArtist(int id) async {
    final db = await initializeDB();
    await db.delete(
      'artist',
      where: "id = ?",
      whereArgs: [id],
    );
  }

  //publisher
  Future<int> insertPublisher(publisher _publisher) async {
    int result = 0;
    final Database db = await initializeDB();

    print('inserting!!');

    result = await db.insert('publisher', _publisher.toMap());
    return result;
  }

  Future<int> updatePublisher(publisher _publisher) async {
    int result = 0;
    final Database db = await initializeDB();

    print('updating!!');

    int id = int.parse(_publisher.id.toString());

    result = await db.update('publisher', _publisher.toMap(), where: 'id = ?', whereArgs: [id]);
    return result;
  }

  Future<List<publisher>> retrievePublisher() async {
    final Database db = await initializeDB();
    final List<Map<String, Object?>> queryResult = await db.query('publisher');
    return queryResult.map((e) => publisher.fromMap(e)).toList();
  }

  Future<publisher> getPublisher(int id) async {
    publisher result = new publisher(Name:'');
    final Database db = await initializeDB();
    final List<Map<String, dynamic>> maps =
    await db.query('publisher', where: 'id = ?', whereArgs: [id]);
    result = publisher.fromMap(maps[0]);
    return result;
  }

  Future<void> deletePublisher(int id) async {
    final db = await initializeDB();
    await db.delete(
      'publisher',
      where: "id = ?",
      whereArgs: [id],
    );
  }

  //user
  Future<int> insertUser(user _user) async {
    int result = 0;
    final Database db = await initializeDB();

    print('inserting!!');

    result = await db.insert('user', _user.toMap());
    return result;
  }

  Future<int> updateUser(user _user) async {
    int result = 0;
    final Database db = await initializeDB();

    print('updating!!');

    int id = int.parse(_user.id.toString());

    result = await db.update('user', _user.toMap(), where: 'id = ?', whereArgs: [id]);
    return result;
  }

  Future<List<user>> retrieveUser() async {
    final Database db = await initializeDB();
    final List<Map<String, Object?>> queryResult = await db.query('user');
    return queryResult.map((e) => user.fromMap(e)).toList();
  }

  Future<user> getUser(int id) async {
    user result = new user();
    final Database db = await initializeDB();
    final List<Map<String, dynamic>> maps =
    await db.query('user', where: 'id = ?', whereArgs: [id]);
    result = user.fromMap(maps[0]);
    return result;
  }

  Future<void> deleteUser(int id) async {
    final db = await initializeDB();
    await db.delete(
      'user',
      where: "id = ?",
      whereArgs: [id],
    );
  }
}