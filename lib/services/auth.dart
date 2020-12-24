import 'package:firebase_auth/firebase_auth.dart';
import 'package:helpquest/models/user.dart';
import 'package:helpquest/services/database.dart';

class AuthService{

  final FirebaseAuth _auth = FirebaseAuth.instance;
  //create user obj based on FirebaseUser
  User _userFromFirebaseUser(FirebaseUser user){
    return user != null ? User(uid: user.uid) : null;
  }
  //auth change user stream
  Stream<User> get user{
    return _auth.onAuthStateChanged
        //.map((FirebaseUser user) => _userFromFirebaseUser(user));
        .map(_userFromFirebaseUser);
  }
  /*
  //login anon
  Future signInAnon() async {
    try{
      AuthResult result = await _auth.signInAnonymously();
      FirebaseUser user = result.user;
      return _userFromFirebaseUser(user);
    }catch(e){
      print(e.toString());
      return null;
    }
  }
  */

  //login mail
  Future signInWithEmailAndPassword(String email, String password) async{
    try{
      AuthResult result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      FirebaseUser user = result.user;
      DatabaseService(key: user.uid).setStatus(true);
      return _userFromFirebaseUser(user);
    }catch(e){
      print(e.toString());
      return null;
    }
  }
  //register mail
  Future registerWithEmailAndPassword(String email, String password, String username) async{
    try{
      AuthResult result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      FirebaseUser user = result.user;
      //create a new document for the user with the uid
      await DatabaseService(key: user.uid).updateUserData(username, email, "", true);
      return _userFromFirebaseUser(user);
    }catch(e){
      print(e.toString());
      return null;
    }
  }
  //password reset
  Future resetPassword(String email) async {
    try{
      return await _auth.sendPasswordResetEmail(email: email);
    }catch(e){
      print(e.toString());
    }
  }
  //sign out
Future signOut(String uid) async
{
  try{
    DatabaseService(key: uid).setStatus(false);
    return await _auth.signOut();
  }catch(e){
    print(e.toString());
    return null;
  }
}}