abstract class NewSuggestionEvent {}

class TypeNewSuggestionEvent extends NewSuggestionEvent {
  final String query;

  TypeNewSuggestionEvent({required this.query});

  @override
  String toString() {
    return 'TypeNewSuggestionEvent{query: $query}';
  }
}

class FetchNewSuggestionEvent extends NewSuggestionEvent {
  final String query;

  FetchNewSuggestionEvent({required this.query});

  @override
  String toString() {
    return 'FetchNewSuggestionEvent{query: $query}';
  }
}
