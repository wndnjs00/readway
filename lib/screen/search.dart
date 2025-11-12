import 'package:flutter/material.dart';
import 'package:readway/service/bookApi.dart';

import '../model/Book.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List<Book> books = [];
  TextEditingController _searchController = TextEditingController();
  bool _isLoading = false;
  bool _hasSearched = false; // 검색여부 확인

  Future<void> searchBook(String keyword) async {
    if (keyword.trim().isEmpty) return;

    setState(() {
      _isLoading = true;
      _hasSearched = true;
    });

    var searchResult = await BookApi.getBookInformation(keyword);

    setState(() {
      books = searchResult;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget content;

    if (_isLoading) {
      // 로딩중일때
      content = const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation(Colors.black),
        ),
      );
    } else if (!_hasSearched) {
      // 검색전 (아무것도 안한상태)
      content = const Center(
        child: Text(
          "Search for something",
          style: TextStyle(fontSize: 18, color: Colors.grey),
        ),
      );
    } else if (books.isEmpty) {
      // 검색결과 없음
      content = const Center(
        child: Text(
          "No results found",
          style: TextStyle(fontSize: 18, color: Colors.grey),
        ),
      );
    } else {
      // 검색결과 있음
      content = GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.7,
          crossAxisSpacing: 16.0,
          mainAxisSpacing: 16.0,
        ),
        itemCount: books.length,
        itemBuilder: (context, index) {
          return InkWell(
            // TODO: GridVeiw 클릭했을때
            onTap: () {},
            child: Container(
              decoration: books[index].imageUrl.isNotEmpty
                  ? BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(books[index].imageUrl),
                        fit: BoxFit.cover,
                      ),
                    )
                  : null,
              child: books[index].imageUrl.isNotEmpty
                  ? null
                  : Center(
                      child: Text(
                        books[index].name,
                        textAlign: TextAlign.center,
                      ),
                    ),
            ),
          );
        },
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(backgroundColor: Colors.white, elevation: 0),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: const BoxDecoration(
                        border: Border(bottom: BorderSide(color: Colors.grey)),
                      ),
                      child: TextField(
                        style: TextStyle(color: Colors.black),
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: "Search for a book",
                          hintStyle: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(fontSize: 20, color: Colors.grey),
                          border: InputBorder.none,
                        ),
                        onSubmitted: (value) => searchBook(value),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        _searchController.clear();
                        books = [];
                        _hasSearched = false;
                      });
                    },
                    icon: Icon(Icons.clear),
                  ),
                ],
              ),
            ),
            Expanded(child: content),
          ],
        ),
      ),
    );
  }
}
