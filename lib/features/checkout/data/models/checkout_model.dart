import 'package:voucher_hub/features/vouchers/data/models/voucher_model.dart';

class CheckoutTotalModel {
  final double? subtotal;
  final double? fees;
  final double? total;
  final String? currency;

  CheckoutTotalModel({this.subtotal, this.fees, this.total, this.currency});

  factory CheckoutTotalModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? json;
    return CheckoutTotalModel(
      subtotal: double.tryParse(data['subtotal']?.toString() ?? ''),
      fees: double.tryParse(data['fees']?.toString() ?? ''),
      total: double.tryParse(
          data['total']?.toString() ?? data['payable_amount']?.toString() ?? ''),
      currency: data['currency']?.toString() ?? 'NGN',
    );
  }
}

class CheckoutResultModel {
  final String? status;
  final String? message;
  final String? orderId;
  final String? paymentReference;
  final double? totalAmount;
  final String? currency;
  final String? suregiftsOrderId;
  final String? failureReason;
  final List<VoucherModel>? vouchers;

  CheckoutResultModel({
    this.status,
    this.message,
    this.orderId,
    this.paymentReference,
    this.totalAmount,
    this.currency,
    this.suregiftsOrderId,
    this.failureReason,
    this.vouchers,
  });

  bool get isSuccessful {
    final s = status;
    return s == 'PurchaseSuccessful' || s == 'PaymentSuccessful' || s == 'payment_successful' || s == 'success';
  }

  bool get isPending {
    final s = status;
    return s == 'PurchaseProcessing' || s?.toLowerCase() == 'pending' || s?.toLowerCase() == 'purchase_processing';
  }

  bool get isFailed {
    final s = status;
    return s == 'PurchaseFailed' || s?.toLowerCase() == 'purchase_failed' || s?.toLowerCase() == 'failed';
  }

  factory CheckoutResultModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? json;
    return CheckoutResultModel(
      status: data['status']?.toString() ?? json['status']?.toString(),
      message: data['message']?.toString() ?? json['message']?.toString(),
      orderId: data['orderId']?.toString() ?? data['id']?.toString(),
      paymentReference: data['paymentReference']?.toString(),
      totalAmount: double.tryParse(data['totalAmount']?.toString() ?? ''),
      currency: data['currency']?.toString(),
      suregiftsOrderId: data['suregiftsOrderId']?.toString(),
      failureReason: data['failureReason']?.toString(),
      vouchers: (data['vouchers'] as List?)
          ?.map((v) => VoucherModel.fromJson(v as Map<String, dynamic>))
          .toList(),
    );
  }
}
