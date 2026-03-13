import 'package:flutter/cupertino.dart';
import '../theme/app_colors.dart';

class CustomCardContainer extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  const CustomCardContainer({super.key, required this.child, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color:  AppColors.whiteColor ,
          borderRadius: BorderRadius.circular(15  ),
          border: Border.all(color: AppColors.borderColor, width: 1),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadowColor,
              offset: Offset(4, 12),
              spreadRadius: 0,
              blurRadius: 24,
            ),
          ],
        ),
        padding: .all(16),
        child: child,
      ),
    );
  }
}
