class PaymentMethodModel {
  final String name;
  final String code; // 'DANA', 'GOPAY', 'OVO'
  final String logoAsset;

  PaymentMethodModel({
    required this.name,
    required this.code,
    required this.logoAsset,
  });
}