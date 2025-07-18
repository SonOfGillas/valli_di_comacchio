import 'package:flutter/material.dart';
import 'package:valli_di_comacchio/app/shared/components/boarder_text/h3/h3.dart';

class GlowingButton extends StatefulWidget {
  final String text;
  final VoidCallback onPressed;
  final String? icon;
  final Color color1;
  final Color color2;
  final bool expanded;
  final bool disabled;

  const GlowingButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.icon,
    this.color1 = const Color(0xfff3bc00), // Gold
    this.color2 = const Color(0xfff7e09e),
    this.expanded = false,
    this.disabled = false,
  });

  @override
  GlowingButtonState createState() => GlowingButtonState();
}

class GlowingButtonState extends State<GlowingButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _pulse;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);
    _pulse = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void didUpdateWidget(covariant GlowingButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Restart animation if text, icon, or colors change
    if (widget.text != oldWidget.text ||
        widget.icon != oldWidget.icon ||
        widget.color1 != oldWidget.color1 ||
        widget.color2 != oldWidget.color2) {
      _controller
        ..reset()
        ..repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.disabled ? null : widget.onPressed,
      child: AnimatedBuilder(
        animation: _pulse,
        builder: (context, child) {
          return Opacity(
            opacity: widget.disabled ? 0.5 : 1.0,
            child: Transform.scale(
              scale: _pulse.value,
              child: Container(
                height: 48,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(40),
                  gradient: LinearGradient(
                    colors: [
                      widget.color1,
                      widget.color2,
                    ],
                  ),
                  boxShadow: widget.disabled
                      ? []
                      : [
                          BoxShadow(
                            color: widget.color1.withValues(alpha: 0.6),
                            spreadRadius: 20 * (_pulse.value - 1) +
                                4 * (_pulse.value - 1) * 10,
                            blurRadius: 32 * (_pulse.value - 1) +
                                24 * (_pulse.value - 1) * 10,
                            offset: const Offset(-8, 0),
                          ),
                          BoxShadow(
                            color: widget.color2.withValues(alpha: 0.6),
                            spreadRadius: 20 * (_pulse.value - 1) +
                                4 * (_pulse.value - 1) * 10,
                            blurRadius: 32 * (_pulse.value - 1) +
                                24 * (_pulse.value - 1) * 10,
                            offset: const Offset(8, 0),
                          ),
                        ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize:
                      widget.expanded ? MainAxisSize.max : MainAxisSize.min,
                  children: [
                    if (widget.icon != null)
                      Icon(
                        Icons.lightbulb,
                        color: Colors.white,
                      ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32.0),
                      child: H3(widget.text),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
