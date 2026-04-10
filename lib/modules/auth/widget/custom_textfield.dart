part of '../view/auth_page.dart';

class CustomTextfieldLogin extends StatelessWidget {
  const CustomTextfieldLogin({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(children: [_FieldEmailLogin(), _FieldPasswordLogin()]);
  }
}

class _FieldEmailLogin extends StatelessWidget {
  const _FieldEmailLogin();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        return _buildTextFormFieldLogin(
          label: 'Username',
          keyboardType: TextInputType.emailAddress,
          controller: context.read<AuthCubit>().emailController,
          onChanged: (value) {
            context.read<AuthCubit>().onChanged(email: value);
          },

          inputFormatters: [FilteringTextInputFormatter.deny(RegExp(r'\s'))],
        );
      },
    );
  }
}

class _FieldPasswordLogin extends StatelessWidget {
  const _FieldPasswordLogin();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        return _buildTextFormFieldPasswordLogin(
          label: 'Password',
          onChanged: (value) {
            context.read<AuthCubit>().onChanged(password: value);
          },
          onToggle: () => context.read<AuthCubit>().togglePasswordVisibility(),
          isObscured: !state.isPasswordVisible,
          controller: context.read<AuthCubit>().passController,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Password tidak boleh kosong';
            }
            if (value.length < 8) {
              return 'Password minimal 8 karakter';
            }
            return null;
          },
        );
      },
    );
  }
}

Widget _buildTextFormFieldLogin({
  required String label,
  required ValueChanged<String> onChanged,
  TextInputType keyboardType = TextInputType.text,
  String? initialValue,
  List<TextInputFormatter>? inputFormatters,
  int? maxLength,
  bool obscureText = false,
  bool readOnly = false,
  String? Function(String?)? validator,
  TextEditingController? controller,
}) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 5),
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.whiteColor.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 2,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextFormField(
        validator: validator,
        controller: controller,
        obscureText: obscureText,
        maxLength: maxLength,
        initialValue: initialValue,
        keyboardType: keyboardType,
        onChanged: onChanged,
        inputFormatters: inputFormatters,
        readOnly: readOnly,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        style: AppTextStyles.textStyleNormal.copyWith(
          color: AppColors.blackColor,
          fontWeight: FontWeight.normal,
          fontSize: 14,
        ),
        decoration: InputDecoration(
          hintText: label,
          hintStyle: AppTextStyles.textStyleNormal.copyWith(
            color: AppColors.greyColor,
            fontWeight: FontWeight.normal,
            fontSize: 14,
          ),
          filled: true,
          fillColor: AppColors.whiteColor,
          contentPadding: const EdgeInsets.symmetric(
            vertical: 14,
            horizontal: 16,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
          counterText: "",
        ),
      ),
    ),
  );
}

Widget _buildTextFormFieldPasswordLogin({
  required String label,
  required ValueChanged<String> onChanged,
  required bool isObscured,
  String? Function(String?)? validator,
  TextEditingController? controller,
  required VoidCallback onToggle,
}) {
  return Padding(
    padding: EdgeInsets.only(bottom: 12),
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.whiteColor.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 2,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextFormField(
        obscureText: isObscured,
        onChanged: onChanged,
        validator: validator,
        controller: controller,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        style: AppTextStyles.textStyleNormal.copyWith(
          color: AppColors.blackColor,
          fontWeight: FontWeight.normal,
          fontSize: 14,
        ),
        decoration: InputDecoration(
          hintText: label,
          hintStyle: AppTextStyles.textStyleNormal.copyWith(
            color: AppColors.greyColor,
            fontWeight: FontWeight.normal,
            fontSize: 14,
          ),
          filled: true,
          fillColor: AppColors.whiteColor,
          contentPadding: const EdgeInsets.symmetric(
            vertical: 14,
            horizontal: 16,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
          counterText: "",
          suffixIcon: IconButton(
            icon: Icon(
              isObscured ? Icons.visibility_off : Icons.visibility,
              color: AppColors.greyColor,
            ),
            onPressed: onToggle,
          ),
        ),
      ),
    ),
  );
}
