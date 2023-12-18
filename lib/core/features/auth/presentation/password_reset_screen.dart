import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:go_router/go_router.dart';
import 'package:news_app/core/common/auth_text_field.dart';

import '../data/auth_repository.dart';

class PasswordResetScreen extends ConsumerWidget {
  PasswordResetScreen({super.key});

  final _controller = TextEditingController();
  final _formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Password Reset'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Column(
          children: [
            FormBuilder(
              key: _formKey,
              child: AuthTextField(
                controller: _controller,
                autofocus: true,
                name: 'passwordResetEmail',
                title: 'Email',
                keyboardType: TextInputType.emailAddress,
                validator: FormBuilderValidators.email(),
                onSubmitted: (value) {
                  if (_formKey.currentState!.saveAndValidate()) {
                    ref
                        .read(authRepositoryProvider)
                        .resetPassword(_controller.text.trim());

                    // show dialog box to notify user that email has been sent
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Email Sent'),
                        content: const Text(
                            'Check your email address for a password reset link.'),
                        actions: [
                          TextButton(
                            onPressed: () => context.pop(),
                            child: const Text('OK'),
                          ),
                        ],
                      ),
                    );
                  }
                },
              ),
            ),
            const SizedBox(height: 16.0),
            const Text(
                'We will send you an email. Follow the instructions to reset your password.'),
          ],
        ),
      ),
    );
  }
}
