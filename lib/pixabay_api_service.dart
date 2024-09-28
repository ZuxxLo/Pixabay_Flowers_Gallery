import 'dart:convert';
import 'package:http/http.dart' as http;

class PixabayApiService {
  final String _apiKey =
      '46232698-182fbec9fd12e6de7433a1bbd'; //should not be pushed to github, but its only for a job application
  final String _baseUrl = 'https://pixabay.com/api/';

  Future<List<dynamic>> fetchImages(
      {required int page, required int perPage}) async {
    final response = await http.get(
      Uri.parse(
          '$_baseUrl?key=$_apiKey&q=flowers&image_type=photo&page=$page&per_page=$perPage'),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return data['hits'] ?? [];
    } else {
      throw Exception('Failed to load images');
    }
  }
}
