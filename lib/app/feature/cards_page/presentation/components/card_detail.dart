import 'package:flutter/material.dart';
import 'dart:math';

import 'package:valli_di_comacchio/app/feature/cards_page/domain/cards.dart';
import 'package:valli_di_comacchio/app/shared/components/boarder_text/labelText.dart/label_text.dart';
import 'package:valli_di_comacchio/app/shared/style/app_colors.dart';

class CardDetail extends StatefulWidget {
  final CollectibleCard card;
  final bool isFoil;

  CardDetail({
    super.key,
    required this.card,
  }) : isFoil = card.isFoil();

  @override
  State<CardDetail> createState() => _CardDetailState();
}

class _CardDetailState extends State<CardDetail> with TickerProviderStateMixin {
  // Animation controller for smooth transitions
  late AnimationController _controller;

  // Animation controller for shimmer movement
  late AnimationController _shimmerController;
  late Animation<double> _shimmerAnimation;

  // Secondary shimmer controller for multi-layered effect
  late AnimationController _shimmerController2;
  late Animation<double> _shimmerAnimation2;

  // Hue rotation controller for rainbow effect
  late AnimationController _rainbowController;
  late Animation<double> _rainbowAnimation;

  // Current rotation values
  double _rotateX = 0.0;
  double _rotateY = 0.0;

  // Touch position
  Offset? _touchPosition;

  // Maximum tilt angle in radians (20 degrees)
  final double _maxTiltAngle = 20.0 * (pi / 180);

  // For foil effect
  double _gradientOffsetX = 0.5;
  double _gradientOffsetY = 0.5;
  double _rainbowOffset = 0.0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    // Primary shimmer animation - faster and more dramatic
    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500), // Faster animation
    )..repeat(reverse: true);

    _shimmerAnimation = Tween<double>(begin: -0.3, end: 0.3).animate(
        CurvedAnimation(parent: _shimmerController, curve: Curves.easeInOut));

    // Secondary shimmer animation - different speed for layered effect
    _shimmerController2 = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2300), // Different timing
    )..repeat(reverse: true);

    _shimmerAnimation2 = Tween<double>(begin: -0.2, end: 0.2).animate(
        CurvedAnimation(parent: _shimmerController2, curve: Curves.easeInOut));

    // Rainbow color cycling animation
    _rainbowController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();

    _rainbowAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _rainbowController, curve: Curves.linear));

    _controller.addListener(() {
      if (_controller.isAnimating) {
        setState(() {
          _rotateX = _rotateX * (1 - _controller.value);
          _rotateY = _rotateY * (1 - _controller.value);

          // Update gradient position for foil effect
          if (widget.isFoil) {
            _updateGradientPosition();
          }
        });
      }
    });

    // Update shimmer animation
    if (widget.isFoil) {
      _shimmerController.addListener(() {
        if (_touchPosition == null) {
          setState(() {
            // More dramatic shimmer movement
            _gradientOffsetX = 0.5 + _shimmerAnimation.value * 2.0;
            _gradientOffsetY = 0.5 + _shimmerAnimation.value * 1.5;
          });
        }
      });

      _rainbowController.addListener(() {
        setState(() {
          _rainbowOffset = _rainbowAnimation.value;
        });
      });
    }
  }

  void _updateGradientPosition() {
    // Convert rotation to gradient offset (normalized values)
    // More dramatic movement from tilting
    _gradientOffsetX = 0.5 + (_rotateY / _maxTiltAngle) * 1.2;
    _gradientOffsetY = 0.5 - (_rotateX / _maxTiltAngle) * 1.2;
  }

  @override
  void dispose() {
    _controller.dispose();
    _shimmerController.dispose();
    _shimmerController2.dispose();
    _rainbowController.dispose();
    super.dispose();
  }

  void _onPanStart(DragStartDetails details) {
    _controller.stop();
    final RenderBox box = context.findRenderObject() as RenderBox;
    _touchPosition = box.globalToLocal(details.globalPosition);
  }

  void _onPanUpdate(DragUpdateDetails details) {
    if (_touchPosition == null) return;

    final RenderBox box = context.findRenderObject() as RenderBox;
    final size = box.size;

    // Calculate touch position relative to center
    final centerX = size.width / 2;
    final centerY = size.height / 2;

    // Update touch position
    _touchPosition = box.globalToLocal(details.globalPosition);

    // Calculate tilt based on position from center
    final dx = (_touchPosition!.dx - centerX) / centerX;
    final dy = (_touchPosition!.dy - centerY) / centerY;

    setState(() {
      // Invert Y rotation for natural feel
      _rotateY = dx * _maxTiltAngle;
      _rotateX = -dy * _maxTiltAngle;

      // Update gradient position for foil effect
      if (widget.isFoil) {
        _updateGradientPosition();
      }
    });
  }

  void _onPanEnd(DragEndDetails details) {
    _touchPosition = null;
    _controller.reset();
    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.autorenew,
                size: 32, color: AppColors.palette_tertiary),
            Text('Tieni premuto per ruotare',
                style: TextStyle(
                  color: AppColors.palette_tertiary,
                  fontSize: 16,
                )),
          ],
        ),
        const SizedBox(height: 20),
        GestureDetector(
          onPanStart: _onPanStart,
          onPanUpdate: _onPanUpdate,
          onPanEnd: _onPanEnd,
          child: Transform(
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001) // Perspective
              ..rotateX(_rotateX)
              ..rotateY(_rotateY),
            alignment: Alignment.center,
            child: Container(
              width: 300,
              height: 440,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.transparent,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.35),
                    blurRadius: 28,
                    offset: const Offset(0, 14),
                    spreadRadius: 3,
                  ),
                ],
              ),
              clipBehavior: Clip.antiAlias,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // Base card image
                  Image.asset(
                    widget.card.imagePath,
                    width: 300,
                    height: 440,
                    fit: BoxFit.cover,
                  ),

                  // Special prism overlay for extreme holographic effect
                  if (widget.isFoil)
                    Positioned.fill(
                      child: Opacity(
                        opacity:
                            0.3, // Reduced opacity to make card more visible
                        child: ShaderMask(
                          blendMode: BlendMode
                              .overlay, // Changed to overlay for better color visibility
                          shaderCallback: (bounds) {
                            return LinearGradient(
                              transform: GradientRotation(_rainbowOffset * pi),
                              begin: Alignment(
                                (_gradientOffsetX - 0.5) * 3.0,
                                (_gradientOffsetY - 0.5) * 3.0,
                              ),
                              end: Alignment(
                                -(_gradientOffsetX - 0.5) * 3.0,
                                -(_gradientOffsetY - 0.5) * 3.0,
                              ),
                              colors: const [
                                Color(0xFFFF0000), // Pure Red
                                Color(0xFFFF8800), // Orange
                                Color(0xFFFFFF00), // Yellow
                                Color(0xFF00FF00), // Pure Green
                                Color(0xFF0088FF), // Sky Blue
                                Color(0xFF8800FF), // Purple
                                Color(0xFFFF0088), // Pink
                              ],
                            ).createShader(bounds);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Colors.white
                                      .withOpacity(0.3), // Reduced from 0.9
                                  Colors.white.withOpacity(0.0),
                                  Colors.white
                                      .withOpacity(0.3), // Reduced from 0.9
                                  Colors.white.withOpacity(0.0),
                                ],
                                stops: const [0.0, 0.3, 0.6, 1.0],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                  // Foil overlay effects - subtle layers that let the card image show through
                  if (widget.isFoil) ...[
                    // STRONG shimmer effect - highly visible
                    ShaderMask(
                      blendMode: BlendMode.lighten,
                      shaderCallback: (Rect bounds) {
                        return RadialGradient(
                          center: Alignment(
                            (_gradientOffsetX - 0.5) * 3.0,
                            (_gradientOffsetY - 0.5) * 3.0,
                          ),
                          radius: 0.8,
                          colors: [
                            Colors.white.withOpacity(0.2), // Reduced from 0.4
                            Colors.white.withOpacity(0.1), // Reduced from 0.2
                            Colors.transparent,
                          ],
                          stops: const [0.0, 0.3, 0.7],
                        ).createShader(bounds);
                      },
                      child: Container(color: Colors.transparent),
                    ),

                    // Rainbow color layer with increased visibility
                    ShaderMask(
                      blendMode: BlendMode.overlay,
                      shaderCallback: (Rect bounds) {
                        return SweepGradient(
                          center: Alignment(
                            (_gradientOffsetX - 0.5) * 2.0,
                            (_gradientOffsetY - 0.5) * 2.0,
                          ),
                          startAngle: 0,
                          endAngle: pi * 2,
                          transform: GradientRotation(_rainbowOffset * pi * 2),
                          colors: const [
                            Color(0xA0FF0000), // Red with 63% opacity
                            Color(0xA0FF8800), // Orange with 63% opacity
                            Color(0xA0FFFF00), // Yellow with 63% opacity
                            Color(0xA000FF00), // Green with 63% opacity
                            Color(0xA00088FF), // Sky Blue with 63% opacity
                            Color(0xA08800FF), // Purple with 63% opacity
                            Color(0xA0FF0088), // Pink with 63% opacity
                            Color(0xA0FF0000), // Back to red with 63% opacity
                          ],
                          tileMode: TileMode.mirror,
                        ).createShader(bounds);
                      },
                      child: Container(
                        color: Colors.transparent,
                      ),
                    ),

                    // Horizontal shimmer line - thin and subtle
                    ShaderMask(
                      blendMode: BlendMode.lighten,
                      shaderCallback: (Rect bounds) {
                        return LinearGradient(
                          begin: Alignment(
                            -1.0 + _shimmerAnimation.value * 4.0,
                            -0.2 + _shimmerAnimation2.value,
                          ),
                          end: Alignment(
                            0.0 + _shimmerAnimation.value * 4.0,
                            0.2 + _shimmerAnimation2.value,
                          ),
                          colors: [
                            Colors.transparent,
                            Colors.white.withOpacity(0.3),
                            Colors.transparent,
                          ],
                          stops: const [0.3, 0.5, 0.7], // Thinner line
                        ).createShader(bounds);
                      },
                      child: Container(color: Colors.transparent),
                    ),

                    // Second horizontal shimmer line - offset from first
                    ShaderMask(
                      blendMode: BlendMode.lighten,
                      shaderCallback: (Rect bounds) {
                        return LinearGradient(
                          begin: Alignment(
                            0.0 - _shimmerAnimation2.value * 4.0,
                            0.3 + _shimmerAnimation.value * 0.5,
                          ),
                          end: Alignment(
                            1.0 - _shimmerAnimation2.value * 4.0,
                            0.7 + _shimmerAnimation.value * 0.5,
                          ),
                          colors: [
                            Colors.transparent,
                            Colors.white.withOpacity(0.3), // Reduced from 0.6
                            Colors.transparent,
                          ],
                          stops: const [0.3, 0.5, 0.7], // Thinner line
                        ).createShader(bounds);
                      },
                      child: Container(color: Colors.transparent),
                    ),

                    // Diagonal shimmer line - subtle and elegant
                    ShaderMask(
                      blendMode: BlendMode.lighten,
                      shaderCallback: (Rect bounds) {
                        return LinearGradient(
                          begin: Alignment(
                            -1.0 - _shimmerAnimation2.value * 2.0,
                            -1.0 + _shimmerAnimation.value * 2.0,
                          ),
                          end: Alignment(
                            1.0 - _shimmerAnimation2.value * 2.0,
                            1.0 + _shimmerAnimation.value * 2.0,
                          ),
                          colors: [
                            Colors.transparent,
                            Colors.white.withOpacity(0.25), // Reduced from 0.6
                            Colors.transparent,
                          ],
                          stops: const [0.4, 0.5, 0.6], // Even thinner line
                        ).createShader(bounds);
                      },
                      child: Container(color: Colors.transparent),
                    ),

                    // Edge highlight that follows tilt - Moderately visible holographic border
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.white.withOpacity(
                                0.4), // Further reduced from 0.6 to 0.4
                            width: 1.2, // Further reduced from 1.5 to 1.2
                          ),
                          borderRadius: BorderRadius.circular(15),
                          gradient: LinearGradient(
                            begin: Alignment(
                              (_gradientOffsetX - 0.5) * 2,
                              (_gradientOffsetY - 0.5) * 2,
                            ),
                            end: Alignment(
                              -(_gradientOffsetX - 0.5) * 2,
                              -(_gradientOffsetY - 0.5) * 2,
                            ),
                            colors: [
                              Colors.white
                                  .withOpacity(0.3), // Reduced from 0.4 to 0.3
                              Colors.transparent,
                              Colors.white
                                  .withOpacity(0.3), // Reduced from 0.4 to 0.3
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
