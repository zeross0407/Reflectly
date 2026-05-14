import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:myrefectly/core/animation/spread_out_animation.dart';
import 'package:myrefectly/features/auth/presentation/bloc/forgot_password/forgot_password_bloc.dart';
import 'package:myrefectly/features/auth/presentation/bloc/forgot_password/forgot_password_event.dart';
import 'package:myrefectly/features/auth/presentation/bloc/forgot_password/forgot_password_state.dart';
import 'package:myrefectly/features/auth/presentation/widget/notification_popup.dart';

class ResetPasswordDialog extends StatefulWidget {
  const ResetPasswordDialog({super.key});

  @override
  State<ResetPasswordDialog> createState() => _ResetPasswordDialogState();
}

class _ResetPasswordDialogState extends State<ResetPasswordDialog> {
  String _email = '';

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;

    return BlocListener<ForgotPasswordBloc, ForgotPasswordState>(
      listener: (context, state) {
        if (state is ForgotPasswordCodeSent) {
          showNotificationPopup(
            context,
            'Password reset email sent! Check your inbox.',
            Colors.green[400],
          );
          Navigator.pop(context);
        } else if (state is ForgotPasswordFailure) {
          showNotificationPopup(context, state.message, Colors.red[400]);
        }
      },
      child: AlertDialog(
        backgroundColor: Colors.white,
        title: const Text(
          'RESET PASSWORD',
          style: TextStyle(
            fontFamily: 'Google',
            color: Colors.red,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
          textAlign: TextAlign.center,
        ),
        contentPadding: EdgeInsets.zero,
        content: SizedBox(
          height: screenWidth * 0.6,
          width: screenWidth * 0.8,
          child: Padding(
            padding: EdgeInsets.all(screenWidth * 0.05),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Enter your email address and we will send you a link to reset your password.',
                  textAlign: TextAlign.start,
                  style: TextStyle(fontFamily: 'Google'),
                ),
                const SizedBox(height: 20),
                Flexible(
                  child: TextField(
                    onChanged: (value) => _email = value,
                    decoration: InputDecoration(
                      hintText: 'Email...',
                      hintStyle: const TextStyle(fontFamily: 'Google'),
                      border: InputBorder.none,
                      filled: true,
                      fillColor: Colors.grey[200],
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 20,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: Colors.transparent),
                        borderRadius: BorderRadius.circular(7),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: Colors.transparent),
                        borderRadius: BorderRadius.circular(7),
                      ),
                    ),
                    style: const TextStyle(fontFamily: 'Google'),
                  ),
                ),
              ],
            ),
          ),
        ),
        actionsAlignment: MainAxisAlignment.spaceEvenly,
        actions: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const Icon(Icons.close),
          ),
          SizedBox(width: screenWidth * 0.1),
          BlocBuilder<ForgotPasswordBloc, ForgotPasswordState>(
            builder: (context, state) {
              final isLoading = state is ForgotPasswordLoading;
              return GestureDetector(
                onTap: () {
                  if (!isLoading) {
                    context.read<ForgotPasswordBloc>().add(
                          ResetCodeRequested(email: _email),
                        );
                  }
                },
                child: isLoading
                    ? RotatingSvgIcon()
                    : const Icon(Icons.check),
              );
            },
          ),
        ],
      ),
    );
  }
}
