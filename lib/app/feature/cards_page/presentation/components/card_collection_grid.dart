import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:valli_di_comacchio/app/feature/cards_page/domain/cards.dart';
import 'package:valli_di_comacchio/app/feature/cards_page/logic/card_cubit.dart';
import 'package:valli_di_comacchio/app/feature/cards_page/logic/card_state.dart';
import 'package:valli_di_comacchio/app/feature/cards_page/presentation/components/new_card_badge.dart';

class CardCollectionGrid extends StatefulWidget {
  const CardCollectionGrid({
    super.key,
    required this.onCardTap,
  });

  final Function(CollectibleCard) onCardTap;

  @override
  State<CardCollectionGrid> createState() => _CardCollectionGridState();
}

class _CardCollectionGridState extends State<CardCollectionGrid>
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

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CardCubit, CardState>(
      buildWhen: (previous, current) =>
          previous.userCards.length != current.userCards.length ||
          previous.newCardsInTheLastPack != current.newCardsInTheLastPack,
      builder: (context, state) {
        return GridView.builder(
          padding: const EdgeInsets.all(12),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.7,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemCount: appCardsCompleteList.length,
          itemBuilder: (context, index) {
            final cardElement = appCardsCompleteList[index];
            final CollectibleCard? userCard = state.userCards
                .where((c) => c.id == cardElement.id)
                .firstOrNull;
            final isCardInCollection = userCard != null;
            final isNewCard =
                state.newCardsInTheLastPack.any((c) => c.id == cardElement.id);

            return GestureDetector(
              onTap: () {
                if (isCardInCollection) {
                  widget.onCardTap(cardElement);
                }
              },
              child: Hero(
                tag: 'card_${cardElement.id}',
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.5),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: isCardInCollection
                            ? Image.asset(
                                cardElement.imagePath,
                                fit: BoxFit.cover,
                              )
                            : _buildMissingCardPlaceholder(cardElement),
                      ),

                      // Shimmer effect for foil cards
                      if (isCardInCollection && cardElement.isFoil())
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
                                      Color(0x22FFFFFF),
                                      Color(0x44FFFFFF),
                                      Color(0x22FFFFFF),
                                      Colors.transparent,
                                    ],
                                    stops: const [0.0, 0.35, 0.5, 0.65, 1.0],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),

                      // NEW badge for newly acquired cards
                      if (isNewCard)
                        const Positioned(
                          top: 8,
                          right: 8,
                          child: NewCardBadge(),
                        ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildMissingCardPlaceholder(CollectibleCard cardElement) {
    return Container(
      color: Colors.grey.shade800,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(
              top: 8.0,
              left: 4.0,
              right: 4.0,
            ),
            child: Text(
              cardElement.name,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.help_outline,
                  size: 40,
                  color: Colors.grey.shade600,
                ),
                const SizedBox(height: 8),
                Text(
                  'MANCANTE',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
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
