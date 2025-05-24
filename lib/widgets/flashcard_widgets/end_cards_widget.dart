import 'package:flutter/material.dart';

class EndOfCardsWidget extends StatelessWidget {
  final VoidCallback? onRestart; // Callback để bắt đầu lại (tùy chọn)
  final VoidCallback? onExit;   // Callback để thoát (tùy chọn)


  const EndOfCardsWidget({Key? key, this.onRestart, this.onExit}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        elevation: 4,
        margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 50),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                "Hoàn Thành!",
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              const Text(
                "Bạn đã xem hết tất cả các thẻ trong phiên học này.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, height: 1.5),
              ),
              const SizedBox(height: 28),
              if (onRestart != null)
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  onPressed: onRestart,
                  child: const Text('Học Lại'),
                ),
              if (onExit != null && onRestart != null) const SizedBox(height: 12),
              if (onExit != null)
                TextButton( // Sử dụng TextButton cho lựa chọn phụ
                  style: TextButton.styleFrom(
                     padding: const EdgeInsets.symmetric(vertical: 12),
                     textStyle: const TextStyle(fontSize: 16),
                  ),
                  onPressed: onExit,
                  child: const Text('Thoát'),
                ),
            ],
          ),
        ),
      ),
    );
  }
}