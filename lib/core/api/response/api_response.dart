class ApiResponse<T> {
  final T? data;
  final String? message;
  final bool success;
  final dynamic errors;

  const ApiResponse({
    this.data,
    this.message,
    required this.success,
    this.errors,
  });

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic) fromJson,
  ) {
    return ApiResponse<T>(
      data: json['data'] != null ? fromJson(json['data']) : null,
      message: json['message']?.toString(),
      success: json['status'] == 1 || json['success'] == true,
      errors: json['errors'],
    );
  }

  factory ApiResponse.raw(Map<String, dynamic> json) {
    return ApiResponse<T>(
      data: json['data'] as T?,
      message: json['message']?.toString(),
      success: json['status'] == 1 || json['success'] == true,
      errors: json['errors'],
    );
  }
}

class PaginatedResponse<T> {
  final List<T> items;
  final int? total;
  final int? currentPage;
  final int? lastPage;
  final int? perPage;

  const PaginatedResponse({
    required this.items,
    this.total,
    this.currentPage,
    this.lastPage,
    this.perPage,
  });

  factory PaginatedResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) fromJson,
  ) {
    final data = json['data'];
    List<T> items = [];
    if (data is List) {
      items = data.map((e) => fromJson(e as Map<String, dynamic>)).toList();
    } else if (data is Map && data.containsKey('data')) {
      items = (data['data'] as List)
          .map((e) => fromJson(e as Map<String, dynamic>))
          .toList();
    }
    return PaginatedResponse(
      items: items,
      total: json['total'] ?? data?['total'],
      currentPage: json['current_page'] ?? data?['current_page'],
      lastPage: json['last_page'] ?? data?['last_page'],
      perPage: json['per_page'] ?? data?['per_page'],
    );
  }
}
