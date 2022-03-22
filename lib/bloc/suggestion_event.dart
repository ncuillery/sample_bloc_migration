abstract class SuggestionEvent {}

class FetchSuggestionEvent extends SuggestionEvent {
  final String query;

  FetchSuggestionEvent({required this.query});

  @override
  String toString() {
    return 'FetchSuggestionEvent{query: $query}';
  }
}

class PendingSuggestionEvent extends SuggestionEvent {
  @override
  String toString() {
    return 'PendingSuggestionEvent{}';
  }
}

class ClearSuggestionEvent extends SuggestionEvent {
  @override
  String toString() {
    return 'ClearSuggestionEvent{}';
  }
}
