import 'package:flutter/material.dart';
import 'package:valli_di_comacchio/app/feature/cards_page/domain/cards.dart';
import 'package:valli_di_comacchio/app/feature/cards_page/logic/card_state.dart';
import 'package:valli_di_comacchio/app/feature/cards_page/presentation/components/new_card_badge.dart';

class RevealedCardsArea extends StatefulWidget {
  const RevealedCardsArea({
    super.key,
    required this.state,
    required this.onCardTap,
    required this.newCardsInPack,
  });

  final CardState state;
  final Function(CollectibleCard) onCardTap;
  final List<CollectibleCard> newCardsInPack;

  @override
  State<RevealedCardsArea> createState() => _RevealedCardsAreaState();
}

class _RevealedCardsAreaState extends State<RevealedCardsArea>
    with SingleTickerProviderStateMixin {
  late AnimationController _shimmerController;
  late Animation<double> _shimmerAnimation;

  @override
  void initState() {
    super.initState();
    _initializeShimmerAnimation();
  }

  void _initializeShimmerAnimation() {
    _shimmerController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();

    _shimmerAnimation = Tween<double>(begin: -1.0, end: 2.0).animate(
      CurvedAnimation(parent: _shimmerController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _shimmerController.dispose();
    super.dispose();
  }

  bool _isNewCard(CollectibleCard card) {
    return widget.newCardsInPack.any((c) => c.id == card.id);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
      child: widget.state.revealedCards.isEmpty
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
              itemCount: widget.state.revealedCards.length,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              itemBuilder: (context, index) {
                final card = widget.state.revealedCards[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: GestureDetector(
                    onTap: () => widget.onCardTap(card),
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
                              card.imagePath,
                              fit: BoxFit.cover,
                            ),
                          ),

                          // Shimmer effect for foil cards
                          if (card.isFoil())
                            AnimatedBuilder(
                              animation: _shimmerAnimation,
                              builder: (context, child) {
                                return ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
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

                          // NEW badge for newly acquired cards
                          if (_isNewCard(card))
                            Positioned(
                              top: 4,
                              right: 4,
                              child: Transform.scale(
                                scale:
                                    0.8, // Smaller for the revealed cards area
                                child: const NewCardBadge(),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
