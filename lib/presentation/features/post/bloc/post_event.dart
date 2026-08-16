import 'package:equatable/equatable.dart';

sealed class PostEvent extends Equatable {
  const PostEvent();

  @override
  List<Object?> get props => const [];
}

class PostFetched extends PostEvent {
  const PostFetched();
}

class PostLoadMore extends PostEvent {
  const PostLoadMore();
}

class PostCommentsFetched extends PostEvent {
  const PostCommentsFetched(this.postId);

  final int postId;

  @override
  List<Object?> get props => [postId];
}
