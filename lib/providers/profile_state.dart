import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../models/user_profile.dart';

part 'profile_state.g.dart';

@riverpod
FutureOr<UserProfile> profileState(ProfileStateRef ref) async {
  final firebaseFirestore = FirebaseFirestore.instance;
  final firebaseAuth = FirebaseAuth.instance;

  // fetch profile from firebase
  try {
    final snapshot = await firebaseFirestore
        .collection('users')
        .doc(firebaseAuth.currentUser!.uid)
        .get();
    if (snapshot.exists) {
      return UserProfile.fromJson(snapshot.data()!);
    } else {
      return UserProfile(
        username: 'null',
        email: firebaseAuth.currentUser!.email!,
        profilePicture: 'https://picsum.photos/200',
      );
    }
  } catch (e) {
    throw Exception('Error loading profile');
  }
}
