import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:valli_di_comacchio/app/shared/style/app_images.dart';

class NpcLoadingModal extends StatelessWidget {
  const NpcLoadingModal({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Blur the whole page
        Positioned.fill(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
            child: Container(
              color: Colors.black.withOpacity(0.3),
            ),
          ),
        ),
        // Centered NPC image and dialogue
        Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                AppImages.rosario,
                height: 230,
              ),
              const SizedBox(height: 24),
              // NpcDialogueBox(
              //   speaker: '',
              //   text: _dots.isEmpty ? ' ' : _dots,
              //   speed: const Duration(milliseconds: 50),
              // ),
            ],
          ),
        ),
      ],
    );
  }
}
