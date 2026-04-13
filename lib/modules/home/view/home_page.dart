import 'package:flutter/material.dart';
import 'package:mobile_ots/misc/colors.dart';
import 'package:mobile_ots/misc/text_style.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const HomeView();
  }
}

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.whiteColor,
        centerTitle: true,
        title: Text(
          'Pilih Kategori',
          style: AppTextStyles.textStyleBold.copyWith(
            color: AppColors.blackColor,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              // TODO: action tambah kategori
            },
            icon: Icon(Icons.add, color: AppColors.blackColor, size: 28),
          ),
        ],
      ),
      body: Stack(
        children: [
          Center(
            child: Text(
              'belum ada kategori',
              style: AppTextStyles.textStyleNormal.copyWith(
                color: AppColors.greyColor,
              ),
            ),
          ),
          Positioned(
            bottom: 100,
            left: 0,
            right: 0,
            child: Opacity(
              opacity: 0.5,
              child: Image.asset(
                "assets/images/logo.png",
                fit: BoxFit.contain,
                height: 50,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
