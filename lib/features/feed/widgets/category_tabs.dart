import 'package:dialogix/theme/palette.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

//TODO: improve code quality and code logics
class CategoryTabs extends StatelessWidget {
  final ThemeMode currentMode;

  const CategoryTabs({super.key, required this.currentMode});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          left: 0,
          top: 0,
          bottom: 0,
          child: Container(
            margin: const EdgeInsets.only(left: 12).w,
            width: 208.w,
            decoration: BoxDecoration(
              color: currentMode == ThemeMode.light
                  ? Palette.glassWhite
                  : Palette.glassBlack,
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        DefaultTabController(
          length: 2,
          child: TabBar(
            padding: const EdgeInsets.all(8).w,
            indicatorWeight: 0,
            dividerHeight: 0,
            indicator: BoxDecoration(
              color: Palette.redColor,
              boxShadow: const [
                BoxShadow(
                  blurRadius: 100,
                  spreadRadius: 2,
                  color: Palette.redColor,
                ),
              ],
              borderRadius: BorderRadius.circular(12),
            ),
            unselectedLabelStyle: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.grey[300]!,
            ),
            tabAlignment: TabAlignment.start,
            isScrollable: true,
            indicatorColor: Colors.transparent,
            onTap: (selectedTabIndex) {},
            tabs: [
              _buildTab(
                icon: CupertinoIcons.flame,
                label: "Trending Now",
                color: Palette.whiteColor,
              ),
              _buildTab(
                label: "Hot",
                color: Palette.whiteColor, // Change the color as needed
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTab(
      {IconData? icon, required String label, required Color color}) {
    return Tab(
      child: Padding(
        padding: const EdgeInsets.all(8.0).w,
        child: Row(
          children: [
            if (icon != null) ...[
              Icon(icon, color: color),
              const Gap(4),
            ],
            Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
