import 'package:odc_mobile_template/business/models/communaute/reply.dart';

class RepliesTopicState {
  final List<Reply> replies;
  final bool? isLoading;
  final String? error;

  RepliesTopicState({
    required this.replies,
    this.isLoading,
    this.error,
  });

  factory RepliesTopicState.initial() {
    return RepliesTopicState(
      replies: [],
      isLoading: false,
      error: null,
    );
  }

  RepliesTopicState copyWith({
    List<Reply>? replies,
    bool? isLoading,
    String? error,
  }) {
    return RepliesTopicState(
      replies: replies ?? this.replies,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}
