import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'reponsive_utils.dart';

import '../modules/home/controllers/home_controller.dart';

class ProductSearchWidget extends StatelessWidget {
  final HomeController controller;

  const ProductSearchWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: UtilsReponsive.height(8.0, context)),
      child: TextField(
        controller: controller.searchController,
        onChanged: controller.filterProducts,
        decoration: InputDecoration(
          hintText: 'Tìm kiếm sản phẩm...',
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(UtilsReponsive.width(10.0, context)),
          ),
        ),
      ),
    );
  }
}