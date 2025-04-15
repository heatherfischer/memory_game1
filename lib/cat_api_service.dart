import 'dart:convert';
import 'package:http/http.dart' as http;

class CatApiService {
  static const String _baseUrl = 'https://api.thecatapi.com/v1/images/search';
  static const String _apiKey =
      'live_Yv673bGtptfBAyWA9e1a7Ohy5JGSUYNGX22QfD8g1jsQKOgFzqQIcVl7F5EzVDXW'; // Replace with your API key

  Future<List<String>> fetchCatImages({int limit = 10}) async {
    final response = await http.get(
      Uri.parse('$_baseUrl?limit=$limit'),
      headers: {'x-api-key': _apiKey},
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((cat) => cat['url'] as String).toList();
    } else {
      throw Exception('Failed to load cat images');
    }
  }
}
