// lib/models/product_management_response.dart
class ProductManagement {
  String code;
  String message;
  List<Datum> data;

  ProductManagement({
    required this.code,
    required this.message,
    required this.data,
  });

  factory ProductManagement.fromJson(Map<String, dynamic> json) {
    return ProductManagement(
      code: json['code'] as String? ?? '',
      message: json['message'] as String? ?? '',
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => Datum.fromJson(e as Map<String, dynamic>))
          .toList() ??
          [],
    );
  }

  ProductManagement copyWith({
    String? code,
    String? message,
    List<Datum>? data,
  }) =>
      ProductManagement(
        code: code ?? this.code,
        message: message ?? this.message,
        data: data ?? this.data,
      );
}

class Datum {
  String type;
  CustomAttributes customAttributes;

  Datum({
    required this.type,
    required this.customAttributes,
  });

  factory Datum.fromJson(Map<String, dynamic> json) {
    return Datum(
      type: json['type'] as String? ?? '',
      customAttributes: CustomAttributes.fromJson(json['customAttributes'] as Map<String, dynamic>? ?? {}),
    );
  }

  Datum copyWith({
    String? type,
    CustomAttributes? customAttributes,
  }) =>
      Datum(
        type: type ?? this.type,
        customAttributes: customAttributes ?? this.customAttributes,
      );
}

class CustomAttributes {
  Button? label;
  List<Form>? form;
  Button? button;
  Productlist? productlist;

  CustomAttributes({
    this.label,
    this.form,
    this.button,
    this.productlist,
  });

  factory CustomAttributes.fromJson(Map<String, dynamic> json) {
    return CustomAttributes(
      label: json['label'] == null ? null : Button.fromJson(json['label'] as Map<String, dynamic>),
      form: (json['form'] as List<dynamic>?)
          ?.map((e) => Form.fromJson(e as Map<String, dynamic>))
          .toList(),
      button: json['button'] == null ? null : Button.fromJson(json['button'] as Map<String, dynamic>),
      productlist: json['productlist'] == null ? null : Productlist.fromJson(json['productlist'] as Map<String, dynamic>),
    );
  }

  CustomAttributes copyWith({
    Button? label,
    List<Form>? form,
    Button? button,
    Productlist? productlist,
  }) =>
      CustomAttributes(
        label: label ?? this.label,
        form: form ?? this.form,
        button: button ?? this.button,
        productlist: productlist ?? this.productlist,
      );
}

class Button {
  String text;

  Button({
    required this.text,
  });

  factory Button.fromJson(Map<String, dynamic> json) {
    return Button(
      text: json['text'] as String? ?? '',
    );
  }

  Button copyWith({
    String? text,
  }) =>
      Button(
        text: text ?? this.text,
      );
}

class Form {
  String label;
  bool? required;
  String name;
  String type;
  int? maxLength;
  int? minValue;
  int? maxValue;

  Form({
    required this.label,
    this.required,
    required this.name,
    required this.type,
    this.maxLength,
    this.minValue,
    this.maxValue,
  });

  factory Form.fromJson(Map<String, dynamic> json) {
    return Form(
      label: json['label'] as String? ?? '',
      required: json['required'] as bool?,
      name: json['name'] as String? ?? '',
      type: json['type'] as String? ?? '',
      maxLength: json['maxLength'] as int?,
      minValue: json['minValue'] as int?,
      maxValue: json['maxValue'] as int?,
    );
  }

  Form copyWith({
    String? label,
    bool? required,
    String? name,
    String? type,
    int? maxLength,
    int? minValue,
    int? maxValue,
  }) =>
      Form(
        label: label ?? this.label,
        required: required ?? this.required,
        name: name ?? this.name,
        type: type ?? this.type,
        maxLength: maxLength ?? this.maxLength,
        minValue: minValue ?? this.minValue,
        maxValue: maxValue ?? this.maxValue,
      );
}

class Productlist {
  List<Item> items;

  Productlist({
    required this.items,
  });

  factory Productlist.fromJson(Map<String, dynamic> json) {
    return Productlist(
      items: (json['items'] as List<dynamic>?)
          ?.map((e) => Item.fromJson(e as Map<String, dynamic>))
          .toList() ??
          [],
    );
  }

  Productlist copyWith({
    List<Item>? items,
  }) =>
      Productlist(
        items: items ?? this.items,
      );
}

class Item {
  String name;
  int price;
  String imageSrc;

  Item({
    required this.name,
    required this.price,
    required this.imageSrc,
  });

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      name: json['name'] as String? ?? '',
      price: json['price'] as int? ?? 0,
      imageSrc: json['imageSrc'] as String? ?? '',
    );
  }

  Item copyWith({
    String? name,
    int? price,
    String? imageSrc,
  }) =>
      Item(
        name: name ?? this.name,
        price: price ?? this.price,
        imageSrc: imageSrc ?? this.imageSrc,
      );
}