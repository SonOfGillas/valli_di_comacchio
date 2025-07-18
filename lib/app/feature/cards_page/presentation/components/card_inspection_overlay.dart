import 'package:flutter/material.dart';
import 'package:valli_di_comacchio/app/feature/cards_page/domain/cards.dart';
import 'package:valli_di_comacchio/app/feature/cards_page/presentation/components/card_detail.dart';

class CardInspectionOverlay extends StatefulWidget {
  const CardInspectionOverlay({
    super.key,
    required this.card,
    required this.onClose,
  });

  final CollectibleCard card;
  final VoidCallback onClose;

  @override
  State<CardInspectionOverlay> createState() => _CardInspectionOverlayState();
}

class _CardInspectionOverlayState extends State<CardInspectionOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _inspectController;
  late Animation<double> _inspectAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimation();
    _startAnimation();
  }

  void _initializeAnimation() {
    _inspectController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _inspectAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _inspectController, curve: Curves.easeOut),
    );
  }

  void _startAnimation() {
    _inspectController.forward();
  }

  void _closeInspection() {
    _inspectController.reverse().then((_) {
      widget.onClose();
    });
  }

  @override
  void dispose() {
    _inspectController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _inspectAnimation,
      builder: (context, child) {
        return Positioned.fill(
          child: GestureDetector(
            onTap: _closeInspection,
            child: Container(
              color:
                  Colors.black.withValues(alpha: 0.8 * _inspectAnimation.value),
              alignment: Alignment.center,
              child: Transform.scale(
                scale: 0.8 + (0.2 * _inspectAnimation.value),
                child: Hero(
                  tag: 'card_${widget.card.name}',
                  child: CardDetail(
                    card: widget.card,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
