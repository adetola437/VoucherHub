import 'package:dartz/dartz.dart';
import '../../../../../core/api/client/api_service.dart';
import '../../../../../core/api/exception/failure.dart';
import '../../models/voucher_model.dart';


abstract class IVouchersRemoteDataSource {
  Future<Either<Failure, List<VoucherModel>>> getVouchers();
  Future<Either<Failure, VoucherModel>> getVoucherById(String voucherId);
  Future<Either<Failure, List<VoucherOperationModel>>> getVoucherOperations(
      String voucherId);
}

class VouchersRemoteDataSourceImpl implements IVouchersRemoteDataSource {
  final IApiService apiService;
  VouchersRemoteDataSourceImpl({required this.apiService});

  List<VoucherModel> _parseList(dynamic json) {
    final list = json is List
        ? json
        : (json is Map && json['data'] is List)
            ? json['data'] as List
            : [];
    return list
        .map((e) => VoucherModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<Either<Failure, List<VoucherModel>>> getVouchers() =>
      apiService.get<List<VoucherModel>>(
        '/vouchers',
        fromJson: _parseList,
      );

  @override
  Future<Either<Failure, VoucherModel>> getVoucherById(String voucherId) =>
      apiService.get<VoucherModel>(
        '/vouchers/$voucherId',
        fromJson: (json) {
          final data =
              json is Map && json.containsKey('data') ? json['data'] : json;
          return VoucherModel.fromJson(data as Map<String, dynamic>);
        },
      );

  @override
  Future<Either<Failure, List<VoucherOperationModel>>> getVoucherOperations(
      String voucherId) =>
      apiService.get<List<VoucherOperationModel>>(
        '/vouchers/$voucherId/operations',
        fromJson: (json) {
          final list = json is List
              ? json
              : (json is Map && json['data'] is List)
                  ? json['data'] as List
                  : [];
          return list
              .map((e) =>
                  VoucherOperationModel.fromJson(e as Map<String, dynamic>))
              .toList();
        },
      );
}
