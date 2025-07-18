import 'package:flutter/material.dart';
import 'package:valli_di_comacchio/app/feature/cards_page/logic/card_state.dart';
import 'package:valli_di_comacchio/app/shared/style/app_images.dart';

class PackWidget extends StatefulWidget {
  const PackWidget({
    super.key,
    required this.state,
    required this.onTap,
  });

  final CardState state;
  final VoidCallback onTap;

  @override
  State<PackWidget> createState() => _PackWidgetState();
}

class _PackWidgetState extends State<PackWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _bounceController;
  late Animation<double> _bounceAnimation;

  @override
  void initState() {
    super.initState();
    _initializeBounceAnimation();
  }

  void _initializeBounceAnimation() {
    _bounceController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _bounceAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween<double>(begin: 1.0, end: 1.05), weight: 1),
      TweenSequenceItem(
          tween: Tween<double>(begin: 1.05, end: 0.95), weight: 1),
      TweenSequenceItem(tween: Tween<double>(begin: 0.95, end: 1.0), weight: 1),
    ]).animate(
      CurvedAnimation(parent: _bounceController, curve: Curves.easeInOut),
    );

    if (widget.state.remainingCards.isNotEmpty) {
      _bounceController.repeat();
    }
  }

  @override
  void didUpdateWidget(PackWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Control bounce animation based on remaining cards
    if (widget.state.remainingCards.isEmpty && _bounceController.isAnimating) {
      _bounceController.stop();
    } else if (widget.state.remainingCards.isNotEmpty &&
        !_bounceController.isAnimating) {
      _bounceController.repeat();
    }
  }

  @override
  void dispose() {
    _bounceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _bounceController,
        builder: (context, child) {
          return Transform.scale(
            scale: widget.state.remainingCards.isEmpty
                ? 1.0
                : _bounceAnimation.value,
            child: Container(
              width: 200,
              height: 300,
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.5),
                    blurRadius: 15,
                    spreadRadius: 2,
                    offset: const Offset(0, 5),
                  ),
                  // Add a pulsing glow effect until all cards are revealed
                  if (widget.state.remainingCards.isNotEmpty)
                    const BoxShadow(
                      color: Colors.yellow,
                      blurRadius: 20,
                      spreadRadius: 5,
                    )
                ],
              ),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 500),
                transitionBuilder: (Widget child, Animation<double> animation) {
                  return FadeTransition(
                    opacity: animation,
                    child: child,
                  );
                },
                child: Image.asset(
                  widget.state.packOpeningStage == PackOpeningStage.initial
                      ? AppImages.pack_closed
                      : AppImages.pack_opened,
                  key: ValueKey<String>(
                    widget.state.packOpeningStage == PackOpeningStage.initial
                        ? 'closed_pack'
                        : 'opened_pack',
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
