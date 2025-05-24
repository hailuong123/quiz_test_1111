import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:us_citizenship_friend/main.dart';
import 'package:us_citizenship_friend/models/questions_model.dart';
import 'package:us_citizenship_friend/widgets/flashcard_widgets/instruction_widget.dart';
import 'package:us_citizenship_friend/widgets/flashcard_widgets/end_cards_widget.dart';
import 'dart:math' as math;

// Enum để quản lý các giai đoạn của trang
enum PagePhase { instructions, questions, finished }

// Lớp để lưu thông tin swipe
class SwipedCardInfo {
  final int index;
  final bool swipedRight;

  SwipedCardInfo({required this.index, required this.swipedRight});
}

class PracticeTestFlashCardPage extends StatefulWidget {
  const PracticeTestFlashCardPage({super.key});
  @override
  State<PracticeTestFlashCardPage> createState() => _PracticeTestFlashCardPage();
}

class _PracticeTestFlashCardPage extends State<PracticeTestFlashCardPage> {
  final ValueNotifier<List<dynamic>> _questionListNotifier = ValueNotifier<List<dynamic>>([]);
  // Dùng List<bool> để theo dõi trạng thái "đã vuốt" logic, mặc dù thẻ vẫn trong tree
  late List<bool> _cardSwipedState; 
  final List<SwipedCardInfo> _swipedCardInfoStack = []; 

  late List<GlobalKey<FlashCardState>> _cardKeys;
  PagePhase _currentPhase = PagePhase.instructions;

  int _rememberCount = 0; // Số lượng câu hỏi đã nhớ
  int _notRememberCount = 0; // Số lượng câu hỏi chưa nhớ

  @override
  void initState() {
    super.initState();
    // Khởi tạo dữ liệu câu hỏi ở đây nếu cần
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final questionsModel = Provider.of<QuestionsModel>(context, listen: false);
      questionsModel.generateQuestion();
      final currentQuestions = List.from(questionsModel.questionsCurrent);
      _questionListNotifier.value = currentQuestions;

      if (currentQuestions.isEmpty) {
        _currentPhase = PagePhase.finished;
      } else {
        _cardKeys = List.generate(
          _questionListNotifier.value.length,
          (_) => GlobalKey<FlashCardState>(),
        );
        _cardSwipedState = List<bool>.filled(_questionListNotifier.value.length, false);
      }

      _rememberCount = 0;
      _notRememberCount = 0; 
      _swipedCardInfoStack.clear();

      if (mounted) setState(() {});      
    });
  }

  // Hàm hiển thị popup xác nhận
  Future<bool?> _showExitConfirmationDialog(BuildContext context) async {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Exit Quiz'),
        content: Text('Are you sure you want to exit the quiz?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false), // Hủy
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true), // Xác nhận
            child: Text('Confirm'),
          ),
        ],
      ),
    );
  }
  
  void _handleExit() {
    final navigator = Navigator.of(context);
    // Không cần _showExitConfirmationDialog ở đây nữa nếu nút X đã có dialog riêng
    // Hoặc bạn có thể dùng chung nếu muốn
    navigator.pushReplacement(
      MaterialPageRoute(builder: (context) => const MyApp()),
    );
  }
  
  void _restartSession() {
    if (_questionListNotifier.value.isEmpty) return;

    for (var key in _cardKeys) {
      key.currentState?.restore();
    }
    setState(() {
      _swipedCardInfoStack.clear();
      
      if (_questionListNotifier.value.isNotEmpty) {
        _cardSwipedState = List<bool>.filled(_questionListNotifier.value.length, false);
      } else {
        _cardSwipedState = [];
      }

      _rememberCount = 0; 
      _notRememberCount = 0; 
      _currentPhase = PagePhase.questions; // Quay lại màn hình hướng dẫn
    });
  }

  void _handleCardSwiped(dynamic swipedQuestionData, bool swipedRight) {
    final qIndex = _questionListNotifier.value.indexOf(swipedQuestionData);
    if (qIndex != -1 && mounted && qIndex < _cardSwipedState.length && !_cardSwipedState[qIndex]) {
      setState(() {
        _cardSwipedState[qIndex] = true;
        // THAY ĐỔI: Thêm SwipedCardInfo vào stack
        _swipedCardInfoStack.add(SwipedCardInfo(index: qIndex, swipedRight: swipedRight)); 

        // Cập nhật số lượng nhớ/không nhớ
        if (swipedRight) {
          _rememberCount++;
        } else {
          _notRememberCount++;
        }

        if (_swipedCardInfoStack.length == _questionListNotifier.value.length) {
          _currentPhase = PagePhase.finished;
        }
      });
    }
  }

  Widget _buildCardArea() {
    switch (_currentPhase) {
      case PagePhase.instructions:
        return InstructionWidget(onDismiss: () {
          setState(() {
            _currentPhase = PagePhase.questions;
            // Reset counts khi bắt đầu học (sau hướng dẫn)
            _rememberCount = 0;
            _notRememberCount = 0;
          });
        });
      case PagePhase.questions:
        return Builder(
          builder: (context) {
            return ValueListenableBuilder<List<dynamic>>(
              valueListenable: _questionListNotifier,
              builder: (context, questions, _) {
                if (questions.isEmpty) {
                  if (mounted && _currentPhase == PagePhase.questions) {
                    setState(() {
                      _currentPhase = PagePhase.finished;
                    });
                  }
                  return const Center(child: Text('No questions available'));
                }
          
                // Đảm bảo các list trạng thái được cập nhật nếu danh sách câu hỏi thay đổi
                if (_cardKeys.length != questions.length) {
                  _cardKeys = List.generate(questions.length, (_) => GlobalKey<FlashCardState>());
                  _cardSwipedState = List<bool>.filled(questions.length, false);
                  // Có thể cần reset _swipedCardIndicesStack hoặc xử lý cẩn thận hơn
                  _swipedCardInfoStack.clear();
                  _rememberCount = 0; // Reset counts nếu danh sách câu hỏi thay đổi
                  _notRememberCount = 0;
                }
          
                return Stack(
                  children: questions.asMap().entries.map((entry) {
                    final index = entry.key;
                    final question = entry.value;
          
                    return FlashCard(
                      key: _cardKeys[index],
                      questionData: question,
                      onActionFinished: _handleCardSwiped,
                    );
                  }).toList(),
                );
              }
            );
          }
        );
      case PagePhase.finished:
        return EndOfCardsWidget(
          onRestart: _restartSession,
          onExit: _handleExit, // Hoặc hiển thị nút X trên AppBar/Header
        );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Consumer<QuestionsModel>( 
      builder: (context, questionsModel, child) {
        return Scaffold(
          body: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container (
                  width: double.infinity,
                  padding: EdgeInsets.all(16), // Thêm padding cho nội dung
                  margin: EdgeInsets.fromLTRB(0, 0, 0, 8), 
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 2),
                        child: GestureDetector(
                          onTap: () async{
                            final navigator = Navigator.of(context);
                            final shouldExit = await _showExitConfirmationDialog(context);
                            if (shouldExit == true) { // đang thiếu mounted check
                              navigator.pushReplacement(
                                MaterialPageRoute(builder: (context) => MyApp()),
                              );
                            } 
                          },
                          child: Icon(Icons.close, color: Colors.grey, size: 30),
                        )
                      ),
                      SizedBox(width: 5),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Learning Progress',
                                  style: TextStyle(fontSize: 13, color: Colors.black),
                                ),
                                Row (
                                  children: [
                                    Icon(Icons.book, color: Colors.black, size: 13),
                                    SizedBox(width: 5),
                                    Text(
                                      '${(questionsModel.currentQuestionIndex + 1)}/${questionsModel.questionsCurrent.length} Questions',
                                      style: TextStyle(fontSize: 13, color: Colors.black),
                                    ),
                                  ],
                                )
                              ]
                            ),
                            SizedBox(height: 5),
                            Container(
                              height: 5,
                              decoration: BoxDecoration(
                                color: Colors.grey,
                                borderRadius: BorderRadius.circular(100),
                              ),
                              child: LayoutBuilder(
                                builder: (BuildContext context, BoxConstraints constraints) {
                                  final totalQuestions = questionsModel.questionsCurrent.length;
                                  final safeTotal = totalQuestions == 0 ? 1 : totalQuestions; // tránh chia 0
                                  final progress = (questionsModel.currentQuestionIndex + 1) / safeTotal;
                                  final progressWidth = constraints.maxWidth * progress;
                                  return Align(
                                    alignment: Alignment.centerLeft,
                                    child: Container(
                                      width: progressWidth,
                                      decoration: BoxDecoration(
                                        color: Colors.red,
                                        borderRadius: BorderRadius.circular(100),
                                      ),
                                    )
                                  );
                                }
                              )
                            )
                          ]
                        )
                      )
                    ]
                  )
                ),
                
                // KHU VỰC THẺ CHÍNH
                Expanded(
                  child: _buildCardArea(), // _buildCardArea giờ được gọi ở đây
                ),
                if(_currentPhase == PagePhase.questions)
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(16), // Thêm padding cho nội dung
                    margin: EdgeInsets.fromLTRB(0, 8, 0, 0), 
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [

                            // Số lượng "Khong Nhớ" (vuốt trái)
                            Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                border: Border.all(color: Color.fromRGBO(251, 133, 0, 1), width: 1),
                                color: Color.fromRGBO(251, 133, 0, .3),
                                borderRadius: BorderRadius.circular(100),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    '$_notRememberCount',
                                    style: TextStyle(fontSize: 20, color: Color.fromRGBO(251, 133, 0, 1), fontWeight: FontWeight.bold, fontFamily: 'Roboto'),
                                  ),
                                ]
                              )
                            ),
                            
                            if (_swipedCardInfoStack.isNotEmpty)
                              IconButton(
                                icon: Icon(Icons.settings_backup_restore, color: Colors.black, size: 30),
                                onPressed: (_swipedCardInfoStack.isEmpty) ? null : () {
                                  if (_swipedCardInfoStack.isNotEmpty) {
                                    final SwipedCardInfo lastSwipedInfo = _swipedCardInfoStack.removeLast();
                                    final int lastSwipedIndex = lastSwipedInfo.index;
                                    final bool wasSwipedRight = lastSwipedInfo.swipedRight;

                                    if (lastSwipedIndex < _cardKeys.length && _cardKeys[lastSwipedIndex].currentState != null) {
                                        _cardKeys[lastSwipedIndex].currentState?.restore();
                                        if (mounted && lastSwipedIndex < _cardSwipedState.length) {
                                          setState(() {
                                            _cardSwipedState[lastSwipedIndex] = false;
                                            // THAY ĐỔI: Giảm count tương ứng
                                            if (wasSwipedRight) {
                                              _rememberCount--;
                                            } else {
                                              _notRememberCount--;
                                            }
                                            // Đảm bảo count không âm
                                            if (_rememberCount < 0) _rememberCount = 0;
                                            if (_notRememberCount < 0) _notRememberCount = 0;

                                            if (_currentPhase == PagePhase.finished) {
                                              _currentPhase = PagePhase.questions;
                                            }
                                          });
                                        }
                                    }
                                    
                                  }
                                },
                              ),
                            
                            // Số lượng "Nhớ" (vuốt phải)
                            Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                border: Border.all(color: Color.fromRGBO(33, 150, 243, 1), width: 1),
                                color: Color.fromRGBO(33, 150, 243, .3),
                                borderRadius: BorderRadius.circular(100),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    '$_rememberCount',
                                    style: TextStyle(fontSize: 20, color: Color.fromRGBO(33, 150, 243, 1), fontWeight: FontWeight.bold, fontFamily: 'Roboto'),
                                  ),
                                ]
                              )
                            ),

                          ]
                        ),
                      ]
                    )
                  )

              ],
            ),
          )
        );
      }
    );
  }
}

enum FlashCardAction {
  remember,
  notRemember,
}

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

  // Animation cho lật thẻ
  late AnimationController _flipAnimationController;
  late Animation<double> _flipAnimation;
  bool _isShowingAnswer = false; // Để theo dõi trạng thái lật thẻ

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
        _borderColor = const Color.fromRGBO(76, 175, 80, 1).withOpacity(opacity); // Màu viền xanh khi vuốt phải
      } else {
        _borderColor = const Color.fromRGBO(244, 67, 54, 1).withOpacity(opacity); // Màu viền đỏ khi vuốt trái
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

