class Contact {
  int? id;
  String name;
  String pseudoName;
  String phoneNumber;

  Contact(
      {this.id,
      required this.name,
      required this.pseudoName,
      required this.phoneNumber});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'pseudoName': pseudoName,
      'phoneNumber': phoneNumber,
    };
  }

  static Contact fromMap(Map<String, dynamic> map) {
    return Contact(
      id: map['id'],
      name: map['name'],
      pseudoName: map['pseudoName'],
      phoneNumber: map['phoneNumber'],
    );
  }
}