import 'package:bloc/bloc.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sample_bloc_migration/bloc/new_suggestion_event.dart';
import 'package:sample_bloc_migration/bloc/new_suggestion_state.dart';
import 'package:sample_bloc_migration/service/suggestion_service.dart';

const int kMinSearchCharacters = 3;
const Duration kDebounceTime = Duration(seconds: 1);

EventTransformer<T> debounce<T>(Duration duration) {
  return (events, mapper) => events.debounceTime(duration).switchMap(mapper);
}

class NewSuggestionBloc extends Bloc<NewSuggestionEvent, NewSuggestionState> {
  final suggestionService = SuggestionService();

  NewSuggestionBloc() : super(EmptyNewSuggestionState()) {
    on<TypeNewSuggestionEvent>(_handleTypeNewSuggestionEvent);
    on<FetchNewSuggestionEvent>(
      _handleFetchNewSuggestionEvent,
      transformer: debounce(kDebounceTime),
    );
  }

  Future<void> _handleTypeNewSuggestionEvent(
    TypeNewSuggestionEvent event,
    emit,
  ) async {
    if (event.query.length >= kMinSearchCharacters) {
      emit(PendingNewSuggestionState());
    } else {
      emit(EmptyNewSuggestionState());
    }

    add(FetchNewSuggestionEvent(query: event.query));
  }

  Future<void> _handleFetchNewSuggestionEvent(
    FetchNewSuggestionEvent event,
    emit,
  ) async {
    try {
      if (event.query.length >= kMinSearchCharacters) {
        final suggestions = await suggestionService.fetch(event.query);

        emit(FetchedNewSuggestionState(suggestions: suggestions));
      }
    } catch (err) {
      emit(FailedNewSuggestionState());
      rethrow;
    }
  }
}
