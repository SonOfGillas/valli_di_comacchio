import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';
import 'package:valli_di_comacchio/app/shared/style/app_colors.dart';

class BaseSuccessModal extends StatefulWidget {
  const BaseSuccessModal({super.key, this.child, this.onClose});

  final Widget? child;
  final VoidCallback? onClose;

  @override
  State<BaseSuccessModal> createState() => _BaseSuccessModalState();
}

class _BaseSuccessModalState extends State<BaseSuccessModal> {
  late ConfettiController _controller;

  @override
  void initState() {
    super.initState();
    _controller = ConfettiController(duration: const Duration(seconds: 2));
    _controller.play();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        widget.onClose?.call();
        Navigator.of(context).pop();
      },
      child: Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.zero,
        child: Stack(
          alignment: Alignment.center,
          children: [
            ConfettiWidget(
              confettiController: _controller,
              blastDirectionality: BlastDirectionality.explosive,
              shouldLoop: true,
              colors: const [
                Colors.green,
                Colors.blue,
                Colors.pink,
                Colors.orange,
                Colors.purple,
              ],
              emissionFrequency: 0.10,
              numberOfParticles: 40,
              maxBlastForce: 50,
              minBlastForce: 12,
              gravity: 0.3,
            ),
            GestureDetector(
              onTap: () {
                widget.onClose?.call();
                Navigator.of(context).pop();
              },
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.all(36),
                    decoration: BoxDecoration(
                      color: AppColors.utility_validation,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 16,
                        ),
                      ],
                    ),
                    child: widget.child ??
                        const Text(
                          'Success',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
