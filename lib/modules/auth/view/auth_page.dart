import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_ots/router/builder.dart';
import '../../../misc/text_style.dart';
import '../../../widgets/button/custom_button.dart';

import '../../../misc/colors.dart';
import '../cubit/auth_cubit.dart';

part '../widget/custom_textfield.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthCubit>(
      create: (context) => AuthCubit(),
      child: const AuthView(),
    );
  }
}

class AuthView extends StatelessWidget {
  const AuthView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColors.whiteColor,
          body: Stack(
            children: [
              Container(color: AppColors.whiteColor),
              Container(
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    center: Alignment.topLeft,
                    radius: 0.7,
                    colors: [
                      AppColors.secondaryColor.withValues(alpha: 0.5),
                      AppColors.whiteColor.withValues(alpha: 0.5),
                    ],
                  ),
                ),
              ),

              Container(
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    center: Alignment.centerRight,
                    radius: 1.5,
                    colors: [
                      AppColors.secondaryColor.withValues(alpha: 0.5),
                      AppColors.whiteColor.withValues(alpha: 0),
                    ],
                  ),
                ),
              ),

              SafeArea(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          minHeight: constraints.maxHeight,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: constraints.maxHeight * 0.5,
                              child: Center(
                                child: Image.asset(
                                  "assets/images/logo.png",
                                  height: 60,
                                ),
                              ),
                            ),
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CustomTextfieldLogin(),
                                  CustomButton(
                                    backgroundColor: AppColors.secondaryColor,
                                    textColor: AppColors.whiteColor,
                                    borderRadius: 8,
                                    isLoading: state.loading,
                                    label: "Masuk",
                                    onPressed: () {
                                      // TODO : LOGIN
                                      HomeRoutes().go(context);
                                    },
                                  ),

                                  const SizedBox(height: 30),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
