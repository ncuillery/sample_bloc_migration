# sample_bloc_migration

Sample project to illustrate a difficulty to migrate to Bloc 8.x.x when using a `transformEvents` method that emit events of different types (in 8.x.x this method is replaced by an event-level transformation API, whereas `transformEvents` operates at the global level).

The use-case demo-ed here is a debounced suggestion box with a special attention to the pending state:

- The suggestion box enters in its pending state as soon as the first key is pressed (we don't wait for the debounce duration because the debounce duration is a "perceived waiting time" from the user perspective)
- When the suggestion box doesn't contain enough characters, we clear the suggestions immediately without waiting for the debouced duration (no pending state because nothing happens)

## EDIT

I finally managed to migrate to Bloc 8.x.x by introducing a new event: `TypeSuggestionEvent`.

This event is added for each character typed in the search field. If the request is valid, the pending state is emitted, otherwise we clear the suggestions immediately (empty state emitted)

In both case we emit the debounced `FetchSuggestionEvent` which also verify if the query is valid before requesting the API. If we don't, when when the query becomes invalid (by typing back the characters with Backspace), there is a `FetchSuggestionEvent` fired for the last valid query and we don't want that to happen. By emitting the `FetchSuggestionEvent` even if the query is invalid, we replace this undesirable event by a new one that does nothing.