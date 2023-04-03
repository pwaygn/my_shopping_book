import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_shopping_book/datasource/datasource.dart';
import 'package:my_shopping_book/models/book.dart';
import 'package:my_shopping_book/models/artist.dart';
import 'package:my_shopping_book/models/publisher.dart';
import 'package:my_shopping_book/db/DatabaseHandler.dart';
import 'package:sqflite/sqflite.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:month_year_picker/month_year_picker.dart';
import 'dart:convert';
import 'package:intl/intl.dart';

class BookScreen extends StatefulWidget{
/*
  @override
  State<StatefulWidget> createState() {
    return _BookScreen();
  }
 */
  const BookScreen({Key? key}) : super(key: key);

  @override
  _BookScreenState createState() => _BookScreenState();
}

class _BookScreenState extends State<BookScreen>{
  late DatabaseHandler handler;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final Title = TextEditingController();
  final Artist = TextEditingController();
  final Publisher = TextEditingController();
  final Link = TextEditingController();
  final Price = TextEditingController();

  late List<artist> artists;
  late List<String> _artistList= [''];
  String _artistName="Default";
  late List<publisher> publishers;
  late List<String> _publisherList=[''];
  String _publisherName="Default";

  final columns = ['Date', 'Title', 'Artist', 'Publisher', 'Link', 'Price', 'Edit', 'Delete'];

  List<book> books = [];
  DateTime DateCreated = DateTime.now();

  double screenHeight = 0;
  double screenWidth = 0;

  Color primary = const Color(0xFF0288D1);

  String _month = DateFormat('MMMM').format(DateTime.now());
  String _monthNum = DateFormat('MM').format(DateTime.now());
  String _year = DateFormat('yyyy').format(DateTime.now());

  var textStyle=TextStyle();
  var textStyle2=TextStyle();

  late SharedPreferences sharedPreferences;
  int eId=0;

  @override
  void initState() {
    super.initState();
    this.handler = DatabaseHandler();

    this.handler.initializeDB().whenComplete(() async {
      books = await this.handler.retrieveBook(_monthNum, _year);
      _getRowSource();
      setState(() {});
    });

    _getCredentials();
    _getRecord();
  }

  void _getRowSource() async {
    /*
    if (_artistList.length <2) {
      artists = await this.handler.retrieveArtist();
      artists.forEach((item) {
        setState(() {
          if (_artistList.contains(item.Name) == false) {
            _artistList.add(item.Name);
          }
        });
      });
    }
    if (_publisherList.length <2) {
      publishers = await this.handler.retrievePublisher();
      publishers.forEach((item) {
        setState(() {
          if (_publisherList.contains(item.Name) == false) {
            _publisherList.add(item.Name);
          }
        });
      });
    }
     */
    artists = await this.handler.retrieveArtist();
    artists.forEach((item) {
      setState(() {
        if (_artistList.contains(item.Name) == false) {
          _artistList.add(item.Name);
        }
      });
    });

    publishers = await this.handler.retrievePublisher();
    publishers.forEach((item) {
      setState(() {
        if (_publisherList.contains(item.Name) == false) {
          _publisherList.add(item.Name);
        }
      });
    });
  }

  void _getCredentials() async {
    try {
      sharedPreferences = await SharedPreferences.getInstance();
      if(sharedPreferences.getInt('id') != null) {
        setState(() {
          eId = sharedPreferences.getInt('id')!;
        });
      }
    } catch(e) {
      return;
    }
  }

  void _getRecord() async {
    try {
      print('eId : ' + eId.toString());
      if (eId != 0) {
        book mybook = new book();
        //mybook = await this.handler.activeBook();
        mybook = await this.handler.getBook(eId);
        Title.text = mybook.Title.toString();
        Artist.text = mybook.Artist.toString();
        Publisher.text = mybook.Publisher.toString();
        Link.text = mybook.Link.toString();
        Price.text = mybook.Price.toString();
        setState(() { });
      }
    } catch(e) {
      return;
    }
  }

  List<Map<String,Object>> get groupedTransactionValues{
    return List.generate(7, (index){
      final weekDay = DateTime.now().subtract(Duration(days: index),);
      var totalSum=0.0;
      for (var i=0; i < books.length; i++)
      {
        if (books[i].Price != null)
        {
          totalSum+=books[i].Price!;
        }
      }
      print(totalSum);
      return {"amount":totalSum};
    });
  }

  double get totalSpending{
    return groupedTransactionValues.fold(0.0, (sum, item){
      return (item['amount'] as double);
    });
  }

  @override
  Widget build(BuildContext context) {
    DataTableSource _data = MyData(books, handler);

    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    textStyle=TextStyle(
      //fontFamily: "NexaBold",
      fontFamily: "Georgia",
      fontSize: screenWidth / 28,
    );
    textStyle2=TextStyle(
      //fontFamily: "NexaBold",
      fontFamily: "Georgia",
      fontSize: screenWidth / 28,
      color: Colors.black,
    );

    _getRowSource();

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.all(5.0),
                      height: 70,
                      child: CupertinoDatePicker(
                        mode: CupertinoDatePickerMode.dateAndTime,
                        initialDateTime: DateTime.now(),
                        onDateTimeChanged: (DateTime newDateTime) {
                          DateCreated = newDateTime;
                        },
                        use24hFormat: false,
                        minuteInterval: 1,
                      ),
                    ),

                    Padding(padding: EdgeInsets.only(top:2.0,bottom: 2.0)),

                    TextFormField(
                      controller: Title,
                      style: textStyle,
                      decoration: InputDecoration(
                          labelText: "Title",
                          labelStyle: textStyle,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0)
                          )
                      ),
                      onChanged: (String? value) {
                        if (value == null || value.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content:Text("Please input Book's Title!"),
                                duration: Duration(seconds: 3),
                              )
                          );
                        }
                        return null;
                      },
                    ),

                    Padding(padding: EdgeInsets.only(top:2.0,bottom: 2.0)),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(

                          child: ListTile(
                            title: DropdownButton<String>(
                              items:_artistList.map((String value){
                                return DropdownMenuItem<String>(
                                  value:value,
                                  child:Text(value),
                                );
                              }).toList(),
                              style: textStyle2,
                              //value: retrieveLeaveType(leave_request_his.leave_Type_ID!),
                              value: Artist.text,
                              onChanged: (String? value) {
                                print('value : ' + value.toString());
/*
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content:Text("Artist : " + value.toString()),
                                  duration: Duration(seconds: 3),
                                )
                            );
 */
                                if (value == null || value.isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content:Text("Please input Book's Artist!"),
                                        duration: Duration(seconds: 3),
                                      )
                                  );
                                }
                                else{
                                  _artistName = value;
                                  Artist.text = value;

                                  setState(() {
                                    _artistName = value;
                                    Artist.text = value;
                                  });

                                }
                              },
                            ),
                          ),

/*
                      child: TextFormField(
                        controller: Artist,
                        style: textStyle,
                        decoration: InputDecoration(
                            labelText: "Artist",
                            labelStyle: textStyle,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0)
                            )
                        ),
                        onChanged: (String? value) {
                          if (value == null || value.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content:Text("Please input Book's Artist!"),
                                  duration: Duration(seconds: 3),
                                )
                            );
                          }
                        },
                      ),
*/
                        ),
                        Expanded(

                          child: ListTile(
                            title: DropdownButton<String>(
                              items:_publisherList.map((String value){
                                return DropdownMenuItem<String>(
                                  value:value,
                                  child:Text(value),
                                );
                              }).toList(),
                              style: textStyle2,
                              //value: retrieveLeaveType(leave_request_his.leave_Type_ID!),
                              value: Publisher.text,
                              onChanged: (String? value) {
                                print('value : ' + value.toString());
/*
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content:Text("Publisher : " + value.toString()),
                                  duration: Duration(seconds: 3),
                                )
                            );
 */
                                if (value == null || value.isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content:Text("Please input Book's Publisher!"),
                                        duration: Duration(seconds: 3),
                                      )
                                  );
                                }
                                else{
                                  _publisherName = value;
                                  Publisher.text = value;

                                  setState(() {
                                    _publisherName = value;
                                    Publisher.text = value;
                                  });

                                }
                              },
                            ),
                          ),

/*
                      child: TextFormField(
                        controller: Publisher,
                        style: textStyle,
                        decoration: InputDecoration(
                            labelText: "Publisher",
                            labelStyle: textStyle,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0)
                            )
                        ),
                        onChanged: (String? value) {
                          if (value == null || value.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content:Text("Please input Book's Publisher!"),
                                  duration: Duration(seconds: 3),
                                )
                            );
                          }
                        },
                      ),
*/
                        ),
                      ],
                    ),

                    Padding(padding: EdgeInsets.only(top:2.0,bottom: 2.0)),

                    TextFormField(
                      controller: Link,
                      style: textStyle,
                      decoration: InputDecoration(
                          labelText: "Link",
                          labelStyle: textStyle,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0)
                          )
                      ),
                      onChanged: (String? value) {
                        if (value == null || value.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content:Text("Please input Book's Link!"),
                                duration: Duration(seconds: 3),
                              )
                          );
                        }
                        return null;
                      },
                    ),

                    Padding(padding: EdgeInsets.only(top:2.0,bottom: 2.0)),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: Price,
                            style: textStyle,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                              TextInputFormatter.withFunction((oldValue, newValue) {
                                try {
                                  final text = newValue.text;
                                  if (text.isNotEmpty) double.parse(text);
                                  return newValue;
                                } catch (e) {}
                                return oldValue;
                              })
                            ],
                            decoration: InputDecoration(
                                labelText: "Price",
                                labelStyle: textStyle,
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5.0)
                                )
                            ),
                            onChanged: (String? value) {
                              if (value == null || value.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content:Text("Please input Book's Price!"),
                                      duration: Duration(seconds: 3),
                                    )
                                );
                              }
                            },
                          ),
                        ),

                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 5.0),
                            child: ElevatedButton(
                              onPressed: () async {
                                //setState(() {});

                                print('click!!!');
/*
                              SnackBar(
                                content:Text("click!!!"),
                                duration: Duration(seconds: 3),
                              );
 */

                                if (_formKey.currentState!.validate()) {
                                  print('validated!');
                                  String response = '';

                                  int res=0;
                                  if (eId != 0){
                                    res = await editBook(eId,
                                        DateCreated.toString(),
                                        Title.text,
                                        Artist.text,
                                        Publisher.text,
                                        Link.text,
                                        double.parse(Price.text));
                                  }
                                  else {
                                    res = await addBook(
                                        DateCreated.toString(),
                                        Title.text,
                                        Artist.text,
                                        Publisher.text,
                                        Link.text,
                                        double.parse(Price.text));
                                  }

                                  sharedPreferences = await SharedPreferences.getInstance();
                                  sharedPreferences.setInt('id', 0);

                                  setState(() {
                                    eId = 0;
                                  });

                                  books = await this.handler.retrieveBook(_monthNum, _year);

                                  setState(() {});
                                  if (res > 0) {
                                    response = "Succesfully Inserted!";

                                    //Clear Text
                                    Title.text="";
                                    Artist.text="";
                                    Publisher.text="";
                                    Link.text="";
                                    Price.text="";

                                  } else {
                                    response =
                                        "Something went wrong! Response Code:" +
                                            res.toString();
                                  }
                                }
                              },
                              child:Icon(Icons.save),
                            ),
                          ),
                        ),

/*
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5.0),
                        child: ElevatedButton(
                          onPressed: () async {
                            print('click!!!');
                            if (_formKey.currentState!.validate()) {
                              print('validated!');
                              String response = '';
                              int res = await addBook(
                                  DateCreated.toString(),
                                  Title.text,
                                  Artist.text,
                                  Publisher.text,
                                  Link.text,
                                  double.parse(Price.text));

                              books = await this.handler.retrieveBook();

                              setState(() {});
                              if (res > 0) {
                                response = "Succesfully Inserted!";
                              } else {
                                response =
                                    "Something went wrong! Response Code:" +
                                        res.toString();
                              }
                            }
                          },
                          child:Icon(Icons.save),
                        ),
                      ),
                    ),*/

                        Expanded(
                          child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 0.0),
                              child: IconButton(icon: Icon(Icons.refresh),onPressed: () async{
                                _getCredentials();

                                books = await this.handler.retrieveBook(_monthNum, _year);

                                if (eId != 0){
                                  _getRecord();
                                }
                                else {
                                  //Clear Text
                                  Title.text = "";
                                  Artist.text = "";
                                  Publisher.text = "";
                                  Link.text = "";
                                  Price.text = "";
                                }

                                setState(() {});
                              },)
                          ),
                        ),

                      ],
                    ),

                    Stack(
                      children: [
                        Container(
                          alignment: Alignment.centerLeft,
                          margin: const EdgeInsets.only(top: 32),
                          child: Text(
                            _month,
                            style: TextStyle(
                              fontFamily: "NexaBold",
                              fontSize: screenWidth / 18,
                            ),
                          ),
                        ),
                        Container(
                          alignment: Alignment.centerRight,
                          margin: const EdgeInsets.only(top: 32),
                          child: GestureDetector(
                            onTap: () async {

                              final month = await showMonthYearPicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(2022),
                                  lastDate: DateTime(2099),
                                  builder: (context, child) {
                                    return Theme(
                                      data: Theme.of(context).copyWith(
                                        colorScheme: ColorScheme.light(
                                          primary: primary,
                                          secondary: primary,
                                          onSecondary: Colors.white,
                                        ),
                                        textButtonTheme: TextButtonThemeData(
                                          style: TextButton.styleFrom(
                                            primary: primary,
                                          ),
                                        ),
                                        textTheme: const TextTheme(
                                          headline4: TextStyle(
                                            fontFamily: "NexaBold",
                                          ),
                                          overline: TextStyle(
                                            fontFamily: "NexaBold",
                                          ),
                                          button: TextStyle(
                                            fontFamily: "NexaBold",
                                          ),
                                        ),
                                      ),
                                      child: child!,
                                    );
                                  }
                              );

                              if(month != null) {
                                setState(() {
                                  _month = DateFormat('MMMM').format(month);
                                  _monthNum = DateFormat('MM').format(month);
                                  _year = DateFormat('yyyy').format(month);
                                });
                              }


                            },
                            child: Text(
                              "Pick a Month",
                              style: TextStyle(
                                fontFamily: "NexaBold",
                                fontSize: screenWidth / 18,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                )),

            Column(
              children: [

                SizedBox(
                  height: 5,
                ),

                PaginatedDataTable(
                  columns: getColumns(columns),
                  source: _data,
                  columnSpacing: 60,
                  horizontalMargin: 5,
                  rowsPerPage: 5,
                  showCheckboxColumn: false,
                ),

              ],
            ),

            Column(
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: Text("Total - ${totalSpending.toStringAsFixed(0)}"),
                ),
                //FittedBox(child: Text("Total - ${totalSpending.toStringAsFixed(0)}")),
              ],
            ),
          ],

        ),
      ),
    );
  }

  List<DataColumn> getColumns(List<String> columns) => columns
      .map((String column) => DataColumn(
    label: Text(column),
  ))
      .toList();

  Future<int> addBook(String? dateTime, String? Title, String? Artist, String? Publisher, String? Link, double? Price) async
  {
    book _book = book(
        Date: dateTime,
        Title: Title,
        Artist: Artist,
        Publisher: Publisher,
        Link: Link,
        Price: Price,
        Status: 'Active');
    this.handler.updateStatus();
    return await this.handler.insertBook(_book);
    //return 0;
  }

  Future<int> editBook(int? id, String? dateTime, String? Title, String? Artist, String? Publisher, String? Link, double? Price) async
  {
    book _book = book(
        id: id,
        Date: dateTime,
        Title: Title,
        Artist: Artist,
        Publisher: Publisher,
        Link: Link,
        Price: Price,
        Status: 'Active');
    this.handler.updateStatus();
    return await this.handler.updateBook(_book);
    //return 0;
  }

}