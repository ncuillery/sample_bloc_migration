import 'package:sample_bloc_migration/model/person.dart';

abstract class SuggestionState {
  final List<Person> suggestions;

  SuggestionState({required this.suggestions});
}

class EmptySuggestionState extends SuggestionState {
  EmptySuggestionState() : super(suggestions: const []);

  @override
  String toString() {
    return 'EmptySuggestionState{suggestions: $suggestions}';
  }
}

class PendingSuggestionState extends SuggestionState {
  PendingSuggestionState() : super(suggestions: const []);

  @override
  String toString() {
    return 'PendingSuggestionState{suggestions: $suggestions}';
  }
}

class FetchedSuggestionState extends SuggestionState {
  FetchedSuggestionState({required List<Person> suggestions})
      : super(suggestions: suggestions);

  @override
  String toString() {
    return 'FetchedSuggestionState{suggestions: $suggestions}';
  }
}

class FailedSuggestionState extends SuggestionState {
  FailedSuggestionState() : super(suggestions: const []);

  @override
  String toString() {
    return 'FailedSuggestionState{suggestions: $suggestions}';
  }
}
