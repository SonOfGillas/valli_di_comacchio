import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:valli_di_comacchio/app/shared/app_state/app_cubit.dart';
import 'package:valli_di_comacchio/app/shared/app_state/app_state.dart';
import 'package:valli_di_comacchio/app/shared/components/footer_nav_bar/footer_nav_bar.dart';
import 'package:valli_di_comacchio/app/shared/components/valli_app_bar/valli_app_bar.dart';

class CardsPage extends StatelessWidget {
  const CardsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppCubit, AppState>(
      builder: (context, state) {
        return Scaffold(
            appBar: ValliAppBar(),
            body: Center(
              child: CardDisplayWidget(),
            ),
            bottomNavigationBar: FooterNavBar());
      },
    );
  }
}

class CardDisplayWidget extends StatefulWidget {
  const CardDisplayWidget({
    super.key,
  });

  @override
  State<CardDisplayWidget> createState() => _CardDisplayWidgetState();
}

class _CardDisplayWidgetState extends State<CardDisplayWidget>
    with SingleTickerProviderStateMixin {
  // Animation controller for smooth transitions
  late AnimationController _controller;

  // Current rotation values
  double _rotateX = 0.0;
  double _rotateY = 0.0;

  // Touch position
  Offset? _touchPosition;

  // Maximum tilt angle in radians (20 degrees)
  final double _maxTiltAngle = 20.0 * (pi / 180);

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _controller.addListener(() {
      if (_controller.isAnimating) {
        setState(() {
          _rotateX = _rotateX * (1 - _controller.value);
          _rotateY = _rotateY * (1 - _controller.value);
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
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
                color: Colors.black.withOpacity(0.2),
                blurRadius: 16,
                offset: Offset(0, 8),
              ),
            ],
          ),
          clipBehavior: Clip.antiAlias,
          child: Image.asset(
            'assets/images/test_card.png',
            width: 220,
            height: 320,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
