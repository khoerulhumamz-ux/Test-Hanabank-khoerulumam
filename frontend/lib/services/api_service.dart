import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';

class ApiService {
  String? token;
  Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    if (token != null) 'Authorization': 'Bearer $token',
  };

  Future<Map<String, dynamic>> login(String username, String password) async {
    final response = await http.post(Uri.parse('${ApiConfig.baseUrl}/auth/login'),
      headers: _headers, body: jsonEncode({'username': username, 'password': password}));
    final data = _decode(response);
    token = data['token'] as String?;
    return data;
  }

  Future<Map<String, dynamic>> balance() async {
    final response = await http.get(Uri.parse('${ApiConfig.baseUrl}/accounts/balance'), headers: _headers);
    return _decode(response);
  }

  Future<Map<String, dynamic>> transfer(String target, int amount, String description) async {
    final response = await http.post(Uri.parse('${ApiConfig.baseUrl}/transfers/overbooking'),
      headers: _headers, body: jsonEncode({'targetAccountNumber': target, 'amount': amount, 'description': description}));
    return _decode(response);
  }

  Future<List<dynamic>> transactions() async {
    final response = await http.get(Uri.parse('${ApiConfig.baseUrl}/transactions?page=0&size=50'), headers: _headers);
    final data = _decode(response);
    return (data['content'] as List<dynamic>? ?? []);
  }

  Future<Map<String, dynamic>> transactionDetail(int id) async {
    final response = await http.get(Uri.parse('${ApiConfig.baseUrl}/transactions/$id'), headers: _headers);
    return _decode(response);
  }

  Map<String, dynamic> _decode(http.Response response) {
    final dynamic parsed = response.body.isEmpty ? <String, dynamic>{} : jsonDecode(response.body);
    if (response.statusCode < 200 || response.statusCode >= 300) {
      final message = parsed is Map ? (parsed['message'] ?? 'Request gagal') : 'Request gagal';
      throw Exception(message.toString());
    }
    return Map<String, dynamic>.from(parsed as Map);
  }
}
