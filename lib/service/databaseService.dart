import 'package:firebase_database/firebase_database.dart';

import '../model/Book.dart';

class DatabaseService {
  DatabaseReference ref = FirebaseDatabase.instance.ref();

  void readDB(void Function(List<Book> newBooks) updateUiWithBooks) {
    DatabaseReference readBookRef = FirebaseDatabase.instance.ref(
      'bookshelf/userid',
    );
    readBookRef.onValue.listen((DatabaseEvent event) {
      final data = event.snapshot.value;

      if (data == null || data is! Map<dynamic, dynamic>) {
        updateUiWithBooks([]);
        return;
      }

      final books = <Book>[];
      for (final key in data.keys) {
        final bookValue = data[key];
        final book = Book.fromMap(bookValue);
        books.add(book);
      }

      updateUiWithBooks(books);
    });
  }

  Future<void> writeDB(Book book) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref(
      "bookshelf/userid/${book.bookKey}",
    );

    await ref
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
          print("데이터 넣기 완료");
        })
        .catchError((error) {
          print("데이터 넣기 실패");
        });
    ;
  }

  void updateDB(Book book) {
    final bookData = {"imageUrl": book.imageUrl};

    final bookKeyRef = FirebaseDatabase.instance.ref().child(
      "bookshelf/userid/${book.bookKey}",
    );

    bookKeyRef
        .update(bookData)
        .then((_) {
          print("데이터 업데이트 완료");
        })
        .catchError((error) {
          print("데이터 업데이트 실패");
        });
  }

  void deleteDB(Book book) {
    final bookKeyRef = FirebaseDatabase.instance.ref().child(
      "bookshelf/userid/${book.bookKey}",
    );
    bookKeyRef.remove();
  }
}
