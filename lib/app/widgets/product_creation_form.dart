import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'reponsive_utils.dart'; //Responsive
import '../modules/home/controllers/home_controller.dart';
import '../widgets/form_field_widget.dart';
import 'package:path/path.dart' as path;

class ProductCreationForm extends StatelessWidget {
  final HomeController controller;
  final FocusNode nameFocusNode;
  final FocusNode priceFocusNode;

  ProductCreationForm({
    super.key,
    required this.controller,
    required this.nameFocusNode,
    required this.priceFocusNode,});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FormFieldWidget(
          labelText: 'Tên sản phẩm',
          controller: controller.productNameController,
          isRequired: true,
          focusNode: nameFocusNode,
        ),
        SizedBoxConst.size(context: context, size: 16.0),
        FormFieldWidget(
          labelText: 'Giá sản phẩm',
          controller: controller.productPriceController,
          isRequired: true,
          type: 'number',
          focusNode: priceFocusNode,
        ),
        SizedBoxConst.size(context: context, size: 16.0),
        Text(
          'Ảnh sản phẩm',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: UtilsReponsive.formatFontSize(16, context)),
        ),
        SizedBoxConst.size(context: context, size: 8.0),
        Obx(() {
          final selectedImage = controller.selectedImage.value;
          return ElevatedButton.icon(
            onPressed: controller.selectImage,
            icon: Icon(
              Icons.cloud_upload_outlined,
              color: Colors.black,
              size: UtilsReponsive.formatFontSize(24, context),
            ),
            label: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  selectedImage != null
                      ? path.basename(selectedImage.path)
                      : 'Chọn tệp tin (tối đa 5MB)',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: UtilsReponsive.formatFontSize(14, context)),
                ),
                if (selectedImage != null) ...[
                  SizedBox(width: UtilsReponsive.width(8.0, context)),
                  Icon(
                    Icons.check_circle_outline,
                    color: Colors.green,
                    size: UtilsReponsive.formatFontSize(16, context),
                  ),
                ],
              ],
            ),
            style: ElevatedButton.styleFrom(
              padding: UtilsReponsive.padding(context,
                  horizontal: 16, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius:
                BorderRadius.circular(UtilsReponsive.width(5.0, context)),
              ),
            ),
          );
        }),
        SizedBoxConst.size(context: context, size: 24.0),
        SizedBox(
          width: double.infinity,
          child: Align(
            alignment: Alignment.center,
            child: ElevatedButton(
              onPressed: controller.createProduct,
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(
                    vertical: UtilsReponsive.height(14.0, context),
                    horizontal: UtilsReponsive.width(32.0, context)),
                textStyle: TextStyle(
                    fontSize: UtilsReponsive.formatFontSize(16.0, context)),
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                      UtilsReponsive.width(10.0, context)),
                ),
              ),
              child: Text(
                'Tạo sản phẩm',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: UtilsReponsive.formatFontSize(16.0, context)),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
