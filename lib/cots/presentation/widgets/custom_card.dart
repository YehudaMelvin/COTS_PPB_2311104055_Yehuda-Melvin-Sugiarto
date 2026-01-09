import 'package:flutter/material.dart';
import '../../design_system/colors.dart';

//  Radius 12, Card padding 16
class CustomCard extends StatelessWidget {
  final Widget child;
  final Color color;
  final VoidCallback? onTap;

  const CustomCard({
    super.key, 
    required this.child, 
    this.color = AppColors.surface,
    this.onTap
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            )
          ],
        ),
        child: child,
      ),
    );
  }
}