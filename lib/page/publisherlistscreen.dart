import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:my_shopping_book/models/publisher.dart';
import 'package:my_shopping_book/db/DatabaseHandler.dart';
import 'package:my_shopping_book/page/publisherscreen.dart';

class PublisherListScreen extends StatefulWidget {
  PublisherListScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _PublisherListScreen();
}

class _PublisherListScreen extends State<PublisherListScreen> {
  double screenHeight = 0;
  double screenWidth = 0;

  List<publisher>? publishers;
  late DatabaseHandler handler;

  getPublishers(){
    this.handler = DatabaseHandler();
    this.handler.initializeDB().whenComplete(() async {
      publishers = await this.handler.retrievePublisher();
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    getPublishers();

    return Scaffold(
      floatingActionButton: _buildFloatingButton(),
      //body: (publishers == null) ? Center(child: Text('Empty'),) : _buildPublisherList(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              alignment: Alignment.centerLeft,
              margin: const EdgeInsets.only(top: 32),
              child: Text(
                "Publisher List",
                style: TextStyle(
                  fontFamily: "NexaBold",
                  fontSize: screenWidth / 18,
                ),
              ),
            ),
            SizedBox(
              height: screenHeight / 1.45,
              child: (publishers == null) ? Center(child: Text('Empty'),) : _buildPublisherList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar(){
    return AppBar(
      title:Text('Publisher List'),
    );
  }

  Widget _buildPublisherList(){
    return ListView.builder(
      itemCount: publishers?.length,
      itemBuilder: (context, index){
        return Card(
          color: Colors.white,
          elevation: 2.0,
          child: ListTile(
            title: ListTile(
              leading: displayByLevel(1),
              trailing: Icon(Icons.arrow_forward_ios),
              title: Text(publishers![index].Name.toString()),
              onTap: (){
                navigateToPublisher(this.publishers![index]);
              },
            ),
          ),
        );
      },
    );
  }

  void navigateToPublisher(publisher obj) async{
    await Navigator.push(context, MaterialPageRoute(builder: (context) => PublisherScreen(obj)));
  }

  Widget _buildFloatingButton(){
    return FloatingActionButton(
        child: Icon(Icons.add_business),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        onPressed: (){
        navigateToPublisher(publisher(Name: ''));
    });
  }

  Widget displayByLevel(int level){
    var normal = Icon(Icons.person,color: Colors.lightBlue,);

    return normal;
  }

}
