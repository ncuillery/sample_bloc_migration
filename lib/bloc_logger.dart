import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';

class BlocLogger extends BlocObserver {
  @override
  void onEvent(Bloc bloc, Object? event) {
    if (kDebugMode) {
      print('Event: $event');
    }
    super.onEvent(bloc, event);
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    if (kDebugMode) {
      print('State: ${transition.nextState}');
    }
    super.onTransition(bloc, transition);
  }
}
