import 'package:dialogix/theme/palette.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class CategoryTabs extends StatelessWidget {
  final ThemeMode currentMode;
  const CategoryTabs({super.key, required this.currentMode});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 12).w,
      decoration: BoxDecoration(
        color: currentMode == ThemeMode.light
            ? Palette.glassWhite
            : Palette.glassBlack,
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(12), bottomLeft: Radius.circular(12)),
      ),
      child: DefaultTabController(
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
                      color: Palette.redColor),
                ],
                borderRadius: BorderRadius.circular(12),
              ),
              unselectedLabelStyle: TextStyle(
                  fontWeight: FontWeight.bold, color: Colors.grey[500]!),
              tabAlignment: TabAlignment.start,
              isScrollable: true,
              indicatorColor: Colors.transparent,
              onTap: (selectedTabIndex) {},
              tabs: [
                Tab(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0).w,
                    child: Row(
                      children: [
                        const Icon(CupertinoIcons.flame,
                            color: Palette.whiteColor),
                        Gap(2.w),
                        const Text(
                          "Best Post",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Palette.whiteColor),
                        ),
                      ],
                    ),
                  ),
                ),
                const Tab(
                  height: 46,
                  text: "Hot",
                ),
              ])),
    );
  }
}
