import 'package:bloc/bloc.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sample_bloc_migration/bloc/suggestion_event.dart';
import 'package:sample_bloc_migration/bloc/suggestion_state.dart';
import 'package:sample_bloc_migration/service/suggestion_service.dart';

const int kMinSearchCharacters = 3;
const Duration kDebounceTime = Duration(seconds: 1);

class SuggestionBloc extends Bloc<SuggestionEvent, SuggestionState> {
  final suggestionService = SuggestionService();

  SuggestionBloc() : super(EmptySuggestionState());

  @override
  Stream<SuggestionState> mapEventToState(SuggestionEvent event) async* {
    if (event is FetchSuggestionEvent) {
      yield* _mapFetchSuggestionEventToState(event);
    } else if (event is PendingSuggestionEvent) {
      yield* _mapPendingSuggestionEventToState(event);
    } else if (event is ClearSuggestionEvent) {
      yield* _mapClearSuggestionEventToState(event);
    }
  }

  @override
  Stream<Transition<SuggestionEvent, SuggestionState>> transformEvents(
    Stream<SuggestionEvent> events,
    TransitionFunction<SuggestionEvent, SuggestionState> transitionFn,
  ) {
    // Do not alter other events than FetchSuggestionEvent
    final nonDebouncedStream =
        events.where((event) => (event is! FetchSuggestionEvent));

    // Transform the FetchSuggestion event. When a FetchSuggestionEvent occurs:
    // if the search query is valid:
    // - a PendingSuggestionEvent is fired immediately (shows the loader)
    // - the FetchSuggestionEvent is delayed
    // if the search query is invalid:
    // - a ClearSuggestionEvent is fired immediately
    // Thanks to the `switchMap`, any other FetchSuggestionEvent cancels
    // the workflow described above, so an eventual delayed FetchSuggestionEvent
    // could not be fired (--> debouncing effect)
    final debouncedStream = events.where(
      (event) {
        return (event is FetchSuggestionEvent);
      },
    ).switchMap<SuggestionEvent>(
      (event) {
        if ((event as FetchSuggestionEvent).query.length >=
            kMinSearchCharacters) {
          return MergeStream<SuggestionEvent>([
            Stream.value(PendingSuggestionEvent()),
            Stream.value(event).delay(kDebounceTime),
          ]);
        } else {
          return Stream.value(ClearSuggestionEvent());
        }
      },
    );

    // Reunite all the events in the same stream
    return super.transformEvents(
      nonDebouncedStream.mergeWith([debouncedStream]),
      transitionFn,
    );
  }

  Stream<SuggestionState> _mapFetchSuggestionEventToState(
    FetchSuggestionEvent event,
  ) async* {
    try {
      final suggestions = await suggestionService.fetch(event.query);

      yield FetchedSuggestionState(suggestions: suggestions);
    } catch (err) {
      yield FailedSuggestionState();
      rethrow;
    }
  }

  Stream<SuggestionState> _mapPendingSuggestionEventToState(
    PendingSuggestionEvent event,
  ) async* {
    yield PendingSuggestionState();
  }

  Stream<SuggestionState> _mapClearSuggestionEventToState(
    ClearSuggestionEvent event,
  ) async* {
    yield EmptySuggestionState();
  }
}
