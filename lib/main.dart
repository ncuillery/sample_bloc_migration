import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sample_bloc_migration/bloc/new_suggestion_bloc.dart';
import 'package:sample_bloc_migration/bloc/new_suggestion_event.dart';
import 'package:sample_bloc_migration/bloc/new_suggestion_state.dart';
import 'package:sample_bloc_migration/bloc/suggestion_bloc.dart';
import 'package:sample_bloc_migration/bloc/suggestion_event.dart';
import 'package:sample_bloc_migration/bloc/suggestion_state.dart';
import 'package:sample_bloc_migration/bloc_logger.dart';

void main() {
  runApp(const MyApp());

  Bloc.observer = BlocLogger();
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BlocProvider(
        create: (context) => SuggestionBloc(),
        child: BlocProvider(
          create: (context) => NewSuggestionBloc(),
          child: const MyHomePage(),
        ),
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bloc 8.x migration'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: BlocBuilder<SuggestionBloc, SuggestionState>(
                  builder: (context, state) {
                return Column(
                  children: <Widget>[
                    TextField(
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        hintText: 'Star Wars character name',
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 0.0, horizontal: 16.0),
                        suffix: state is PendingSuggestionState
                            ? const SizedBox(
                                height: 20,
                                child: FittedBox(
                                  fit: BoxFit.fitHeight,
                                  child: CircularProgressIndicator(),
                                ),
                              )
                            : null,
                      ),
                      onChanged: (String text) {
                        BlocProvider.of<SuggestionBloc>(context).add(
                          FetchSuggestionEvent(query: text),
                        );
                      },
                    ),
                    ...state.suggestions.map(
                      (person) => Text(person.name),
                    )
                  ],
                );
              }),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: BlocBuilder<NewSuggestionBloc, NewSuggestionState>(
                  builder: (context, state) {
                return Column(
                  children: <Widget>[
                    TextField(
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        hintText: 'Star Wars character name',
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 0.0, horizontal: 16.0),
                        suffix: state is PendingNewSuggestionState
                            ? const SizedBox(
                                height: 20,
                                child: FittedBox(
                                  fit: BoxFit.fitHeight,
                                  child: CircularProgressIndicator(),
                                ),
                              )
                            : null,
                      ),
                      onChanged: (String text) {
                        BlocProvider.of<NewSuggestionBloc>(context).add(
                          TypeNewSuggestionEvent(query: text),
                        );
                      },
                    ),
                    ...state.suggestions.map(
                      (person) => Text(person.name),
                    )
                  ],
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
