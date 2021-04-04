import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:google_signin/provider/google_sign_in.dart';

final googleSignInProvider =
    ChangeNotifierProvider((ref) => GoogleSignInProvider());

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.pink,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, watch, child) {
      final provider = watch(googleSignInProvider);

      return Scaffold(
        appBar: AppBar(
          title: Text('Google Sign In'),
        ),
        body: StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (provider.isSignIn) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasData) {
                final user = FirebaseAuth.instance.currentUser;
                return Container(
                  alignment: Alignment.center,
                  color: Colors.pink[50],
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text('Logged In'),
                      SizedBox(height: 10),
                      CircleAvatar(
                          maxRadius: 25,
                          backgroundImage: NetworkImage(user.photoURL)),
                      SizedBox(height: 10),
                      Text('Name: ' + user.displayName),
                      SizedBox(height: 10),
                      Text('Email: ' + user.email),
                      SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () {
                          context.read(googleSignInProvider).logout();
                        },
                        child: Text('Logout'),
                      ),
                    ],
                  ),
                );
              } else {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SignInButton(
                        Buttons.Google,
                        text: "Sign up with Google",
                        onPressed: () {
                          context.read(googleSignInProvider).login();
                        },
                      ),
                    ],
                  ),
                );
              }
            }),
      );
    });
  }
}
