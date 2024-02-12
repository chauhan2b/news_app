import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_repository.g.dart';

class AuthRepository {
  final _firebaseAuth = FirebaseAuth.instance;
  final _firebaseFirestore = FirebaseFirestore.instance;

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  Future<void> signIn(String email, String password) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      // email enumeration is on by default, which improves security by not providing
      // extensive error messages, so only the first condition is used
      if (e.code == 'invalid-credential') {
        throw ('Email or password is incorrect.');
      } else if (e.code == 'wrong-password') {
        throw ('Provided password is incorrect.');
      } else if (e.code == 'user-not-found') {
        throw ('User not found for that email.');
      }
    } catch (e) {
      throw ('Some error occurred. Please try again.');
    }
  }

  Future<void> register(String email, String password) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // send email verification
      await _firebaseAuth.currentUser!.sendEmailVerification();

      // store user profile data with one default domain
      await _firebaseFirestore
          .collection('users')
          .doc(_firebaseAuth.currentUser!.uid)
          .set({
        'email': email,
        'username': email.split('@')[0],
        'profilePicture': 'https://picsum.photos/200',
        'domains': ['ign.com'],
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        throw ('The account already exists for that email. Please login.');
      }
    } catch (e) {
      throw ('Some error occurred. Please try again.');
    }
  }

  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
    } catch (e) {
      throw ('Some error occurred. Please try again.');
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } catch (e) {
      throw ('Error sending email');
    }
  }
}

@Riverpod(keepAlive: true)
AuthRepository authRepository(AuthRepositoryRef ref) {
  return AuthRepository();
}

@Riverpod(keepAlive: true)
Stream<User?> authStateChanges(AuthStateChangesRef ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return authRepository.authStateChanges;
}
