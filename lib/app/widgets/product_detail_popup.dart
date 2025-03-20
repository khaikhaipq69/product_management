import 'package:entry_project/app/widgets/util_common.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'reponsive_utils.dart';
import '../modules/home/controllers/home_controller.dart';
import 'package:entry_project/app/models/ProductManagement.dart' as productModel;
import 'dart:io';

class ProductDetailPopup extends StatefulWidget {
  final productModel.Item product;
  final HomeController controller;

  const ProductDetailPopup({
    super.key,
    required this.product,
    required this.controller,
  });

  @override
  State<ProductDetailPopup> createState() => _ProductDetailPopupState();
}

class _ProductDetailPopupState extends State<ProductDetailPopup> {
  late TextEditingController _nameController;
  late TextEditingController _priceController;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.product.name);
    _priceController = TextEditingController(text: widget.product.price.toString());
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  void _toggleEdit() {
    setState(() {
      _isEditing = !_isEditing;
    });
  }

  void _saveChanges() {
    final newName = _nameController.text.trim();
    final newPrice = _priceController.text.trim();

    final nameControllerConfig = widget.controller.formFields.firstWhereOrNull((f) => f.name == 'name');
    final priceControllerConfig = widget.controller.formFields.firstWhereOrNull((f) => f.name == 'price');

    if (nameControllerConfig?.required == true && newName.isEmpty) {
      UtilCommon.snackBar(text: 'Product name cannot be empty', isFail: true);
      return;
    }

    if (priceControllerConfig?.required == true && newPrice.isEmpty) {
      UtilCommon.snackBar(text: 'Product price cannot be empty', isFail: true);
      return;
    }

    if (newPrice.isNotEmpty && priceControllerConfig?.type == 'number') {
      final parsedPrice = int.tryParse(newPrice);
      if (parsedPrice == null) {
        UtilCommon.snackBar(text: 'Product price must be a valid number', isFail: true);
        return;
      }
      if (priceControllerConfig?.minValue != null && parsedPrice < priceControllerConfig!.minValue!) {
        UtilCommon.snackBar(text: 'Product price cannot be less than ${priceControllerConfig.minValue}', isFail: true);
        return;
      }
      if (priceControllerConfig?.maxValue != null && parsedPrice > priceControllerConfig!.maxValue!) {
        UtilCommon.snackBar(text: 'Product price cannot be greater than ${priceControllerConfig.maxValue}', isFail: true);
        return;
      }
    }

    if (nameControllerConfig?.minValue != null && newName.length < nameControllerConfig!.minValue!) {
      UtilCommon.snackBar(text: 'Product name cannot be less than ${nameControllerConfig.minValue}', isFail: true);
      return;
    }

    if (nameControllerConfig?.maxLength != null && newName.length > nameControllerConfig!.maxLength!) {
      UtilCommon.snackBar(text: 'Product name cannot be greater than ${nameControllerConfig.maxLength}', isFail: true);
      return;
    }

    final parsedNewPrice = int.tryParse(newPrice);
    if (newName.isNotEmpty && parsedNewPrice != null) {
      widget.controller.updateProduct(widget.product, newName, parsedNewPrice);
      setState(() {
        _isEditing = false;
      });
    } else if (newName.isEmpty || parsedNewPrice == null) {
      UtilCommon.snackBar(text: 'Please enter a valid name and price.', isFail: true);
    }
  }

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
                if (widget.controller.localImages.containsKey(widget.product.name)) {
                  return Image.file(
                    widget.controller.localImages[widget.product.name]!,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(Icons.image_not_supported, size: 60);
                    },
                  );
                } else if (widget.product.imageSrc.startsWith('/data/user/0/') ||
                    widget.product.imageSrc.startsWith('/storage/')) {
                  return Image.file(
                    File(widget.product.imageSrc),
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(Icons.image_not_supported, size: 60);
                    },
                  );
                } else {
                  return Image.network(
                    widget.product.imageSrc,
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
            TextFormField(
              controller: _nameController,
              enabled: _isEditing,
              decoration: InputDecoration(
                labelText: 'Tên sản phẩm',
                border: _isEditing ? const OutlineInputBorder() : InputBorder.none,
              ),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: UtilsReponsive.formatFontSize(18.0, context),
              ),
            ),
            SizedBoxConst.size(context: context, size: 8.0),

            // Price
            TextFormField(
              controller: _priceController,
              enabled: _isEditing,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Giá sản phẩm',
                border: _isEditing ? const OutlineInputBorder() : InputBorder.none,
              ),
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
                  onPressed: _toggleEdit,
                  child: Text(_isEditing ? 'Hủy' : 'Chỉnh sửa'),
                ),
                ElevatedButton(
                  onPressed: _isEditing ? _saveChanges : () => widget.controller.deleteProduct(widget.product),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isEditing ? Colors.green : Colors.redAccent,
                  ),
                  child: Text(_isEditing ? 'Lưu' : 'Xóa'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}