import 'package:flutter/material.dart';

class InstructionWidget extends StatelessWidget {
  final VoidCallback onDismiss;

  const InstructionWidget({Key? key, required this.onDismiss}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        elevation: 4,
        margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 50), // Thêm vertical margin
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch, // Cho nút bấm rộng ra
            children: [
              Text(
                'Cách Học Flashcard',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              const Text(
                'Vuốt thẻ sang PHẢI nếu bạn đã nhớ câu trả lời.\n\nVuốt thẻ sang TRÁI nếu bạn chưa nhớ.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, height: 1.5),
              ),
              const SizedBox(height: 28),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                onPressed: onDismiss,
                child: const Text('Đã Hiểu! Bắt Đầu Học'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}