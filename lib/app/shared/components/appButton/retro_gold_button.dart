import 'package:flutter/material.dart';
import 'package:valli_di_comacchio/app/shared/components/boarder_text/h3/h3.dart';

/// Golden pixel‑art style button — just call RetroGoldButton(label:'Vendi', …)
class RetroGoldButton extends StatelessWidget {
  const RetroGoldButton({
    super.key,
    required this.label,
    required this.onPressed,
  });

  final String label;
  final VoidCallback onPressed;

  static const double _w = 150; // overall size from your CSS
  static const double _h = 41;
  static const _gold = Color(0xFFF3BC00);
  static const _borderWidth = 1.4;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: SizedBox(
        width: _w,
        height: _h,
        child: Stack(
          children: [
            // Base rectangle with border & shadows  ───────────────────────────
            Positioned(
              left: 0,
              top: 0,
              right: 0,
              bottom: 0,
              child: Container(
                decoration: BoxDecoration(
                  color: _gold,
                  border: Border.all(
                    color: Colors.black,
                    width: _borderWidth,
                  ),
                  borderRadius: BorderRadius.circular(
                      8), // <-- Add this line for rounded corners
                  boxShadow: const [
                    BoxShadow(
                      offset: Offset(0, 4.88),
                      blurRadius: 1.39,
                      color: Color.fromRGBO(0, 0, 0, 0.25),
                    ),
                    BoxShadow(
                      offset: Offset(0, 1.39),
                      blurRadius: 0,
                      color: Colors.black,
                    ),
                  ],
                ),
              ),
            ),

            // Top white shine strip  ──────────────────────────────────────────
            Positioned(
              left: 0.75,
              top: 0,
              right: 0.75,
              height: 4.89,
              child: Opacity(
                opacity: 0.7,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(8), // Match the button's top radius
                    ),
                  ),
                ),
              ),
            ),

            // Bottom dark overlay strip  ──────────────────────────────────────
            Positioned(
              left: -0.75,
              bottom: 0,
              right: -0.75,
              height: 4.89,
              child: Opacity(
                opacity: 0.7,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.vertical(
                      bottom: Radius.circular(
                          8), // Match the button's bottom radius
                    ),
                  ),
                ),
              ),
            ),

            // Tiny angled highlight rectangle  ───────────────────────────────
            Positioned(
              right: 6,
              top: -0.05,
              child: Transform.rotate(
                angle: -43.36 * 3.1415926535 / 180, // degrees → radians
                child: Container(
                  width: 3.76,
                  height: 9.92,
                  decoration: BoxDecoration(
                    color: const Color(0xdd3d01),
                    borderRadius:
                        BorderRadius.circular(2), // Optional: subtle rounding
                  ),
                ),
              ),
            ),

            // Button text  ────────────────────────────────────────────────────
            Center(
              child: H3(label),
            ),
          ],
        ),
      ),
    );
  }
}
