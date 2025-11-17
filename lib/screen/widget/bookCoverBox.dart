import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:readway/model/Book.dart';
import 'package:readway/viewmodel/book_viewmodel.dart';

class BookCoverBox extends ConsumerStatefulWidget {
  final String imageUrl;
  final String name;
  final String bookKey;
  final int pageCount;
  final String publisher;
  final String description;
  final String publishedDate;

  const BookCoverBox({
    required this.imageUrl,
    required this.name,
    required this.bookKey,
    required this.pageCount,
    required this.publisher,
    required this.description,
    required this.publishedDate,
  });

  @override
  ConsumerState<BookCoverBox> createState() => _BookCoverBoxState();
}

class _BookCoverBoxState extends ConsumerState<BookCoverBox> {
  bool isHeartTapped = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: widget.imageUrl.isNotEmpty
              ? BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(widget.imageUrl),
                    fit: BoxFit.cover,
                  ),
                )
          : BoxDecoration(
            color: Colors.grey[300]
          ),
          child: widget.imageUrl.isNotEmpty
              ? null
              : Center(child: Text(widget.name, textAlign: TextAlign.center)),
        ),
        //하트모양 아이콘
        Positioned(
          top: 10,
          right: 10,
          child: InkWell(
            // 하트이미지 클릭했을때
            onTap: () {
              setState(() {
                isHeartTapped = !isHeartTapped;

                final repository = ref.read(bookRepositoryProvider);

                if (isHeartTapped) {
                  // insert data
                  repository.writeBookShelf(
                    Book(
                      name: widget.name,
                      imageUrl: widget.imageUrl,
                      bookKey: widget.bookKey,
                      pageCount: widget.pageCount,
                      publisher: widget.publisher,
                      description: widget.description,
                      publishedDate: widget.publishedDate,
                    ),
                  );
                } else {
                  // delete data
                  repository.deleteBookShelf(
                    Book(
                      name: widget.name,
                      imageUrl: widget.imageUrl,
                      bookKey: widget.bookKey,
                      pageCount: widget.pageCount,
                      publisher: widget.publisher,
                      description: widget.description,
                      publishedDate: widget.publishedDate,
                    ),
                  );
                }
              });
            },

            child: Icon(
              isHeartTapped ? Icons.favorite : Icons.favorite_border,
              color: isHeartTapped ? Colors.red : Colors.grey,
              size: 20,
            ),
          ),
        ),
      ],
    );
  }
}
