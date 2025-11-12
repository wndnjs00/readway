import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import '../model/Book.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
      var name = "Book $i";
      var imageUrl = "https://picsum.photos/200/350?random=$i";
      var book = Book(name: name, imageUrl: imageUrl);

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