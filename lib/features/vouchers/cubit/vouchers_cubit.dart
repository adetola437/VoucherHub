import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/models/voucher_model.dart';
import '../data/repository/vouchers_repository.dart';

// ─── States ───────────────────────────────────────────────────────────────────
abstract class VouchersState extends Equatable {
  const VouchersState();
  @override
  List<Object?> get props => [];
}

class VouchersInitial extends VouchersState {}
class VouchersLoading extends VouchersState {}
class VoucherDetailLoading extends VouchersState {}

class VouchersLoaded extends VouchersState {
  final List<VoucherModel> vouchers;
  const VouchersLoaded(this.vouchers);
  @override
  List<Object?> get props => [vouchers];
}

class VoucherDetailLoaded extends VouchersState {
  final VoucherModel voucher;
  final List<VoucherOperationModel> operations;
  const VoucherDetailLoaded({required this.voucher, required this.operations});
  @override
  List<Object?> get props => [voucher, operations];
}

class VouchersError extends VouchersState {
  final String message;
  const VouchersError(this.message);
  @override
  List<Object?> get props => [message];
}

// ─── Cubit ────────────────────────────────────────────────────────────────────
class VouchersCubit extends Cubit<VouchersState> {
  final IVouchersRepository repository;
  VouchersCubit({required this.repository}) : super(VouchersInitial());

  Future<void> loadVouchers() async {
    emit(VouchersLoading());
    final result = await repository.getVouchers();
    result.fold(
      (f) => emit(VouchersError(f.message)),
      (vouchers) => emit(VouchersLoaded(vouchers)),
    );
  }

  Future<void> loadVoucherDetail(String voucherId) async {
    emit(VoucherDetailLoading());
    // Fetch detail and operations in parallel
    final results = await Future.wait([
      repository.getVoucherById(voucherId),
      repository.getVoucherOperations(voucherId),
    ]);

    final voucherResult = results[0] as dynamic;
    final opsResult = results[1] as dynamic;

    voucherResult.fold(
      (f) => emit(VouchersError(f.message)),
      (voucher) {
        final ops = opsResult.fold(
          (_) => <VoucherOperationModel>[],
          (list) => list as List<VoucherOperationModel>,
        );
        emit(VoucherDetailLoaded(voucher: voucher, operations: ops));
      },
    );
  }
}
