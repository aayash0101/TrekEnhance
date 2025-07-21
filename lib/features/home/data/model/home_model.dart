class TrekModel {
  final String id;
  final String name;
  final String location;
  final String? imageUrl;
  final String? smallDescription;
  final String? difficulty;

  TrekModel({
    required this.id,
    required this.name,
    required this.location,
    this.imageUrl,
    this.smallDescription,
    this.difficulty,
  });

  factory TrekModel.fromJson(Map<String, dynamic> json) {
    return TrekModel(
      id: json['_id'],
      name: json['name'],
      location: json['location'] ?? '',
      imageUrl: json['imageUrl'],
      smallDescription: json['smallDescription'],
      difficulty: json['difficulty'],
    );
  }
}
