import 'package:news/src/resources/news_api_provider.dart';
import 'dart:convert';
import 'package:http/http.dart';
import 'package:http/testing.dart';
import 'package:test/test.dart';

void main() {
  test('FetchTopIds returns a list of ids', () async {
    // setup of test case
    final newsApi = NewsApiProvider();
    newsApi.client = MockClient((request) async {
      return Response(json.encode([1, 2, 3, 4]), 200);
    });
    // expectation
    final ids = await newsApi.fetchTopIds();
    // verify
    expect(ids, [1, 2, 3, 4]);
  });
  test('FetchItem returns an ItemModel', () async {
    final newsApi = NewsApiProvider();
    newsApi.client = MockClient((request) async {
      final jsonMap = {'id': 123};
      return Response(json.encode(jsonMap), 200);
    });
    final item = await newsApi.fetchItem(999);
    expect(item.id, 123);
  });
}
