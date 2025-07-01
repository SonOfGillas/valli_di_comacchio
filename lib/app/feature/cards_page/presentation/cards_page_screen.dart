import 'package:flutter/material.dart';
import 'package:valli_di_comacchio/app/feature/cards_page/domain/card_pack.dart';
import 'package:valli_di_comacchio/app/feature/cards_page/domain/cards.dart';
import 'package:valli_di_comacchio/app/feature/cards_page/logic/cards_page_utils.dart';
import 'package:valli_di_comacchio/app/feature/cards_page/presentation/components/pack_opening.dart';
import 'package:valli_di_comacchio/app/feature/cards_page/presentation/components/pack_courosel.dart';
import 'package:valli_di_comacchio/app/feature/cards_page/presentation/components/card_detail.dart';
import 'package:valli_di_comacchio/app/shared/components/boarder_text/h1_on_primary/h1_on_primary.dart';
import 'package:valli_di_comacchio/app/shared/components/boarder_text/labelText.dart/label_text.dart';
import 'package:valli_di_comacchio/app/shared/style/app_colors.dart';

class CardPageScreen extends StatefulWidget {
  const CardPageScreen({super.key});

  @override
  State<CardPageScreen> createState() => _CardPageScreenState();
}

class _CardPageScreenState extends State<CardPageScreen>
    with TickerProviderStateMixin {
  // The cards revealed from packs
  final List<CollectibleCard> _collectedCards = appCardsCompleteList;

  // Whether we're showing the pack carousel screen
  bool _showingPackCarousel = false;

  // Whether we're showing the pack opening screen
  bool _openingPack = false;

  // Selected pack from carousel
  CardPack? _selectedPack;

  // Animation controller for card collection
  late AnimationController _cardCollectionController;
  late Animation<double> _cardScaleAnimation;

  // Animation controller for foil shimmer effect
  late AnimationController _shimmerController;
  late Animation<double> _shimmerAnimation;

  // Selected card for inspection
  CollectibleCard? _selectedCard;

  // Controller for card inspection animation
  late AnimationController _inspectController;
  late Animation<double> _inspectAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize card collection animation
    _cardCollectionController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _cardScaleAnimation = Tween<double>(begin: 1.5, end: 1.0).animate(
      CurvedAnimation(
          parent: _cardCollectionController, curve: Curves.easeOutBack),
    );

    // Initialize shimmer animation for foil cards
    _shimmerController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();

    _shimmerAnimation = Tween<double>(begin: -1.0, end: 2.0).animate(
      CurvedAnimation(parent: _shimmerController, curve: Curves.easeInOut),
    );

    // Initialize card inspection animation
    _inspectController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _inspectAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _inspectController, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _cardCollectionController.dispose();
    _inspectController.dispose();
    _shimmerController.dispose();
    super.dispose();
  }

  // Open a new card pack - show carousel first
  void _openNewPack() {
    setState(() {
      _showingPackCarousel = true;
    });
  }

  // Handle pack selection from carousel
  void _onPackSelected(CardPack pack) {
    setState(() {
      _selectedPack = pack;
      _showingPackCarousel = false;
      _openingPack = true;
    });
  }

  // Handle cards revealed from the pack
  void _onCardsRevealed(List<CollectibleCard> cards) {
    // Add the cards to the collection
    setState(() {
      _collectedCards.addAll(cards);
      _openingPack = false;
      _selectedPack = null;
    });

    // Play the collection animation
    _cardCollectionController.reset();
    _cardCollectionController.forward();
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
    // Show pack carousel screen
    if (_showingPackCarousel) {
      return Scaffold(
        backgroundColor: AppColors.palette_secondary,
        body: Stack(
          children: [
            Column(
              children: [
                const SizedBox(height: 12),
                const H1(
                  'Scegli un pacchetto',
                ),
                const SizedBox(height: 40),
                Expanded(
                  child: PackCarousel(
                    onPackSelected: _onPackSelected,
                  ),
                ),
              ],
            ),
            // Back button
            Positioned(
              top: 12,
              left: 12,
              child: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new,
                    color: AppColors.palette_primary, size: 30),
                onPressed: () {
                  setState(() {
                    _showingPackCarousel = false;
                  });
                },
              ),
            ),
          ],
        ),
      );
    }

    // Show pack opening screen
    if (_openingPack && _selectedPack != null) {
      return WillPopScope(
        onWillPop: () async {
          setState(() {
            _openingPack = false;
            _selectedPack = null;
          });
          return false;
        },
        child: PackOpeningPage(
          pack: _selectedPack!,
          onCardRevealed: (_) => {
            // TODO manage card revealed callback
          },
          onClose: () {
            setState(() {
              _openingPack = false;
              _selectedPack = null;
            });
          },
        ),
      );
    }

    // Show main collection screen
    return Scaffold(
      backgroundColor: AppColors.palette_secondary,
      body: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Stats bar
              Container(
                color: AppColors.palette_tertiary,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    LabelText(
                      'Collezione: ${_collectedCards.length}/${appCardsCompleteList.length}',
                      withBoarder: false,
                    ),
                  ],
                ),
              ),

              // Card collection
              Expanded(
                child: _collectedCards.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.collections_bookmark_outlined,
                              size: 80,
                              color: Colors.white.withOpacity(0.3),
                            ),
                            const SizedBox(height: 20),
                            Text(
                              'No cards collected yet',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.7),
                                fontSize: 18,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'Open a pack to get started!',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.5),
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      )
                    : AnimatedBuilder(
                        animation: _cardCollectionController,
                        builder: (context, child) {
                          return GridView.builder(
                            padding: const EdgeInsets.all(12),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 0.7,
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 12,
                            ),
                            itemCount: _collectedCards.length,
                            itemBuilder: (context, index) {
                              // Apply scale animation to the most recently added cards
                              final isNew =
                                  index >= _collectedCards.length - packetSize;

                              return GestureDetector(
                                onTap: () =>
                                    _inspectCard(_collectedCards[index]),
                                child: Transform.scale(
                                  scale: isNew &&
                                          _cardCollectionController.status ==
                                              AnimationStatus.forward
                                      ? _cardScaleAnimation.value
                                      : 1.0,
                                  child: Hero(
                                    tag: 'card_${_collectedCards[index].id}',
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                                Colors.black.withOpacity(0.5),
                                            blurRadius: 8,
                                            offset: const Offset(0, 3),
                                          ),
                                        ],
                                      ),
                                      child: Stack(
                                        fit: StackFit.expand,
                                        children: [
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            child: Image.asset(
                                              _collectedCards[index].imagePath,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                          if (_collectedCards[index].isFoil())
                                            AnimatedBuilder(
                                              animation: _shimmerAnimation,
                                              builder: (context, child) {
                                                return ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
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
                                ),
                              );
                            },
                          );
                        },
                      ),
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
                      color: Colors.black
                          .withOpacity(0.8 * _inspectAnimation.value),
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
      ),
      floatingActionButton: _selectedCard == null
          ? FloatingActionButton.extended(
              onPressed: _openNewPack,
              backgroundColor: Colors.amber,
              label: const Text(
                'APRI UN PACCHETTO',
                style: TextStyle(
                    color: Colors.black87, fontWeight: FontWeight.bold),
              ),
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
