import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

enum AuthStatus { SIGNED_OUT, SIGNED_IN, IN_PROGRESS }

class AuthState extends ChangeNotifier {
  AuthStatus _currentStatusInternal = AuthStatus.IN_PROGRESS;

  AuthStatus get currentStatus => _currentStatusInternal;

  set _currentStatus(AuthStatus newStatus) {
    _currentStatusInternal = newStatus;
    notifyListeners();
  }
}

class AuthManager extends ChangeNotifier {
  final AuthState _authState;

  AuthManager(this._authState) {
    print("Hello");
    _init();
  }

  void _init() async {
    final signedIn = await _googleSignIn.isSignedIn();
    _authState._currentStatus =
        signedIn ? AuthStatus.SIGNED_IN : AuthStatus.SIGNED_OUT;
  }

  GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
    ],
  );

  void signOut() async {
    _authState._currentStatus = AuthStatus.IN_PROGRESS;
    notifyListeners();
    try {
      final result = await _googleSignIn.signOut();
      _authState._currentStatus = AuthStatus.SIGNED_OUT;
    } catch (error) {
      print(error);
      _authState._currentStatus = AuthStatus.SIGNED_IN;
    }
  }

  void signIn() async {
    _authState._currentStatus = AuthStatus.IN_PROGRESS;
    try {
      final result = await _googleSignIn.signIn();
      if (result == null) {
        _authState._currentStatus = AuthStatus.SIGNED_OUT;
      } else {
        _authState._currentStatus = AuthStatus.SIGNED_IN;
      }
    } catch (error) {
      print(error);
      _authState._currentStatus = AuthStatus.SIGNED_OUT;
    }
  }
}
