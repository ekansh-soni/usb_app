class UserModel {
  int? id;
  String name;
  String email;
  String password;
  String phone;
  String createdAt;

  UserModel({
    this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.phone,
    required this.createdAt,
  });

  // JSON to Object
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'],
      name: map['name'],
      email: map['email'],
      password: map['password'],
      phone: map['phone'],
      createdAt: map['created_at'] ?? DateTime.now().toString(),
    );
  }

  // Object to JSON
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'password': password,
      'phone': phone,
      'created_at': createdAt,
    };
  }
}