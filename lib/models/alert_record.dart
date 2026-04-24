class AlertRecord {
  const AlertRecord({
    this.id,
    required this.soundType,
    required this.decibel,
    required this.createdAt,
  });

  final int? id;
  final String soundType;
  final double decibel;
  final DateTime createdAt;

  Map<String, Object?> toMap() {
    return <String, Object?>{
      'id': id,
      'soundType': soundType,
      'decibel': decibel,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory AlertRecord.fromMap(Map<String, Object?> map) {
    return AlertRecord(
      id: map['id'] as int?,
      soundType: map['soundType'] as String? ?? 'Bilinmeyen ses',
      decibel: (map['decibel'] as num?)?.toDouble() ?? 0,
      createdAt: DateTime.tryParse(map['createdAt'] as String? ?? '') ??
          DateTime.fromMillisecondsSinceEpoch(0),
    );
  }
}
