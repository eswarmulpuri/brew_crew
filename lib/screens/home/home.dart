import 'package:brew_crew/models/brew.dart';
import 'package:brew_crew/models/user.dart';
import 'package:brew_crew/screens/home/settingsForm.dart';
import 'package:brew_crew/services/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:brew_crew/services/database.dart';
import 'package:provider/provider.dart';

import 'brewList.dart';

class Home extends StatelessWidget {

  final AuthService _auth = AuthService();
  //
  // User user;
  //
  // Home(User user) {
  //   this.user = user;
  // }

  @override
  Widget build(BuildContext context) {

    User user = Provider.of<User>(context);

    void _showSettingsPanel() {
      showModalBottomSheet(context: context, builder: (context) {
        return Container(
          padding: EdgeInsets.symmetric(vertical: 20,horizontal: 60),
          child: SettingsForm(),
        );
      });
    }

    return StreamProvider<List<Brew>>.value(
      value: DatabaseService(user.uid).brews,
      child: Scaffold(
        backgroundColor: Colors.brown[50],
        appBar: AppBar(
          title: Text('Brew Crew'),
          backgroundColor: Colors.brown[400],
          elevation: 0,
          actions: [
            FlatButton.icon(
                onPressed: () async {
                  await _auth.signOut();
                },
                icon: Icon(Icons.person),
                label: Text('logout')
            ),
            FlatButton.icon(
                onPressed: () {
                  _showSettingsPanel();
                },
                icon: Icon(Icons.settings),
                label: Text('Settings')
            )
          ],
        ),
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/coffee_bg.png')
            ),
          ),
            child: BrewList()
        ),
      ),
    );
  }
}
