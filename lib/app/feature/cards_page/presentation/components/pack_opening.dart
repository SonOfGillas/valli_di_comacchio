import 'dart:math';
import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';
import 'package:valli_di_comacchio/app/feature/cards_page/domain/card_pack.dart';
import 'package:valli_di_comacchio/app/feature/cards_page/domain/cards.dart';
import 'package:valli_di_comacchio/app/feature/cards_page/presentation/components/card_detail.dart';
import 'package:valli_di_comacchio/app/shared/components/boarder_text/h3/h3.dart';
import 'package:valli_di_comacchio/app/shared/style/app_colors.dart';
import 'package:valli_di_comacchio/app/shared/style/app_images.dart';

// The opening stages
enum OpeningStage {
  initial, // Unopened pack - showing bouncing animation
  openingCards // Cards being pulled out
}

class PackOpeningPage extends StatefulWidget {
  const PackOpeningPage(
      {Key? key,
      required this.pack,
      required this.onCardRevealed,
      required this.onClose})
      : super(key: key);

  final CardPack pack;
  final Function(CollectibleCard) onCardRevealed;
  final VoidCallback onClose;

  @override
  State<PackOpeningPage> createState() => _PackOpeningPageState();
}

class _PackOpeningPageState extends State<PackOpeningPage>
    with TickerProviderStateMixin {
  // Current stage
  OpeningStage _stage = OpeningStage.initial;

  // List of cards that have been revealed
  final List<CollectibleCard> _revealedCards = [];

  // List of cards remaining in the pack
  late List<CollectibleCard> _remainingCards;

  // Controller for the pack bouncing animation
  late AnimationController _bounceController;
  late Animation<double> _bounceAnimation;

  // Controller for the card reveal animation
  late AnimationController _cardRevealController;
  late Animation<double> _cardScaleAnimation;
  late Animation<double> _cardSlideAnimation;

  // The most recently revealed card
  CollectibleCard? _currentRevealedCard;

  // Whether a card reveal animation is in progress
  bool _isRevealingCard = false;

  // Selected card for inspection
  CollectibleCard? _selectedCard;

  // Controller for card inspection animation
  late AnimationController _inspectController;
  late Animation<double> _inspectAnimation;

  // Animation controller for foil shimmer effect
  late AnimationController _shimmerController;
  late Animation<double> _shimmerAnimation;

  // Confetti controller for foil card reveals
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();

    // Initialize the list of remaining cards
    _remainingCards = List.from(widget.pack.cards);

    // Initialize the bounce animation controller
    _bounceController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    // Create a repeating bounce animation
    _bounceAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween<double>(begin: 1.0, end: 1.05), weight: 1),
      TweenSequenceItem(
          tween: Tween<double>(begin: 1.05, end: 0.95), weight: 1),
      TweenSequenceItem(tween: Tween<double>(begin: 0.95, end: 1.0), weight: 1),
    ]).animate(
      CurvedAnimation(parent: _bounceController, curve: Curves.easeInOut),
    );

    // Start the continuous bouncing effect
    _bounceController.repeat();

    // Initialize the card reveal animation controller
    _cardRevealController = AnimationController(
      duration: const Duration(milliseconds: 1700),
      vsync: this,
    );

    _cardScaleAnimation = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(parent: _cardRevealController, curve: Curves.elasticOut),
    );

    _cardSlideAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
          parent: _cardRevealController, curve: Curves.easeOutCubic),
    );

    // Initialize card inspection animation
    _inspectController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _inspectAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _inspectController, curve: Curves.easeOut),
    );

    // Initialize shimmer animation for foil cards
    _shimmerController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();

    _shimmerAnimation = Tween<double>(begin: -1.0, end: 2.0).animate(
      CurvedAnimation(parent: _shimmerController, curve: Curves.easeInOut),
    );

    // Initialize confetti controller for foil cards
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 2));
  }

  @override
  void dispose() {
    _bounceController.dispose();
    _cardRevealController.dispose();
    _inspectController.dispose();
    _shimmerController.dispose();
    _confettiController.dispose();
    super.dispose();
  }

  // Start revealing cards from the pack
  void _startRevealingCards() {
    if (_stage != OpeningStage.initial) return;

    setState(() {
      _stage = OpeningStage.openingCards;
    });

    // Temporarily intensify the bounce effect for feedback, then continue bouncing
    final wasRepeating = _bounceController.isAnimating;
    _bounceController.stop();
    _bounceController.reset();
    _bounceController.forward().then((_) {
      // Only restart repeating if it was previously repeating
      if (wasRepeating) {
        _bounceController.repeat();
      }
    });

    // Reveal the first card
    _revealNextCard();
  }

  // Reveal the next card
  void _revealNextCard() {
    // Only allow if we're in the correct stage and not already animating
    if (_stage != OpeningStage.openingCards) return;
    if (_isRevealingCard) return;
    if (_remainingCards.isEmpty) return;

    // Set the stage to opening cards
    setState(() {
      _stage = OpeningStage.openingCards;
      _isRevealingCard = true;
    });

    // Pick a random card from the remaining cards
    final random = Random();
    final index = random.nextInt(_remainingCards.length);
    final card = _remainingCards[index];

    // Remove the card from remaining and add to revealed
    _remainingCards.removeAt(index);

    // Set the current revealed card
    setState(() {
      _currentRevealedCard = card;
    });

    // Trigger the card revealed callback
    widget.onCardRevealed(card);

    // Trigger confetti for foil cards
    if (card.isFoil()) {
      _confettiController.play();
    }

    // Reset and play the card reveal animation
    _cardRevealController.reset();
    _cardRevealController.forward().then((_) {
      // After animation completes, add card to revealed list
      setState(() {
        _revealedCards.add(card);
        _currentRevealedCard = null;
        _isRevealingCard = false;

        // If this was the last card, stop the bounce animation
        if (_remainingCards.isEmpty) {
          _bounceController.stop();
        }
      });
    });
  }

  // Inspect a card
  void _inspectCard(CollectibleCard card) {
    setState(() {
      _selectedCard = card;
    });

    _inspectController.reset();
    _inspectController.forward();
  }

  // Close card inspection
  void _closeInspection() {
    _inspectController.reverse().then((_) {
      setState(() {
        _selectedCard = null;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Main pack opening interface
        Stack(
          children: [
            // Background
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.palette_secondary,
                    AppColors.palette_tertiary,
                  ],
                ),
              ),
            ),

            Column(
              children: [
                // Status text
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back_ios_new,
                            color: AppColors.palette_primary, size: 30),
                        onPressed: () {
                          widget.onClose();
                        },
                      ),
                      H3(
                        _remainingCards.isEmpty
                            ? 'Il Pacchetto è vuoto!'
                            : 'Carte rimanenti:   ${_remainingCards.length}',
                      ),
                      Container(
                        width: 40, // Fixed width for alignment
                      ),
                    ],
                  ),
                ),

                // Pack area
                Expanded(
                  child: Center(
                    child: GestureDetector(
                      onTap: () {
                        if (_stage == OpeningStage.initial) {
                          _startRevealingCards();
                        } else if (!_isRevealingCard &&
                            _remainingCards.isNotEmpty) {
                          _revealNextCard();
                        }
                      },
                      child: AnimatedBuilder(
                        animation: _bounceController,
                        builder: (context, child) {
                          return Stack(
                            alignment: Alignment.center,
                            children: [
                              // The main pack with bounce effect that continues until all cards are revealed
                              Transform.scale(
                                scale: _remainingCards.isEmpty
                                    ? 1.0
                                    : _bounceAnimation.value,
                                child: Container(
                                  width: 200,
                                  height: 300,
                                  decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.5),
                                        blurRadius: 15,
                                        spreadRadius: 2,
                                        offset: const Offset(0, 5),
                                      ),
                                      // Add a pulsing glow effect until all cards are revealed
                                      if (_remainingCards.isNotEmpty)
                                        BoxShadow(
                                          color: Colors.yellow,
                                          // .withOpacity(
                                          //     0.5 * _bounceAnimation.value),
                                          blurRadius: 20,
                                          spreadRadius: 5,
                                        )
                                    ],
                                  ),
                                  child: AnimatedSwitcher(
                                    duration: const Duration(milliseconds: 500),
                                    transitionBuilder: (Widget child,
                                        Animation<double> animation) {
                                      return FadeTransition(
                                        opacity: animation,
                                        child: child,
                                      );
                                    },
                                    child: Image.asset(
                                      _stage == OpeningStage.initial
                                          ? AppImages.pack_closed
                                          : AppImages.pack_opened,
                                      key: ValueKey<String>(
                                          _stage == OpeningStage.initial
                                              ? 'closed_pack'
                                              : 'opened_pack'),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),

                              // Revealed card animation
                              if (_currentRevealedCard != null)
                                Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    // Confetti effect for foil cards
                                    if (_currentRevealedCard!.isFoil())
                                      ConfettiWidget(
                                        confettiController: _confettiController,
                                        blastDirectionality:
                                            BlastDirectionality.explosive,
                                        shouldLoop: false,
                                        colors: [
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
                                      animation: _cardRevealController,
                                      builder: (context, child) {
                                        return Transform.translate(
                                          offset: Offset(
                                              0,
                                              30 *
                                                  (1 -
                                                      _cardSlideAnimation
                                                          .value)),
                                          child: Transform.scale(
                                            scale: _cardScaleAnimation.value,
                                            child: Container(
                                              width: 180,
                                              height: 280,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: _currentRevealedCard!
                                                            .isFoil()
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
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    child: Image.asset(
                                                      _currentRevealedCard!
                                                          .imagePath,
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                  // Shimmer effect for foil cards
                                                  if (_currentRevealedCard!
                                                      .isFoil())
                                                    AnimatedBuilder(
                                                      animation:
                                                          _shimmerAnimation,
                                                      builder:
                                                          (context, child) {
                                                        return ClipRRect(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                          child: Container(
                                                            decoration:
                                                                BoxDecoration(
                                                              gradient:
                                                                  LinearGradient(
                                                                begin:
                                                                    Alignment(
                                                                  -1.0 +
                                                                      _shimmerAnimation
                                                                          .value,
                                                                  -0.5,
                                                                ),
                                                                end: Alignment(
                                                                  0.0 +
                                                                      _shimmerAnimation
                                                                          .value,
                                                                  0.5,
                                                                ),
                                                                colors: const [
                                                                  Colors
                                                                      .transparent,
                                                                  Color(
                                                                      0x44FFAA00), // Gold shimmer
                                                                  Color(
                                                                      0x66FFDD00), // Brighter gold
                                                                  Color(
                                                                      0x44FFAA00), // Gold shimmer
                                                                  Colors
                                                                      .transparent,
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
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                ),

                // Revealed cards area
                Container(
                  height: 120,
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.black45,
                    border: Border(
                      top: BorderSide(
                        color: Colors.blueGrey.shade700,
                        width: 2,
                      ),
                    ),
                  ),
                  child: _revealedCards.isEmpty
                      ? const Center(
                          child: Text(
                            'No cards revealed yet',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 16,
                            ),
                          ),
                        )
                      : ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: _revealedCards.length,
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          itemBuilder: (context, index) {
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 5),
                              child: GestureDetector(
                                onTap: () =>
                                    _inspectCard(_revealedCards[index]),
                                child: Container(
                                  width: 70,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.4),
                                        blurRadius: 5,
                                        offset: const Offset(0, 2),
                                      )
                                    ],
                                  ),
                                  child: Stack(
                                    fit: StackFit.expand,
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: Image.asset(
                                          _revealedCards[index].imagePath,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      if (_revealedCards[index].isFoil())
                                        AnimatedBuilder(
                                          animation: _shimmerAnimation,
                                          builder: (context, child) {
                                            return ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  gradient: LinearGradient(
                                                    begin: Alignment(
                                                      -1.0 +
                                                          _shimmerAnimation
                                                              .value,
                                                      -0.5,
                                                    ),
                                                    end: Alignment(
                                                      0.0 +
                                                          _shimmerAnimation
                                                              .value,
                                                      0.5,
                                                    ),
                                                    colors: const [
                                                      Colors.transparent,
                                                      Color(0x22FFFFFF),
                                                      Color(0x44FFFFFF),
                                                      Color(0x22FFFFFF),
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
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
          ],
        ),

        // Card inspection overlay
        if (_selectedCard != null)
          AnimatedBuilder(
            animation: _inspectAnimation,
            builder: (context, child) {
              return Positioned.fill(
                child: GestureDetector(
                  onTap: _closeInspection,
                  child: Container(
                    color:
                        Colors.black.withOpacity(0.8 * _inspectAnimation.value),
                    alignment: Alignment.center,
                    child: Transform.scale(
                      scale: 0.8 + (0.2 * _inspectAnimation.value),
                      child: Hero(
                        tag: 'card_${_selectedCard?.name}',
                        child: CardDetail(
                          card: _selectedCard!,
                        ),
                      ),
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
