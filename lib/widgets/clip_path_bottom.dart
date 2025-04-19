import 'package:flutter/material.dart';

class ClipPathBottom extends StatelessWidget {
  const ClipPathBottom({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: RoundedBottomClipper(),
      child: Container(
        height: 50, // Chiều cao cố định để giữ độ bo tròn
        decoration: BoxDecoration(
          color: Color(0xFF222f63)
        ),
      ),
    );
  }
}

// Custom Clipper để tạo hình vòng tròn ở đáy
class RoundedBottomClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final Path path = Path();
    path.lineTo(0, size.height - 50); // Điểm bắt đầu ở góc trái dưới
    path.quadraticBezierTo(size.width / 2, size.height, size.width, size.height - 50); // Tạo đường cong hình bán nguyệt
    path.lineTo(size.width, 0); // Đóng path về góc phải trên
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
