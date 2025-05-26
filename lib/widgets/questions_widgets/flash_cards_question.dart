import 'package:flutter/material.dart';
import 'dart:math' as math;

class FlashCard extends StatefulWidget {
  final dynamic questionData;
  final Function(dynamic swipedQuestionData, bool swipedRight) onActionFinished; // Callback khi thẻ đã swipe xong và animation hoàn tất

  const FlashCard({
    required Key key, // Sẽ là GlobalKey
    required this.questionData,
    required this.onActionFinished,
  }) : super(key: key);

  @override
  FlashCardState createState() => FlashCardState();
}

class FlashCardState extends State<FlashCard> with SingleTickerProviderStateMixin {
  Color _borderColor = Colors.white; // Màu viền mặc định
  Offset _cardOffset = Offset.zero; // Vị trí hiện tại của thẻ
  double _cardOpacity = 1.0; // Độ mờ hiện tại của thẻ
  double _cardRotation = 0.0; // Độ xoay hiện tại
  bool _isDragging = false; // Để phân biệt giữa kéo tay và animation tự động
  bool _isHiddenBase = false; // Để phân biệt giữa kéo tay và animation tự động
  bool _isShowingAnswer = false; // Để theo dõi trạng thái lật thẻ

  // Animation cho lật thẻ
  late AnimationController _flipAnimationController;
  late Animation<double> _flipAnimation;

  // Giá trị khi thẻ được coi là đã vuốt đi (để animation)
  static const double _offscreenMultiplier = 1.5;
  static const Duration _animationDuration = Duration(milliseconds: 300);
  static const Duration _flipDuration = Duration(milliseconds: 300);

  Size get _screenSize => MediaQuery.of(context).size;

  @override
  void initState() {
    super.initState();
    _flipAnimationController = AnimationController(
      vsync: this,
      duration: _flipDuration,
    );
    _flipAnimation = Tween<double>(begin: 0.0, end: 1).animate(
      CurvedAnimation(parent: _flipAnimationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _flipAnimationController.dispose();
    super.dispose();
  }

  void _flipCard() {
    if (_isDragging || _cardOpacity < 1.0) return; // Không cho phép lật khi đang kéo

    if (_flipAnimationController.isCompleted) {
      _flipAnimationController.reverse();
      setState(() {
        _isShowingAnswer = false;
      });
    } else {
      _flipAnimationController.forward();
      setState(() {
        _isShowingAnswer = true;
      });
    } 
  }

  // Được gọi từ parent để bắt đầu animation vuốt thẻ ra khỏi màn hình
  void swipeAway({required bool toRight}) {
    if (!mounted) return;

    // Nếu thẻ đang lật dở, hoàn thành hoặc hủy animation lật trước khi swipe
    if (_flipAnimationController.isAnimating) {
      _flipAnimationController.stop();
    }
    if (_flipAnimationController.value < .5) {
      _flipAnimationController.value = 0;
      _isShowingAnswer = false;
    } else {
      _flipAnimationController.value = 1;
      _isShowingAnswer = true;
    }

    setState(() {
      _isDragging = false;
      if (toRight) {
        _cardOffset = Offset(_screenSize.width * _offscreenMultiplier, _cardOffset.dy + _screenSize.width * 0.1);
        _cardRotation = math.pi / 12;
      } else {
        _cardOffset = Offset(-_screenSize.width * _offscreenMultiplier, _cardOffset.dy + _screenSize.width * 0.1);
        _cardRotation = -math.pi / 12;
      }
      _cardOpacity = 0.0; // Mờ dần đi
    });
    // Gọi callback sau khi animation hoàn tất
    Future.delayed(_animationDuration, () {
      if (mounted) {
        widget.onActionFinished(widget.questionData, toRight);
      }
    });
  }

  // Được gọi từ parent để bắt đầu animation đưa thẻ trở lại
  void restore() {
    if (!mounted) return;
    setState(() {
      _isDragging = false;
      _cardOffset = Offset.zero;
      _cardOpacity = 1.0;
      _cardRotation = 0.0;
      _borderColor = Colors.white;
      _isHiddenBase = false;
      _isShowingAnswer = false; // Reset trạng thái lật
    });
    // Nếu cần callback khi restore xong, có thể thêm Future.delayed tương tự ở đây

    // Reset Flip state
    _flipAnimationController.value = 0;
    _isShowingAnswer = false;
  }

  void _onPanStart(DragStartDetails details) {
    if (!mounted) return;
    // Chỉ cho phép kéo nếu thẻ đang hiển thị đầy đủ và không trong animation tự động
    if (_cardOpacity == 1.0 && _cardOffset == Offset.zero && !_flipAnimationController.isAnimating) {
       setState(() {
        _isDragging = true;
      });
    }
  }

  void _onPanUpdate(DragUpdateDetails details) {
    if (!_isDragging || !mounted) return;
    double maxOffset = _screenSize.width / 2; // hoặc giá trị bạn muốn
    double opacity = (_cardOffset.dx.abs() / maxOffset).clamp(0.2, 1.0); // min 0.2, max 1.0
    
    setState(() {
      _cardOffset += details.delta;
      // Tính toán độ xoay dựa trên vị trí kéo ngang
      _cardRotation = (_cardOffset.dx / _screenSize.width) * (math.pi / 15);

      // Cho màu vào border dựa trên vị trí kéo
      if (_cardOffset.dx > 0) {
        _borderColor = Color.fromRGBO(76, 175, 80, opacity); // Màu viền xanh khi vuốt phải
      } else {
        _borderColor = Color.fromRGBO(255, 171, 64, opacity); // Màu viền đỏ khi vuốt trái
      }
    });
  }

  void _onPanEnd(DragEndDetails details) {
    if (!_isDragging || !mounted) return;

    final double swipeThreshold = _screenSize.width / 3;
    bool swiped = _cardOffset.dx.abs() > swipeThreshold;

    if (swiped) {
      swipeAway(toRight: _cardOffset.dx > 0);
      setState(() {
        _isHiddenBase = true; // Đánh dấu là đã vuốt
      });
    } else {
      // Quay lại vị trí ban đầu nếu không vuốt đủ xa
      setState(() {
        _isDragging = false;
        _cardOffset = Offset.zero;
        _cardRotation = 0.0;
        _borderColor = Colors.white; // Trả về màu viền mặc định
        _isHiddenBase = false;
        // Opacity vẫn là 1.0
      });
    }
  }

  Widget _buildCardFace({required bool isFront}) {
    // Giả sử có 'answer' trong questionData
    final String textToShow = isFront
        ? (widget.questionData['question']?.toString() ?? 'Câu hỏi trống')
        : (widget.questionData['answer_custom']?.toString() ?? 'Không có câu trả lời');
    
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16), // Thêm padding cho nội dung
      margin: EdgeInsets.fromLTRB(16, 0, 16, 0), 
      constraints: BoxConstraints(
        minHeight: 400, // Chiều cao tối thiểu
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _borderColor, width: 5),
      ),
      child: Center(
        child: Text(
          textToShow,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20, 
            color: isFront ? Colors.black87 : Colors.black, 
            fontWeight: FontWeight.w500
          ),
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    // AnimatedContainer sẽ tạo hiệu ứng chuyển động mượt mà cho transform và opacity
    return Container (
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Lớp nền trắng, sẽ chỉ hiện ra nếu có kẽ hở nhỏ khi lật
          // Container này sẽ có cùng kích thước với các mặt thẻ
          if (!_isHiddenBase)
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(16), // Thêm padding cho nội dung
              margin: EdgeInsets.fromLTRB(16, 0, 16, 0), 
              constraints: BoxConstraints(
                minHeight: 400, // Chiều cao tối thiểu
              ),
              decoration: BoxDecoration(
                color: Colors.white, // Luôn là màu trắng để che đi stack phía sau
                borderRadius: BorderRadius.circular(15),
                // Không cần border hay shadow cho lớp nền này
              ),
            ),
          AnimatedContainer(
            duration: _isDragging ? Duration.zero : _animationDuration, // Không animate khi đang kéo tay
            curve: Curves.easeOut,
            transform: Matrix4.identity()
            ..translate(_cardOffset.dx, _cardOffset.dy)
            ..rotateZ(_cardRotation),
            child: AnimatedOpacity(
              duration: _isDragging ? Duration.zero : _animationDuration,
              opacity: _cardOpacity,
              child: GestureDetector(
                onPanStart: _onPanStart,
                onPanUpdate: _onPanUpdate,
                onPanEnd: _onPanEnd,
                onTap: _flipCard,
                // Phần nội dung của thẻ
                child: AnimatedBuilder(
                  animation: _flipAnimation,
                  builder: (context, child) {
                    final angle = _flipAnimation.value * math.pi; // 0 to pi
                    final isFrontFace = angle < (math.pi / 2);
                    return Transform(
                      transform: Matrix4.identity()
                        ..setEntry(3, 2, 0.001) // Perspective
                        ..rotateY(angle), // Rotate Y cho hiệu ứng lật
                      alignment: Alignment.center,
                      child: isFrontFace
                          ? _buildCardFace(isFront: true)
                          : Transform( // Xoay mặt sau lại để không bị ngược chữ
                              alignment: Alignment.center,
                              transform: Matrix4.identity()..rotateY(math.pi),
                              child: _buildCardFace(isFront: false),
                            ),
                    );
                  },
                ),
              ),
            ),
          )
        ]
      ),
    );
  }
}
