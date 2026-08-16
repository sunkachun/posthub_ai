import 'package:equatable/equatable.dart';

import '../../../../domain/entities/comment.dart';
import '../../../../domain/entities/post.dart';

enum PostStatus { initial, loading, success, failure }

class PostState extends Equatable {
  const PostState({
    this.posts = const [],
    this.status = PostStatus.initial,
    this.isLoadingMore = false,
    this.hasReachedMax = false,
    this.errorMessage,
    this.comments = const [],
    this.commentsStatus = PostStatus.initial,
    this.commentsErrorMessage,
  });

  final List<PostEntity> posts;
  final PostStatus status;
  final bool isLoadingMore;
  final bool hasReachedMax;
  final String? errorMessage;

  final List<CommentEntity> comments;
  final PostStatus commentsStatus;
  final String? commentsErrorMessage;

  PostState copyWith({
    List<PostEntity>? posts,
    PostStatus? status,
    bool? isLoadingMore,
    bool? hasReachedMax,
    String? errorMessage,
    List<CommentEntity>? comments,
    PostStatus? commentsStatus,
    String? commentsErrorMessage,
  }) {
    return PostState(
      posts: posts ?? this.posts,
      status: status ?? this.status,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      errorMessage: errorMessage ?? this.errorMessage,
      comments: comments ?? this.comments,
      commentsStatus: commentsStatus ?? this.commentsStatus,
      commentsErrorMessage: commentsErrorMessage ?? this.commentsErrorMessage,
    );
  }

  @override
  List<Object?> get props => [
        posts,
        status,
        isLoadingMore,
        hasReachedMax,
        errorMessage,
        comments,
        commentsStatus,
        commentsErrorMessage,
      ];
}
