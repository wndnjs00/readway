import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:localization/localization.dart';
import 'package:readway/screen/detail.dart';
import 'package:readway/viewmodel/book_viewmodel.dart';

import '../model/Book.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final booksAsync = ref.watch(bookViewModelProvider);

    return MaterialApp(
      home: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.height,
                alignment: Alignment.center,
                child: booksAsync.when(
                  data: (books) => books.isNotEmpty
                      ? _buildBookList(context, books)
                      : Text(
                          "no-liked-books-add-a-bookshelf".i18n(),
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 18, color: Colors.grey),
                        ),
                  loading: () => const CircularProgressIndicator(),
                  error: (error, stack) => Text(
                    "error-loading-books".i18n(),
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18, color: Colors.red),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
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
