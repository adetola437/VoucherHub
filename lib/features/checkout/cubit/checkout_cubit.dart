import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import '../../cart/cubit/cart_cubit.dart';
import '../data/models/checkout_model.dart';
import '../data/repository/checkout_repository.dart';

// ─── States ───────────────────────────────────────────────────────────────────
abstract class CheckoutState extends Equatable {
  const CheckoutState();
  @override
  List<Object?> get props => [];
}

class CheckoutInitial extends CheckoutState {}
class CheckoutCalculating extends CheckoutState {}
class CheckoutProcessing extends CheckoutState {}

class CheckoutTotalLoaded extends CheckoutState {
  final CheckoutTotalModel total;
  const CheckoutTotalLoaded(this.total);
  @override
  List<Object?> get props => [total];
}

class CheckoutSuccess extends CheckoutState {
  final CheckoutResultModel result;
  const CheckoutSuccess(this.result);
  @override
  List<Object?> get props => [result];
}

class CheckoutFailure extends CheckoutState {
  final String message;
  const CheckoutFailure(this.message);
  @override
  List<Object?> get props => [message];
}

class CheckoutError extends CheckoutState {
  final String message;
  const CheckoutError(this.message);
  @override
  List<Object?> get props => [message];
}

// ─── Cubit ────────────────────────────────────────────────────────────────────
class CheckoutCubit extends Cubit<CheckoutState> {
  final ICheckoutRepository repository;
  CheckoutCubit({required this.repository}) : super(CheckoutInitial());

  Future<void> calculateTotal() async {
    emit(CheckoutCalculating());
    try {
      final result = await repository.calculateTotal();
      result.fold(
        (f) => emit(CheckoutError(f.message)),
        (total) => emit(CheckoutTotalLoaded(total)),
      );
    } catch (e) {
      emit(CheckoutError(e.toString()));
    }
  }

  Future<void> checkout() async {
    try {
      emit(CheckoutProcessing());
      final result = await repository.checkout();
      result.fold(
        (f) => emit(CheckoutError(f.message)),
        (checkoutResult) {
          if (checkoutResult.isFailed) {
            emit(CheckoutFailure(
                checkoutResult.message ?? 'Checkout failed. Please try again.'));
          } else {
            emit(CheckoutSuccess(checkoutResult));
          }
          GetIt.I<CartCubit>().loadCart();
        },
      );
    } catch (e) {
      emit(CheckoutError(e.toString()));
    }
  }
}