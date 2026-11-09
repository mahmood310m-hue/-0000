class Student {
  final String id;
  final String fullName;
  final String phone;
  final String className;
  final String stage;
  final String parentName;
  final String parentPhone;
  final String? photoUrl;
  final DateTime createdAt;
  
  Student({
    required this.id,
    required this.fullName,
    required this.phone,
    required this.className,
    required this.stage,
    required this.parentName,
    required this.parentPhone,
    this.photoUrl,
    required this.createdAt,
  });
  
  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      id: json['id'] ?? '',
      fullName: json['full_name'] ?? '',
      phone: json['phone'] ?? '',
      className: json['class_name'] ?? '',
      stage: json['stage'] ?? '',
      parentName: json['parent_name'] ?? '',
      parentPhone: json['parent_phone'] ?? '',
      photoUrl: json['photo_url'],
      createdAt: DateTime.parse(json['created_at'] ?? DateTime.now().toIso8601String()),
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'full_name': fullName,
      'phone': phone,
      'class_name': className,
      'stage': stage,
      'parent_name': parentName,
      'parent_phone': parentPhone,
      'photo_url': photoUrl,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
