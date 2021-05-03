import 'package:brew_crew/models/user.dart';
import 'package:brew_crew/services/database.dart';
import 'package:brew_crew/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:brew_crew/shared/constants.dart';
import 'package:provider/provider.dart';


class SettingsForm extends StatefulWidget {
  @override
  _SettingsFormState createState() => _SettingsFormState();
}

class _SettingsFormState extends State<SettingsForm> {

  final _formKey = GlobalKey<FormState>();
  final List<String> sugars = ['0', '1', '2', '3', '4'];

  //form values
  String _currentName;
  String _currentSugars;
  int _currentStrength;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);

    return StreamBuilder<UserData>(
      stream: DatabaseService(user.uid).userData,
      // ignore: missing_return
      builder: (context, snapshot) {

        if(snapshot.hasData) {

          UserData data = snapshot.data;

          return Form(
              key: _formKey,
              child: Column(
                children: [
                  Text(
                      'Update your brew settings.',
                      style: TextStyle(fontSize: 18)
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    initialValue: data.name,
                    decoration: textInboxDecoration,
                    validator: (val) => val.isEmpty ? 'Please enter a name' : null,
                    onChanged: (val) => setState(
                          () => _currentName = val,
                    ),
                  ),
                  SizedBox(height: 20),

                  //DropDown

                  DropdownButtonFormField(
                    value: _currentSugars ?? data.sugars,
                    decoration: textInboxDecoration,
                    items: sugars.map((sugar) {
                      return DropdownMenuItem(
                        value: sugar,
                        child: Text('$sugar sugars'),
                      );
                    }).toList(),
                    onChanged: (val) => setState(() => _currentSugars = val ),
                  ),

                  //Slider

                  Slider(
                      min: 100,
                      max: 900,
                      divisions: 8,
                      value: (_currentStrength ?? data.strength).toDouble(),
                      activeColor: Colors.brown[_currentStrength ?? data.strength],
                      inactiveColor: Colors.brown[_currentStrength ?? data.strength],
                      onChanged: (val) {
                        setState(() {
                          _currentStrength = val.round();
                        });
                      }
                  ),

                  RaisedButton(
                      color: Colors.pink[400],
                      child: Text(
                        'Update',
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () async {
                        if(_formKey.currentState.validate()) {
                          await DatabaseService(user.uid)
                              .updateUserData(_currentSugars ?? data.sugars, _currentName ?? data.name, _currentStrength ?? data.strength);
                        };

                        Navigator.pop(context);
                      }
                  )
                ],
              )
          );
        } else {
          Loading();
        }
      }
    );
  }
}
