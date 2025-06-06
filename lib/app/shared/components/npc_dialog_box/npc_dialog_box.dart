import 'dart:async';

import 'package:flutter/material.dart';
import 'package:valli_di_comacchio/app/shared/components/boarder_text/h3/h3.dart';

class NpcDialogueBox extends StatefulWidget {
  final String speaker;
  final String text;
  final VoidCallback? onTap;
  final Duration speed;

  late final List<String> textList;

  NpcDialogueBox({
    super.key,
    required this.text,
    required this.speaker,
    this.onTap,
    this.speed = const Duration(milliseconds: 60),
  }) {
    textList = text
        .split('.')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();
  }

  @override
  State<NpcDialogueBox> createState() => _NpcDialogueBoxState();
}

const Color npcDialogColor = Color.fromARGB(100, 0, 0, 0);

class _NpcDialogueBoxState extends State<NpcDialogueBox>
    with SingleTickerProviderStateMixin {
  String _visibleText = '';
  Timer? _typingTimer;
  int _charIndex = 0;
  int _sentenceIndex = 0;
  late final AnimationController _bounceController;
  late final Animation<double> _bounceAnimation;

  get isLastSentence => _sentenceIndex >= widget.textList.length - 1;

  @override
  void initState() {
    super.initState();
    _bounceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _bounceAnimation = Tween<double>(begin: 1.0, end: 1.2)
        .chain(CurveTween(curve: Curves.elasticInOut))
        .animate(_bounceController);

    _startTyping();
  }

  @override
  void dispose() {
    _typingTimer?.cancel();
    _bounceController.dispose();
    super.dispose();
  }

  void _startTyping() {
    _charIndex = 0;
    _visibleText = '';
    _typingTimer?.cancel();

    final currentSentence = widget.textList[_sentenceIndex];
    _typingTimer = Timer.periodic(widget.speed, (timer) {
      if (_charIndex < currentSentence.length) {
        setState(() {
          _visibleText += currentSentence[_charIndex];
          _charIndex++;
        });
      } else {
        timer.cancel();
        if (isLastSentence) {
          _bounceController.stop();
          _bounceController.value = 1.0;
        } else {
          _bounceController.repeat(reverse: true);
        }
      }
    });
  }

  void _nextSentence() {
    if (_sentenceIndex < widget.textList.length - 1) {
      setState(() {
        _sentenceIndex++;
      });
      _startTyping();
      _bounceController.stop();
      _bounceController.value = 1.0;
    } else {
      widget.onTap?.call();
    }
  }

  void _onTextTap() {
    final currentSentence = widget.textList[_sentenceIndex];
    if (_charIndex < currentSentence.length) {
      // Fast-forward current sentence
      setState(() {
        _typingTimer?.cancel();
        _visibleText = currentSentence;
        _charIndex = currentSentence.length;
      });
    } else {
      // Go to next sentence or call onTap
      _nextSentence();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: _onTextTap,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    // Main dialog container
                    Container(
                      margin:
                          const EdgeInsets.only(left: 16, right: 16, bottom: 4),
                      padding: const EdgeInsets.all(16),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: npcDialogColor,
                        border: Border.all(color: Colors.white, width: 3),
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.5),
                            offset: const Offset(4, 4),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                      child: H3(_visibleText),
                    ),
                    // Speaker container,
                    Positioned(
                      top: -18,
                      right: 30,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: H3(widget.speaker),
                      ),
                    ),
                  ],
                ),
                if (isLastSentence) const SizedBox(height: 10),
                if (!isLastSentence)
                  ScaleTransition(
                    scale: _bounceAnimation,
                    child: CustomPaint(
                      size: const Size(20, 10),
                      painter: _SpeechTailPainter(),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SpeechTailPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = npcDialogColor;
    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width / 2, size.height)
      ..lineTo(size.width, 0)
      ..close();
    canvas.drawPath(path, paint);

    final borderPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;
    canvas.drawPath(path, borderPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
