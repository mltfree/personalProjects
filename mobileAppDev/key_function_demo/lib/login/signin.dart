import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_ownership_app_v2/site/purchase.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_ownership_app_v2/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:shared_ownership_app_v2/site/purchase_groups.dart';


class SignInPage extends StatefulWidget{
  @override
  _SignInPageState createState() => new _SignInPageState();

}


class _SignInPageState extends State<SignInPage>{

  String _email, _password;
  TextEditingController userNameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context){
    return new Scaffold(
      appBar: new AppBar(
        title: Text('Rice'),
        backgroundColor: Colors.teal,
      ),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 5.0),
          child: Column(
              mainAxisAlignment : MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
            children : [
              TextFormField(
                controller: userNameController,
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
              TextFormField(
                controller: passwordController,
                decoration: const InputDecoration(
                  icon: Icon(Icons.lock),
                  hintText: 'Password',
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter some text';
                  }
                },
                obscureText: true,
              ),
              RaisedButton(
                onPressed: () {
                  _email =  userNameController.text;
                  _password = passwordController.text;
                  signIn();
                  },
                shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                child: Text('Sign In'),
                color: Colors.teal,
              ),
            ]
          ),
        ),
      ),
    );
  }

  void signIn() async {
    try {

      FirebaseUser firebase_user = await FirebaseAuth.instance.signInWithEmailAndPassword(email: _email, password: _password);

      DocumentSnapshot firebaseUserInfo = await Firestore.instance.collection('user').document(firebase_user.uid).get();
      //userInfo['name'];
      //userInfo['location'];
      ScopedModel.of<UserModel>(context, rebuildOnChange: true).fbUID = firebase_user.uid;
      ScopedModel.of<UserModel>(context, rebuildOnChange: true).uName = firebaseUserInfo['name'];
      ScopedModel.of<UserModel>(context, rebuildOnChange: true).location = firebaseUserInfo['location'];
      ScopedModel.of<UserModel>(context, rebuildOnChange: true).product = firebaseUserInfo['product'];
      ScopedModel.of<UserModel>(context, rebuildOnChange: true).hoursNeeded = firebaseUserInfo['hoursNeeded'];
      ScopedModel.of<UserModel>(context, rebuildOnChange: true).user_need_map = firebaseUserInfo['user_need'];
      ScopedModel.of<UserModel>(context, rebuildOnChange: true).purchaseGroups = firebaseUserInfo['purchaseGroups'];
      print('done');

      Navigator.pushNamed(context, '/purchase');
    } catch (e) {
      print(e.message);
    }
  }



}




