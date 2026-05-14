import 'package:equatable/equatable.dart';

class ProductModel extends Equatable {
  final String id;
  final String? name;
  final String imageUrl;
  final String? description;
  final String? currency;
  final double? minValue;
  final double? maxValue;
  final List<double> denominations;
  final String? redemptionInstructions;
  final String? termsAndConditions; // ← NEW
  final String? country;
  final String? category;
  final ProductValidity? validity;

  const ProductModel({
    required this.id,
    this.name,
    required this.imageUrl,
    this.description,
    this.currency,
    this.minValue,
    this.maxValue,
    this.denominations = const [],
    this.redemptionInstructions,
    this.termsAndConditions,
    this.country,
    this.category,
    this.validity,
  });

  bool get hasFixedDenominations => denominations.isNotEmpty;

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    // termsAndConditions may arrive as a List<String> or a plain String
    String? terms;
    final rawTerms = json['termsAndConditions'] ?? json['terms_and_conditions'];
    if (rawTerms is List) {
      terms = (rawTerms).map((e) => e.toString()).join('\n');
    } else if (rawTerms != null) {
      terms = rawTerms.toString();
    }

    return ProductModel(
      id: json['code']?.toString() ?? '',
      name: json['name']?.toString(),
      imageUrl: json['imageUrl']?.toString() ?? '',
      description: json['description']?.toString(),
      currency: json['currency']?.toString() ?? 'NGN',
      minValue: double.tryParse(json['minValue']?.toString() ?? ''),
      maxValue: double.tryParse(json['maxValue']?.toString() ?? ''),
      denominations: (json['denominations'] as List?)
              ?.map((e) => double.tryParse(e.toString()) ?? 0.0)
              .where((e) => e > 0)
              .toList() ??
          [],
      redemptionInstructions: (json['redemptionDetails'] as List?)?.join('\n'),
      termsAndConditions: terms,
      country: (json['countries'] as List?)?.isNotEmpty == true
          ? json['countries'][0].toString()
          : null,
      category: (json['categories'] as List?)?.isNotEmpty == true
          ? json['categories'][0].toString()
          : null,
      validity: json['validity'] != null
          ? ProductValidity.fromJson(json['validity'] as Map<String, dynamic>)
          : null,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        imageUrl,
        currency,
        minValue,
        maxValue,
        validity,
      ];
}

class ProductValidity extends Equatable {
  final String? type;
  final int? value;

  const ProductValidity({this.type, this.value});

  factory ProductValidity.fromJson(Map<String, dynamic> json) {
    return ProductValidity(
      type: json['type']?.toString(),
      value: int.tryParse(json['value']?.toString() ?? ''),
    );
  }

  @override
  List<Object?> get props => [type, value];
}