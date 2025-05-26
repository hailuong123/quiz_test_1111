import 'package:flutter/material.dart';

class InstructionWidget extends StatefulWidget {
  // THAY ĐỔI: Callback giờ đây nhận số lượng câu hỏi (int?)
  // int? có nghĩa là có thể null nếu người dùng chọn "Tất cả" hoặc bạn muốn xử lý mặc định
  final Function(int? questionCount) onDismiss;
  final VoidCallback? onExit;   // Callback để thoát (tùy chọn)

  const InstructionWidget({Key? key, required this.onDismiss, this.onExit}) : super(key: key);

  @override
  State<InstructionWidget> createState() => _InstructionWidgetState();
}

class _InstructionWidgetState extends State<InstructionWidget> {
  // Các lựa chọn số lượng câu hỏi
  final List<Map<String, dynamic>> _questionCountOptions = [
    {'value': 10, 'label': '10 Câu hỏi'},
    {'value': 25, 'label': '25 Câu hỏi'},
    {'value': 50, 'label': '50 Câu hỏi'},
    {'value': null, 'label': 'Tất cả câu hỏi'}, // null cho "Tất cả"
  ];
  
  // Giá trị được chọn trong dropdown, mặc định là "Tất cả"
  int? _selectedQuestionCount; // Mặc định là null (Tất cả)

  @override
  void initState() {
    super.initState();
    // Đặt giá trị mặc định cho dropdown là lựa chọn đầu tiên hoặc "Tất cả"
    _selectedQuestionCount = _questionCountOptions.firstWhere((opt) => opt['value'] == null, orElse: () => _questionCountOptions.first)['value'];
  }


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Chào Mừng Bạn!',
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.primaryColor,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Sẵn sàng để kiểm tra kiến thức?',
                style: theme.textTheme.titleMedium?.copyWith(color: Colors.grey[700]),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              
              // Dropdown chọn số lượng câu hỏi
              Text(
                'Chọn số lượng câu hỏi:',
                style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<int?>(
                value: _selectedQuestionCount,
                items: _questionCountOptions.map((option) {
                  return DropdownMenuItem<int?>(
                    value: option['value'],
                    child: Text(option['label']),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    _selectedQuestionCount = newValue;
                  });
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                ),
                isExpanded: true,
              ),
              const SizedBox(height: 24),

              // Hướng dẫn sử dụng
              Text(
                'Cách Học:',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold, 
                  color: theme.primaryColorDark
                ),
                textAlign: TextAlign.left,
              ),
              const SizedBox(height: 12),
              _buildInstructionItem(
                context,
                icon: Icons.touch_app,
                text: 'NHẤN vào thẻ để xem đáp án.',
              ),
              const SizedBox(height: 10),
              _buildInstructionItem(
                context,
                icon: Icons.swipe_left,
                text: 'VUỐT SANG TRÁI nếu bạn CHƯA NHỚ câu trả lời.',
              ),
              const SizedBox(height: 10),
              _buildInstructionItem(
                context,
                icon: Icons.swipe_right,
                text: 'VUỐT SANG PHẢI nếu bạn ĐÃ NHỚ câu trả lời.',
              ),
              const SizedBox(height: 32),

              //` Nút bắt đầu
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.primaryColor,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                onPressed: () {
                  widget.onDismiss(_selectedQuestionCount);
                },
                child: const Text('Bắt Đầu Học Ngay!', style: TextStyle(color: Colors.white)),
              ),

              if (widget.onExit != null)
                  TextButton( // Sử dụng TextButton cho lựa chọn phụ
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      textStyle: const TextStyle(fontSize: 16),
                    ),
                    onPressed: widget.onExit,
                    child: const Text('Thoát'),
                  ),
              ],
            ),
          ),
    );
  }

  Widget _buildInstructionItem(BuildContext context, {required IconData icon, required String text}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 22, color: Theme.of(context).primaryColor),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(height: 1.4),
          ),
        ),
      ],
    );
  }
}
