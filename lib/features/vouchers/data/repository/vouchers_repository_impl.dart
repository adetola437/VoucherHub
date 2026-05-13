import 'package:dartz/dartz.dart';
import '../../../../core/api/exception/failure.dart';
import '../datasources/remote/vouchers_remote_datasource.dart';
import '../models/voucher_model.dart';
import 'vouchers_repository.dart';

class VouchersRepositoryImpl implements IVouchersRepository {
  final IVouchersRemoteDataSource remoteDataSource;
  VouchersRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<VoucherModel>>> getVouchers() =>
      remoteDataSource.getVouchers();

  @override
  Future<Either<Failure, VoucherModel>> getVoucherById(String voucherId) =>
      remoteDataSource.getVoucherById(voucherId);

  @override
  Future<Either<Failure, List<VoucherOperationModel>>> getVoucherOperations(
          String voucherId) =>
      remoteDataSource.getVoucherOperations(voucherId);
}
