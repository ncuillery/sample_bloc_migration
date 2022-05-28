import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:sample_bloc_migration/model/person.dart';

class SuggestionService {
  final client = Dio();

  Future<List<Person>> fetch(String query) async {
    if (kDebugMode) {
      print('Request: https://swapi.dev/api/people/?search=$query');
    }
    Response response = await client.get(
      'https://swapi.dev/api/people/?search=$query',
    );

    final results = response.data['results'] as List;

    return results.map((json) => Person(name: json['name']!)).toList();
  }
}
