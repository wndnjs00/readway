import 'package:firebase_database/firebase_database.dart';
import 'package:localization/localization.dart';

import '../model/Book.dart';

class DatabaseService {
  DatabaseReference ref = FirebaseDatabase.instance.ref();

  void getBookShelfDB(void Function(List<Book> newBooks) updateUiWithBooks) {
    DatabaseReference readBookRef = FirebaseDatabase.instance.ref(
      'bookshelf/userid',
    );
    readBookRef.onValue.listen((DatabaseEvent event) async {
      final data = event.snapshot.value;

      if (data == null || data is! Map<dynamic, dynamic>) {
        updateUiWithBooks([]);
        return;
      }

      final futures = data.keys.map((key) async {
        final bookValue = data[key];

        final userDataRef = FirebaseDatabase.instance.ref(
          'userData/userid/$key',
        );
        final userDataSnapshot = await userDataRef.get();
        
        int? myReadCount;
        String? myReview;
        
        if (userDataSnapshot.exists) {
          final userData = userDataSnapshot.value as Map<dynamic, dynamic>?;
          if (userData != null) {
            myReadCount = userData['myReadCount'] as int?;
            myReview = userData['myReview'] as String?;
          }
        }

        final mergedBookValue = Map<dynamic, dynamic>.from(bookValue);
        if (myReadCount != null) mergedBookValue['myReadCount'] = myReadCount;
        if (myReview != null) mergedBookValue['myReview'] = myReview;
        
        return Book.fromMap(mergedBookValue);
      });

      // Future.wait(futures)로 비동기작업들 모두 모아놓고, 바로 전달
      final books = await Future.wait(futures);
      updateUiWithBooks(books);
    });
  }

  Future<void> writeBookShelfDB(Book book) async {
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

  void updateBookShelfDB(Book book) {
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

  void deleteBookShelfDB(Book book) {
    final bookKeyRef = FirebaseDatabase.instance.ref().child(
      "bookshelf/userid/${book.bookKey}",
    );
    bookKeyRef.remove();
  }

  // userData에서 myReadCount와 myReview 읽어오기
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
}
