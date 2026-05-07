// Institución educativa; devuelta por /Institutions y mostrada en SelectInstitutionScreen
class Institution {
  final String id;
  final String name;
  final String address;
  final String phone;
  final String contactEmail;
  final int type;          // Tipo de centro (p.ej. 1=universidad, 2=FP)
  final String? logoUrl;   // Puede ser null si el centro no tiene logo configurado
  final String timezone;
  final bool isActive;

  Institution({
    required this.id,
    required this.name,
    required this.address,
    required this.phone,
    required this.contactEmail,
    required this.type,
    this.logoUrl,
    required this.timezone,
    required this.isActive,
  });

  factory Institution.fromJson(Map<String, dynamic> json) {
    return Institution(
      id: json['id'] as String,
      name: json['name'] as String,
      address: json['address'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      contactEmail: json['contactEmail'] as String? ?? '',
      type: json['type'] as int? ?? 0,
      logoUrl: json['logoUrl'] as String?,
      timezone: json['timezone'] as String? ?? '',
      isActive: json['isActive'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'address': address,
      'phone': phone,
      'contactEmail': contactEmail,
      'type': type,
      'logoUrl': logoUrl,
      'timezone': timezone,
      'isActive': isActive,
    };
  }
}