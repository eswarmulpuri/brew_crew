class User {
  String uid;

  User(String uid) {
    this.uid = uid;
  }
}

class UserData {
  String uid;
  String name;
  String sugars;
  int strength;

  UserData({ this.uid,this.sugars,this.strength, this.name});
}