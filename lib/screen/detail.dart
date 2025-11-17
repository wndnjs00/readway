import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/Book.dart';
import '../viewmodel/book_viewmodel.dart';
import 'package:localization/localization.dart';

class DetailScreen extends ConsumerStatefulWidget {
  final Book book;

  const DetailScreen({super.key, required this.book});

  @override
  ConsumerState<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends ConsumerState<DetailScreen> {
  final TextEditingController progressController = TextEditingController();
  final TextEditingController reviewController = TextEditingController();

  int? myReadCount; // 내가 읽은 페이지
  String? myReview; // 내가 작성한 리뷰

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() async {
    final repository = ref.read(bookRepositoryProvider);
    final userData = await repository.getUserData(widget.book.bookKey);

    if (userData != null) {
      setState(() {
        myReadCount = userData["myReadCount"] as int?;
        myReview = userData["myReview"] as String?;

        if (myReadCount != null) {
          progressController.text = myReadCount.toString();
        }
        if (myReview != null && myReview!.isNotEmpty) {
          reviewController.text = myReview!;
        }
      });
    } else {
      // userData가 없으면 widget.book의 값 사용
      setState(() {
        myReadCount = widget.book.myReadCount;
        
        // 빈 문자열이면 null로 처리
        final reviewValue = widget.book.myReview;
        myReview = (reviewValue != null && reviewValue.trim().isNotEmpty)
            ? reviewValue 
            : null;
        
        if (myReadCount != null) {
          progressController.text = myReadCount.toString();
        }
        if (myReview != null && myReview!.isNotEmpty) {
          reviewController.text = myReview!;
        }
      });
    }
  }

  void saveProgress() {
    int? inputMyReadCount = int.tryParse(progressController.text);

    if (inputMyReadCount == null || inputMyReadCount < 0 || inputMyReadCount > widget.book.pageCount) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('please-enter-a-valid-page-number'.i18n())));
      return;
    }

    final repository = ref.read(bookRepositoryProvider);
    repository.updateMyReadCount(widget.book.bookKey, inputMyReadCount);

    setState(() {
      myReadCount = inputMyReadCount;
    });
  }

  void saveReview() {
    String inputMyReview = reviewController.text.trim();
    if (inputMyReview.isEmpty) return;

    final repository = ref.read(bookRepositoryProvider);
    repository.updateMyReview(widget.book.bookKey, inputMyReview);

    setState(() {
      myReview = inputMyReview;
    });
  }

  @override
  Widget build(BuildContext context) {
    double progressPercent = (myReadCount ?? 0) / widget.book.pageCount;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'detail-page'.i18n(),
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: SizedBox(
                      width: 110,
                      height: 150,
                      child: widget.book.imageUrl.isNotEmpty
                          ? Image.network(
                              widget.book.imageUrl,
                              fit: BoxFit.cover,
                            )
                          : Container(
                              color: Colors.grey[300],
                              child: Center(
                                child: Text(
                                  widget.book.name,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.book.name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(widget.book.publisher),
                        Text(
                          '${"published-date".i18n()} ${widget.book.publishedDate}',
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              SizedBox(
                height: 160,
                child: Scrollbar(
                  child: SingleChildScrollView(
                    child: Text(
                      widget.book.description,
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 30),

              Text(
                "reading-progress".i18n(),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.brown,
                ),
              ),
              const SizedBox(height: 10),

              Row(
                children: [
                  SizedBox(
                    width: 70,
                    height: 45,
                    child: TextField(
                      controller: progressController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(horizontal: 5),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(" / ${widget.book.pageCount} page".i18n()),

                  const Spacer(),

                  ElevatedButton(
                    onPressed: saveProgress,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.brown,
                      foregroundColor: Colors.white,
                    ),
                    child: Text("save".i18n()),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: SizedBox(
                  height: 16,
                  child: LinearProgressIndicator(
                    value: progressPercent,
                    backgroundColor: Colors.grey[300],
                    color: Colors.brown,
                  ),
                ),
              ),

              const SizedBox(height: 5),

              Text(
                "${(progressPercent * 100).toStringAsFixed(1)}% ${"completed".i18n()}",
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),

              const SizedBox(height: 40),

              Text(
                "my-review".i18n(),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.brown,
                ),
              ),
              const SizedBox(height: 12),

              if (myReview == null || myReview!.trim().isEmpty) ...[
                TextField(
                  controller: reviewController,
                  maxLines: 5,
                  decoration: InputDecoration(
                    hintText: "share-your-thoughts-about-this-book".i18n(),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                ElevatedButton(
                  onPressed: saveReview,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.brown,
                    foregroundColor: Colors.white,
                    minimumSize: const Size.fromHeight(48),
                  ),
                  child: Text("submit-review".i18n()),
                ),
              ]
              else ...[
                Container(
                  padding: const EdgeInsets.all(16),
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: Colors.brown[50],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "complete".i18n(),
                        style: TextStyle(color: Colors.brown, fontSize: 12),
                      ),
                      const SizedBox(height: 10),
                      Text(myReview ?? '', style: const TextStyle(fontSize: 14)),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    reviewController.text = myReview!;
                    setState(() => myReview = null);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[700],
                    foregroundColor: Colors.white,
                    minimumSize: const Size.fromHeight(48),
                  ),
                  child: Text("edit".i18n()),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}