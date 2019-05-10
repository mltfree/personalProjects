import 'package:scoped_model/scoped_model.dart';


class UserModel extends Model {

  String uName = '';
  String uEmail = '';
  String location = '';
  String product = '';
  int userDefined = 0;
  String fbUID = '';
  String hoursNeeded = '';
  var user_need_map = Map();
  Map purchaseGroups = Map();

  void setName(String n){
    uName = n;

    notifyListeners();
  }

  void setFirebaseUID(String uid){
    fbUID = uid;

    notifyListeners();
  }

  void setLocation(String loc){
    location = loc;

    notifyListeners();
  }

  void setProduct(String prod){
    product = prod;

    notifyListeners();
  }

  void setUserDefined(int uD){
    userDefined = 1;

    notifyListeners();
  }

  void setPurchaseGroups(String key, String val){
    purchaseGroups[key] = val;

    notifyListeners();
  }

}