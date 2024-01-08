import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../domain/bookmark.dart';

part 'bookmarks_provider.g.dart';

@Riverpod(keepAlive: true)
class Bookmarks extends _$Bookmarks {
  final _db = FirebaseFirestore.instance;
  final _uid = FirebaseAuth.instance.currentUser!.uid;
  List<Bookmark> _bookmarks = [];
  List<String> _bookmarkIds = [];

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
    _bookmarkIds = _bookmarks.map((bookmark) => bookmark.id).toList();
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
    _bookmarkIds.add(bookmark.id);
    state = AsyncValue.data(_bookmarks);
  }

  void removeBookmark(Bookmark bookmark) async {
    state = const AsyncValue.loading();
    _bookmarksRef.doc(bookmark.id).delete();
    _bookmarks.remove(bookmark);
    _bookmarkIds.remove(bookmark.id);
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
    _bookmarkIds.clear();
    state = AsyncValue.data(_bookmarks);
  }

  bool isBookmarked(String id) {
    if (_bookmarkIds.contains(id)) {
      return true;
    }
    return false;
  }
}

// to update the bookmark button ui when adding or removing a bookmark
@riverpod
class BookmarkID extends _$BookmarkID {
  @override
  bool build(String id) {
    return ref.read(bookmarksProvider.notifier).isBookmarked(id);
  }

  void toggle() {
    state = !state;
  }
}
