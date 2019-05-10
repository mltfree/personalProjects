import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_ownership_app_v2/user.dart';



class PurchaseProductNeed extends StatefulWidget{

  @override
  _PurchaseProductNeedState createState() => new _PurchaseProductNeedState();

}


class _PurchaseProductNeedState extends State<PurchaseProductNeed>{

  TextEditingController hourController = TextEditingController();


  @override
  Widget build(BuildContext context){
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
                new Container(
                  padding: new EdgeInsets.all(3.0),
                ),
                TextFormField(
                  controller: hourController,
                  decoration: const InputDecoration(
                    icon: Icon(Icons.watch_later),
                    hintText: 'Hours Needed',
                  ),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter some text';
                    }
                  },
                ),
                new Container(
                  padding: new EdgeInsets.all(5.0),
                ),
                ScopedModelDescendant<UserModel>(
                  builder : (context, child, user){
                    return RaisedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/purchaseGroups');
                        user.hoursNeeded = hourController.text;
                        Firestore.instance.collection('user').document(user.fbUID).updateData({'hoursNeeded': hourController.text});
                      },
                      child: Text('Submit'),
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