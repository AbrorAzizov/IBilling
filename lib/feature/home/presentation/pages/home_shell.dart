import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_colors.dart';

class HomeShell extends StatelessWidget {
  const HomeShell({
    required this.navigationShell,
    super.key,
  });

  final StatefulNavigationShell navigationShell;

  void _onTap(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: navigationShell,
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          canvasColor: AppColors.black,
        ),
        child: BottomNavigationBar(
          currentIndex: navigationShell.currentIndex,
          onTap: _onTap,
          type: BottomNavigationBarType.fixed,
          backgroundColor: AppColors.black,
          selectedItemColor: AppColors.white,
          unselectedItemColor: AppColors.textSecondary,
          selectedFontSize: 12,
          unselectedFontSize: 12,
          items: [
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                AppAssets.icDocumentInactive,
                colorFilter: const ColorFilter.mode(AppColors.textSecondary, BlendMode.srcIn),
              ),
              activeIcon: SvgPicture.asset(
                AppAssets.icDocumentActive,
                colorFilter: const ColorFilter.mode(AppColors.white, BlendMode.srcIn),
              ),
              label: 'Contracts',
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                AppAssets.icTimeCircleInactive,
                colorFilter: const ColorFilter.mode(AppColors.textSecondary, BlendMode.srcIn),
              ),
              activeIcon: SvgPicture.asset(
                AppAssets.icTimeCircleActive,
                colorFilter: const ColorFilter.mode(AppColors.white, BlendMode.srcIn),
              ),
              label: 'History',
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                AppAssets.icPlusInactive,
                colorFilter: const ColorFilter.mode(AppColors.textSecondary, BlendMode.srcIn),
              ),
              activeIcon: SvgPicture.asset(
                AppAssets.icPlusActive,
                colorFilter: const ColorFilter.mode(AppColors.white, BlendMode.srcIn),
              ),
              label: 'New',
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                AppAssets.icBookmarkInactive,
                colorFilter: const ColorFilter.mode(AppColors.textSecondary, BlendMode.srcIn),
              ),
              activeIcon: SvgPicture.asset(
                AppAssets.icBookmarkActive,
                colorFilter: const ColorFilter.mode(AppColors.white, BlendMode.srcIn),
              ),
              label: 'Saved',
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                AppAssets.icProfileInactive,
                colorFilter: const ColorFilter.mode(AppColors.textSecondary, BlendMode.srcIn),
              ),
              activeIcon: SvgPicture.asset(
                AppAssets.icProfileActive,
                colorFilter: const ColorFilter.mode(AppColors.white, BlendMode.srcIn),
              ),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
