class Book {
  String name;
  String imageUrl;

  Book({required this.name, required this.imageUrl});

  factory Book.fromJson(Map<String, dynamic> json) {
    final volumeInfo = json['volumeInfo'];
    final name = volumeInfo['title'] ?? '';
    final imageLinks = volumeInfo['imageLinks'] ?? '';
    final imageUrl = imageLinks['thumbnail'] ?? '';

    return Book(name: name, imageUrl: imageUrl);
  }
}