class AboutAppModel {
  final String title;
  final String description;
  AboutAppModel({
    required this.title,
    required this.description,
  });

  factory AboutAppModel.fromJson(Map<String, dynamic> map) {
    return AboutAppModel(
      title: map['title'],
      description: map['description'],
    );
  }
}
