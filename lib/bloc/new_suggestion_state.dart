import 'package:sample_bloc_migration/model/person.dart';

abstract class NewSuggestionState {
  final List<Person> suggestions;

  NewSuggestionState({required this.suggestions});
}

class EmptyNewSuggestionState extends NewSuggestionState {
  EmptyNewSuggestionState() : super(suggestions: const []);

  @override
  String toString() {
    return 'EmptyNewSuggestionState{suggestions: $suggestions}';
  }
}

class PendingNewSuggestionState extends NewSuggestionState {
  PendingNewSuggestionState() : super(suggestions: const []);

  @override
  String toString() {
    return 'PendingNewSuggestionState{suggestions: $suggestions}';
  }
}

class FetchedNewSuggestionState extends NewSuggestionState {
  FetchedNewSuggestionState({required List<Person> suggestions})
      : super(suggestions: suggestions);

  @override
  String toString() {
    return 'FetchedNewSuggestionState{suggestions: $suggestions}';
  }
}

class FailedNewSuggestionState extends NewSuggestionState {
  FailedNewSuggestionState() : super(suggestions: const []);

  @override
  String toString() {
    return 'FailedNewSuggestionState{suggestions: $suggestions}';
  }
}
