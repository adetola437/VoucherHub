import 'package:equatable/equatable.dart';

class VoucherModel extends Equatable {
  final String? id;
  final String? orderId;
  final String? productCode;
  final String? productName;
  final String? productImageUrl;
  final double? amount;
  final String? currency;
  final String? voucherCode;
  final String? pin;
  final String? serialNumber;
  final String? expiryDate;
  final String? suregiftsVoucherId;
  final String? suregiftsOrderId;
  final String? createdAtUtc;

  const VoucherModel({
    this.id,
    this.orderId,
    this.productCode,
    this.productName,
    this.productImageUrl,
    this.amount,
    this.currency,
    this.voucherCode,
    this.pin,
    this.serialNumber,
    this.expiryDate,
    this.suregiftsVoucherId,
    this.suregiftsOrderId,
    this.createdAtUtc,
  });

  factory VoucherModel.fromJson(Map<String, dynamic> json) {
    return VoucherModel(
      id: json['id']?.toString(),
      orderId: json['orderId']?.toString() ?? json['order_id']?.toString(),
      productCode: json['productCode']?.toString() ?? json['product_code']?.toString(),
      productName: json['productName']?.toString() ?? json['product_name']?.toString(),
      productImageUrl: json['productImageUrl']?.toString() ?? json['product_image_url']?.toString(),
      amount: double.tryParse(json['amount']?.toString() ?? '0'),
      currency: json['currency']?.toString() ?? 'NGN',
      voucherCode: json['voucherCode']?.toString() ?? json['voucher_code']?.toString(),
      pin: json['pin']?.toString(),
      serialNumber: json['serialNumber']?.toString() ?? json['serial_number']?.toString(),
      expiryDate: json['expiryDate']?.toString() ?? json['expiry_date']?.toString(),
      suregiftsVoucherId: json['suregiftsVoucherId']?.toString() ?? json['suregifts_voucher_id']?.toString(),
      suregiftsOrderId: json['suregiftsOrderId']?.toString() ?? json['suregifts_order_id']?.toString(),
      createdAtUtc: json['createdAtUtc']?.toString() ?? json['created_at_utc']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'orderId': orderId,
    'productCode': productCode,
    'productName': productName,
    'productImageUrl': productImageUrl,
    'amount': amount,
    'currency': currency,
    'voucherCode': voucherCode,
    'pin': pin,
    'serialNumber': serialNumber,
    'expiryDate': expiryDate,
    'suregiftsVoucherId': suregiftsVoucherId,
    'suregiftsOrderId': suregiftsOrderId,
    'createdAtUtc': createdAtUtc,
  };

  @override
  List<Object?> get props => [id, orderId, voucherCode];
}

class VoucherCodeModel extends Equatable {
  final String? code;
  final String? pin;
  final String? serialNumber;
  final String? redemptionUrl;
  final String? instructions;
  final String? termsAndConditions;
  final String? expiryDate;

  const VoucherCodeModel({
    this.code,
    this.pin,
    this.serialNumber,
    this.redemptionUrl,
    this.instructions,
    this.termsAndConditions,
    this.expiryDate,
  });

  factory VoucherCodeModel.fromJson(Map<String, dynamic> json) {
    return VoucherCodeModel(
      code: json['code']?.toString() ?? json['voucher_code']?.toString(),
      pin: json['pin']?.toString(),
      serialNumber: json['serial_number']?.toString() ??
          json['serial']?.toString(),
      redemptionUrl: json['redemption_url']?.toString() ??
          json['redeem_url']?.toString(),
      instructions: json['instructions']?.toString() ??
          json['redemption_instructions']?.toString(),
      termsAndConditions: json['terms_and_conditions']?.toString(),
      expiryDate: json['expiry_date']?.toString() ??
          json['valid_till']?.toString(),
    );
  }

  @override
  List<Object?> get props => [code, pin, serialNumber];
}

class VoucherOperationModel extends Equatable {
  final String? id;
  final String? type;
  final String? status;
  final String? description;
  final String? createdAt;

  const VoucherOperationModel({
    this.id,
    this.type,
    this.status,
    this.description,
    this.createdAt,
  });

  factory VoucherOperationModel.fromJson(Map<String, dynamic> json) {
    return VoucherOperationModel(
      id: json['id']?.toString(),
      type: json['type']?.toString() ?? json['operation']?.toString(),
      status: json['status']?.toString(),
      description: json['description']?.toString() ??
          json['message']?.toString(),
      createdAt: json['created_at']?.toString(),
    );
  }

  @override
  List<Object?> get props => [id];
}
