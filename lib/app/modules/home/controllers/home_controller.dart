import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

import 'package:entry_project/app/service/product_management.dart'; // Import the service
import 'package:entry_project/app/models/ProductManagement.dart' as productModel; // Import the new model

class HomeController extends GetxController {
  final productNameController = TextEditingController();
  final productPriceController = TextEditingController();
  RxList<productModel.Productlist> productLists = <productModel.Productlist>[].obs; // Use Productlist
  RxString titleText = ''.obs; // Title will come from the 'label' in the data
  RxList<productModel.Form> formFields = <productModel.Form>[].obs; // To hold the form fields
  RxString createButtonText = ''.obs; // To hold the create button text
  RxBool isLoading = true.obs;
  RxString errorMessage = ''.obs;

  final ProductManagementService _productService = ProductManagementService();

  final count = 0.obs;

  @override
  void onInit() {
    super.onInit();
    fetchProductData();
  }

  Future<void> fetchProductData() async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      final response = await _productService.fetchProductData();

      for (final datum in response.data) {
        if (datum.type == 'Label') {
          titleText.value = datum.customAttributes.label?.text ?? '';
        } else if (datum.type == 'ProductSubmitForm') {
          formFields.addAll(datum.customAttributes.form ?? []);
        } else if (datum.type == 'Button') {
          createButtonText.value = datum.customAttributes.button?.text ?? '';
        } else if (datum.type == 'ProductList') {
          if (datum.customAttributes.productlist != null) {
            productLists.add(datum.customAttributes.productlist!);
            print('Productlist fetched. Item count: ${datum.customAttributes.productlist!.items.length}'); // Check item count
            for (final item in datum.customAttributes.productlist!.items) {
              print('  Item Name: ${item.name}, Price: ${item.price}, Image: ${item.imageSrc}'); // Log individual items
            }
          } else {
            print('Productlist is null in the API response.');
          }
        }
      }

      print('Total Productlist count in controller: ${productLists.length}'); // Check the number of Productlist objects
      if (productLists.isNotEmpty) {
        print('Items in the first Productlist: ${productLists.first.items.length}'); // Check items in the first list
      } else {
        print('No Productlist objects found in the response.');
      }

    } catch (e) {
      errorMessage.value = 'Failed to load data: $e';
      print('Error fetching data: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> createProduct() async {
    final nameController = formFields.firstWhereOrNull((f) => f.name == 'name');
    final priceController = formFields.firstWhereOrNull((f) => f.name == 'price');

    final name = productNameController.text.trim();
    final price = productPriceController.text.trim();

    if (nameController?.required == true && name.isEmpty) {
      Get.snackbar('Error', 'Product name cannot be empty');
      return;
    }
    if (priceController?.required == true && price.isEmpty) {
      Get.snackbar('Error', 'Product price cannot be empty');
      return;
    }

    if (price.isNotEmpty && priceController?.type == 'number') {
      if (int.tryParse(price) == null) {
        Get.snackbar('Error', 'Product price must be a valid number');
        return;
      }
      if (priceController?.minValue != null && int.parse(price) < priceController!.minValue!) {
        Get.snackbar('Error', 'Product price cannot be less than ${priceController.minValue}');
        return;
      }
      if (priceController?.maxValue != null && int.parse(price) > priceController!.maxValue!) {
        Get.snackbar('Error', 'Product price cannot be greater than ${priceController.maxValue}');
        return;
      }
    }

    isLoading.value = true;
    try {
      await Future.delayed(const Duration(seconds: 1));
      final newItem = productModel.Item(name: name, price: int.tryParse(price) ?? 0, imageSrc: 'https://via.placeholder.com/150/AAAAAA/FFFFFF?Text=New+Product');
      if (productLists.isNotEmpty) {
        productLists.first.items.insert(0, newItem);
        // Trigger an update in the UI
        productLists.refresh();
      }
      productNameController.clear();
      productPriceController.clear();
      Get.snackbar('Success', 'Product "$name" created successfully!');
    } catch (e) {
      Get.snackbar('Error', 'Failed to create product: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void selectImage() {
    Get.snackbar('Thông báo', 'Tính năng chọn ảnh sẽ được triển khai sau.', snackPosition: SnackPosition.BOTTOM);
  }
}