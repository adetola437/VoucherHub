import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/models/order_model.dart';
import '../data/repository/orders_repository.dart';

// ─── States ───────────────────────────────────────────────────────────────────
abstract class OrdersState extends Equatable {
  const OrdersState();
  @override
  List<Object?> get props => [];
}

class OrdersInitial extends OrdersState {}
class OrdersLoading extends OrdersState {}
class OrderDetailLoading extends OrdersState {}

class OrdersLoaded extends OrdersState {
  final List<OrderModel> orders;
  const OrdersLoaded(this.orders);
  @override
  List<Object?> get props => [orders];
}

class OrderDetailLoaded extends OrdersState {
  final OrderModel order;
  const OrderDetailLoaded(this.order);
  @override
  List<Object?> get props => [order];
}

class OrdersError extends OrdersState {
  final String message;
  const OrdersError(this.message);
  @override
  List<Object?> get props => [message];
}

// ─── Cubit ────────────────────────────────────────────────────────────────────
class OrdersCubit extends Cubit<OrdersState> {
  final IOrdersRepository repository;
  OrdersCubit({required this.repository}) : super(OrdersInitial());

  Future<void> loadOrders() async {
    emit(OrdersLoading());
    final result = await repository.getOrders();
    result.fold(
      (f) {
        String errorMessage = f.message != null && f.message!.isNotEmpty
            ? f.message
            : 'An error occurred while fetching orders.';
        emit(OrdersError(errorMessage));
      },
      (orders) => emit(OrdersLoaded(orders)),
    );
  }

  Future<void> loadOrderDetail(String orderId) async {
    emit(OrderDetailLoading());
    final result = await repository.getOrderById(orderId);
    result.fold(
      (f) => emit(OrdersError(f.message)),
      (order) => emit(OrderDetailLoaded(order)),
    );
  }
}
