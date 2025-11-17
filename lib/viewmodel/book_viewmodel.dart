import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/datasource/book_datasource.dart';
import '../data/repository/book_repository.dart';
import '../data/repository/book_repository_impl.dart';
import '../model/Book.dart';

// DataSource Provider
final bookDataSourceProvider = Provider<BookDataSource>((ref) {
  return BookDataSource();
});

// Repository Provider
final bookRepositoryProvider = Provider<BookRepository>((ref) {
  final dataSource = ref.watch(bookDataSourceProvider);
  return BookRepositoryImpl(dataSource);
});


class BookViewModel extends StateNotifier<AsyncValue<List<Book>>> {
  final BookRepository _repository;

  BookViewModel(this._repository) : super(const AsyncValue.loading()) {
    _loadBooks();
  }

  void _loadBooks() {
    _repository.getBookShelf().listen(
      (books) {
        state = AsyncValue.data(books);
      },
      onError: (error, stackTrace) {
        state = AsyncValue.error(error, stackTrace);
      },
    );
  }

  Future<void> writeBook(Book book) async {
    await _repository.writeBookShelf(book);
  }

  void updateBook(Book book) {
    _repository.updateBookShelf(book);
  }

  void deleteBook(Book book) {
    _repository.deleteBookShelf(book);
  }
}

// BookViewModel Provider
final bookViewModelProvider =
    StateNotifierProvider<BookViewModel, AsyncValue<List<Book>>>((ref) {
  final repository = ref.watch(bookRepositoryProvider);
  return BookViewModel(repository);
});

