import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_ownership_app_v2/user.dart';



class PurchaseGroups extends StatefulWidget{

  @override
  _PurchaseGroupsState createState() => new _PurchaseGroupsState();

}


class _PurchaseGroupsState extends State<PurchaseGroups>{

  TextEditingController hourController = TextEditingController();

  @override
  Widget build(BuildContext context){
    var deviceSize = MediaQuery.of(context).size;
    return new Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: new AppBar(
        title: Text('Rice - Dynamically generating cooperatives'),
        backgroundColor: Colors.teal,
      ),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 5.0),
          child: Column(
              mainAxisAlignment : MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children : [
                SizedBox(
                  height : deviceSize.height * (7.0/10.0),
                  child: _buildBody(context),
                ),
                new Container(
                  padding: new EdgeInsets.all(5.0),
                ),
                ScopedModelDescendant<UserModel>(
                  builder : (context, child, user){
                    return RaisedButton(
                      onPressed: () {
                        Firestore.instance.collection('user').document(user.fbUID).updateData({'user_need': user.user_need_map});
                      },
                      child: Text('Purchase'),
                      color: Colors.teal,
                      shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                    );
                  },
                ),
              ]
          ),
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
              onTap: (){
                Navigator.pushNamed(context, '/purchase');
              },
              subtitle: const Text('Purchase - Groups'),
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


Widget _buildBody(BuildContext context) {
  return StreamBuilder<QuerySnapshot>(
    stream: Firestore.instance.collection('user').snapshots(), ///.where("location", isEqualTo: "Chennai").snapshots(),
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
  print(data['hoursNeeded']);
  final record = Record.fromSnapshot(data);

  if(data['name'] != ScopedModel.of<UserModel>(context).uName){
    ScopedModel.of<UserModel>(context, rebuildOnChange: true).user_need_map[data['name']] = data['hoursNeeded'];
    return Padding(
      key: ValueKey(record.name),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: ListTile(
          title: Text(record.name),
          subtitle: Text(record.location + ' ,' + record.product),
          onTap: () => print(record),
        ),
      ),
    );
  }
  if(data['name'] == ScopedModel.of<UserModel>(context).uName){
    return Padding(
      padding: const EdgeInsets.fromLTRB(1.0, 1.0, 1.0, 1.0),
    );
  }
}


/////// Record
class Record {
  final String name;
  final String location;
  final String product;
  final DocumentReference reference;

  Record.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['name'] != null),
        assert(map['location'] != null),
        assert(map['product'] != null),
        name = map['name'],
        location = map['location'],
        product = map['product'];

  Record.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

}