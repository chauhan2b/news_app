import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:news_app/core/features/auth/data/auth_register_provider.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:news_app/core/routing/router.dart';

import '../../../common/auth_text_field.dart';
import 'controller/auth_sign_in_controller.dart';

class LoginScreen extends ConsumerWidget {
  LoginScreen({super.key});

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    bool isRegister = ref.watch(authRegisterProvider);
    final authController = ref.watch(authSignInControllerProvider);

    void signIn() async {
      if (_formKey.currentState!.saveAndValidate()) {
        await ref.read(authSignInControllerProvider.notifier).signIn(
              _emailController.text.trim(),
              _passwordController.text.trim(),
            );

        if (context.mounted) {
          context.pushReplacementNamed(AppRoute.homeScreen.name);
        }
      }
    }

    void register() async {
      if (_formKey.currentState!.saveAndValidate()) {
        await ref.read(authSignInControllerProvider.notifier).register(
              _emailController.text.trim(),
              _passwordController.text.trim(),
              _confirmPasswordController.text.trim(),
            );

        if (context.mounted) {
          context.pushReplacementNamed(AppRoute.homeScreen.name);
        }
      }
    }

    // show alert dialog when there is an error
    ref.listen<AsyncValue>(authSignInControllerProvider, (_, state) {
      if (!state.isLoading && state.hasError) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(isRegister ? 'Register failed' : 'Login failed'),
            content: Text(state.error.toString()),
            actions: [
              TextButton(
                onPressed: () => context.pop(),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    });

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Center(
          child: SingleChildScrollView(
            child: FormBuilder(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    isRegister ? 'Welcome to News App!' : 'Hey! Welcome back',
                    style: const TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 50),
                  AuthTextField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    title: 'Email',
                    name: 'email',
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(),
                      FormBuilderValidators.email(),
                    ]),
                  ),
                  const SizedBox(height: 16.0),
                  AuthTextField(
                    controller: _passwordController,
                    obscureText: true,
                    title: 'Password',
                    name: 'password',
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(),
                      FormBuilderValidators.minLength(6),
                    ]),
                  ),
                  const SizedBox(height: 16.0),
                  Visibility(
                    visible: isRegister,
                    child: AuthTextField(
                      controller: _confirmPasswordController,
                      obscureText: true,
                      title: 'Confirm Password',
                      name: 'confirmPassword',
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(),
                        (value) {
                          if (value != _passwordController.text.trim()) {
                            return 'Password do not match';
                          } else {
                            return null;
                          }
                        }
                      ]),
                    ),
                  ),
                  isRegister ? const SizedBox(height: 16.0) : const SizedBox(),
                  Visibility(
                    visible: !isRegister,
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: GestureDetector(
                        onTap: () {
                          context.pushNamed(AppRoute.passwordReset.name);
                        },
                        child: Text(
                          'Forgot password?',
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.primary),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  authController.isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : FilledButton(
                          onPressed: () => isRegister ? register() : signIn(),
                          style: ButtonStyle(
                            shape: MaterialStateProperty.all(
                              const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                              ),
                            ),
                            minimumSize: MaterialStateProperty.all(
                              const Size(double.infinity, 60),
                            ),
                            textStyle: MaterialStateProperty.all(
                              const TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          child: Text(isRegister ? 'REGISTER' : 'LOGIN'),
                        ),
                  const SizedBox(height: 16.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(isRegister
                          ? 'Already have an account?'
                          : 'Don\'t have an account?'),
                      TextButton(
                        onPressed: () {
                          ref
                              .read(authRegisterProvider.notifier)
                              .toggleRegister();
                          // reset errors when switching between login and register
                          // _formKey.currentState!.reset();
                        },
                        child: Text(
                          isRegister ? 'Login' : 'Register',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
