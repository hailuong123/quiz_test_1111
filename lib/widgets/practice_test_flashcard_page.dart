import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:us_citizenship_friend/main.dart';
import 'package:us_citizenship_friend/models/questions_model.dart';
import 'package:us_citizenship_friend/widgets/questions_widgets/instruction_widget.dart';
import 'package:us_citizenship_friend/widgets/questions_widgets/end_cards_widget.dart';
import 'package:us_citizenship_friend/widgets/questions_widgets/progress_bar_widget.dart';
import 'package:us_citizenship_friend/widgets/questions_widgets/flash_cards_question.dart';
import 'dart:async';


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

  // State cho hiệu ứng "+1"
  double _plusOneOpacityRemembered = 0.0;
  double _plusOneOpacityNotRemembered = 0.0;
  Timer? _plusOneTimerRemembered;
  Timer? _plusOneTimerNotRemembered;

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

  @override
  void dispose() {
    _plusOneTimerRemembered?.cancel();
    _plusOneTimerNotRemembered?.cancel();
    super.dispose();
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

      _plusOneOpacityRemembered = 0.0; // Reset opacity
      _plusOneOpacityNotRemembered = 0.0;
    });
  }

  void _triggerPlusOneAnimation(bool forRemembered) {
    if (forRemembered) {
      _plusOneTimerRemembered?.cancel(); // Hủy timer cũ nếu có
      if (mounted) {
        setState(() {
          _plusOneOpacityRemembered = 1.0;
        });
      }
      _plusOneTimerRemembered = Timer(const Duration(milliseconds: 200), () { // Thời gian hiển thị "+1"
        if (mounted) {
          setState(() {
            _plusOneOpacityRemembered = 0.0; // Bắt đầu fade out
          });
        }
      });
    } else {
      _plusOneTimerNotRemembered?.cancel();
      if (mounted) {
        setState(() {
          _plusOneOpacityNotRemembered = 1.0;
        });
      }
      _plusOneTimerNotRemembered = Timer(const Duration(milliseconds: 200), () {
        if (mounted) {
          setState(() {
            _plusOneOpacityNotRemembered = 0.0;
          });
        }
      });
    }
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
          _triggerPlusOneAnimation(true);
        } else {
          _notRememberCount++;
          _triggerPlusOneAnimation(false);
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
        return InstructionWidget(onDismiss: (testQuestionsQuantity) {
          setState(() {
            _currentPhase = PagePhase.questions;
            // Reset counts khi bắt đầu học (sau hướng dẫn)
            _rememberCount = 0;
            _notRememberCount = 0;
          });
        }, onExit: _handleExit);
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

                  _plusOneOpacityRemembered = 0.0;
                  _plusOneOpacityNotRemembered = 0.0;
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
                  }).toList().reversed.toList(), // Đảo ngược để thẻ mới nhất ở trên cùng
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

  Widget _buildCounterWidget({
    required int count,
    required String label,
    required Color borderColor,
    required Color backgroundColor,
    required Color textColor,
    required double plusOneOpacity,
    required Color plusOneBackgroundColor,
  }) {
    return Stack(
      alignment: Alignment.topCenter, // Để "+1" hiện phía trên một chút
      clipBehavior: Clip.none, // Cho phép "+1" tràn ra ngoài bounds của Column
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                border: Border.all(color: borderColor, width: 1.5),
                color: backgroundColor,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  '$count',
                  style: TextStyle(fontSize: 18, color: textColor, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 4),
            Text(label, style: const TextStyle(fontSize: 12, color: Colors.black54))
          ],
        ),
        // Animated "+1" Indicator
        Positioned( // Định vị "+1"
          top: -15, // Điều chỉnh vị trí theo ý muốn
          child: AnimatedOpacity(
            opacity: plusOneOpacity,
            duration: const Duration(milliseconds: 210), // Duration cho fade in/out
            child: IgnorePointer(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: plusOneBackgroundColor, // Màu nền cho "+1"
                  borderRadius: BorderRadius.circular(100), // Bo tròn như bạn muốn
                  // boxShadow: [ // Optional shadow for +1
                  //   BoxShadow(
                  //     color: Colors.black.withOpacity(0.2),
                  //     blurRadius: 2,
                  //     offset: Offset(0,1),
                  //   )
                  // ]
                ),
                child: const Text(
                  '+1',
                  style: TextStyle(fontSize: 14, color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ),
      ],
    );
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
                if (_currentPhase == PagePhase.questions)
                  LayoutBuilder(
                    builder: (BuildContext context, BoxConstraints constraints) {
                      // Số câu đã học dựa trên số thẻ đã được swipe
                      double progressPercentage = 0.0;
                      final totalQuestions = questionsModel.questionsCurrent.length;
                      int swipedCount = _swipedCardInfoStack.length; 

                      // Nếu đã hoàn thành, hiển thị đã học hết
                      if (_currentPhase == PagePhase.finished && totalQuestions > 0) {
                        swipedCount = totalQuestions;
                      }

                      if (totalQuestions > 0) {
                        if (_currentPhase == PagePhase.finished) {
                          // Nếu đã hoàn thành, tiến trình là 100%
                          progressPercentage = 1.0;
                        } else {
                          // Tính toán phần trăm tiến trình
                          progressPercentage = swipedCount / totalQuestions;
                        }
                      }
                      progressPercentage = progressPercentage.clamp(0.0, 1.0);

                      return ProgressBarWidget (
                        totalQuestions: totalQuestions,
                        currentQuestionIndex: swipedCount,
                        progress: progressPercentage,
                        onCloseQuiz: questionsModel.closeQuiz
                      );
                    }
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
                            _buildCounterWidget(
                              count: _notRememberCount,
                              label: 'Chưa Nhớ',
                              borderColor: Colors.orangeAccent,
                              backgroundColor: Color.fromRGBO(255, 171, 64, .2),
                              textColor: Colors.deepOrange,
                              plusOneOpacity: _plusOneOpacityNotRemembered,
                              plusOneBackgroundColor: const Color.fromRGBO(251, 133, 0, 1), // Màu từ snippet của bạn
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
                                            wasSwipedRight ? _rememberCount-- : _notRememberCount--;
                                            
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
                            _buildCounterWidget(
                              count: _rememberCount,
                              label: 'Đã Nhớ',
                              borderColor: Colors.green,
                              backgroundColor: Color.fromRGBO(76, 175, 80, .2),
                              textColor: Colors.green,
                              plusOneOpacity: _plusOneOpacityRemembered,
                              plusOneBackgroundColor: Colors.green, // Hoặc màu bạn muốn cho "+1" của "Đã Nhớ"
                            )

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


