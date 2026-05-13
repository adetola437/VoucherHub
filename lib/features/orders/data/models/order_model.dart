import 'package:equatable/equatable.dart';

class OrderModel extends Equatable {
  final String id;
  final String? status;
  final String? currency;
  final double? totalAmount;
  final int? voucherCount;
  final String? createdAt;
  final List<OrderItemModel> items;

  const OrderModel({
    required this.id,
    this.status,
    this.currency,
    this.totalAmount,
    this.voucherCount,
    this.createdAt,
    this.items = const [],
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    final rawItems = json['items'] ?? json['order_items'] ?? [];
    return OrderModel(
      id: json['id']?.toString() ?? '',
      status: json['status']?.toString(),
      currency: json['currency']?.toString() ?? 'NGN',
      totalAmount: double.tryParse(
          json['total_amount']?.toString() ??
              json['total']?.toString() ??
              '0'),
      voucherCount: int.tryParse(
          json['voucher_count']?.toString() ??
              json['vouchers_count']?.toString() ??
              '0'),
      createdAt: json['created_at']?.toString(),
      items: (rawItems as List)
          .map((e) => OrderItemModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  @override
  List<Object?> get props => [id];
}

class OrderItemModel extends Equatable {
  final String? id;
  final String? productName;
  final String? productImage;
  final double? amount;
  final int? quantity;
  final String? currency;

  const OrderItemModel({
    this.id,
    this.productName,
    this.productImage,
    this.amount,
    this.quantity,
    this.currency,
  });

  factory OrderItemModel.fromJson(Map<String, dynamic> json) {
    final product = json['product'] ?? {};
    return OrderItemModel(
      id: json['id']?.toString(),
      productName: json['product_name']?.toString() ??
          product['name']?.toString(),
      productImage: json['product_image']?.toString() ??
          product['image']?.toString(),
      amount: double.tryParse(
          json['amount']?.toString() ?? json['price']?.toString() ?? '0'),
      quantity: int.tryParse(json['quantity']?.toString() ?? '1') ?? 1,
      currency: json['currency']?.toString() ?? 'NGN',
    );
  }

  @override
  List<Object?> get props => [id];
}
