import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import 'package:shared_ownership_app_v2/login/welcome.dart';
import 'package:shared_ownership_app_v2/login/signin.dart';
import 'package:shared_ownership_app_v2/site/purchase.dart';
import 'package:shared_ownership_app_v2/site/manage.dart';
import 'package:shared_ownership_app_v2/user.dart';
import 'package:shared_ownership_app_v2/site/profile.dart';
import 'package:shared_ownership_app_v2/site/purchase_productneed.dart';
import 'package:shared_ownership_app_v2/site/purchase_groups.dart';
import 'package:shared_ownership_app_v2/login/signup.dart';
import 'package:shared_ownership_app_v2/site/purchase_selectpurchasegroup.dart';
import 'package:shared_ownership_app_v2/site/purchase_createpurchasegroup.dart';


void main() {
  final user = UserModel();

  runApp(ScopedModel<UserModel>(
      model: user,
      child: MyApp()));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rice - Dynamically generating cooperatives',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        backgroundColor: Colors.teal[50],
      ),
      routes:{
        '/welcome': (context) => WelcomePage(),
        '/signin' : (context) => SignInPage(),
        '/purchase' : (context) => Purchase(),
        '/manage' : (context) => Manage(),
        '/profile' : (context) => Profile(),
        '/purchaseProductNeed' : (context) => PurchaseProductNeed(),
        '/purchaseGroups' : (context) => PurchaseGroups(),
        '/signup' : (context) => SignUpPage(),
        '/purchaseSelectPurchaseGroup' : (context) => PurchaseSelectPurchaseGroup(),
        '/purhcaseCreatePurchaseGroup' : (context) => PurchaseCreatePurchaseGroup(),
      },
      home: WelcomePage(),
    );
  }
}
