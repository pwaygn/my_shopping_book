import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:my_shopping_book/models/artist.dart';
import 'package:my_shopping_book/db/DatabaseHandler.dart';
import 'package:my_shopping_book/page/artistscreen.dart';

class ArtistListScreen extends StatefulWidget {
  ArtistListScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ArtistListScreen();
}

class _ArtistListScreen extends State<ArtistListScreen> {
  double screenHeight = 0;
  double screenWidth = 0;

  List<artist>? artists;
  late DatabaseHandler handler;

  getArtists(){
    this.handler = DatabaseHandler();
    this.handler.initializeDB().whenComplete(() async {
      artists = await this.handler.retrieveArtist();
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    getArtists();

    return Scaffold(
      floatingActionButton: _buildFloatingButton(),
      //body: (artists == null) ? Center(child: Text('Empty'),) : _buildArtistList(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              alignment: Alignment.centerLeft,
              margin: const EdgeInsets.only(top: 32),
              child: Text(
                "Artist List",
                style: TextStyle(
                  fontFamily: "NexaBold",
                  fontSize: screenWidth / 18,
                ),
              ),
            ),
            SizedBox(
              height: screenHeight / 1.45,
              child: (artists == null) ? Center(child: Text('Empty'),) : _buildArtistList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar(){
    return AppBar(
      title:Text('Artist List'),
    );
  }

  Widget _buildArtistList(){
    return ListView.builder(
      itemCount: artists?.length,
      itemBuilder: (context, index){
        return Card(
          color: Colors.white,
          elevation: 2.0,
          child: ListTile(
            title: ListTile(
              leading: displayByLevel(1),
              trailing: Icon(Icons.arrow_forward_ios),
              title: Text(artists![index].Name.toString()),
              onTap: (){
                navigateToArtist(this.artists![index]);
              },
            ),
          ),
        );
      },
    );
  }

  void navigateToArtist(artist obj) async{
    await Navigator.push(context, MaterialPageRoute(builder: (context) => ArtistScreen(obj)));
  }

  Widget _buildFloatingButton(){
    return FloatingActionButton(
        child: Icon(Icons.person_add),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        onPressed: (){
        navigateToArtist(artist(Name: ''));
    });
  }

  Widget displayByLevel(int level){
    var normal = Icon(Icons.person,color: Colors.lightBlue,);

    return normal;
  }

}
