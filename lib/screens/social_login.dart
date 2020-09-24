import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn googleSignIn = GoogleSignIn();
final firestoreInstance = FirebaseFirestore.instance;

void signInWithFacebook() async {
  FacebookLogin facebookLogin = FacebookLogin();
  final result = await facebookLogin.logIn(["email"]);
  switch (result.status) {
    case FacebookLoginStatus.loggedIn:
      final FacebookAccessToken accessToken = result.accessToken;
      print('''
         Logged in!
         
         Token: ${accessToken.token}
         User id: ${accessToken.userId}
         Expires: ${accessToken.expires}
         Permissions: ${accessToken.permissions}
         Declined permissions: ${accessToken.declinedPermissions}
         ''');
      break;
    case FacebookLoginStatus.cancelledByUser:
      print('Login cancelled by the user.');
      break;
    case FacebookLoginStatus.error:
      print('Something went wrong with the login process.\n'
          'Here\'s the error Facebook gave us: ${result.errorMessage}');
      break;
  }
  final token = result.accessToken.token;
  final graphResponse = await http.get(
      'https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,email&access_token=${token}');
  final profile = jsonDecode(graphResponse.body);
  print(" Facebook profile:");
  print(profile);
  if (result.status == FacebookLoginStatus.loggedIn) {
    final credential = FacebookAuthProvider.credential(token);
    final UserCredential authResult =
        await _auth.signInWithCredential(credential);
    final User user = authResult.user;
    DocumentReference usersRef =
    firestoreInstance.collection("users").doc(user.uid);
    usersRef.get().then((docSnapshot) => {
      if (!docSnapshot.exists)
        {
          usersRef.set({
            "firstName": profile["first_name"],
            "lastName": profile["last_name"],
            "email":profile["email"],
            "address": "",
            "phoneNumber": "",
            "points": 0,
            "profilePicture": user.photoURL,
          }).then((value) {
            print("Successfully uploaded User details to Firebase");
          })
        }
    });
    // firestoreInstance.collection("users").doc(user.uid).set({
    //   "firstName": profile["first_name"],
    //   "lastName": profile["last_name"],
    //   "email": profile["email"],
    //   "address": "",
    //   "phoneNumber": "",
    //   "points": 0,
    //   "profilePicture": "",
    // }).then((value) {
    //   print("Successfully uploaded User details to Firebase");
    // });
  }
}

Future<String> signInWithGoogle() async {
  await Firebase.initializeApp();
  final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
  final GoogleSignInAuthentication googleSignInAuthentication =
      await googleSignInAccount.authentication;

  final AuthCredential credential = GoogleAuthProvider.credential(
    accessToken: googleSignInAuthentication.accessToken,
    idToken: googleSignInAuthentication.idToken,
  );

  final UserCredential authResult =
      await _auth.signInWithCredential(credential);
  final User user = authResult.user;

  if (user != null) {
    assert(!user.isAnonymous);
    assert(await user.getIdToken() != null);

    final User currentUser = _auth.currentUser;
    assert(user.uid == currentUser.uid);

    print('signInWithGoogle succeeded: ');
    print(user);
    List<String> name = user.displayName.split(' ');
    DocumentReference usersRef =
        firestoreInstance.collection("users").doc(user.uid);
    usersRef.get().then((docSnapshot) => {
          if (!docSnapshot.exists)
            {
              usersRef.set({
                "firstName": name[0],
                "lastName": name[1],
                "email": user.email,
                "address": "",
                "phoneNumber": "",
                "points": 0,
                "profilePicture": user.photoURL,
              }).then((value) {
                print("Successfully uploaded User details to Firebase");
              })
            }
        });
    return '$user';
  }

  return null;
}

Future<void> signOutGoogle() async {
  await googleSignIn.signOut();

  print("User Signed Out");
}
