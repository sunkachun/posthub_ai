import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../domain/repositories/post_repository.dart';
import 'post_event.dart';
import 'post_state.dart';

class PostBloc extends Bloc<PostEvent, PostState> {
  PostBloc({required PostRepository repository})
      : _repository = repository,
        super(const PostState()) {
    on<PostFetched>(_onPostFetched);
    on<PostLoadMore>(_onPostLoadMore);
    on<PostCommentsFetched>(_onPostCommentsFetched);
  }

  static const int _pageSize = 10;

  final PostRepository _repository;
  int _page = 1;

  Future<void> _onPostFetched(
    PostFetched event,
    Emitter<PostState> emit,
  ) async {
    _page = 1;
    emit(state.copyWith(status: PostStatus.loading));
    try {
      final posts =
          await _repository.fetchPosts(page: _page, pageSize: _pageSize);
      emit(
        state.copyWith(
          status: PostStatus.success,
          posts: posts,
          hasMore: posts.length >= _pageSize,
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          status: PostStatus.failure,
          errorMessage: 'Failed to load posts.',
        ),
      );
    }
  }

  Future<void> _onPostLoadMore(
    PostLoadMore event,
    Emitter<PostState> emit,
  ) async {
    if (!state.hasMore ||
        state.isLoadingMore ||
        state.status != PostStatus.success) {
      return;
    }

    emit(state.copyWith(isLoadingMore: true));
    _page++;
    try {
      final posts =
          await _repository.fetchPosts(page: _page, pageSize: _pageSize);
      emit(
        state.copyWith(
          isLoadingMore: false,
          posts: [...state.posts, ...posts],
          hasMore: posts.length >= _pageSize,
        ),
      );
    } catch (_) {
      _page--;
      emit(state.copyWith(isLoadingMore: false));
    }
  }

  Future<void> _onPostCommentsFetched(
    PostCommentsFetched event,
    Emitter<PostState> emit,
  ) async {
    emit(state.copyWith(commentsStatus: PostStatus.loading));
    try {
      final comments = await _repository.fetchComments(event.postId);
      emit(
        state.copyWith(
          commentsStatus: PostStatus.success,
          comments: comments,
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          commentsStatus: PostStatus.failure,
          commentsErrorMessage: 'Failed to load comments.',
        ),
      );
    }
  }
}
