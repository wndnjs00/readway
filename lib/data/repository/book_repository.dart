import '../../model/Book.dart';

abstract class BookRepository {
  Stream<List<Book>> getBookShelf();
  Future<void> writeBookShelf(Book book);
  void updateBookShelf(Book book);
  void deleteBookShelf(Book book);
  Future<Map<String, dynamic>?> getUserData(String bookKey);
  Future<void> updateMyReadCount(String bookKey, int myReadCount);
  Future<void> updateMyReview(String bookKey, String myReview);
}