import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hungrx_web/presentation/bloc/login_page/login_page_bloc.dart';
import 'package:hungrx_web/presentation/bloc/login_page/login_page_event.dart';
import 'package:hungrx_web/presentation/bloc/login_page/login_page_state.dart';

class PhoneLoginScreen extends StatefulWidget {
  const PhoneLoginScreen({super.key});

  @override
  State<PhoneLoginScreen> createState() => _PhoneLoginScreenState();
}

class _PhoneLoginScreenState extends State<PhoneLoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) => PhoneLoginBloc(),
        child: BlocListener<PhoneLoginBloc, PhoneLoginState>(
          listener: (context, state) {
            if (state is PhoneLoginSuccess) {
              context.pushNamed(
                'otpVerify',
                pathParameters: {
                  'phoneNumber': state.phoneNumber,
                  'name': state.name,
                },
              );
            } else if (state is PhoneLoginFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.error)),
              );
            }
          },
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                child: Container(
                  width: constraints.maxWidth,
                  height: constraints.maxHeight,
                  padding: EdgeInsets.symmetric(
                    horizontal: constraints.maxWidth * 0.05,
                    vertical: 24,
                  ),
                  child: _buildResponsiveContent(constraints),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildResponsiveContent(BoxConstraints constraints) {
    // Determine if we should use mobile layout
    bool isMobile = constraints.maxWidth < 768;

    if (isMobile) {
      return _buildMobileLayout();
    } else {
      return _buildDesktopLayout(constraints);
    }
  }

  Widget _buildMobileLayout() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildLogoSection(),
        const SizedBox(height: 32),
        _buildLoginForm(),
      ],
    );
  }

  Widget _buildDesktopLayout(BoxConstraints constraints) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildLogoSection(),
        _buildLoginForm(),
      ],
    );
  }

  Widget _buildLogoSection() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 190,
          height: 190,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
          ),
          clipBehavior:
              Clip.antiAlias, // Add this to ensure image stays within circle
          child: Image.asset(
            'assets/images/logo.png',
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              // Fallback widget when image fails to load
              return const Icon(
                Icons.restaurant,
                size: 60,
                color: Colors.black,
              );
            },
          ),
        ),
        const SizedBox(height: 24),
        const Text(
          'hungrX',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 80,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildLoginForm() {
    return Container(
      constraints: const BoxConstraints(
        maxWidth: 500, // Maximum width for the form
        minWidth: 280, // Minimum width for the form
      ),
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        border: Border.all(width: 2, color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'LOGIN NOW',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 32),
            _buildTextField(
              controller: _nameController,
              prefixText: '       ',
              hintText: 'ENTER YOUR NAME',
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your name';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: _phoneController,
              hintText: 'ENTER YOUR MOBILE NUMBER',
              prefixText: '+91 ',
              keyboardType: TextInputType.phone,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your phone number';
                }
                if (value.length != 10) {
                  return 'Please enter a valid 10-digit phone number';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),
            _buildSubmitButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    String? prefixText,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hintText,
        prefixText: prefixText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 16,
        ),
      ),
      validator: validator,
    );
  }

  Widget _buildSubmitButton() {
    return BlocBuilder<PhoneLoginBloc, PhoneLoginState>(
      builder: (context, state) {
        return ElevatedButton(
          onPressed: state is PhoneLoginLoading
              ? null
              : () {
                  if (_formKey.currentState?.validate() ?? false) {
                    context.read<PhoneLoginBloc>().add(
                          PhoneLoginSubmitted(
                            name: _nameController.text,
                            phoneNumber: _phoneController.text,
                          ),
                        );
                  }
                },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
          child: state is PhoneLoginLoading
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : const Text(
                  'SEND OTP',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
        );
      },
    );
  }
}
