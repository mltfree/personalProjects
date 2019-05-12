import 'package:flutter/material.dart';



class WelcomePage extends StatefulWidget {
  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage>{

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text('Reader'),
        backgroundColor: Colors.blue,
      ),
      body : Container(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 5.0),
          child: Column(
            mainAxisAlignment : MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              RaisedButton(
                onPressed: navigateToQR,
                child: Text('QR-Bar Code Detector'),
                color: Colors.blue,
                shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),

              ),
              RaisedButton(
                onPressed: navigateToTextReader,
                child: Text('Text Detector'),
                color: Colors.blue,
                shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
              ),
            ],
          ),
        ),
      ),
    );
  }


  void navigateToQR(){
    Navigator.pushNamed(context, '/qrDetector');
  }


  void navigateToTextReader(){
    Navigator.pushNamed(context, '/textReader');
  }

}