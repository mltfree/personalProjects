import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_ownership_app_v2/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';



class Purchase extends StatelessWidget{

  @override
  Widget build(BuildContext context){
    return new Scaffold(
      appBar: AppBar(
        title: Text('Rice - Dynamically generating cooperatives'),
        backgroundColor: Colors.teal,
      ),
      body: Center(
          child: MyGridView().build(context)
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Text('Pratik'),
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


class MyGridView {
  Card getStructuredGridCell(name, image) {
    return new Card(
      elevation: 1.4,
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        verticalDirection: VerticalDirection.down,
        children: <Widget>[
          new Image(image: new AssetImage('images/' + image)),
          new Center(child: new Text(name)
          )
        ],
      ),
    );
  }



  GridView build(BuildContext context){
    return new GridView.count(
      primary: true,
      padding: const EdgeInsets.all(1.0),
      crossAxisCount: 2,
      childAspectRatio: 0.99,
      mainAxisSpacing: 1.0,
      crossAxisSpacing: 1.0,
      children: <Widget>[
        ScopedModelDescendant<UserModel>(
            builder: (context, child, user) => RaisedButton(
              child : getStructuredGridCell("Farm Equipment", "FarmEquipmentIcon.JPG"),
              color: Colors.white,
              onPressed: () {
                Navigator.pushNamed(context, '/purchaseSelectPurchaseGroup');
                user.setProduct('FarmEquipment');
                Firestore.instance.collection('user').document(user.fbUID).updateData({'product': 'FarmEquipment'});
              },
            ),
        ),
        ScopedModelDescendant<UserModel>(
            builder: (context, child, user) => RaisedButton(
              child : getStructuredGridCell("Farm Vehicles", "TractorIcon.JPG"),
              onPressed: () {
                Navigator.pushNamed(context, '/purchaseProductNeed');
                user.setProduct('Tractor');
                Firestore.instance.collection('user').document(user.fbUID).updateData({'product': 'Tractor'});
              },
              color: Colors.white,
            )
        ),
      ],
    );
  }

}