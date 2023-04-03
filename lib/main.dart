import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'dart:io';
import 'package:sqflite/sqflite.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:file_picker/file_picker.dart';
import 'package:my_shopping_book/page/homescreen.dart';
import 'package:month_year_picker/month_year_picker.dart';

void main() => runApp(MyShoppingBook());


class MyShoppingBook extends StatelessWidget
{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          brightness: Brightness.light,
          primaryColor: Colors.black,
          accentColor: Colors.cyan,
          fontFamily: 'Georgia',
          textTheme: const TextTheme(
              headline1: TextStyle(fontSize: 72.0,fontWeight: FontWeight.bold),
              headline2: TextStyle(fontSize: 36.0,fontStyle: FontStyle.italic),
              headline3: TextStyle(fontSize: 14.0, fontFamily: 'Hind')
          )),
      home: new Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text('My Shopping Books'),
          actions: [myPopMenu(),],
        ),
        body: Container(
          margin: EdgeInsets.all(10.0),
          child: HomeScreen(),
        ),
      ),
      localizationsDelegates: const [
        MonthYearPickerLocalizations.delegate,
      ],
    );
  }

  Widget myPopMenu() {
    return PopupMenuButton(
        color: Colors.white,
        onSelected: (value) {
          if (value==1){
            exportDB(context);
          }else{
            importDB(context);
          }
        },
        itemBuilder: (context) => [
          PopupMenuItem(
              value: 1,
              child: Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(2, 2, 8, 2),
                    child: Icon(Icons.print),
                  ),
                  Text('Export Data')
                ],
              )),
          PopupMenuItem(
            value: 2,
            child: Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(2, 2, 8, 2),
                  child: Icon(Icons.print),
                ),
                Text('Import Data')
                /*
                Text(
                  "Import Data",
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: const Color(0xff000000),
                  ),
                  textAlign: TextAlign.center,
                ),
                 */
              ],
            ),
          ),
        ]);
  }

  Future<void> exportDB(context) async
  {
    final dbFolder = await getDatabasesPath();
    File source1 = File('$dbFolder/myshoppingbook.db');

    Directory copyTo =
    Directory("storage/emulated/0/Sqlite Backup");
    if ((await copyTo.exists())) {
      // print("Path exist");
      var status = await Permission.storage.status;
      if (!status.isGranted) {
        await Permission.storage.request();
      }
    } else {
      print("not exist");
      if (await Permission.storage.request().isGranted) {
        // Either the permission was already granted before or the user just granted it.
        await copyTo.create();
      } else {
        print('Please give permission');
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content:Text("Please give permission"),
              duration: Duration(seconds: 3),
            )
        );
      }
    }

    String newPath = "${copyTo.path}/myshoppingbook.db";
    await source1.copy(newPath);
/*
    setState(() {
      message = 'Successfully Copied DB';
    });*/
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:Text("Successfully Copied DB"),
          duration: Duration(seconds: 3),
        )
    );
  }

  Future<void> importDB(context) async
  {
    var databasesPath = await getDatabasesPath();
    var dbPath = join(databasesPath, 'myshoppingbook.db');

    FilePickerResult? result =
    await FilePicker.platform.pickFiles();

    if (result != null) {
      File source = File(result.files.single.path!);
      await source.copy(dbPath);
      /*
      setState(() {
        message = 'Successfully Restored DB';
      });*/
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:Text("Successfully Restored DB"),
            duration: Duration(seconds: 3),
          )
      );
    } else {
      // User canceled the picker

    }
  }

}