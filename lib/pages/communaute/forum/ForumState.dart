import 'package:odc_mobile_template/business/models/communaute/forum.dart';

class ForumState {
  final List<Forum> forums;
  final bool? isLoading;
  final String? error;

  ForumState({
    required this.forums,
    this.isLoading,
    this.error,
  });

  factory ForumState.initial() {
    return ForumState(
      forums: [],
      isLoading: false,
      error: null,
    );
  }

  ForumState copyWith({
    List<Forum>? forums,
    bool? isLoading,
    String? error,
  }) {
    return ForumState(
      forums: forums ?? this.forums,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}
