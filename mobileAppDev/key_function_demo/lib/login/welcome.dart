import 'package:flutter/material.dart';
import 'package:shared_ownership_app_v2/login/signin.dart';



class WelcomePage extends StatefulWidget {
  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage>{

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text('Rice'),
        backgroundColor: Colors.teal,
      ),
      body : Container(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 5.0),
            child: Column(
              mainAxisAlignment : MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                RaisedButton(
                  onPressed: navigateToSignIn,
                  child: Text('Sign In'),
                  color: Colors.teal,
                  shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),

                ),
                RaisedButton(
                  onPressed: navigateToSignUp,
                  child: Text('Sign Up'),
                  color: Colors.teal,
                  shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                ),
              ],
            ),
      ),
      ),
    );
  }


  void navigateToSignIn(){
    Navigator.pushNamed(context, '/signin');
  }


  void navigateToSignUp(){
    Navigator.pushNamed(context, '/signup');
  }

}