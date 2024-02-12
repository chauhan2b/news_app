import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:news_app/core/features/auth/data/auth_repository.dart';

class EmailVerificationScreen extends ConsumerWidget {
  const EmailVerificationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Verification Email Sent',
            style: TextStyle(fontSize: 28),
          ),
          const SizedBox(height: 10),
          const Text(
            'We have sent you a verification email.\nPress on the link to continue.',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          TextButton(
            onPressed: () {
              // invalidating auth provider so we get newer instance of the user
              ref.invalidate(authRepositoryProvider);
            },
            child: const Text('Reload'),
          )
        ],
      )),
    );
  }
}
