import 'dart:convert';

import 'package:http/http.dart' as http;

class FetchCurrency {
  Future<Map<String, dynamic>> fetchCurrenciesAndRates(String fromCurrency) async {
    final url = 'https://api.exchangerate-api.com/v4/latest/$fromCurrency';
    final response = await http.get(Uri.parse(url));
    if(response == 200){
      return jsonDecode(response.body);
    }
    else
      throw Exception('Failed to load currencies and rates');
  }
}