import 'package:firebase_database/firebase_database.dart';
import 'package:localization/localization.dart';

import '../../model/Book.dart';

class BookDataSource {
  DatabaseReference ref = FirebaseDatabase.instance.ref();

  Stream<DatabaseEvent> getBookShelfStream() {
    DatabaseReference readBookRef = FirebaseDatabase.instance.ref(
      'bookshelf/userid',
    );
    return readBookRef.onValue;
  }

  Future<void> writeBookShelf(Book book) async {
    DatabaseReference bookshelfRef = FirebaseDatabase.instance.ref(
      "bookshelf/userid/${book.bookKey}",
    );

    await bookshelfRef
        .set({
          "name": book.name,
          "imageUrl": book.imageUrl,
          "bookKey": book.bookKey,
          "pageCount": book.pageCount,
          "publisher": book.publisher,
          "description": book.description,
          "publishedDate": book.publishedDate,
        })
        .then((_) {
          print("book-information-saved".i18n());
        })
        .catchError((error) {
          print("failed-to-save-book-information".i18n());
        });

    if (book.myReadCount != null || book.myReview != null) {
      DatabaseReference userDataRef = FirebaseDatabase.instance.ref(
        "userData/userid/${book.bookKey}",
      );
      
      final userData = <String, dynamic>{};
      if (book.myReadCount != null) {
        userData['myReadCount'] = book.myReadCount;
      }
      if (book.myReview != null && book.myReview!.isNotEmpty) {
        userData['myReview'] = book.myReview;
      }
      
      if (userData.isNotEmpty) {
        await userDataRef.update(userData).then((_) {
          print("user-data-saved".i18n());
        }).catchError((error) {
          print("failed-to-save-user-data".i18n());
        });
      }
    }
  }

  void updateBookShelf(Book book) {
    final bookData = {"imageUrl": book.imageUrl};

    final bookKeyRef = FirebaseDatabase.instance.ref().child(
      "bookshelf/userid/${book.bookKey}",
    );

    bookKeyRef
        .update(bookData)
        .then((_) {
          print("data-updated".i18n());
        })
        .catchError((error) {
          print("failed-to-update-data".i18n());
        });
  }

  void deleteBookShelf(Book book) {
    final bookKeyRef = FirebaseDatabase.instance.ref().child(
      "bookshelf/userid/${book.bookKey}",
    );
    bookKeyRef.remove();
  }

  Future<Map<String, dynamic>?> getUserData(String bookKey) async {
    final snapshot = await ref
        .child("userData/userid/$bookKey")
        .get();

    if (snapshot.exists) {
      final data = snapshot.value as Map;
      
      int? myReadCount;
      String? myReview;

      if (data["myReadCount"] != null) {
        myReadCount = data["myReadCount"] is int 
            ? data["myReadCount"] 
            : int.tryParse(data["myReadCount"].toString());
      }

      if (data["myReview"] != null) {
        myReview = data["myReview"].toString();
      }

      return {
        "myReadCount": myReadCount,
        "myReview": myReview,
      };
    }
    
    return null;
  }

  Future<void> updateMyReadCount(String bookKey, int myReadCount) async {
    await ref.child("userData/userid/$bookKey").update({
      "myReadCount": myReadCount,
    });
  }

  Future<void> updateMyReview(String bookKey, String myReview) async {
    await ref.child("userData/userid/$bookKey").update({
      "myReview": myReview,
    });
  }

  Future<Map<dynamic, dynamic>?> getUserDataByKey(String bookKey) async {
    final userDataRef = FirebaseDatabase.instance.ref(
      'userData/userid/$bookKey',
    );
    final userDataSnapshot = await userDataRef.get();
    
    if (userDataSnapshot.exists) {
      return userDataSnapshot.value as Map<dynamic, dynamic>?;
    }
    
    return null;
  }
}

