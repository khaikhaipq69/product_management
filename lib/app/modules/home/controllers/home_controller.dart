import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'package:entry_project/app/service/product_management.dart';
import 'package:entry_project/app/models/ProductManagement.dart'
    as productModel;

class HomeController extends GetxController {
  final productNameController = TextEditingController();
  final productPriceController = TextEditingController();
  RxList<productModel.Productlist> productLists =
      <productModel.Productlist>[].obs;
  RxString titleText = ''.obs;
  RxList<productModel.Form> formFields = <productModel.Form>[].obs;
  RxString createButtonText = ''.obs;
  RxBool isLoading = true.obs;
  RxString errorMessage = ''.obs;
  RxBool isGridView = true.obs; // To control the display mode

  final ProductManagementService _productService = ProductManagementService();
  final ImagePicker _picker = ImagePicker();
  Rx<File?> selectedImage = Rx<File?>(null);

  final count = 0.obs;

  @override
  void onInit() {
    super.onInit();
    fetchProductData();
  }

  void toggleView() {
    isGridView.value = !isGridView.value;
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
            print(
                'ProductList fetched. Item count: ${datum.customAttributes.productlist!.items.length}');
            for (final item in datum.customAttributes.productlist!.items) {
              print(
                  '  Item Name: ${item.name}, Price: ${item.price}, Image: ${item.imageSrc}');
            }
          } else {
            print('Productlist is null in the API response.');
          }
        }
      }
      print('Total Productlist count in controller: ${productLists.length}');
      if (productLists.isNotEmpty) {
        print(
            'Items in the first Productlist: ${productLists.first.items.length}');
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
    final priceController =
        formFields.firstWhereOrNull((f) => f.name == 'price');

    final name = productNameController.text.trim();
    final price = productPriceController.text.trim();
    final imageFile = selectedImage.value;

    if (nameController?.required == true && name.isEmpty || name == '') {
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
      if (priceController?.minValue != null &&
          int.parse(price) < priceController!.minValue!) {
        Get.snackbar('Error',
            'Product price cannot be less than ${priceController.minValue}');
        return;
      }
      if (priceController?.maxValue != null &&
          int.parse(price) > priceController!.maxValue!) {
        Get.snackbar('Error',
            'Product price cannot be greater than ${priceController.maxValue}');
        return;
      }
    }

    if (imageFile == null) {
      Get.snackbar('Error', 'Please select a product image.');
      return;
    }

    isLoading.value = true;
    try {
      // Simulate image upload and product creation
      await Future.delayed(const Duration(seconds: 1));
      final newItem = productModel.Item(
          name: name,
          price: int.tryParse(price) ?? 0,
          imageSrc: imageFile
              .path // In a real scenario, you'd upload this to a server
          );
      if (productLists.isNotEmpty) {
        productLists.first.items.insert(0, newItem);
        productLists.refresh();
        for (int i = 0; i < productLists.first.items.length; i++) {
          print(productLists.first.items[i].name +
              ", " +
              productLists.first.items[i].price.toString() +
              ", " +
              productLists.first.items[i].imageSrc);
        }
      }
      productNameController.clear();
      productPriceController.clear();
      selectedImage.value = null;
      Get.snackbar('Success', 'Product "$name" created successfully!');
    } catch (e) {
      Get.snackbar('Error', 'Failed to create product: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> selectImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      selectedImage.value = File(image.path);
    }
  }
}
