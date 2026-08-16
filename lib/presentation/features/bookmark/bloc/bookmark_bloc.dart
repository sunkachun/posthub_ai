import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../domain/repositories/bookmark_repository.dart';
import 'bookmark_event.dart';
import 'bookmark_state.dart';

class BookmarkBloc extends Bloc<BookmarkEvent, BookmarkState> {
  BookmarkBloc({required BookmarkRepository repository})
      : _repository = repository,
        super(const BookmarkState()) {
    on<LoadBookmarks>(_onLoadBookmarks);
    on<ToggleBookmark>(_onToggleBookmark);
  }

  final BookmarkRepository _repository;

  Future<void> _onLoadBookmarks(
    LoadBookmarks event,
    Emitter<BookmarkState> emit,
  ) async {
    final ids = await _repository.getBookmarkedPostIds();
    emit(state.copyWith(bookmarkedIds: ids));
  }

  Future<void> _onToggleBookmark(
    ToggleBookmark event,
    Emitter<BookmarkState> emit,
  ) async {
    await _repository.toggleBookmark(event.postId);
    final ids = await _repository.getBookmarkedPostIds();
    emit(state.copyWith(bookmarkedIds: ids));
  }
}
