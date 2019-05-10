import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_ownership_app_v2/user.dart';





class Profile extends StatefulWidget{
  @override
  _ProfileState createState() => new _ProfileState();

}


class _ProfileState extends State<Profile>{

  String _name;
  TextEditingController nameController = TextEditingController();
  TextEditingController locationController = TextEditingController();

  /////////////// Drop Down Code ///////////////////////////
  List _cities = ["Select Your Location", "Mumbai", "Bangalore", "Kochi", "Trichy"];

  List<DropdownMenuItem<String>> _dropDownMenuItems;
  String _currentCity;

  @override
  void initState() {
    _dropDownMenuItems = getDropDownMenuItems();
    _currentCity = _dropDownMenuItems[0].value;
    super.initState();
  }

  List<DropdownMenuItem<String>> getDropDownMenuItems() {
    List<DropdownMenuItem<String>> items = new List();
    for (String city in _cities) {
      items.add(new DropdownMenuItem(
          value: city,
          child: new Text(city)
      ));
    }
    return items;
  }

  ///////////////////////////////////////////////////////////////////
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
                ListTile(
                  leading: const Icon(Icons.save),
                  title: Text('Currently Stored Information'),
                  subtitle: Text((ScopedModel.of<UserModel>(context, rebuildOnChange: true).uName) +
                      ' ,' + (ScopedModel.of<UserModel>(context, rebuildOnChange: true).location) +
                      ' ,' + (ScopedModel.of<UserModel>(context, rebuildOnChange: true).product) +
                      ' ,' + (ScopedModel.of<UserModel>(context, rebuildOnChange: true).hoursNeeded)),
                      onTap: (){
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    icon: Icon(Icons.email),
                    hintText: 'Email',
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
                TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    icon: Icon(Icons.person),
                    hintText: 'Name',
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
                    new Icon(Icons.location_on),
                    new Container(
                      padding: new EdgeInsets.all(5.0),
                    ),
                    //new Text("Please choose your city : "),
                    new Container(
                      padding: new EdgeInsets.all(5.0),
                    ),
                    new DropdownButton(
                      hint: Text('Select Location'),
                      value: _currentCity,
                      items: _dropDownMenuItems,
                      onChanged: changedDropDownItem,
                    ),
                  ],
                ),
                new Container(
                  padding: new EdgeInsets.all(5.0),
                ),
                ScopedModelDescendant<UserModel>(
                  builder : (context, child, user){
                    return RaisedButton(
                      onPressed: () {
                        Firestore.instance.collection('user').document(user.fbUID).updateData({'name': nameController.text , 'location': _currentCity});

                        user.setName(nameController.text);
                        user.setLocation(_currentCity);
                        print(user.fbUID);

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
              selected: true,
              onTap: (){
              },
            ),
            ListTile(
              leading: const Icon(Icons.shopping_cart),
              title: Text('Purchase'),
              onTap: (){
                Navigator.pushNamed(context, '/purchase');
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


  void changedDropDownItem(String selectedCity) {
    setState(() {
      _currentCity = selectedCity;
    });
  }


}