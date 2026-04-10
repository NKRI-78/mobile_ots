import 'dart:ui';

import 'package:flutter/material.dart';

import 'colors.dart';

class ShowSnackbar {
  ShowSnackbar._();

  static void snackbar(
    BuildContext context,
    String content, {
    required bool isSuccess,
    Duration? time,
    VoidCallback? onTap,
  }) {
    final overlay = Overlay.of(context);
    late final OverlayEntry overlayEntry;

    final Color backgroundColor = isSuccess
        ? AppColors.greenColor.withValues(alpha: 0.85)
        : AppColors.redColor.withValues(alpha: 0.85);
    final Color textColor = AppColors.whiteColor;
    final IconData icon = isSuccess
        ? Icons.check_circle_rounded
        : Icons.error_rounded;

    final animationController = AnimationController(
      vsync: Navigator.of(context),
      duration: const Duration(milliseconds: 300),
    );

    final slideAnimation =
        Tween<Offset>(begin: const Offset(0, -1), end: Offset.zero).animate(
          CurvedAnimation(
            parent: animationController,
            curve: Curves.easeOutCubic,
          ),
        );

    final fadeAnimation = CurvedAnimation(
      parent: animationController,
      curve: Curves.easeInOut,
    );

    overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: MediaQuery.of(context).padding.top + 5,
        left: 20,
        right: 20,
        child: SafeArea(
          child: SlideTransition(
            position: slideAnimation,
            child: FadeTransition(
              opacity: fadeAnimation,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                  child: Material(
                    color: Colors.transparent,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                      decoration: BoxDecoration(
                        color: backgroundColor,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.5),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.25),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: GestureDetector(
                        onTap: onTap,
                        child: Row(
                          children: [
                            Icon(icon, color: Colors.white, size: 22),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                content,
                                style: TextStyle(
                                  color: textColor,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  height: 1.3,
                                ),
                              ),
                            ),

                            if (onTap != null) ...[
                              const SizedBox(width: 10),
                              const Icon(
                                Icons.open_in_new,
                                color: Colors.white,
                                size: 20,
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );

    overlay.insert(overlayEntry);

    animationController.forward();

    Future.delayed(time ?? const Duration(seconds: 3), () async {
      await animationController.reverse();
      if (overlayEntry.mounted) overlayEntry.remove();
      animationController.dispose();
    });
  }
}
