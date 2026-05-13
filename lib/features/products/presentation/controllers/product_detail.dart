import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:voucher_hub/core/navigation/app_router.dart';

import '../../../../config/di/app_initializer.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/app_messages.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/app_widgets.dart';
import '../../../cart/cubit/cart_cubit.dart';
import '../../data/models/product_model.dart';

part '../contracts/product_detail.dart';
part '../views/product_detail.dart';

class ProductDetailScreen extends StatefulWidget {
  static const route = 'product-detail';
  final ProductModel product;
  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen>
    implements ProductDetailControllerContract {
  late final ProductDetailViewContract view;

  @override
  late CartCubit cartCubit;

  @override
  ProductModel get product => widget.product;

  late double? _selectedAmount;

  @override
  late TextEditingController amountCtrl;

  late int _quantity;

  late String? _amountError;

  @override
  double? get selectedAmount => _selectedAmount;

  @override
  int get quantity => _quantity;

  @override
  String? get amountError => _amountError;

  @override
  void initState() {
    super.initState();
    _selectedAmount = null;
    _quantity = 1;
    _amountError = null;
    amountCtrl = TextEditingController();
    cartCubit = sl<CartCubit>();
    view = ProductDetailView(controller: this);
  }

  @override
  void setSelectedAmount(double? amount) {
    setState(() => _selectedAmount = amount);
  }

  @override
  void setQuantity(int quantity) {
    setState(() => _quantity = quantity);
  }

  @override
  void setAmountError(String? error) {
    setState(() => _amountError = error);
  }

  @override
  void validateAmount() {
    double? amount = _selectedAmount;
    if (!product.hasFixedDenominations) {
      amount = double.tryParse(amountCtrl.text);
      if (amount == null) {
        setAmountError('Enter a valid amount');
        return;
      }
      if (product.minValue != null && amount < product.minValue!) {
        setAmountError(
          'Minimum amount is ${CurrencyFormatter.formatAmount(product.minValue!, product.currency)}',
        );
        return;
      }
      // if (product.maxValue != null && amount > product.maxValue!) {
      //   setAmountError(
      //     'Maximum amount is ${CurrencyFormatter.formatAmount(product.maxValue!, product.currency)}',
      //   );
      //   return;
      // }
    }
    if (amount == null) {
      AppMessages.showError(message: 'Please select an amount');
      return;
    }
  }

  @override
  void addToCart() {
    validateAmount();
    if (_amountError != null) return;

    double? amount = _selectedAmount ?? double.tryParse(amountCtrl.text);
    if (amount == null) return;

    cartCubit.addToCart(
      productCode: product.id,
      amount: amount,
      quantity: _quantity,
    );
    

  
    AppMessages.showSuccess(
      message: 'Added to cart!',
      actionLabel: 'View Cart',
      onAction: () => navigateToCart(rootNavigatorKey.currentContext!),
    );
  }

  @override
  void navigateToCart(BuildContext context) {
    context.push('/cart');
  }

  @override
  Widget build(BuildContext context) {
    return view.build(context);
  }

  @override
  void dispose() {
    amountCtrl.dispose();
    super.dispose();
  }
}
