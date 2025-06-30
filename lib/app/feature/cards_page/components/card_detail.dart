import 'package:flutter/material.dart';
import 'dart:math';

class CardDetail extends StatefulWidget {
  final bool isFoil;

  const CardDetail({
    super.key,
    this.isFoil =
        true, // Set default to true to make effect visible immediately
  });

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
    return GestureDetector(
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
          width: 220,
          height: 320,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.35),
                blurRadius: 20,
                offset: const Offset(0, 10),
                spreadRadius: 2,
              ),
            ],
          ),
          clipBehavior: Clip.antiAlias,
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Base card image
              Image.asset(
                'assets/images/test_card.png',
                width: 220,
                height: 320,
                fit: BoxFit.cover,
              ),

              // Special prism overlay for extreme holographic effect
              if (widget.isFoil)
                Positioned.fill(
                  child: Opacity(
                    opacity:
                        0.25, // Further reduced opacity to better show card details
                    child: ShaderMask(
                      blendMode: BlendMode.srcOver,
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
                            Color(0xFFFF0000),
                            Color(0x00FFFFFF),
                            Color(0xFF00FFFF),
                            Color(0x00FFFFFF),
                            Color(0xFF00FF00),
                            Color(0x00FFFFFF),
                            Color(0xFFFF00FF),
                          ],
                        ).createShader(bounds);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Colors.white.withOpacity(0.9),
                              Colors.white.withOpacity(0.1),
                              Colors.white.withOpacity(0.9),
                              Colors.white.withOpacity(0.1),
                            ],
                            stops: const [0.0, 0.3, 0.6, 1.0],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

              // Selective highlight areas that enhance the card's special features
              if (widget.isFoil)
                Positioned.fill(
                  child: CustomPaint(
                    painter: CardHighlightPainter(
                      shimmerOffset: _shimmerAnimation.value,
                      gradientOffsetX: _gradientOffsetX,
                      gradientOffsetY: _gradientOffsetY,
                    ),
                    child: Container(),
                  ),
                ),

              // Foil overlay effects - subtle layers that let the card image show through
              if (widget.isFoil) ...[
                // STRONG shimmer effect - highly visible
                ShaderMask(
                  blendMode: BlendMode.lighten, // Much stronger blend mode
                  shaderCallback: (Rect bounds) {
                    return RadialGradient(
                      center: Alignment(
                        (_gradientOffsetX - 0.5) * 3.0,
                        (_gradientOffsetY - 0.5) * 3.0,
                      ),
                      radius: 0.8, // Tighter radius for stronger highlight
                      colors: [
                        Colors.white.withOpacity(
                            0.4), // Further reduced from 0.6 to 0.4
                        Colors.white.withOpacity(
                            0.2), // Further reduced from 0.3 to 0.2
                        Colors.transparent,
                      ],
                      stops: const [
                        0.0,
                        0.3,
                        0.7
                      ], // More defined highlight with sharp falloff
                    ).createShader(bounds);
                  },
                  child: Container(color: Colors.transparent),
                ),

                // Rainbow color layer with moderate visibility (50% opacity)
                ShaderMask(
                  blendMode: BlendMode.overlay, // Strong blend mode
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
                        Color(0x80FF0000), // Red with 50% opacity
                        Color(0x80FF7F00), // Orange with 50% opacity
                        Color(0x80FFFF00), // Yellow with 50% opacity
                        Color(0x8000FF00), // Green with 50% opacity
                        Color(0x800000FF), // Blue with 50% opacity
                        Color(0x804B0082), // Indigo with 50% opacity
                        Color(0x809400D3), // Violet with 50% opacity
                        Color(0x80FF0000), // Back to red with 50% opacity
                      ],
                      tileMode: TileMode.mirror,
                    ).createShader(bounds);
                  },
                  child: Container(
                    color: Colors.transparent, // Removed white base layer
                  ),
                ),

                // Horizontal shimmer line - DRAMATICALLY more visible
                ShaderMask(
                  blendMode: BlendMode.lighten, // Very strong blend mode
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
                        Colors.white.withOpacity(
                            0.6), // Reduced opacity for white shimmer
                        Colors.transparent,
                      ],
                      stops: const [0.2, 0.5, 0.8], // Sharper line
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
                        Colors.white.withOpacity(
                            0.6), // Reduced opacity for white shimmer
                        Colors.transparent,
                      ],
                      stops: const [0.2, 0.5, 0.8],
                    ).createShader(bounds);
                  },
                  child: Container(color: Colors.transparent),
                ),

                // Diagonal shimmer line - MUCH stronger effect
                ShaderMask(
                  blendMode: BlendMode.lighten, // Very strong blend mode
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
                        Colors.white.withOpacity(
                            0.6), // Reduced opacity for white shimmer
                        Colors.transparent,
                      ],
                      // Narrower white section for more defined line
                      stops: const [
                        0.35,
                        0.5,
                        0.65
                      ], // Very tight line for strong effect
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
    );
  }
}

/// Custom painter to create selective highlight areas on the card
/// This helps maintain the foil effect while ensuring card details remain visible
class CardHighlightPainter extends CustomPainter {
  final double shimmerOffset;
  final double gradientOffsetX;
  final double gradientOffsetY;

  CardHighlightPainter({
    required this.shimmerOffset,
    required this.gradientOffsetX,
    required this.gradientOffsetY,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final width = size.width;
    final height = size.height;

    // Create paint for highlights with strong glow
    final highlightPaint = Paint()
      ..style = PaintingStyle.fill
      ..maskFilter = const MaskFilter.blur(
          BlurStyle.normal, 8); // Much stronger blur for dramatic glow

    // Calculate dynamic position based on shimmer animation
    final xOffset = shimmerOffset * width * 0.6; // Increased movement

    // Create several highlight areas that correspond to card features
    // These positions are approximate and can be adjusted based on the actual card design

    // Top title area highlight - MUCH brighter
    {
      final rect = RRect.fromLTRBR(
        width * 0.2,
        height * 0.05 + xOffset * 0.1,
        width * 0.8,
        height * 0.12 + xOffset * 0.1,
        const Radius.circular(4),
      );

      highlightPaint.shader = RadialGradient(
        center: Alignment(
          (gradientOffsetX - 0.5) * 2.0,
          (gradientOffsetY - 0.5) * 2.0,
        ),
        radius: 1.2,
        colors: [
          Colors.white.withOpacity(
              0.5 + shimmerOffset.abs() * 0.2), // Reduced from 0.7 to 0.5
          Colors.white.withOpacity(0.2), // Reduced from 0.3 to 0.2
          Colors.transparent,
        ],
        stops: const [0.0, 0.3, 1.0],
      ).createShader(Rect.fromLTRB(0, 0, width, height));

      canvas.drawRRect(rect, highlightPaint);
    }

    // Card art frame highlight - MUCH brighter
    {
      final rect = RRect.fromLTRBR(
        width * 0.1,
        height * 0.15,
        width * 0.9,
        height * 0.6,
        const Radius.circular(8),
      );

      highlightPaint.shader = LinearGradient(
        begin: Alignment(shimmerOffset, -shimmerOffset),
        end: Alignment(-shimmerOffset, shimmerOffset),
        colors: [
          Colors.white.withOpacity(0.3), // Reduced from 0.4 to 0.3
          Colors.white.withOpacity(0.4), // Reduced from 0.6 to 0.4
          Colors.white.withOpacity(0.3), // Reduced from 0.4 to 0.3
        ],
      ).createShader(Rect.fromLTRB(0, 0, width, height));

      canvas.drawRRect(rect, highlightPaint);
    }

    // Bottom text area highlights (simulating text lines) - MUCH brighter
    for (int i = 0; i < 3; i++) {
      final rect = RRect.fromLTRBR(
        width * 0.15,
        height * (0.65 + i * 0.07),
        width * (0.7 + i * 0.1) + xOffset * 0.5, // More dynamic movement
        height * (0.67 + i * 0.07),
        const Radius.circular(2),
      );

      highlightPaint.shader = LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: [
          Colors.white.withOpacity(0.15 + i * 0.07), // Reduced opacity
          Colors.white.withOpacity(
              0.5 + shimmerOffset.abs() * 0.2), // Reduced from 0.7 to 0.5
          Colors.white.withOpacity(0.15), // Reduced from 0.2 to 0.15
        ],
      ).createShader(Rect.fromLTRB(0, 0, width, height));

      canvas.drawRRect(rect, highlightPaint);
    }

    // Add additional card elements highlights for stronger effect

    // Card border highlight
    final borderRect = RRect.fromLTRBR(
      width * 0.05,
      height * 0.05,
      width * 0.95,
      height * 0.95,
      const Radius.circular(12),
    );

    final borderPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4)
      ..shader = SweepGradient(
        center: Alignment(
          (gradientOffsetX - 0.5) * 1.5,
          (gradientOffsetY - 0.5) * 1.5,
        ),
        startAngle: 0,
        endAngle: pi * 2,
        colors: [
          Colors.white.withOpacity(0.5), // Reduced from 0.8 to 0.5
          Colors.white.withOpacity(0.2), // Reduced from 0.3 to 0.2
          Colors.white.withOpacity(0.5), // Reduced from 0.8 to 0.5
          Colors.white.withOpacity(0.2), // Reduced from 0.3 to 0.2
        ],
      ).createShader(Rect.fromLTRB(0, 0, width, height));

    canvas.drawRRect(borderRect, borderPaint);
  }

  @override
  bool shouldRepaint(CardHighlightPainter oldDelegate) {
    return oldDelegate.shimmerOffset != shimmerOffset ||
        oldDelegate.gradientOffsetX != gradientOffsetX ||
        oldDelegate.gradientOffsetY != gradientOffsetY;
  }
}
