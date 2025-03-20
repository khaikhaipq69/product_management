// lib/services/product_management_service.dart
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/ProductManagement.dart';

class ProductManagementService {
  final String apiUrl =
      'https://hiring-test.stag.tekoapis.net/api/products/management';

  Future<ProductManagement> fetchProductData() async {
    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final decodedData = json.decode(utf8.decode(response.bodyBytes));
        print(decodedData);
        return ProductManagement.fromJson(decodedData);
      } else {
        throw Exception(
            'Failed to load data: Status code ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('An error occurred while loading data: $e');
    }
  }
}
