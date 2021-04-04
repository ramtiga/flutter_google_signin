import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleSignInProvider extends ChangeNotifier {
  final googleSignIn = GoogleSignIn();
  bool _isSignIn;

  GoogleSignInProvider() {
    _isSignIn = false;
  }

  bool get isSignIn => _isSignIn;

  set isSignIn(bool isSignIn) {
    _isSignIn = isSignIn;
    notifyListeners();
  }

  //ログイン
  Future login() async {
    isSignIn = true;
    final user = await googleSignIn.signIn();

    if (user == null) {
      isSignIn = false;
      return;
    } else {
      final auth = await user.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: auth.accessToken,
        idToken: auth.idToken,
      );
      await FirebaseAuth.instance.signInWithCredential(credential);

      isSignIn = false;
    }
  }

  //ログアウト
  void logout() async {
    await googleSignIn.disconnect();
    FirebaseAuth.instance.signOut();
  }
}
