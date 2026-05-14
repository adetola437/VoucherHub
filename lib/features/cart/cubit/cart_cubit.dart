import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/models/cart_model.dart';
import '../data/repository/cart_repository.dart';

// ─── States ───────────────────────────────────────────────────────────────────
abstract class CartState extends Equatable {
  const CartState();
  @override
  List<Object?> get props => [];
}

class CartInitial extends CartState {}
class CartLoading extends CartState {}
class CartUpdating extends CartState {}

class CartLoaded extends CartState {
  final CartModel cart;
  final Set<String> busyIds;
  final String? lastError;
  final DateTime? errorTimestamp;

  const CartLoaded(
    this.cart, {
    this.busyIds = const {},
    this.lastError,
    this.errorTimestamp,
  });

  bool isBusy(String id) => busyIds.contains(id);

  @override
  List<Object?> get props => [cart, busyIds, lastError, errorTimestamp];
}

class CartError extends CartState {
  final String message;
  const CartError(this.message);
  @override
  List<Object?> get props => [message];
}

class CartItemAdded extends CartState {
  final CartModel cart;
  const CartItemAdded(this.cart);
  @override
  List<Object?> get props => [cart];
}

// ─── Cubit ────────────────────────────────────────────────────────────────────
class CartCubit extends Cubit<CartState> {
  final ICartRepository repository;
  CartCubit({required this.repository}) : super(CartInitial());

  Future<void> loadCart() async {
    emit(CartLoading());
    final result = await repository.getCart();
    result.fold(
      (f) => emit(CartError(f.message)),
      (cart) => emit(CartLoaded(cart)),
    );
  }

  Future<void> addToCart({
    required String productCode,
    required double amount,
    required int quantity,
  }) async {
    emit(CartLoading());
    final result = await repository.addToCart(
        productCode: productCode, amount: amount, quantity: quantity);
    result.fold(
      (f) => emit(CartError(f.message)),
      (cart) => emit(CartItemAdded(cart)),
    );
  }

  Future<void> updateItem(String cartItemId, int quantity) async {
    final currentState = state;
    final CartModel currentCart;
    final Set<String> currentBusy;

    if (currentState is CartLoaded) {
      currentCart = currentState.cart;
      currentBusy = currentState.busyIds;
    } else if (currentState is CartItemAdded) {
      currentCart = currentState.cart;
      currentBusy = const <String>{};
    } else {
      return;
    }

    // Mark only this item as busy — the screen stays visible
    emit(CartLoaded(currentCart, busyIds: {...currentBusy, cartItemId}));

    final result = await repository.updateCartItem(
      cartItemId: cartItemId,
      quantity: quantity,
    );

    result.fold(
      (f) {
        final updatedBusy = {...currentBusy}..remove(cartItemId);
        emit(CartLoaded(
          currentCart,
          busyIds: updatedBusy,
          lastError: f.message,
          errorTimestamp: DateTime.now(),
        ));
      },
      (cart) => emit(CartLoaded(cart)),
    );
  }

  Future<void> removeItem(String cartItemId) async {
    final currentState = state;
    final CartModel currentCart;
    final Set<String> currentBusy;

    if (currentState is CartLoaded) {
      currentCart = currentState.cart;
      currentBusy = currentState.busyIds;
    } else if (currentState is CartItemAdded) {
      currentCart = currentState.cart;
      currentBusy = const <String>{};
    } else {
      return;
    }

    emit(CartLoaded(currentCart, busyIds: {...currentBusy, cartItemId}));

    final result = await repository.removeCartItem(cartItemId);

    await result.fold(
      (f) async {
        final updatedBusy = {...currentBusy}..remove(cartItemId);
        emit(CartLoaded(
          currentCart,
          busyIds: updatedBusy,
          lastError: f.message,
          errorTimestamp: DateTime.now(),
        ));
      },
      (_) async {
        final refresh = await repository.getCart();
        refresh.fold(
          (f) {
            final updatedBusy = {...currentBusy}..remove(cartItemId);
            emit(CartLoaded(
              currentCart,
              busyIds: updatedBusy,
              lastError: f.message,
              errorTimestamp: DateTime.now(),
            ));
          },
          (cart) => emit(CartLoaded(cart)),
        );
      },
    );
  }

  Future<void> clearCart() async {
    final result = await repository.clearCart();
    result.fold(
      (f) => emit(CartError(f.message)),
      (_) => loadCart(),
    );
  }
}