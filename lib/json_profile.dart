// json_profile.dart
class Profile {
  int? id;
  String name;
  String email;
  String phone;
  String address;
  String? bloodGroup;

  Profile({this.id, required this.name, required this.email, required this.phone, required this.address, this.bloodGroup});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'address': address,
      'bloodGroup': bloodGroup,
    };
  }

  factory Profile.fromMap(Map<String, dynamic> map) {
    return Profile(
      id: map['id'],
      name: map['name'],
      email: map['email'],
      phone: map['phone'],
      address: map['address'],
      bloodGroup: map['bloodGroup'],
    );
  }
}
