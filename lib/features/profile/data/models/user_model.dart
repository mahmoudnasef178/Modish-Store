class UserModel {
  final String id;
  final String displayName;
  final String email;
  final String? phoneNumber;
  final List<String> roles;

  UserModel({
    required this.id,
    required this.displayName,
    required this.email,
    this.phoneNumber,
    required this.roles,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    // Priority: fullName > displayName > userName (if not email)
    final fullName = json['fullName']?.toString();
    final displayNameField = json['displayName']?.toString();
    final userName = json['userName']?.toString() ?? '';
    final email = json['email']?.toString() ?? '';

    // Pick the best available name — avoid using the email as the name.
    // We prioritize userName because it is the field updated by the UpdateUser API.
    String resolvedName;
    if (userName.isNotEmpty && !userName.contains('@')) {
      resolvedName = userName;
    } else if (displayNameField != null && displayNameField.isNotEmpty && !displayNameField.contains('@')) {
      resolvedName = displayNameField;
    } else if (fullName != null && fullName.isNotEmpty) {
      resolvedName = fullName;
    } else {
      // Fallback: extract name from email prefix
      resolvedName = email.contains('@') ? email.split('@')[0] : userName;
    }

    return UserModel(
      id: json['id'],
      displayName: resolvedName,
      email: email,
      phoneNumber: json['phoneNumber'],
      roles: List<String>.from(json['roles'] ?? []),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'displayName': displayName,
    'email': email,
    'phoneNumber': phoneNumber,
  };
}
