import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:readway/screen/detail.dart';
import 'package:readway/service/databaseService.dart';

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
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.height,
                alignment: Alignment.center,
                child: books.isNotEmpty
                    ? _buildBookList(context, books)
                    : const Text(
                        "No liked books\nAdd a bookshelf",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void updateUiWithBooks(List<Book> newBooks) {
    if (mounted) {
      setState(() {
        books = newBooks;
      });
    }
  }

  void prepareBookList() {
    DatabaseService().readDB(updateUiWithBooks);
  }
}

Widget? _buildBookList(BuildContext context, List<Book> books) {
  return CarouselSlider.builder(
    itemCount: books.length,
    itemBuilder: (context, index, realIndex) {
      return buildBookCard(context, books[index]);
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

Widget buildBookCard(BuildContext context, Book book) {
  return GestureDetector(
    onTap: () {
      Navigator.push(context, MaterialPageRoute(builder: (_) => DetailScreen(book: book),
      )
      );
    },
   child: Container(
    margin: EdgeInsets.all(1.0),
    child: ClipRRect(
      child: Stack(
        children: [
          Image.network(book.imageUrl, fit: BoxFit.cover, width: 200.0),
        ],
      ),
    ),
   ),
  );
}
