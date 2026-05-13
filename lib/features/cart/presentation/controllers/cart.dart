import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../config/di/app_initializer.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/app_widgets.dart';
import '../../cubit/cart_cubit.dart';
import '../../data/models/cart_model.dart';

part '../contracts/cart.dart';
part '../views/cart.dart';

class CartScreen extends StatefulWidget {
  static const route = 'cart';
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen>
    implements CartControllerContract {
  late final CartViewContract view;
  late CartCubit cubit;

  @override
  void initState() {
    super.initState();
    cubit = sl<CartCubit>();
    view = CartView(controller: this, cubit: cubit);
    loadCart();
  }

  @override
  Widget build(BuildContext context) {
    return view.build(context);
  }

  @override
  void loadCart() => cubit.loadCart();

  @override
  void clearCart(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Clear Cart'),
        content: const Text('Remove all items from your cart?'),
        actions: [
          TextButton(
              onPressed: () => context.pop(),
              child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              context.pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Clearing cart..., No Endpoint For clearing all cart items'),
                ),
              );
            },
            child: const Text('Clear',
                style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );
  }

  @override
  void updateItem(String cartItemId, int quantity) =>
      cubit.updateItem(cartItemId, quantity);

  @override
  void removeItem(String cartItemId) => cubit.removeItem(cartItemId);

  @override
  void checkout(BuildContext context) => context.push('/checkout');

  @override
  void navigateToCatalogue(BuildContext context) => context.go('/products');
}