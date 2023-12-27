import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../domain/bookmark.dart';

part 'bookmarks_provider.g.dart';

@riverpod
class Bookmarks extends _$Bookmarks {
  final _db = FirebaseFirestore.instance;
  final _uid = FirebaseAuth.instance.currentUser!.uid;
  List<Bookmark> _bookmarks = [];

  // a simple bookmarks reference to use in every function
  CollectionReference<Bookmark> get _bookmarksRef => _db
      .collection('users')
      .doc(_uid)
      .collection('bookmarks')
      .withConverter<Bookmark>(
          fromFirestore: (snapshot, _) => Bookmark.fromJson(snapshot.data()!),
          toFirestore: (bookmark, _) => bookmark.toJson());

  Future<List<Bookmark>> _fetchBookmarks() async {
    final bookmarksSnapshot = await _bookmarksRef.get();
    _bookmarks = bookmarksSnapshot.docs
        .map((bookmark) => bookmark.data().copyWith(id: bookmark.id))
        .toList();
    return _bookmarks;
  }

  @override
  Future<List<Bookmark>> build() {
    return _fetchBookmarks();
  }

  void saveBookmark(Bookmark bookmark) async {
    state = const AsyncValue.loading();
    _bookmarksRef.doc(bookmark.id).set(bookmark);
    _bookmarks.add(bookmark);
    state = AsyncValue.data(_bookmarks);
  }

  void removeBookmark(Bookmark bookmark) async {
    state = const AsyncValue.loading();
    _bookmarksRef.doc(bookmark.id).delete();
    _bookmarks.remove(bookmark);
    state = AsyncValue.data(_bookmarks);
  }

  void clearBookmarks() async {
    state = const AsyncValue.loading();
    _bookmarksRef.get().then((value) {
      for (var element in value.docs) {
        element.reference.delete();
      }
    });
    _bookmarks.clear();
    state = AsyncValue.data(_bookmarks);
  }

  void toggleBookmark(Bookmark bookmark) async {
    if (state.value!.contains(bookmark)) {
      removeBookmark(bookmark);
    } else {
      saveBookmark(bookmark);
    }
  }
}
