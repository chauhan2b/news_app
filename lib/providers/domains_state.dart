import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'domains_state.g.dart';

@Riverpod(keepAlive: true)
class Domains extends _$Domains {
  final _db = FirebaseFirestore.instance;
  final _uid = FirebaseAuth.instance.currentUser!.uid;

  Future<List<String>> _fetchDomains() async {
    final domainsRef = _db.collection('users').doc(_uid);
    return domainsRef.get().then((value) {
      return List.from(value.data()!['domains']);
    });
  }

  @override
  Future<List<String>> build() async {
    // fetch user's saved domains from firebase
    return _fetchDomains();
  }

  void add(String domain) async {
    state = const AsyncValue.loading();
    final domainsRef = _db.collection('users').doc(_uid);
    domainsRef.update({
      'domains': FieldValue.arrayUnion([domain])
    });
    state = await AsyncValue.guard(() => _fetchDomains());
  }

  void remove(String domain) async {
    state = const AsyncValue.loading();
    final domainsRef = _db.collection('users').doc(_uid);
    domainsRef.update({
      'domains': FieldValue.arrayRemove([domain])
    });
    state = await AsyncValue.guard(() => _fetchDomains());
  }
}
