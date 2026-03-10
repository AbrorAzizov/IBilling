import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const CustomAppBar({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    // Top padding handles the system status bar height
    final double topPadding = MediaQuery.of(context).padding.top;

    return Container(
      // Height includes the status bar + the actual bar height
      height: preferredSize.height + topPadding,
      padding: EdgeInsets.only(
        top: topPadding,
        left: 20, // iBilling usually uses 20dp padding
        right: 20,
      ),
      decoration: const BoxDecoration(
        color: Color(0xFF141416), // Updated to iBilling dark theme
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween, // Separates Left and Right groups
        children: [
          // Left Group: Profile + Title
          Row(
            children: [
              SvgPicture.asset(
                'assets/app_bar/Ellipse 13.svg',
                height: 35,
                width: 35,
              ),
              const SizedBox(width: 12), // Added gap between icon and text
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Colors.white, // Changed to white for dark theme
                ),
              ),
              const SizedBox(width: 8),

            ],
          ),


        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(60);
}