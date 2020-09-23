import 'package:akash_siwisoft/auth/auth_manager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 40.0),
                child: Text(
                  "SIVISOFT",
                  style: TextStyle(fontSize: 40),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Text(
                  "Currency Converter",
                  style: TextStyle(fontSize: 18),
                ),
              ),
              Flexible(
                flex: 1,
                fit: FlexFit.tight,
                child: Container(
                  child: Center(
                    child: Consumer<AuthState>(
                      builder: (context, authState, child) {
                        switch (authState.currentStatus) {
                          case AuthStatus.SIGNED_OUT:
                            return buildSignInButton(context);
                          case AuthStatus.SIGNED_IN:
                            Future.delayed(Duration(milliseconds: 0), () {
                              Navigator.of(context).pushReplacementNamed('/baseSelector');
                            });
                            return Text("Sign In Successful!");
                          case AuthStatus.IN_PROGRESS:
                            return buildProgressBar();
                        }
                        return Container();
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildSignInButton(BuildContext context) => Consumer<AuthManager>(
    builder: (context, authManager, child) => RaisedButton.icon(
      color: Colors.white,
      onPressed: () {
        authManager.signIn();
      },
      icon: SizedBox(
        width: 20,
        child: Image.asset("assets/img/goo.png"),
      ),
      label: Text("Sign In"),
    ),
  );

  Widget buildProgressBar() => CircularProgressIndicator();
}
