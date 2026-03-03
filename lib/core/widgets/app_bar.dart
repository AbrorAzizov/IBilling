import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/constants/app_colors.dart';

enum AppBarType {
  simple,
  withBack,
  withAction,
}

class CustomAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  final String title;
  final AppBarType type;
  final Widget? action;

  const CustomAppBar({
    super.key,
    required this.title,
    this.type = AppBarType.simple,
    this.action,
  });

  @override
  Size get preferredSize => const Size.fromHeight(64);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.background,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SafeArea(
        bottom: false,
        child: SizedBox(
          height: 64,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildLeading(context),

              Expanded(
                child: Center(
                  child: Text(
                    title,
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.white,
                    ),
                  ),
                ),
              ),

              _buildTrailing(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLeading(BuildContext context) {
    switch (type) {
      case AppBarType.withBack:
        return GestureDetector(
          onTap: () => Navigator.pop(context),
          child: const Icon(Icons.arrow_back_ios,
              color: AppColors.white, size: 20),
        );

      case AppBarType.simple:
      case AppBarType.withAction:
        return SvgPicture.asset(
          'assets/app_bar/Ellipse 13.svg',
          width: 24,
          height: 24,
        );
    }
  }

  Widget _buildTrailing() {
    if (type == AppBarType.withAction && action != null) {
      return action!;
    }
    return const SizedBox(width: 24);
  }
}