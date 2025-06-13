class Workspace {
  Workspace({
    required this.id,
    required this.name,
    this.description,
    this.pictureUrl,
  });

  final String id;
  final String name;
  final String? description;
  final String? pictureUrl;
}
