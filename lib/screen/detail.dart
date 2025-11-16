import 'package:flutter/material.dart';
import '../model/Book.dart';
import '../service/databaseService.dart';

class DetailScreen extends StatefulWidget {
  final Book book;

  const DetailScreen({super.key, required this.book});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen>{
  final DatabaseService _databaseService = DatabaseService();
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
    final userData = await _databaseService.getUserData(widget.book.bookKey);

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
      ).showSnackBar(const SnackBar(content: Text("Please enter a valid page number.")));
      return;
    }

    _databaseService.updateMyReadCount(widget.book.bookKey, inputMyReadCount);

    setState(() {
      myReadCount = inputMyReadCount;
    });
  }

  void saveReview() {
    String inputMyReview = reviewController.text.trim();
    if (inputMyReview.isEmpty) return;

    _databaseService.updateMyReview(widget.book.bookKey, inputMyReview);

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
          "Detail page",
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          // 추가
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
                          "Published Date: ${widget.book.publishedDate}",
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

              const Text(
                "Reading Progress",
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
                  Text(" / ${widget.book.pageCount} page"),

                  const Spacer(),

                  ElevatedButton(
                    onPressed: saveProgress,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.brown,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text("Save"),
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
                "${(progressPercent * 100).toStringAsFixed(1)}% Completed",
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),

              const SizedBox(height: 40),

              const Text(
                "my review",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.brown,
                ),
              ),
              const SizedBox(height: 12),

              // 리뷰가 DB에 없을 때 → 입력 UI
              if (myReview == null || myReview!.trim().isEmpty) ...[
                TextField(
                  controller: reviewController,
                  maxLines: 5,
                  decoration: InputDecoration(
                    hintText: "Share your thoughts about this book...",
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
                  child: const Text("Submit Review"),
                ),
              ]
              // 리뷰가 있을 때 → 완료 UI
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
                      const Text(
                        "● Completed",
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
                    // 수정모드로 전환
                    reviewController.text = myReview!;
                    setState(() => myReview = null);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[700],
                    foregroundColor: Colors.white,
                    minimumSize: const Size.fromHeight(48),
                  ),
                  child: const Text("Edit"),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}