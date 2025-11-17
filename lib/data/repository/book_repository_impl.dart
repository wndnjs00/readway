import 'package:firebase_database/firebase_database.dart';

import '../datasource/book_datasource.dart';
import '../../model/Book.dart';
import 'book_repository.dart';

class BookRepositoryImpl implements BookRepository {
  final BookDataSource _dataSource;

  BookRepositoryImpl(this._dataSource);

  @override
  Stream<List<Book>> getBookShelf() {
    return _dataSource.getBookShelfStream().asyncMap((DatabaseEvent event) async {
      final data = event.snapshot.value;

      if (data == null || data is! Map<dynamic, dynamic>) {
        return <Book>[];
      }

      final futures = data.keys.map((key) async {
        final bookValue = data[key];

        final userData = await _dataSource.getUserDataByKey(key);
        
        int? myReadCount;
        String? myReview;
        
        if (userData != null) {
          myReadCount = userData['myReadCount'] as int?;
          myReview = userData['myReview'] as String?;
        }

        final mergedBookValue = Map<dynamic, dynamic>.from(bookValue);
        if (myReadCount != null) mergedBookValue['myReadCount'] = myReadCount;
        if (myReview != null) mergedBookValue['myReview'] = myReview;
        
        return Book.fromMap(mergedBookValue);
      });

      return await Future.wait(futures);
    });
  }

  @override
  Future<void> writeBookShelf(Book book) async {
    await _dataSource.writeBookShelf(book);
  }

  @override
  void updateBookShelf(Book book) {
    _dataSource.updateBookShelf(book);
  }

  @override
  void deleteBookShelf(Book book) {
    _dataSource.deleteBookShelf(book);
  }

  @override
  Future<Map<String, dynamic>?> getUserData(String bookKey) async {
    return await _dataSource.getUserData(bookKey);
  }

  @override
  Future<void> updateMyReadCount(String bookKey, int myReadCount) async {
    await _dataSource.updateMyReadCount(bookKey, myReadCount);
  }

  @override
  Future<void> updateMyReview(String bookKey, String myReview) async {
    await _dataSource.updateMyReview(bookKey, myReview);
  }
}

