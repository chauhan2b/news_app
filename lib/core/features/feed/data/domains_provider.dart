import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'domains_provider.g.dart';

@Riverpod(keepAlive: true)
class Domains extends _$Domains {
  final _db = FirebaseFirestore.instance;
  final _uid = FirebaseAuth.instance.currentUser!.uid;
  List<String> _domains = [];

  // a simple domains reference to use in every function
  DocumentReference<Map<String, dynamic>> get _domainsRef =>
      _db.collection('users').doc(_uid);

  Future<List<String>> _fetchDomains() async {
    final domainsSnapshot = await _domainsRef.get();
    _domains = List.from(domainsSnapshot.data()!['domains']);
    return _domains;
  }

  @override
  Future<List<String>> build() async {
    // fetch user's saved domains from firebase
    return _fetchDomains();
  }

  void add(String domain) async {
    state = const AsyncValue.loading();
    _domainsRef.update({
      'domains': FieldValue.arrayUnion([domain])
    });
    _domains.add(domain);
    state = AsyncValue.data(_domains);
  }

  void remove(String domain) async {
    state = const AsyncValue.loading();
    final domainsRef = _db.collection('users').doc(_uid);
    domainsRef.update({
      'domains': FieldValue.arrayRemove([domain])
    });
    _domains.remove(domain);
    state = AsyncValue.data(_domains);
  }
}
