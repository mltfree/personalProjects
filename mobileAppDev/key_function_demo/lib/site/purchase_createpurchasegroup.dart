import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_ownership_app_v2/user.dart';
import 'package:random_string/random_string.dart';


class PurchaseCreatePurchaseGroup extends StatefulWidget {
  @override
  _PurchaseCreatePurchaseGroup createState() => new _PurchaseCreatePurchaseGroup();

}

class _PurchaseCreatePurchaseGroup extends State<PurchaseCreatePurchaseGroup>{

  TextEditingController ownershipPctController = TextEditingController();


  /////////////// Drop Down Code ///////////////////////////
  List _products = ["XYZ Rice Milling Machine", "ABC Rice Milling Machine", "123 Rice Milling Machine"];

  List<DropdownMenuItem<String>> _dropDownMenuItems;
  String _currentProduct;

  @override
  void initState() {
    _dropDownMenuItems = getDropDownMenuItems();
    _currentProduct = _dropDownMenuItems[0].value;
    super.initState();
  }

  List<DropdownMenuItem<String>> getDropDownMenuItems() {
    List<DropdownMenuItem<String>> items = new List();
    for (String prod in _products) {
      items.add(new DropdownMenuItem(
          value: prod,
          child: new Text(prod)
      ));
    }
    return items;
  }

  ///////////////////////////////////////////////////////////////////


  @override
  Widget build(BuildContext context){
    var deviceSize = MediaQuery.of(context).size;
    return new Scaffold(
      appBar: AppBar(
        title: Text('Rice - Dynamically generating cooperatives'),
        backgroundColor: Colors.teal,
      ),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 5.0),
          child: Column(
            mainAxisAlignment : MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextFormField(
                controller: ownershipPctController,
                decoration: const InputDecoration(
                  icon: Icon(Icons.pie_chart),
                  hintText: '% Ownership',
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter some text';
                  }
                },
              ),
              new Container(
                padding: new EdgeInsets.all(3.0),
              ),
              Row(
                children: <Widget>[
                  new Icon(Icons.shopping_cart),
                  new Container(
                    padding: new EdgeInsets.all(5.0),
                  ),
                  Text("Select Product"),
                  new Container(
                    padding: new EdgeInsets.all(5.0),
                  ),
                  new DropdownButton(
                    hint: Text('Select Location'),
                    value: _currentProduct,
                    items: _dropDownMenuItems,
                    onChanged: changedDropDownItem,
                  ),
                ],
              ),
              RaisedButton(
                onPressed: () {
                  var _randString = randomString(20);
                  Firestore.instance.collection('purchaseGroup').document(_randString).setData({
                    'addingNewUsers':  true
                    , 'location': ScopedModel.of<UserModel>(context).location
                    , 'product' : ScopedModel.of<UserModel>(context).product
                    , 'product_name': _currentProduct
                    , 'users_status' : {ScopedModel.of<UserModel>(context).fbUID : 'interested'}
                    , 'users_PctOwnership' : {ScopedModel.of<UserModel>(context).fbUID: ownershipPctController.text}
                    , 'users_name' : {ScopedModel.of<UserModel>(context).fbUID :ScopedModel.of<UserModel>(context).uName}
                    , 'users_NextScheduledDate' : Map()
                    , 'document_ID' : _randString
                  });

                  ScopedModel.of<UserModel>(context, rebuildOnChange: true).setPurchaseGroups(_randString, 'interested');

                  updateUser_PurchaseGroup_Map(_randString);

                  //Firestore.instance.collection('user').document(ScopedModel.of<UserModel>(context).fbUID).updateData({
                  //  'purchaseGroups' : purchaseGroup_Map
                  //});
                },
                shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                child: Text('Create New Purchase Group'),
                textColor: Colors.white,
                color: Colors.teal,
              ),
            ],
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
              subtitle: Text('Create Purchase Group'),
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

  void changedDropDownItem(String selectedProduct) {
    setState(() {
      _currentProduct = selectedProduct;
    });
  }

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
}






