import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_ownership_app_v2/user.dart';
import 'dart:convert';


class PurchaseSelectPurchaseGroup extends StatefulWidget {
  @override
  _PurchaseSelectPurchaseGroup createState() => new _PurchaseSelectPurchaseGroup();

}

class _PurchaseSelectPurchaseGroup extends State<PurchaseSelectPurchaseGroup>{

  @override
  Widget build(BuildContext context){
    var deviceSize = MediaQuery.of(context).size;
    return new Scaffold(
      appBar: AppBar(
        title: Text('Rice - Dynamically generating cooperatives'),
        backgroundColor: Colors.teal,
      ),
      body: Container(
        child : Column(
            mainAxisAlignment : MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children : [
              Container(
                padding: new EdgeInsets.all(5.0),
                decoration : const BoxDecoration(
                 border: Border(
                   bottom: BorderSide(width: 2.0, color: Colors.teal)
                 ),
               ),
               child: SizedBox(
                  height : deviceSize.height * (6.5/10.0),
                  child: _buildBody(context),
                ),

              ),
              new Container(
                padding: new EdgeInsets.all(5.0),
              ),
              RaisedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/purhcaseCreatePurchaseGroup');
                },
                shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                child: Text('Create New Purchase Group'),
                textColor: Colors.white,
                color: Colors.teal,
              ),
            ],
        ),
      ),
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
  String output = '';
  output = output + mapInfo(data);

  // Logic to update Purchase Group
  void updateUser_PurchaseGroup_Map(String rString) async {

    try{

      String _fbUID = ScopedModel.of<UserModel>(context).fbUID;
      DocumentSnapshot firebaseUserInfo = await Firestore.instance.collection('user').document(_fbUID).get();
      Map _purchaseGroup_Maps = firebaseUserInfo['purchaseGroups'];
      _purchaseGroup_Maps[rString] = 'interested';

      Firestore.instance.collection('user').document(ScopedModel.of<UserModel>(context).fbUID).updateData({
        'purchaseGroups' : _purchaseGroup_Maps
      });

    } catch(e){
      print(e);
    }

  }


  if(data['addingNewUsers'] == true){
    return Padding(
      key: ValueKey(record.product),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: ExpansionTile(
          title: Text(record.product_name),
          children: <Widget>[
            Column(
              mainAxisAlignment : MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text(output),
                new Container(
                  padding: new EdgeInsets.all(1.0),
                ),
                RaisedButton(
                  onPressed: () {
                    String _randString = data['document_ID'];
                    Map _user_status_map = data['users_status'];
                    _user_status_map[ScopedModel.of<UserModel>(context).fbUID] = 'interested';

                    Map _users_PctOwnership_map = data['users_PctOwnership'];
                    _users_PctOwnership_map[ScopedModel.of<UserModel>(context).fbUID] = '10%';

                    Map _users_name_map = data['users_name'];
                    _users_name_map[ScopedModel.of<UserModel>(context).fbUID] = ScopedModel.of<UserModel>(context).uName;

                    Firestore.instance.collection('purchaseGroup').document(_randString).updateData({
                       'users_status' : _user_status_map
                      , 'users_PctOwnership' : _users_PctOwnership_map // TODO :  make percentage dynamic
                      , 'users_name' : _users_name_map
                    });

                    ScopedModel.of<UserModel>(context, rebuildOnChange: true).setPurchaseGroups(_randString, 'interested');

                    updateUser_PurchaseGroup_Map(_randString);

                  },
                  shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                  child: Text('Join this purchase group'),
                  textColor: Colors.white,
                  color: Colors.teal,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

}


String mapInfo(DocumentSnapshot d){
  Map map_UserNames = d['users_name'];
  Map map_Ownership = d['users_PctOwnership'];
  String returnVal = '';
  for (var x in map_UserNames.keys){
    returnVal = 'UserName: ' + map_UserNames[x] + '; ' + 'Ideal Ownership: ' + map_Ownership[x] + '%||';
  }

  return returnVal;
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





