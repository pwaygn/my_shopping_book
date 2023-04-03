import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:my_shopping_book/models/artist.dart';
import 'package:my_shopping_book/db/DatabaseHandler.dart';

class ArtistScreen extends StatefulWidget {
  final artist Artist;
  ArtistScreen(this.Artist);

  @override
  State<StatefulWidget> createState() => _ArtistScreen(Artist);
}

class _ArtistScreen extends State<ArtistScreen> {
  double screenHeight = 0;
  double screenWidth = 0;

  late DatabaseHandler handler;

  artist Artist;
  _ArtistScreen(this.Artist);

  var NameController = TextEditingController();
  var textStyle=TextStyle();
  final connectionIssueSnackBar = SnackBar(content: Text("404, Connection Issue !"));

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    NameController.text=Artist.Name.toString();
    //textStyle=Theme.of(context).textTheme.caption!;
    textStyle=TextStyle(
      //fontFamily: "NexaBold",
      fontFamily: "Georgia",
      fontSize: screenWidth / 24,
    );

    return Scaffold(
      appBar: AppBar(
        title:Text('Artist'),
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
                saveArtist();
              },
              child: updateSaveText(),
            ),

            ElevatedButton (
              /*
              padding: EdgeInsets.all(8.0),
              textColor: Colors.blueAccent,
              */
              onPressed: (){
                deleteArtist(Artist.id!);
              },
              child: Text("Delete"),
            ),
          ],
        )

      ], ),
    );
  }

  void saveArtist() async{
    this.handler = DatabaseHandler();

    String response = '';

    //Artist.Name = NameController.text;

    int res=0;
    if (Artist.id == null){
      res = await this.handler.insertArtist(Artist);
    }
    else {
      res = await this.handler.updateArtist(Artist);
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
    print(NameController.text);
    Artist.Name = NameController.text;
  }

  void deleteArtist(int id) async{
    this.handler = DatabaseHandler();

    await this.handler.deleteArtist(id);
    Navigator.pop(context,true);
    //deleteResponse == true ? Navigator.pop(context,true):Scaffold.of(context).showSnackBar(connectionIssueSnackBar);
  }

  Widget updateSaveText(){
    return Artist.id == null ? Text("Save"):Text("Update");
  }

}
