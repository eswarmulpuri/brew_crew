import 'package:brew_crew/models/brew.dart';
import 'package:brew_crew/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {

  String uid;

  DatabaseService(String uid) {
    this.uid = uid;
  }

  // collection reference
  final CollectionReference brewCollection = Firestore.instance.collection('brews');

  Future updateUserData(String sugars, String name, int strength) async {
    return await brewCollection.document(uid).setData({
      'sugars': sugars,
      'name' : name,
      'strength': strength
    });
  }

  // userData from snapshot

  UserData _userDataFromSnapshot(DocumentSnapshot snapshot) {
    return UserData(
      uid: uid,
      name: snapshot.data['name'],
      sugars: snapshot.data['sugars'],
      strength: snapshot.data['strength']
    );
  }

  List<Brew> _brewListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map(
            (e) => Brew(e.data['name'] ?? '', e.data['sugars'] ?? '', e.data['strength'] ?? 0)
    ).toList();
  }

  // get brews stream
  Stream<List<Brew>> get brews {
    return brewCollection.snapshots().map(_brewListFromSnapshot);
  }

  //get user doc stream
  Stream<UserData> get userData {
    return brewCollection.document(uid).snapshots()
        .map(
            (doc) => _userDataFromSnapshot(doc));
  }

}