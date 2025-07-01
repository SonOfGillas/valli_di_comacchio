import 'dart:math';
import 'package:flutter/material.dart';
import 'package:valli_di_comacchio/app/feature/cards_page/domain/card_pack.dart';
import 'package:valli_di_comacchio/app/feature/cards_page/logic/cards_page_utils.dart';

class PackCarousel extends StatefulWidget {
  final Function(CardPack) onPackSelected;

  PackCarousel({
    super.key,
    int packCount = 8,
    required this.onPackSelected,
  }) {
    packs = List.generate(
      packCount,
      (index) => getRandomPacket(),
    );
  }

  late List<CardPack> packs;

  @override
  State<PackCarousel> createState() => _PackCarouselState();
}

class _PackCarouselState extends State<PackCarousel>
    with SingleTickerProviderStateMixin {
  // Animation controller for the rotation
  late AnimationController _controller;

  // Current rotation angle in radians
  double _rotationAngle = 0.0;

  // Selected pack index
  int _selectedPackIndex = 0;

  // Touch start position for calculating drag direction
  double? _startDragX;

  // Velocity of carousel spin
  double _rotationVelocity = 0.0;

  // Flag to track if carousel is spinning freely
  bool _isSpinning = false;

  @override
  void initState() {
    super.initState();

    // Initialize animation controller
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 5000),
    );

    // Add listener to update the rotation based on animation value
    _controller.addListener(_updateRotation);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // Update rotation based on animation or free spinning
  void _updateRotation() {
    if (_isSpinning) {
      setState(() {
        // Apply decay to velocity
        _rotationVelocity *= 0.98;

        // Update rotation angle
        _rotationAngle += _rotationVelocity;

        // Stop spinning when velocity is very low
        if (_rotationVelocity.abs() < 0.001) {
          _isSpinning = false;
          _snapToNearestPack();
        }
      });
    }
  }

  // Snap carousel to the nearest pack when rotation stops
  void _snapToNearestPack() {
    final packAngle = 2 * pi / widget.packs.length;
    final currentAngle = _rotationAngle % (2 * pi);

    // Find the nearest pack index
    int nearestIndex = (currentAngle / packAngle).round() % widget.packs.length;
    if (nearestIndex < 0) nearestIndex += widget.packs.length;

    // Calculate the target angle to snap to
    final targetAngle = nearestIndex * packAngle;

    // Animate to the target angle
    final diff = (targetAngle - (currentAngle % (2 * pi)));

    // Ensure we take the shortest path
    final adjustedDiff =
        diff > pi ? diff - 2 * pi : (diff < -pi ? diff + 2 * pi : diff);

    setState(() {
      _rotationAngle += adjustedDiff;
      _selectedPackIndex =
          (widget.packs.length - nearestIndex) % widget.packs.length;
      widget.onPackSelected(widget.packs[_selectedPackIndex]);
    });
  }

  // Handle drag start
  void _onPanStart(DragStartDetails details) {
    _isSpinning = false;
    _startDragX = details.localPosition.dx;
  }

  // Handle drag update
  void _onPanUpdate(DragUpdateDetails details) {
    if (_startDragX != null) {
      final currentX = details.localPosition.dx;
      final dx = currentX - _startDragX!;

      // Convert horizontal drag to rotation (scale factor controls sensitivity)
      final rotationDelta = dx * 0.01;

      setState(() {
        _rotationAngle += rotationDelta;
        _startDragX = currentX;
      });
    }
  }

  // Handle drag end with velocity for momentum effect
  void _onPanEnd(DragEndDetails details) {
    _startDragX = null;

    // Set initial velocity based on drag gesture velocity
    if (details.velocity.pixelsPerSecond.dx.abs() > 100) {
      _rotationVelocity = details.velocity.pixelsPerSecond.dx * 0.0001;
      _isSpinning = true;

      // Use animation controller for continuous updates
      _controller.stop();
      _controller.addListener(() {
        if (_isSpinning) {
          _updateRotation();
        } else {
          _controller.removeListener(_updateRotation);
        }
      });
      _controller.repeat();
    } else {
      _snapToNearestPack();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: GestureDetector(
        onPanStart: _onPanStart,
        onPanUpdate: _onPanUpdate,
        onPanEnd: _onPanEnd,
        child: Center(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final centerX = constraints.maxWidth / 2;
              final centerY = constraints.maxHeight / 2;
              final radius = min(centerX, centerY) * 0.8;

              return Stack(
                clipBehavior: Clip.none,
                children: List.generate(widget.packs.length, (index) {
                  // Calculate the angle for this pack
                  final angle =
                      _rotationAngle + (index * 2 * pi / widget.packs.length);

                  // Calculate position on the circle
                  final x = centerX + radius * sin(angle);
                  final y = centerY - radius * cos(angle);

                  // Calculate size based on position (packs in front appear larger)
                  final scale = 0.8 + 0.4 * (1 + cos(angle)) / 2;

                  // Is this the front-most pack?
                  final isFrontmost = (cos(angle) > 0.9);

                  return Positioned(
                    left: x - 60 * scale,
                    top: y - 85 * scale,
                    width: 120 * scale,
                    height: 170 * scale,
                    key: ValueKey('pack_$index'),
                    child: Transform(
                      transform: Matrix4.identity()
                        ..setEntry(3, 2, 0.001) // Perspective
                        ..rotateY(
                            sin(angle) * 0.8), // Rotate packs based on position
                      alignment: Alignment.center,
                      child: GestureDetector(
                        onTap: isFrontmost
                            ? () {
                                widget.onPackSelected(widget.packs[index]);
                              }
                            : null,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          decoration: BoxDecoration(
                            boxShadow: [
                              if (isFrontmost)
                                BoxShadow(
                                  color: Colors.yellow.withOpacity(0.6),
                                  blurRadius: 25,
                                  spreadRadius: 5,
                                )
                            ],
                          ),
                          child: Image.asset(
                            'assets/images/card_pack.png',
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                  );
                })
                  // Sort by z-index for proper layering
                  ..sort((a, b) {
                    final indexA = int.parse(
                        (a.key as ValueKey).value.toString().split('_')[1]);
                    final indexB = int.parse(
                        (b.key as ValueKey).value.toString().split('_')[1]);

                    final angleA = _rotationAngle +
                        (indexA * 2 * pi / widget.packs.length);
                    final angleB = _rotationAngle +
                        (indexB * 2 * pi / widget.packs.length);

                    return cos(angleA).compareTo(cos(angleB));
                  }),
              );
            },
          ),
        ),
      ),
    );
  }
}
