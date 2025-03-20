import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'reponsive_utils.dart'; // Import your responsive utilities

import '../modules/home/controllers/home_controller.dart';
import 'package:entry_project/app/models/ProductManagement.dart'
    as productModel;

class ProductListWidget extends StatelessWidget {
  final HomeController controller;

  const ProductListWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Danh sách sản phẩm',
              style: TextStyle(
                  fontSize: UtilsReponsive.formatFontSize(18.0, context),
                  fontWeight: FontWeight.bold),
            ),
            Obx(() => IconButton(
                  icon: Icon(
                    controller.isGridView.value ? Icons.list : Icons.grid_view,
                  ),
                  onPressed: () {
                    controller.toggleView();
                  },
                )),
          ],
        ),
        SizedBoxConst.size(context: context, size: 16.0),
        Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          } else if (controller.errorMessage.value.isNotEmpty) {
            return Center(child: Text('Lỗi: ${controller.errorMessage.value}'));
          } else if (controller.productLists.isEmpty ||
              controller.productLists.first.items.isEmpty) {
            return const Center(child: Text('Không có sản phẩm nào.'));
          } else {
            final products = controller.productLists.first.items;
            return controller.isGridView.value
                ? GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.7,
                      crossAxisSpacing: UtilsReponsive.width(16.0, context),
                      mainAxisSpacing: UtilsReponsive.height(16.0, context),
                    ),
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      final product = products[index];
                      return Card(
                        child: InkWell(
                          onTap: () {
                            print('Tapped on ${product.name}');
                          },
                          child: Padding(
                            padding: UtilsReponsive.paddingAll(context,
                                padding: 8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Expanded(
                                    child: Image.network(
                                  product.imageSrc,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Image.file(
                                      File(product.imageSrc),
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        return Icon(Icons.image_not_supported,
                                            size: UtilsReponsive.formatFontSize(
                                                60.0, context));
                                      },
                                    );
                                  },
                                )),
                                SizedBoxConst.size(context: context, size: 8.0),
                                Text(
                                  product.name,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: UtilsReponsive.formatFontSize(
                                          14.0, context)),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBoxConst.size(context: context, size: 4.0),
                                Text(
                                  '${NumberFormat.currency(locale: 'vi_VN', symbol: '₫').format(product.price)}',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: UtilsReponsive.formatFontSize(
                                          12.0, context)),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      final product = products[index];
                      return Card(
                        margin: EdgeInsets.symmetric(
                            vertical: UtilsReponsive.height(8.0, context)),
                        child: Padding(
                          padding:
                              UtilsReponsive.paddingAll(context, padding: 16.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                  width: UtilsReponsive.width(80.0, context),
                                  height: UtilsReponsive.height(80.0, context),
                                  child: Image.network(
                                    product.imageSrc,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Image.file(
                                        File(product.imageSrc),
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                          return Icon(Icons.image_not_supported,
                                              size:
                                                  UtilsReponsive.formatFontSize(
                                                      60.0, context));
                                        },
                                      );
                                    },
                                  )),
                              SizedBoxConst.sizeWith(
                                  context: context, size: 16.0),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      product.name,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize:
                                              UtilsReponsive.formatFontSize(
                                                  16.0, context)),
                                    ),
                                    SizedBoxConst.size(
                                        context: context, size: 8.0),
                                    Text(
                                      '${NumberFormat.currency(locale: 'vi_VN', symbol: '₫').format(product.price)}',
                                      style: TextStyle(
                                          fontSize:
                                              UtilsReponsive.formatFontSize(
                                                  14.0, context)),
                                    ),
                                    // You can display other product details here if needed
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
          }
        }),
      ],
    );
  }
}
