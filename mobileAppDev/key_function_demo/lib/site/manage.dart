import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_ownership_app_v2/user.dart';
import 'dart:convert';


class Manage extends StatefulWidget {
  @override
  _ManageState createState() => new _ManageState();

}

class _ManageState extends State<Manage>{

  @override
  Widget build(BuildContext context){
    var deviceSize = MediaQuery.of(context).size;
    return new Scaffold(
      appBar: AppBar(
        title: Text('Rice - Dynamically generating cooperatives'),
        backgroundColor: Colors.teal,
      ),
      body: _buildBody(context),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Text('Drawer Header'),
              decoration: BoxDecoration(
                color: Colors.teal,
              ),
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: Text('Profile'),
              onTap: (){
                Navigator.pushNamed(context, '/profile');
              },
            ),
            ListTile(
              leading: const Icon(Icons.shopping_cart),
              title: Text('Purchase'),
              subtitle: Text('Select Purchase Group'),
              selected: true,
              onTap: (){

              },
            ),
            ListTile(
              leading: const Icon(Icons.folder),
              title: Text('Manage'),
              onTap: (){
                Navigator.pushNamed(context, '/manage');
              },
            ),
          ],
        ),
      ),
    );
  }

}


/////////// Adding list elements ////////////////

Widget _buildBody(BuildContext context) {
  return StreamBuilder<QuerySnapshot>(
    stream: Firestore.instance.collection('purchaseGroup').where("product", isEqualTo: ScopedModel.of<UserModel>(context).product).snapshots(),
    builder: (context, snapshot) {
      if (!snapshot.hasData) return LinearProgressIndicator();

      return _buildList(context, snapshot.data.documents);
    },
  );
}



Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
  return ListView(
    padding: const EdgeInsets.only(top: 20.0),
    children: snapshot.map((data) => _buildListItem(context, data)).toList(),
  );
}


Widget _buildListItem(BuildContext context, DocumentSnapshot data) {
  //print(data['hoursNeeded']);
  final record = Record.fromSnapshot(data);


  bool checkVal = data['users_name'].containsKey(ScopedModel.of<UserModel>(context).fbUID);

  if(checkVal){//   (data['users_name'].containsKey(ScopedModel.of<UserModel>(context).fbUID)){
    return Padding(
      key: ValueKey(record.product),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: ListTile(
          title: Text(record.product_name),

        ),
      ),
    );
  }
  else {
    return Container(
        padding: EdgeInsets.all(1.0),
      );
  }

}



/////// Record
class Record {
  final String location;
  final String product;
  final String product_name;
  final DocumentReference reference;

  Record.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['location'] != null),
        assert(map['product'] != null),
        assert(map['product_name'] != null),
        location = map['location'],
        product = map['product'],
        product_name = map['product_name'];

  Record.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

}





