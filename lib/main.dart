import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

import 'model/Book.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<Book> books = [];

  @override
  void initState() {
    super.initState();
    prepareBookList();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: MediaQuery
                    .of(context)
                    .size
                    .height,
                alignment: Alignment.center,
                child: _buildBookList(context, books),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 사이즈 5개짜리의 책 랜덤리스트를 만든다
  void prepareBookList() {
    for (int i = 0; i < 5; i++) {
      var book = Book();
      book.name = "Book $i";
      book.imageUrl = "https://picsum.photos/200/350?random=$i";
      books.add(book);
    }
  }

  Widget? _buildBookList(BuildContext context, List<Book> books) {
    return CarouselSlider.builder(
      itemCount: books.length,
      itemBuilder: (context, index, realIndex) {
        return buildBookCard(books[index]);
      },
      options: CarouselOptions(
        enlargeCenterPage: true,
        enableInfiniteScroll: false,
        initialPage: 2,
        viewportFraction: 0.40,
        enlargeStrategy: CenterPageEnlargeStrategy.scale,
        autoPlay: false,
      ),
    );
  }

  buildBookCard(Book book) {
    return Container(
      margin: EdgeInsets.all(1.0),
      child: ClipRRect(
        child: Stack(
          children: [
            Image.network(book.imageUrl, fit: BoxFit.cover, width: 200.0),
          ],
        ),
      ),
    );
  }
}