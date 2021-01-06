import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_list/services/auth_service.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          alignment: AlignmentDirectional.center,
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'PODSJETNIK ZA KUPOVINU',
                    style: TextStyle(
                      fontSize: 24.0,
                      fontFamily: 'Poppins-Bold',
                    ),
                  ),
                  Text(
                    'Zaboravljanju hljeba je došao kraj',
                    style: TextStyle(
                      fontSize: 18.0,
                    ),
                  ),
                  GoogleSignInButton(
                    darkMode: false,
                    onPressed: () async =>
                        context.read<AuthService>().signInWithGoogle(),
                  ),
                ],
              ),
            ),
            Positioned(
                bottom: 20.0,
                child: Column(
                  children: <Widget>[
                    Text(
                      'Copyright © 2021 Andrej Vujić',
                      style: TextStyle(
                        fontSize: 12.0,
                      ),
                    ),
                    Text(
                      'All rights reserved.',
                      style: TextStyle(
                        fontSize: 12.0,
                      ),
                    ),
                  ],
                )),
          ],
        ),
      ),
    );
  }
}
