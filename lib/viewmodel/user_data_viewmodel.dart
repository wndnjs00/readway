import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/repository/book_repository.dart';
import 'book_viewmodel.dart';

class UserDataViewModel
    extends StateNotifier<AsyncValue<Map<String, dynamic>?>> {
  final BookRepository _repository;
  final String _bookKey;

  UserDataViewModel(this._repository, this._bookKey)
      : super(const AsyncValue.loading()) {
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      final userData = await _repository.getUserData(_bookKey);
      state = AsyncValue.data(userData);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> updateMyReadCount(int myReadCount) async {
    await _repository.updateMyReadCount(_bookKey, myReadCount);
    await _loadUserData();
  }

  Future<void> updateMyReview(String myReview) async {
    await _repository.updateMyReview(_bookKey, myReview);
    await _loadUserData();
  }
}

// UserDataViewModel Provider
final userDataViewModelProvider = StateNotifierProvider.family<
    UserDataViewModel, AsyncValue<Map<String, dynamic>?>, String>(
  (ref, bookKey) {
    final repository = ref.watch(bookRepositoryProvider);
    return UserDataViewModel(repository, bookKey);
  },
);


