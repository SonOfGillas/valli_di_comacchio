import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:valli_di_comacchio/app/shared/style/app_colors.dart';

class AppCircularIconButton extends StatelessWidget {
  final String svgPath;
  final VoidCallback onPressed;
  final bool selected;

  const AppCircularIconButton({
    super.key,
    required this.svgPath,
    required this.onPressed,
    this.selected = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: selected ? AppColors.palette_primary : Colors.grey.shade400,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: SvgPicture.asset(
          svgPath,
          height: 24,
          colorFilter: ColorFilter.mode(
            selected ? Colors.white : Colors.grey.shade600,
            BlendMode.srcIn,
          ),
        ),
      ),
    );
  }
}
