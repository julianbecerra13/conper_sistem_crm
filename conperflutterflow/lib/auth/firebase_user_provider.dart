import 'package:firebase_auth/firebase_auth.dart';
import 'package:rxdart/rxdart.dart';

class RodeoFirebaseUser {
  RodeoFirebaseUser(this.user);
  User? user;
  bool get loggedIn => user != null;
}

RodeoFirebaseUser? currentUser;
bool get loggedIn => currentUser?.loggedIn ?? false;
Stream<RodeoFirebaseUser> rodeoFirebaseUserStream() => FirebaseAuth.instance
        .authStateChanges()
        .debounce((user) => user == null && !loggedIn
            ? TimerStream(true, const Duration(seconds: 1))
            : Stream.value(user))
        .map<RodeoFirebaseUser>(
      (user) {
        currentUser = RodeoFirebaseUser(user);
        return currentUser!;
      },
    );
