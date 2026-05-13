import 'package:equatable/equatable.dart';

class CartItemModel extends Equatable {
  final String id;
  final String? productId;
  final String? productName;
  final String? productImage;
  final double amount;
  final int quantity;
  final String? currency;
  final double? subtotal;

  const CartItemModel({
    required this.id,
    this.productId,
    this.productName,
    this.productImage,
    required this.amount,
    required this.quantity,
    this.currency,
    this.subtotal,
  });

  double get totalPrice => subtotal ?? (amount * quantity);

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    final product = json['product'] ?? {};
    return CartItemModel(
      id: json['id']?.toString() ?? '',
      productId: (json['productCode'] ?? json['product_id'] ?? product['id'])
          ?.toString(),
      productName: json['productName']?.toString() ??
          json['product_name']?.toString() ??
          product['name']?.toString(),
      productImage: json['productImageUrl']?.toString() ??
          json['product_image']?.toString() ??
          product['image']?.toString(),
      amount: double.tryParse(json['unitPrice']?.toString() ??
              json['amount']?.toString() ??
              json['price']?.toString() ??
              '0') ??
          0,
      quantity: int.tryParse(json['quantity']?.toString() ?? '1') ?? 1,
      currency: json['currency']?.toString() ??
          product['currency']?.toString() ??
          'NGN',
      subtotal: double.tryParse(json['subtotal']?.toString() ?? ''),
    );
  }

  CartItemModel copyWith({int? quantity}) => CartItemModel(
        id: id,
        productId: productId,
        productName: productName,
        productImage: productImage,
        amount: amount,
        quantity: quantity ?? this.quantity,
        currency: currency,
        subtotal: subtotal,
      );

  @override
  List<Object?> get props => [id];
}

class CartModel extends Equatable {
  final String? id;
  final List<CartItemModel> items;
  final double? subtotal;
  final double? total;
  final String? currency;

  const CartModel({
    this.id,
    required this.items,
    this.subtotal,
    this.total,
    this.currency,
  });

  double get calculatedTotal =>
      items.fold(0, (sum, item) => sum + item.totalPrice);

  bool get isEmpty => items.isEmpty;

  factory CartModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? json;
    final rawItems = data['items'] ?? data['cart_items'] ?? [];
    return CartModel(
      id: data['id']?.toString(),
      items: (rawItems as List)
          .map((e) => CartItemModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      subtotal: double.tryParse(data['subtotal']?.toString() ?? ''),
      total: double.tryParse(data['total']?.toString() ?? ''),
      currency: data['currency']?.toString() ?? 'NGN',
    );
  }

  @override
  List<Object?> get props => [id, items];
}
