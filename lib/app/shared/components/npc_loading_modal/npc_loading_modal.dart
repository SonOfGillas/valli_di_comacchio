import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:valli_di_comacchio/app/shared/style/app_images.dart';
import 'package:valli_di_comacchio/app/shared/components/npc_dialog_box/npc_dialog_box.dart';

class NpcLoadingModal extends StatefulWidget {
  const NpcLoadingModal({super.key});

  @override
  State<NpcLoadingModal> createState() => _NpcLoadingModalState();
}

class _NpcLoadingModalState extends State<NpcLoadingModal> {
  String _dots = '';
  Timer? _timer;
  int _dotCount = 0;

  @override
  void initState() {
    super.initState();
    _startDotAnimation();
  }

  void _startDotAnimation() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      setState(() {
        _dotCount = (_dotCount + 1) % 4;
        _dots = '.' * _dotCount;
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

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
              NpcDialogueBox(
                speaker: '',
                text: _dots.isEmpty ? ' ' : _dots,
                speed: const Duration(milliseconds: 50),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
