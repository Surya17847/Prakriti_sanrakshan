import 'dart:convert';
import 'package:http/http.dart' as http;
import 'news_article.dart';

class NewsApiService {
  final String _apiKey = 'eacaf8d5cb1148e9be2e4f6feffc3dae';
  final String _url = 'https://newsapi.org/v2/everything'; // Changed to 'everything' to search by keywords
Future<List<NewsArticle>> fetchNewsArticles() async {
  print("Fetching articles...");
  try {
    final response = await http.get(
Uri.parse('$_url?q=pollution&apiKey=$_apiKey')
    );

    print('Response Status: ${response.statusCode}');
    print('Response Body: ${response.body}');

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      final articles = body['articles'] as List;
      return articles.map((json) => NewsArticle.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load news: ${response.statusCode}');
    }
  } catch (e) {
    print("Error during HTTP request: $e");
    throw Exception('Network or parsing error: $e');
  }
}


}
