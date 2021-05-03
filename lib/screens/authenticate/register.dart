import 'package:brew_crew/services/auth.dart';
import 'package:brew_crew/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:brew_crew/shared/constants.dart';


class Register extends StatefulWidget {

  Function toggleView;

  Register(Function toggleView) {
    this.toggleView = toggleView;
  }

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

  final AuthService _auth = new AuthService();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;

  String email = '';
  String password = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    return loading ? Loading() : Scaffold(
      backgroundColor: Colors.brown[100],
      appBar: AppBar(
        backgroundColor: Colors.brown[400],
        elevation: 0,
        title: Text('Sign Up to Brew Crew'),
        actions: [
          FlatButton.icon(
              onPressed: () {
                widget.toggleView();
              },
              icon: Icon(Icons.person),
              label: Text('Sign In')
          )
        ],
      ),
      body: Container(
          padding: EdgeInsets.symmetric(vertical: 20,horizontal: 50),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                SizedBox(height: 20),
                TextFormField(
                  decoration: textInboxDecoration.copyWith(hintText: 'Email'),
                  validator: (val) => val.isEmpty ? 'Enter an Email' : null,
                  onChanged: (val) {
                    setState(() {
                      email = val;
                    });
                  },
                ),
                SizedBox(height: 20),
                TextFormField(
                  obscureText: true,
                  decoration: textInboxDecoration.copyWith(hintText: 'Password'),
                  validator: (val) => val.length < 6 ? 'Enter a password 6+ characters long' : null,
                  onChanged: (val) {
                    setState(() {
                      password = val;
                    });
                  },
                ),
                SizedBox(height: 20),
                RaisedButton(
                    color: Colors.pink[400],
                    child: Text(
                      'Register',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    onPressed: () async {
                      if(_formKey.currentState.validate()) {
                        setState(() {
                          loading = true;
                        });
                        dynamic result = await _auth.registerWithEmailAndPassword(email, password);

                        if(result == null) {
                          loading = false;
                          setState(() {
                            error = 'please supply a valid email';
                          });
                        }
                      }
                    }
                ),
                SizedBox(height: 12),
                Text(
                  error,
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 14.0
                  ),
                )
              ],
            ),
          )
      ),
    );
  }
}
