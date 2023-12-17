import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:news_app/routing/router.dart';

import '../../controller/auth_sign_out_controller.dart';
import '../../providers/profile_state.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncProfile = ref.watch(profileStateProvider);

    void signOut() {
      ref.read(authSignOutControllerProvider.notifier).signOut();

      if (context.mounted) {
        context.pushReplacementNamed(AppRoute.loginScreen.name);
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Sign out?'),
                    content: const Text('Are you sure you want to sign out?'),
                    actions: [
                      TextButton(
                        onPressed: () => context.pop(),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: signOut,
                        child: const Text('Sign Out'),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
      body: asyncProfile.when(
          data: (profile) => Column(
                children: [
                  Center(
                    child: CircleAvatar(
                      radius: 60.0,
                      backgroundImage: NetworkImage(profile.profilePicture),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  Text(
                    profile.username,
                    style: const TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  Text(
                    profile.email,
                    style: const TextStyle(
                      fontSize: 16.0,
                    ),
                  ),
                ],
              ),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stacktrace) => Center(child: Text(error.toString()))),
    );
  }
}
