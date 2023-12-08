import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'domain_repository.g.dart';

class DomainRepository {
  final db = FirebaseFirestore.instance;
  final uid = FirebaseAuth.instance.currentUser!.uid;

  void addDomain(String domain) {
    // add domain at domains --> user id --> list of domains
    db.collection('domains').doc(uid).update({
      'domains': FieldValue.arrayUnion([domain])
    });
  }

  void removeDomain(String domain) {
    // remove domain at domains --> user id --> list of domains
    db.collection('domains').doc(uid).update({
      'domains': FieldValue.arrayRemove([domain])
    });
  }

  Stream<List<String>> get domains {
    return db
        .collection('domains')
        .doc(uid)
        .snapshots()
        .map((event) => event.data()!['domains'] as List<String>);
  }

  Future<List<String>> getDomains() async {
    return (await db.collection('domains').doc(uid).get()).data()!['domains']
        as List<String>;
  }
}

@riverpod
DomainRepository domainRepository(DomainRepositoryRef ref) {
  return DomainRepository();
}
