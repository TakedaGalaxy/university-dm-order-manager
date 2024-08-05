class User {
  final int id;
  final String name;
  final int companyId;
  final String password;
  final String profileTypeName;

  User(this.id, this.name,this.password, this.companyId, this.profileTypeName);

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      json['id'],
      json['name'],
      json['password'],
      json['companyId'],
      json['profileTypeName'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'companyId': companyId,
    'password': password,
    'profileTypeName': profileTypeName,
  };
}