import 'package:brew_crew/services/auth.dart';
import 'package:brew_crew/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:brew_crew/shared/constants.dart';

class SignIn extends StatefulWidget {

  Function toggleView;

  SignIn(Function toggleView) {
    this.toggleView = toggleView;
  }

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

  final AuthService _auth = AuthService();
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
        title: Text('Sign in to Brew Crew'),
        actions: [
          FlatButton.icon(
            label: Text('Register'),
            icon: Icon(Icons.person),
            onPressed: () {
              widget.toggleView();
            },
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
                decoration: textInboxDecoration.copyWith(hintText: 'Password'),
                validator: (val) => val.length < 6 ? 'Enter a password 6+ characters long' : null,
                obscureText: true,
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
                    'Sign In',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                  onPressed: () async {
                    if(_formKey.currentState.validate()) {

                      setState(() {
                        loading = true;
                      });

                      dynamic result = await _auth.signInWithEmailAndPassword(email, password);

                      if(result == null) {
                        setState(() {
                          loading = false;
                          error = 'Could not sign in with the Credentials!';
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
