import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../config/di/app_initializer.dart';
import '../../core/theme/app_colors.dart';
import '../../features/cart/cubit/cart_cubit.dart';

/// The persistent shell that wraps every tab screen.
/// [navigationShell] is provided by go_router's StatefulShellRoute and keeps
/// each branch's navigator stack alive independently.
class MainShell extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const MainShell({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      // CartCubit is a lazySingleton — safe to share across all tabs.
      value: sl<CartCubit>(),
      child: Scaffold(
        // The shell itself has no AppBar — each tab's Scaffold provides its own.
        body: navigationShell,
        bottomNavigationBar: _BottomNav(
          currentIndex: navigationShell.currentIndex,
          onTap: (index) => _onTap(index),
        ),
      ),
    );
  }

  void _onTap(int index) {
    // goBranch keeps each tab's scroll/state alive.
    // initialLocation: true means tapping the active tab goes back to its root.
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }
}

class _BottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const _BottomNav({required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartCubit, CartState>(
      builder: (context, cartState) {
        // Show badge count on Cart tab from live CartCubit state.
        final cartCount = switch (cartState) {
          CartLoaded s => s.cart.items.length,
          _ => 0,
        };

        return BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: currentIndex,
          selectedItemColor: AppColors.primary,
          unselectedItemColor: AppColors.textSecondary,
          backgroundColor: Colors.white,
          elevation: 8,
          onTap: onTap,
          items: [
            const BottomNavigationBarItem(
              icon: Icon(Icons.store_outlined),
              activeIcon: Icon(Icons.store),
              label: 'Catalogue',
            ),
            BottomNavigationBarItem(
              icon: Badge(
                isLabelVisible: cartCount > 0,
                label: Text('$cartCount'),
                child: const Icon(Icons.shopping_cart_outlined),
              ),
              activeIcon: Badge(
                isLabelVisible: cartCount > 0,
                label: Text('$cartCount'),
                child: const Icon(Icons.shopping_cart),
              ),
              label: 'Cart',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.receipt_long_outlined),
              activeIcon: Icon(Icons.receipt_long),
              label: 'Orders',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.confirmation_number_outlined),
              activeIcon: Icon(Icons.confirmation_number),
              label: 'Vouchers',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              activeIcon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
        );
      },
    );
  }
}