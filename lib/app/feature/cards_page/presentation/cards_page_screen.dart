import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:valli_di_comacchio/app/feature/cards_page/domain/card_pack.dart';
import 'package:valli_di_comacchio/app/feature/cards_page/domain/cards.dart';
import 'package:valli_di_comacchio/app/feature/cards_page/logic/card_cubit.dart';
import 'package:valli_di_comacchio/app/feature/cards_page/logic/card_state.dart';
import 'package:valli_di_comacchio/app/feature/cards_page/presentation/components/new_card_badge.dart';
import 'package:valli_di_comacchio/app/feature/cards_page/presentation/components/pack_opening.dart';
import 'package:valli_di_comacchio/app/feature/cards_page/presentation/components/pack_courosel.dart';
import 'package:valli_di_comacchio/app/feature/cards_page/presentation/components/card_detail.dart';
import 'package:valli_di_comacchio/app/shared/components/boarder_text/h1_on_primary/h1_on_primary.dart';
import 'package:valli_di_comacchio/app/shared/components/boarder_text/labelText.dart/label_text.dart';
import 'package:valli_di_comacchio/app/shared/components/modal/base_modal.dart';
import 'package:valli_di_comacchio/app/shared/style/app_colors.dart';
import 'package:valli_di_comacchio/app/shared/style/app_icons.dart';
import 'package:valli_di_comacchio/app/shared/style/app_images.dart';

import '../../../shared/components/boarder_text/h3/h3.dart';

class CardPageScreen extends StatefulWidget {
  const CardPageScreen({super.key});

  @override
  State<CardPageScreen> createState() => _CardPageScreenState();
}

class _CardPageScreenState extends State<CardPageScreen>
    with TickerProviderStateMixin {
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
  void _onPackSelected(CardPack pack, BuildContext context) {
    final userHaveEnoughCoins = context.read<CardCubit>().userHasEnoughCoins;
    _showPackCostModal(pack, userHaveEnoughCoins);
  }

  // Show pack cost modal
  void _showPackCostModal(CardPack pack, bool userHaveEnoughCoins) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return BaseModal(
          child: Center(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.palette_tertiary,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(
                  color: AppColors.palette_primary,
                  width: 2,
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const H3('Apertura Pacchetto'),
                  const SizedBox(height: 20),
                  Image.asset(
                    AppImages.pack_closed,
                    width: 120,
                    height: 180,
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(height: 20),
                  if (!userHaveEnoughCoins)
                    const Text(
                      'credito insufficiente per aprire questo pacchetto.',
                      style: TextStyle(
                        color: AppColors.shade_red_100,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.amber,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SvgPicture.asset(
                          AppIcons.money,
                          width: 20,
                          height: 20,
                          colorFilter: ColorFilter.mode(
                            AppColors.palette_primary,
                            BlendMode.srcIn,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          '$packetCost COINS',
                          style: TextStyle(
                            color: Colors.black87,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey.shade600,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
                            'Annulla',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            if (userHaveEnoughCoins) {
                              Navigator.of(context).pop();
                              _openPack(pack);
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: userHaveEnoughCoins
                                ? Colors.green
                                : Colors.grey,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
                            'Apri',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // Open the selected pack
  void _openPack(CardPack pack) {
    context.read<CardCubit>().openAPack(pack);
    setState(() {
      _selectedPack = pack;
      _showingPackCarousel = false;
      _openingPack = true;
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
                    onPackSelected: (cardPack) =>
                        _onPackSelected(cardPack, context),
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
    return BlocBuilder<CardCubit, CardState>(
      buildWhen: (previous, current) =>
          previous.userCards.length != current.userCards.length ||
          previous.newCardsInTheLastPack != current.newCardsInTheLastPack,
      builder: (context, state) {
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
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        LabelText(
                          'Collezione: ${state.userCards.length}/${appCardsCompleteList.length}',
                          withBoarder: false,
                        ),
                      ],
                    ),
                  ),

                  // Card collection
                  Expanded(
                    child: AnimatedBuilder(
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
                          itemCount: appCardsCompleteList.length,
                          itemBuilder: (context, index) {
                            return BlocBuilder<CardCubit, CardState>(
                              buildWhen: (previous, current) =>
                                  previous.userCards.length !=
                                      current.userCards.length ||
                                  previous.newCardsInTheLastPack !=
                                      current.newCardsInTheLastPack,
                              builder: (context, state) {
                                final cardElement = appCardsCompleteList[index];
                                final CollectibleCard? userCard =
                                    state.userCards
                                        .where(
                                          (c) => c.id == cardElement.id,
                                        )
                                        .firstOrNull;
                                final isCardInCollection = userCard != null;
                                final isNewCard = state.newCardsInTheLastPack
                                    .any((c) => c.id == cardElement.id);
                                return GestureDetector(
                                  onTap: () => {
                                    if (isCardInCollection)
                                      {_inspectCard(cardElement)}
                                  },
                                  child: Transform.scale(
                                    scale: 1.0,
                                    child: Hero(
                                      tag: 'card_${cardElement.id}',
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
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
                                              child: isCardInCollection
                                                  ? Image.asset(
                                                      cardElement.imagePath,
                                                      fit: BoxFit.cover,
                                                    )
                                                  : Container(
                                                      color:
                                                          Colors.grey.shade800,
                                                      child: Column(
                                                        children: [
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .only(
                                                                    top: 8.0,
                                                                    left: 4.0,
                                                                    right: 4.0),
                                                            child: Text(
                                                              cardElement.name,
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .grey
                                                                    .shade600,
                                                                fontSize: 16,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                            ),
                                                          ),
                                                          Expanded(
                                                            child: Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Icon(
                                                                  Icons
                                                                      .help_outline,
                                                                  size: 40,
                                                                  color: Colors
                                                                      .grey
                                                                      .shade600,
                                                                ),
                                                                const SizedBox(
                                                                    height: 8),
                                                                Text(
                                                                  'MANCANTE',
                                                                  style:
                                                                      TextStyle(
                                                                    color: Colors
                                                                        .grey
                                                                        .shade600,
                                                                    fontSize:
                                                                        12,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                            ),
                                            if (isCardInCollection &&
                                                cardElement.isFoil())
                                              AnimatedBuilder(
                                                animation: _shimmerAnimation,
                                                builder: (context, child) {
                                                  return ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        gradient:
                                                            LinearGradient(
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
                                            // NEW badge for newly acquired cards
                                            if (isNewCard)
                                              Positioned(
                                                top: 8,
                                                right: 8,
                                                child: NewCardBadge(),
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
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
        );
      },
    );
  }
}
