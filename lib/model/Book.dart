import 'package:localization/localization.dart';

class Book {
  String name;
  String imageUrl;
  String bookKey;
  int pageCount;
  String publisher;
  String description;
  String publishedDate;
  int? myReadCount;
  String? myReview;

  Book({
    required this.name,
    required this.imageUrl,
    required this.bookKey,
    required this.pageCount,
    required this.publisher,
    required this.description,
    required this.publishedDate,
    this.myReadCount,
    this.myReview,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    final volumeInfo = json['volumeInfo'];
    final bookKey = json['id'];
    final name = volumeInfo['title'] ?? 'title-not-available'.i18n();
    final imageLinks = volumeInfo['imageLinks'] ?? {};
    final pageCount = volumeInfo['pageCount'] ?? 0;
    final imageUrl = imageLinks['thumbnail'] ?? '';
    final publisher = volumeInfo['publisher'] ?? 'publisher-not-available'.i18n();
    final description = volumeInfo['description'] ?? 'description-not-available'.i18n();
    final publishedDate = volumeInfo['publishedDate'] ?? 'published-date-not-available'.i18n();

    return Book(
      name: name,
      imageUrl: imageUrl,
      bookKey: bookKey,
      pageCount: pageCount,
      publisher: publisher,
      description: description,
      publishedDate: publishedDate,
      myReadCount: 0,
      myReview: null,
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
    var myReadCount = bookValue["myReadCount"];
    var myReview = bookValue["myReview"] as String?;

    return Book(
      name: name,
      imageUrl: imageUrl,
      bookKey: bookKey,
      pageCount: pageCount,
      publisher: publisher,
      description: description,
      publishedDate: publishedDate,
      myReadCount: myReadCount,
      myReview: myReview,
    );
  }
}
