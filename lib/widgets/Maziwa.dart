class Maziwa {
  String id;
  String name;
  String lita;

  Maziwa({required this.id, required this.name, required this.lita});

  factory Maziwa.fromJson(Map<String, dynamic> json) {
    return Maziwa(
      id: json['id'].toString(),
      name: json['name'].toString(),
      lita: json['lita'].toString(),
    );
  }
}