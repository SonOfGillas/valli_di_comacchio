import 'dart:async';
import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';
import 'package:valli_di_comacchio/app/feature/cards_page/domain/cards.dart';
import 'package:valli_di_comacchio/app/feature/cards_page/logic/card_state.dart';
import 'package:valli_di_comacchio/app/feature/cards_page/presentation/components/new_card_badge.dart';

class RevealedCardWidget extends StatefulWidget {
  const RevealedCardWidget({
    super.key,
    required this.card,
    required this.state,
    required this.onTap,
    required this.isNewCard,
    this.onAnimationComplete,
  });

  final CollectibleCard card;
  final CardState state;
  final VoidCallback onTap;
  final bool isNewCard;
  final VoidCallback? onAnimationComplete;

  @override
  State<RevealedCardWidget> createState() => _RevealedCardWidgetState();
}

class _RevealedCardWidgetState extends State<RevealedCardWidget>
    with TickerProviderStateMixin {
  late AnimationController _cardRevealController;
  late Animation<double> _cardScaleAnimation;
  late Animation<double> _cardSlideAnimation;
  late AnimationController _shimmerController;
  late Animation<double> _shimmerAnimation;
  late ConfettiController _confettiController;
  late AnimationController _collectController;
  late Animation<double> _collectAnimation;
  Timer? _autoRemoveTimer;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startRevealAnimation();
  }

  @override
  void didUpdateWidget(RevealedCardWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Check if this card is no longer the current revealed card
    if (oldWidget.state.currentRevealedCard?.id == widget.card.id &&
        widget.state.currentRevealedCard?.id != widget.card.id) {
      // Start collect animation
      _startCollectAnimation();
    }
  }

  void _initializeAnimations() {
    // Card reveal animation
    _cardRevealController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _cardScaleAnimation = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(parent: _cardRevealController, curve: Curves.elasticOut),
    );

    _cardSlideAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
          parent: _cardRevealController, curve: Curves.easeOutCubic),
    );

    // Shimmer animation for foil cards
    _shimmerController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();

    _shimmerAnimation = Tween<double>(begin: -1.0, end: 2.0).animate(
      CurvedAnimation(parent: _shimmerController, curve: Curves.easeInOut),
    );

    // Confetti controller for foil cards
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 2));

    // Collect animation - scales down and fades out
    _collectController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
      value: 0.0, // Start at 0 (fully visible state)
    );

    _collectAnimation = Tween<double>(
      begin: 1.0, // Start fully visible
      end: 0.0, // End invisible when collecting
    ).animate(CurvedAnimation(
      parent: _collectController,
      curve: Curves.easeInBack,
    ));
  }

  void _startRevealAnimation() {
    // Trigger confetti for foil cards
    if (widget.card.isFoil()) {
      _confettiController.play();
    }

    // Start the reveal animation
    _cardRevealController.forward();

    // Auto-remove the card after exactly 2000ms from when it starts appearing
    _autoRemoveTimer = Timer(const Duration(milliseconds: 2000), () {
      if (mounted) {
        // Auto-collect the card after 2000ms total
        widget.onAnimationComplete?.call();
      }
    });
  }

  void _startCollectAnimation() {
    _collectController.forward().then((_) {
      if (mounted) {
        widget.onAnimationComplete?.call();
      }
    });
  }

  @override
  void dispose() {
    _autoRemoveTimer?.cancel();
    _cardRevealController.dispose();
    _shimmerController.dispose();
    _confettiController.dispose();
    _collectController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Confetti effect for foil cards
        if (widget.card.isFoil())
          ConfettiWidget(
            confettiController: _confettiController,
            blastDirectionality: BlastDirectionality.explosive,
            shouldLoop: false,
            colors: const [
              Colors.amber,
              Colors.yellow,
              Colors.orange,
              Colors.deepOrange,
              Colors.red,
            ],
            emissionFrequency: 0.15,
            numberOfParticles: 50,
            maxBlastForce: 40,
            minBlastForce: 15,
            gravity: 0.3,
          ),

        // The revealed card
        AnimatedBuilder(
          animation: _collectAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: _collectAnimation.value,
              child: Opacity(
                opacity: _collectAnimation.value,
                child: GestureDetector(
                  onTap: () {
                    // Cancel the auto-remove timer since user is collecting manually
                    _autoRemoveTimer?.cancel();
                    // Immediately trigger the tap callback
                    widget.onTap();
                  },
                  child: AnimatedBuilder(
                    animation: _cardRevealController,
                    builder: (context, child) {
                      return Transform.translate(
                        offset: Offset(0, 30 * (1 - _cardSlideAnimation.value)),
                        child: Transform.scale(
                          scale: _cardScaleAnimation.value,
                          child: Container(
                            width: 180,
                            height: 280,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: widget.card.isFoil()
                                      ? Colors.amber
                                      : Colors.yellow,
                                  blurRadius: 20,
                                  spreadRadius: 5,
                                )
                              ],
                            ),
                            child: Stack(
                              fit: StackFit.expand,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.asset(
                                    widget.card.imagePath,
                                    fit: BoxFit.cover,
                                  ),
                                ),

                                // Shimmer effect for foil cards
                                if (widget.card.isFoil())
                                  AnimatedBuilder(
                                    animation: _shimmerAnimation,
                                    builder: (context, child) {
                                      return ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              begin: Alignment(
                                                -1.0 + _shimmerAnimation.value,
                                                -0.5,
                                              ),
                                              end: Alignment(
                                                0.0 + _shimmerAnimation.value,
                                                0.5,
                                              ),
                                              colors: const [
                                                Colors.transparent,
                                                Color(
                                                    0x44FFAA00), // Gold shimmer
                                                Color(
                                                    0x66FFDD00), // Brighter gold
                                                Color(
                                                    0x44FFAA00), // Gold shimmer
                                                Colors.transparent,
                                              ],
                                              stops: const [
                                                0.0,
                                                0.35,
                                                0.5,
                                                0.65,
                                                1.0
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),

                                // NEW badge for newly acquired cards
                                if (widget.isNewCard)
                                  const Positioned(
                                    top: 8,
                                    right: 8,
                                    child: NewCardBadge(),
                                  ),

                                // Tap to collect hint
                                Positioned(
                                  bottom: 8,
                                  left: 0,
                                  right: 0,
                                  child: AnimatedBuilder(
                                    animation: _cardRevealController,
                                    builder: (context, child) {
                                      // Only show hint when animation is complete
                                      if (_cardRevealController.value < 1.0) {
                                        return const SizedBox.shrink();
                                      }

                                      return Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.black54,
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        child: const Text(
                                          'Tocca per raccogliere',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
