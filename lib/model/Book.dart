import 'package:randomstring_dart/randomstring_dart.dart';

class Book {
  String name;
  String imageUrl;
  String bookKey;
  int pageCount;
  String publisher;
  String description;
  String publishedDate;

  Book({
    required this.name,
    required this.imageUrl,
    required this.bookKey,
    required this.pageCount,
    required this.publisher,
    required this.description,
    required this.publishedDate,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    final volumeInfo = json['volumeInfo'];
    final name = volumeInfo['title'] ?? 'Title not available';
    final imageLinks = volumeInfo['imageLinks'] ?? {};
    final pageCount = volumeInfo['pageCount'] ?? 0;
    final imageUrl = imageLinks['thumbnail'] ?? '';
    final publisher = volumeInfo['publisher'] ?? 'Publisher not available';
    final description = volumeInfo['description'] ?? 'Description not available';
    final publishedDate = volumeInfo['publishedDate'] ?? 'Published date not available';

    final rs = RandomString();
    String bookKey = rs.getRandomString();

    return Book(
      name: name,
      imageUrl: imageUrl,
      bookKey: bookKey,
      pageCount: pageCount,
      publisher: publisher,
      description: description,
      publishedDate: publishedDate,
    );
  }

  factory Book.fromMap(Map<dynamic, dynamic> bookValue) {
    var name = bookValue["name"] ?? '';
    var imageUrl = bookValue["imageUrl"] ?? '';
    var bookKey = bookValue["bookKey"] ?? '';
    var pageCount = bookValue["pageCount"] ?? 0;
    var publisher = bookValue["publisher"] ?? '';
    var description = bookValue["description"] ?? '';
    var publishedDate = bookValue["publishedDate"] ?? '';

    return Book(
      name: name,
      imageUrl: imageUrl,
      bookKey: bookKey,
      pageCount: pageCount,
      publisher: publisher,
      description: description,
      publishedDate: publishedDate,
    );
  }
}
