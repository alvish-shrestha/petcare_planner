// ignore_for_file: use_build_context_synchronously, deprecated_member_use, dead_code, unnecessary_null_comparison

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:petcare_planner_frontend/widgets/app_colors.dart';

enum SnackBarType { success, error, info }

class AppSnackBar {
  static void show(
    BuildContext context, {
    required String message,
    SnackBarType type = SnackBarType.info,
  }) {
    Color iconBackgroundColor;
    Icon icon;

    switch (type) {
      case SnackBarType.success:
        iconBackgroundColor = AppColors.primary;
        icon = const Icon(Icons.check, color: AppColors.white, size: 14);
        break;
      case SnackBarType.error:
        iconBackgroundColor = Colors.red;
        icon = const Icon(Icons.error, color: AppColors.white, size: 14);
        break;
      case SnackBarType.info:
        iconBackgroundColor = Colors.blue;
        icon = const Icon(Icons.info, color: AppColors.white, size: 14);
        break;
    }

    final snackBar = SnackBar(
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      elevation: 0,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      content: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.25),
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: Colors.white.withOpacity(0.3)),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: iconBackgroundColor,
                    shape: BoxShape.circle,
                  ),
                  child: icon,
                ),
                const SizedBox(width: 12),
                Flexible(
                  child: Text(
                    message,
                    style: const TextStyle(
                      fontFamily: "Poppins",
                      color: AppColors.strongText,
                      fontSize: 14,
                      shadows: [
                        Shadow(
                          blurRadius: 10,
                          color: Colors.black26,
                          offset: Offset(0, 1),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  // static void showCentered(
  //   BuildContext context, {
  //   required String message,
  //   SnackBarType type = SnackBarType.info,
  //   Duration duration = const Duration(seconds: 2),
  // }) {
  //   Color iconBackgroundColor;
  //   Icon icon;

  //   switch (type) {
  //     case SnackBarType.success:
  //       iconBackgroundColor = AppColors.primary;
  //       icon = const Icon(Icons.check, color: Colors.white, size: 14);
  //       break;
  //     case SnackBarType.error:
  //       iconBackgroundColor = Colors.red;
  //       icon = const Icon(Icons.error, color: Colors.white, size: 14);
  //       break;
  //     case SnackBarType.info:
  //       iconBackgroundColor = Colors.blue;
  //       icon = const Icon(Icons.info, color: Colors.white, size: 14);
  //       break;
  //   }

  //   showDialog(
  //     context: context,
  //     barrierDismissible: false,
  //     barrierColor: Colors.transparent,
  //     builder: (_) {
  //       Future.delayed(duration, () {
  //         if (Navigator.of(context).canPop()) {
  //           Navigator.of(context).pop();
  //         }
  //       });

  //       return Center(
  //         child: ClipRRect(
  //           borderRadius: BorderRadius.circular(30),
  //           child: BackdropFilter(
  //             filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
  //             child: Container(
  //               padding: const EdgeInsets.symmetric(
  //                 horizontal: 24,
  //                 vertical: 16,
  //               ),
  //               decoration: BoxDecoration(
  //                 color: Colors.white.withOpacity(0.25),
  //                 borderRadius: BorderRadius.circular(30),
  //                 border: Border.all(color: Colors.white.withOpacity(0.3)),
  //               ),
  //               child: Row(
  //                 mainAxisSize: MainAxisSize.min,
  //                 children: [
  //                   Container(
  //                     padding: const EdgeInsets.all(8),
  //                     decoration: BoxDecoration(
  //                       color: iconBackgroundColor,
  //                       shape: BoxShape.circle,
  //                     ),
  //                     child: icon,
  //                   ),
  //                   const SizedBox(width: 16),
  //                   Flexible(
  //                     child: Text(
  //                       message,
  //                       style: const TextStyle(
  //                         fontFamily: "Poppins",
  //                         color: AppColors.textPrimary,
  //                         fontSize: 14,
  //                         shadows: [
  //                           Shadow(
  //                             blurRadius: 10,
  //                             color: Colors.black26,
  //                             offset: Offset(0, 0.098),
  //                           ),
  //                         ],
  //                       ),
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }

  // static void showCentered(
  //   BuildContext context, {
  //   required String message,
  //   SnackBarType type = SnackBarType.info,
  //   Duration duration = const Duration(seconds: 2),
  // }) {
  //   Color iconBackgroundColor;
  //   Icon icon;

  //   switch (type) {
  //     case SnackBarType.success:
  //       iconBackgroundColor = AppColors.primary;
  //       icon = const Icon(Icons.check, color: Colors.white, size: 14);
  //       break;
  //     case SnackBarType.error:
  //       iconBackgroundColor = Colors.red;
  //       icon = const Icon(Icons.error, color: Colors.white, size: 14);
  //       break;
  //     case SnackBarType.info:
  //       iconBackgroundColor = Colors.blue;
  //       icon = const Icon(Icons.info, color: Colors.white, size: 14);
  //       break;
  //   }

  //   final overlayState = Overlay.of(context);
  //   if (overlayState == null) return;

  //   final overlayEntry = OverlayEntry(
  //     builder: (context) {
  //       return Positioned.fill(
  //         child: IgnorePointer(
  //           ignoring: true,
  //           child: Center(
  //             child: ClipRRect(
  //               borderRadius: BorderRadius.circular(30),
  //               child: BackdropFilter(
  //                 filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
  //                 child: Container(
  //                   padding: const EdgeInsets.symmetric(
  //                     horizontal: 24,
  //                     vertical: 16,
  //                   ),
  //                   decoration: BoxDecoration(
  //                     color: Colors.white.withOpacity(0.25),
  //                     borderRadius: BorderRadius.circular(30),
  //                     border: Border.all(color: Colors.white.withOpacity(0.3)),
  //                   ),
  //                   child: Row(
  //                     mainAxisSize: MainAxisSize.min,
  //                     children: [
  //                       Container(
  //                         padding: const EdgeInsets.all(8),
  //                         decoration: BoxDecoration(
  //                           color: iconBackgroundColor,
  //                           shape: BoxShape.circle,
  //                         ),
  //                         child: icon,
  //                       ),
  //                       const SizedBox(width: 16),
  //                       Flexible(
  //                         child: Text(
  //                           message,
  //                           style: const TextStyle(
  //                             fontFamily: "Poppins",
  //                             color: AppColors.textPrimary,
  //                             fontSize: 14,
  //                             shadows: [
  //                               Shadow(
  //                                 blurRadius: 10,
  //                                 color: Colors.black26,
  //                                 offset: Offset(0, 0.098),
  //                               ),
  //                             ],
  //                           ),
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                 ),
  //               ),
  //             ),
  //           ),
  //         ),
  //       );
  //     },
  //   );

  //   overlayState.insert(overlayEntry);

  //   Future.delayed(duration, () {
  //     overlayEntry.remove();
  //   });
  // }
}
