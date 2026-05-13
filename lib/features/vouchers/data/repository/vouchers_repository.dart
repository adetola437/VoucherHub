import 'package:dartz/dartz.dart';
import '../../../../core/api/exception/failure.dart';
import '../models/voucher_model.dart';

abstract class IVouchersRepository {
  Future<Either<Failure, List<VoucherModel>>> getVouchers();
  Future<Either<Failure, VoucherModel>> getVoucherById(String voucherId);
  Future<Either<Failure, List<VoucherOperationModel>>> getVoucherOperations(
      String voucherId);
}
