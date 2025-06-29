import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:valli_di_comacchio/app/shared/components/boarder_text/h3/h3.dart';
import 'package:valli_di_comacchio/app/shared/domain/entities/npc.dart';
import 'package:valli_di_comacchio/app/shared/style/app_images.dart';

class NpcLoadingModal extends StatefulWidget {
  const NpcLoadingModal({super.key, required this.npc});

  final Npc npc;

  @override
  State<NpcLoadingModal> createState() => _NpcLoadingModalState();
}

class _NpcLoadingModalState extends State<NpcLoadingModal> {
  int _dotCount = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      setState(() {
        _dotCount = (_dotCount + 1) % 4;
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
    String dots = '.' * _dotCount;
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
                widget.npc.imageLocalPath,
                height: 230,
              ),
              const SizedBox(height: 24),
              H3(
                '${widget.npc.name} sta pensando$dots',
              ),
            ],
          ),
        ),
      ],
    );
  }
}
