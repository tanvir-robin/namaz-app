class Products {
  String? packSize;
  String? productName;
  String? type;
  num? unitPrice;
  String? index;

  Products({
    this.packSize,
    this.productName,
    this.type,
    this.unitPrice,
    this.index,
  });

  @override
  String toString() {
    return 'Products2(packSize: $packSize, productName: $productName, type: $type, unitPrice: $unitPrice, index: $index)';
  }

  factory Products.fromJson(Map<String, dynamic> json) => Products(
        packSize: json['Pack size'] as String?,
        productName: json['Product Name'] as String?,
        type: json['Type'] as String?,
        unitPrice: json['Unit Price'] as num?,
        index: json['index'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'Pack size': packSize,
        'Product Name': productName,
        'Type': type,
        'Unit Price': unitPrice,
        'index': index,
      };
}
