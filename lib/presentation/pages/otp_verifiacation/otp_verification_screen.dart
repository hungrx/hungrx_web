// File: lib/presentation/pages/auth/otp_verification_screen.dart
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hungrx_web/presentation/bloc/otp_verification/otp_verification_bloc.dart';
import 'package:hungrx_web/presentation/bloc/otp_verification/otp_verification_event.dart';
import 'package:hungrx_web/presentation/bloc/otp_verification/otp_verification_state.dart';

class OtpVerificationScreen extends StatefulWidget {
  final String phoneNumber;
  final String name;

  const OtpVerificationScreen({
    super.key,
    required this.name,
    required this.phoneNumber,
  });

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final List<TextEditingController> _otpControllers = List.generate(
    6,
    (index) => TextEditingController(),
  );
  bool _canResendOtp = false;
  int _resendTimer = 30; // 30 seconds cooldown
  Timer? _timer;
  final List<FocusNode> _focusNodes = List.generate(
    6,
    (index) => FocusNode(),
  );

  @override
  void dispose() {
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    _timer?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _startResendTimer();
  }

  void _startResendTimer() {
    setState(() {
      _canResendOtp = false;
      _resendTimer = 30;
    });

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_resendTimer > 0) {
          _resendTimer--;
        } else {
          _canResendOtp = true;
          timer.cancel();
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) => OtpVerificationBloc(),
        child: BlocListener<OtpVerificationBloc, OtpVerificationState>(
          listener: (context, state) {
            if (state is OtpVerificationSuccess) {
              context.pushNamed('dashboard');
            } else if (state is OtpVerificationFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.error),
                  backgroundColor: Colors.red,
                ),
              );
              for (var controller in _otpControllers) {
                controller.clear();
              }
              // Focus on first field
              FocusScope.of(context).requestFocus(FocusNode());
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
    bool isMobile = constraints.maxWidth < 768;
    return isMobile ? _buildMobileLayout() : _buildDesktopLayout();
  }

  Widget _buildMobileLayout() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildLogoSection(),
        const SizedBox(height: 32),
        _buildOtpForm(),
      ],
    );
  }

  Widget _buildDesktopLayout() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildLogoSection(),
        _buildOtpForm(),
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
          clipBehavior: Clip.antiAlias,
          child: Image.asset(
            'assets/images/logo.png',
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
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
            fontSize: 100,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildOtpForm() {
    return Container(
      constraints: const BoxConstraints(
        maxWidth: 500,
        minWidth: 280,
      ),
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        border: Border.all(width: 2, color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'VERIFY OTP',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Enter the OTP sent to +91 ${widget.phoneNumber}',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 32),
          _buildOtpFields(),
          const SizedBox(height: 24),
          _buildVerifyButton(),
          const SizedBox(height: 16),
          _buildResendButton(),
        ],
      ),
    );
  }

  Widget _buildOtpFields() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(6, (index) => _buildOtpDigitField(index)),
    );
  }

  Widget _buildOtpDigitField(int index) {
    return SizedBox(
      width: 50,
      height: 50,
      child: TextFormField(
        controller: _otpControllers[index],
        focusNode: _focusNodes[index],
        // decoration: InputDecoration(
        //   counterText: '',
        //   border: OutlineInputBorder(
        //     borderRadius: BorderRadius.circular(15),
        //   ),
        //   contentPadding: EdgeInsets.zero,
        // ),
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        inputFormatters: [
          LengthLimitingTextInputFormatter(1),
          FilteringTextInputFormatter.digitsOnly,
        ],
        onChanged: (value) {
          if (value.isNotEmpty && index < 5) {
            _focusNodes[index + 1].requestFocus();
          } else if (value.isEmpty && index > 0) {
            _focusNodes[index - 1].requestFocus();
          }
        },
      ),
    );
  }

  Widget _buildVerifyButton() {
    return BlocBuilder<OtpVerificationBloc, OtpVerificationState>(
      builder: (context, state) {
        return ElevatedButton(
          onPressed: state is OtpVerificationLoading
              ? null
              : () {
                  final otp = _otpControllers
                      .map((controller) => controller.text)
                      .join('');
                  if (otp.length == 6) {
                    context.read<OtpVerificationBloc>().add(
                          OtpVerificationSubmitted(
                            phoneNumber: widget.phoneNumber,
                            otp: otp,
                            name: widget.name,
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
          child: state is OtpVerificationLoading
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : const Text(
                  'VERIFY',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
        );
      },
    );
  }

  Widget _buildResendButton() {
    return TextButton(
      onPressed: _canResendOtp
          ? () {
              context.read<OtpVerificationBloc>().add(
                    ResendOtpRequested(
                      phoneNumber: widget.phoneNumber,
                      name: widget.name,
                    ),
                  );
              _startResendTimer();
            }
          : null,
      child: Text(
        _canResendOtp ? 'Resend OTP' : 'Resend OTP in $_resendTimer seconds',
        style: TextStyle(
          color:
              _canResendOtp ? Theme.of(context).primaryColor : Colors.grey[600],
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
