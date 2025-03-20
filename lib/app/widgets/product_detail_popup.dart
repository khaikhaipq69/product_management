import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'reponsive_utils.dart';
import '../modules/home/controllers/home_controller.dart';
import 'package:entry_project/app/models/ProductManagement.dart' as productModel;
import 'dart:io';

class ProductDetailPopup extends StatelessWidget {
  final productModel.Item product;
  final HomeController controller;

  const ProductDetailPopup({
    super.key,
    required this.product,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: UtilsReponsive.paddingAll(context, padding: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Image
            SizedBox(
              width: double.infinity,
              height: UtilsReponsive.height(150.0, context),
              child: Obx(() {
                if (controller.localImages.containsKey(product.name)) {
                  return Image.file(
                    controller.localImages[product.name]!,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(Icons.image_not_supported, size: 60);
                    },
                  );
                } else if (product.imageSrc.startsWith('/data/user/0/') ||
                    product.imageSrc.startsWith('/storage/')) {
                  return Image.file(
                    File(product.imageSrc),
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(Icons.image_not_supported, size: 60);
                    },
                  );
                } else {
                  return Image.network(
                    product.imageSrc,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(Icons.image_not_supported, size: 60);
                    },
                  );
                }
              }),
            ),
            SizedBoxConst.size(context: context, size: 16.0),

            // Name
            Text(
              product.name,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: UtilsReponsive.formatFontSize(18.0, context),
              ),
            ),
            SizedBoxConst.size(context: context, size: 8.0),

            // Price
            Text(
              NumberFormat.currency(locale: 'vi_VN', symbol: '₫')
                  .format(product.price),
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: UtilsReponsive.formatFontSize(16.0, context),
              ),
            ),
            SizedBoxConst.size(context: context, size: 24.0),

            // Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Implement Edit functionality
                    print('Edit ${product.name}');
                    Get.back();
                  },
                  child:  Text('Chỉnh sửa'),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Implement Delete functionality
                    print('Delete ${product.name}');
                    Get.back();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.yellow,
                  ),
                  child:  Text('Xóa'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}