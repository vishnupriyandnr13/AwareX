class TrustedContact {
  const TrustedContact({
    required this.id,
    required this.name,
    required this.phoneNumber,
    required this.relationship,
    required this.isPrimary,
    required this.createdAt,
    this.avatarPath,
    this.sourceContactId,
  });

  final String id;
  final String name;
  final String phoneNumber;
  final String relationship;
  final bool isPrimary;
  final DateTime createdAt;

  /// Optional local/avatar reference.
  final String? avatarPath;

  /// ID of the original phone contact, when imported.
  final String? sourceContactId;

  String get initials {
    final parts = name
        .trim()
        .split(RegExp(r'\s+'))
        .where((part) => part.isNotEmpty)
        .toList();

    if (parts.isEmpty) {
      return '?';
    }

    if (parts.length == 1) {
      return parts.first.substring(0, 1).toUpperCase();
    }

    return '${parts.first.substring(0, 1)}'
            '${parts.last.substring(0, 1)}'
        .toUpperCase();
  }

  TrustedContact copyWith({
    String? id,
    String? name,
    String? phoneNumber,
    String? relationship,
    bool? isPrimary,
    DateTime? createdAt,
    String? avatarPath,
    String? sourceContactId,
  }) {
    return TrustedContact(
      id: id ?? this.id,
      name: name ?? this.name,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      relationship: relationship ?? this.relationship,
      isPrimary: isPrimary ?? this.isPrimary,
      createdAt: createdAt ?? this.createdAt,
      avatarPath: avatarPath ?? this.avatarPath,
      sourceContactId: sourceContactId ?? this.sourceContactId,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phoneNumber': phoneNumber,
      'relationship': relationship,
      'isPrimary': isPrimary,
      'createdAt': createdAt.toIso8601String(),
      'avatarPath': avatarPath,
      'sourceContactId': sourceContactId,
    };
  }

  factory TrustedContact.fromJson(Map<String, dynamic> json) {
    return TrustedContact(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      phoneNumber: json['phoneNumber'] as String? ?? '',
      relationship: json['relationship'] as String? ?? 'Trusted Contact',
      isPrimary: json['isPrimary'] as bool? ?? false,
      createdAt:
          DateTime.tryParse(json['createdAt'] as String? ?? '') ??
          DateTime.now(),
      avatarPath: json['avatarPath'] as String?,
      sourceContactId: json['sourceContactId'] as String?,
    );
  }
}
