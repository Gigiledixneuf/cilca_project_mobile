import 'package:odc_mobile_template/business/models/communaute/topic.dart';

class TopicsForumState {
  final List<Topic> topics;
  final bool? isLoading;
  final String? error;

  TopicsForumState({
    required this.topics,
    this.isLoading,
    this.error,
  });

  factory TopicsForumState.initial() {
    return TopicsForumState(
      topics: [],
      isLoading: false,
      error: null,
    );
  }

  TopicsForumState copyWith({
    List<Topic>? topics,
    bool? isLoading,
    String? error,
  }) {
    return TopicsForumState(
      topics: topics ?? this.topics,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}
