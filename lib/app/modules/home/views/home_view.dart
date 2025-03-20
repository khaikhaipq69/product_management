import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/home_controller.dart';
import 'package:entry_project/app/widgets/product_creation_form.dart';
import 'package:entry_project/app/widgets/product_list_widget.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quản lý sản phẩm',
            style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Part 1: Product Creation Form
            ProductCreationForm(controller: controller),
            const SizedBox(height: 32.0),
            // Part 2: Existing Product List
            ProductListWidget(controller: controller)
          ],
        ),
      ),
    );
  }
}
