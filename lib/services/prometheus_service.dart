import 'dart:convert';
import 'package:http/http.dart' as http;

class PrometheusService {
  static String baseUrl = 'http://192.168.0.169:9090';

  static Future<double> fetchValue(String query) async {
    final encodedQuery = Uri.encodeComponent(query);
    final url = Uri.parse('$baseUrl/api/v1/query?query=$encodedQuery');

    final response = await http.get(url);

    if (response.statusCode != 200) {
      throw Exception('Prometheus API error');
    }

    final data = jsonDecode(response.body);
    final result = data['data']['result'];

    if (result == null || result.isEmpty) {
      return 0;
    }

    return double.parse(result[0]['value'][1]);
  }
}