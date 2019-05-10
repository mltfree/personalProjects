import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_ownership_app_v2/site/purchase.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_ownership_app_v2/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';



class SignUpPage extends StatefulWidget{
  @override
  _SignUpPageState createState() => new _SignUpPageState();

}


class _SignUpPageState extends State<SignUpPage>{

  String _email, _password;
  TextEditingController userNameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context){
    return new Scaffold(
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
                  child: Text('Sign Up'),
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

      FirebaseUser firebase_user = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: _email, password: _password);

      Firestore.instance.collection('user').document(firebase_user.uid).setData({ 'firebaseUID':  firebase_user.uid
        , 'name': ''
        , 'location': ''
        , 'product': ''
        , 'hoursNeeded': ''
        , 'user_need' : Map()
        , 'purchaseGroups' : Map()});
      ScopedModel.of<UserModel>(context).setFirebaseUID(firebase_user.uid);



      print('done');

      Navigator.pushNamed(context, '/purchase');
    } catch (e) {
      print(e.message);

    }
  }

}