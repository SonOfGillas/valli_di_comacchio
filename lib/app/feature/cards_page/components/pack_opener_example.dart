import 'dart:math';
import 'package:flutter/material.dart';
import 'package:valli_di_comacchio/app/feature/cards_page/components/pack_opening.dart';
import 'package:valli_di_comacchio/app/feature/cards_page/components/card_detail.dart';

class PackOpenerExample extends StatefulWidget {
  const PackOpenerExample({Key? key}) : super(key: key);

  @override
  State<PackOpenerExample> createState() => _PackOpenerExampleState();
}

class _PackOpenerExampleState extends State<PackOpenerExample>
    with TickerProviderStateMixin {
  // The cards revealed from packs
  final List<String> _collectedCards = [];

  // Whether we're showing the pack opening screen
  bool _openingPack = false;

  // Animation controller for card collection
  late AnimationController _cardCollectionController;
  late Animation<double> _cardScaleAnimation;

  // Selected card for inspection
  String? _selectedCard;

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
    super.dispose();
  }

  // Open a new card pack
  void _openNewPack() {
    setState(() {
      _openingPack = true;
    });
  }

  // Handle cards revealed from the pack
  void _onCardsRevealed(List<String> cards) {
    // Add the cards to the collection
    setState(() {
      _collectedCards.addAll(cards);
      _openingPack = false;
    });

    // Play the collection animation
    _cardCollectionController.reset();
    _cardCollectionController.forward();
  }

  // Inspect a card
  void _inspectCard(String card) {
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
    if (_openingPack) {
      // Show the pack opening screen
      return WillPopScope(
        onWillPop: () async {
          setState(() {
            _openingPack = false;
          });
          return false;
        },
        child: PackOpeningPage(
            // onComplete: _onCardsRevealed,
            ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Card Collection'),
        backgroundColor: Colors.blueGrey.shade800,
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline),
            onPressed: () {
              // Show help dialog
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('How to Use'),
                  content: const SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('• Tap "OPEN NEW PACK" to get more cards'),
                        SizedBox(height: 8),
                        Text('• Tap any card to inspect it up close'),
                        SizedBox(height: 8),
                        Text('• Swipe down to dismiss the card inspection'),
                        SizedBox(height: 8),
                        Text(
                            '• Collect all cards to complete your collection!'),
                      ],
                    ),
                  ),
                  actions: [
                    TextButton(
                      child: const Text('GOT IT'),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      backgroundColor: Colors.blueGrey.shade900,
      body: Stack(
        children: [
          // Background pattern
          Container(
            decoration: BoxDecoration(
              color: Colors.blueGrey.shade900,
              image: DecorationImage(
                image: const AssetImage('assets/images/LOGO-comacchio.png'),
                opacity: 0.05,
                repeat: ImageRepeat.repeat,
                scale: 6.0,
              ),
            ),
          ),

          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Stats bar
              Container(
                color: Colors.black38,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Collection: ${_collectedCards.length}/${cardsInThePack.length}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (_collectedCards.length == cardsInThePack.length)
                      const Text(
                        '✨ COMPLETE! ✨',
                        style: TextStyle(
                          color: Colors.amber,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
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
                              final isNew = index >=
                                  _collectedCards.length -
                                      cardsInThePack.length;

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
                                    tag: 'card_${_collectedCards[index]}',
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
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: Image.asset(
                                          _collectedCards[index],
                                          fit: BoxFit.cover,
                                        ),
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
                    onVerticalDragEnd: (details) {
                      if (details.velocity.pixelsPerSecond.dy > 500) {
                        _closeInspection();
                      }
                    },
                    onTap: _closeInspection,
                    child: Container(
                      color: Colors.black
                          .withOpacity(0.8 * _inspectAnimation.value),
                      alignment: Alignment.center,
                      child: Transform.scale(
                        scale: 0.8 + (0.2 * _inspectAnimation.value),
                        child: Hero(
                          tag: 'card_$_selectedCard',
                          child: CardDetail(
                            isFoil: Random()
                                .nextBool(), // Randomly show foil effect
                            // cardAsset: _selectedCard!, TODO update this
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
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openNewPack,
        backgroundColor: Colors.amber,
        icon: const Icon(Icons.card_giftcard, color: Colors.black87),
        label: const Text(
          'OPEN NEW PACK',
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
