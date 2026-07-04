const fs = require('fs');
let content = fs.readFileSync('apps/mobile/lib/features/inventory/models/item_variant.model.dart', 'utf8');

content = content.replace('  final String barcode;', '  final String barcode;\n  final String? name;\n  final List<String> images;');
content = content.replace('    required this.barcode,', '    required this.barcode,\n    this.name,\n    this.images = const [],');
content = content.replace("      barcode: json['barcode'] ?? '',", "      barcode: json['barcode'] ?? '',\n      name: json['name'],\n      images: (json['images'] as List<dynamic>?)?.map((e) => e as String).toList() ?? [],");
content = content.replace("      'barcode': barcode,", "      'barcode': barcode,\n      'name': name,\n      'images': images,");
content = content.replace('    String? barcode,', '    String? barcode,\n    String? name,\n    List<String>? images,');
content = content.replace('      barcode: barcode ?? this.barcode,', '      barcode: barcode ?? this.barcode,\n      name: name ?? this.name,\n      images: images ?? this.images,');

fs.writeFileSync('apps/mobile/lib/features/inventory/models/item_variant.model.dart', content);
