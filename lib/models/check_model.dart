class CheckItem {
  final double amount;

  CheckItem({required this.amount});
}

class Check {
  final String id;
  final String establishmentName;
  final List<double> items;
  final double total;
  final bool match;
  final String imagePath;
  final DateTime createdAt;

  Check({
    required this.id,
    required this.establishmentName,
    required this.items,
    required this.total,
    required this.match,
    required this.imagePath,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'establishmentName': establishmentName,
    'items': items,
    'total': total,
    'match': match,
    'imagePath': imagePath,
    'createdAt': createdAt.toIso8601String(),
  };

  String get displayName => 
    establishmentName.isNotEmpty ? establishmentName : 'Check ${createdAt.toString().split('.')[0]}';
} 