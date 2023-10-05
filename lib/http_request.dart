import 'dart:convert';
import 'package:http/http.dart' as http;

class BlogApi {
  final String baseUrl;
  final String adminSecret;

  BlogApi({required this.baseUrl, required this.adminSecret});

  Future<dynamic> fetchBlogs() async {
    final Uri uri = Uri.parse('$baseUrl/api/rest/blogs');

    try {
      final response = await http.get(
        uri,
        headers: {'x-hasura-admin-secret': adminSecret},
      );

      if (response.statusCode == 200) {
        final dynamic responseData = jsonDecode(response.body);
        return responseData;
      } else {
        throw Exception('Failed to fetch blogs: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to fetch blogs: $e');
    }
  }
}
