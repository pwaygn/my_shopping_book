import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:my_shopping_book/models/publisher.dart';
import 'package:my_shopping_book/db/DatabaseHandler.dart';

class PublisherScreen extends StatefulWidget {
  final publisher Publisher;
  PublisherScreen(this.Publisher);

  @override
  State<StatefulWidget> createState() => _PublisherScreen(Publisher);
}

class _PublisherScreen extends State<PublisherScreen> {
  double screenHeight = 0;
  double screenWidth = 0;

  late DatabaseHandler handler;

  publisher Publisher;
  _PublisherScreen(this.Publisher);

  var NameController = TextEditingController();
  var textStyle=TextStyle();
  final connectionIssueSnackBar = SnackBar(content: Text("404, Connection Issue !"));

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    NameController.text=Publisher.Name.toString();
    textStyle=Theme.of(context).textTheme.caption!;

    textStyle=TextStyle(
      //fontFamily: "NexaBold",
      fontFamily: "Georgia",
      fontSize: screenWidth / 24,
    );

    return Scaffold(
      appBar: AppBar(
        title:Text('Publisher'),
      ),
      body: _buildForm(),
    );
  }

  Widget _buildForm(){
    return Padding(
      padding: EdgeInsets.only(top: 35.0, left: 10.0, right: 10.0),
      child: ListView( children: <Widget>[

        TextField(
          controller: NameController,
          style: textStyle,
          onChanged: (value)=>updateName(),
          decoration: InputDecoration(
              labelText: "Name",
              labelStyle: textStyle,
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0)
              )
          ),
        ),

        Padding(padding: EdgeInsets.only(top:15.0,bottom: 15.0)),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            ElevatedButton (
              /*
              padding: EdgeInsets.all(8.0),
              textColor: Colors.blueAccent,
               */
              onPressed: (){
                savePublisher();
              },
              child: updateSaveText(),
            ),

            ElevatedButton (
              /*
              padding: EdgeInsets.all(8.0),
              textColor: Colors.blueAccent,
              */
              onPressed: (){
                deletePublisher(Publisher.id!);
              },
              child: Text("Delete"),
            ),
          ],
        )

      ], ),
    );
  }

  void savePublisher() async{
    this.handler = DatabaseHandler();

    String response = '';

    //Publisher.Name = NameController.text;

    int res=0;
    if (Publisher.id == null){
      res = await this.handler.insertPublisher(Publisher);
    }
    else {
      res = await this.handler.updatePublisher(Publisher);
    }
    setState(() {});
    if (res > 0) {
      response = "Succesfully Inserted!";
    } else {
      response = "Something went wrong! Response Code:" + res.toString();
    }
    /*
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:Text(response),
          duration: Duration(seconds: 3),
        )
    );
     */
    Navigator.pop(context,true);
  }

  void updateName(){
    Publisher.Name = NameController.text;
  }

  void deletePublisher(int id) async{
    this.handler = DatabaseHandler();

    await this.handler.deletePublisher(id);
    Navigator.pop(context,true);
    //deleteResponse == true ? Navigator.pop(context,true):Scaffold.of(context).showSnackBar(connectionIssueSnackBar);
  }

  Widget updateSaveText(){
    return Publisher.id == null ? Text("Save"):Text("Update");
  }

}
