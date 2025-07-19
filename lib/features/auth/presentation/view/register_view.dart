import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_application_trek_e/features/auth/presentation/view/login_view.dart';
import 'package:flutter_application_trek_e/features/auth/presentation/view_model/register_view_model/register_view_model.dart';
import 'package:flutter_application_trek_e/features/auth/presentation/view_model/register_view_model/register_event.dart';
import 'package:flutter_application_trek_e/features/auth/presentation/view_model/register_view_model/register_state.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController    = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  void _handleSignup(BuildContext context) {
    final username = _usernameController.text.trim();
    final email    = _emailController.text.trim();
    final password = _passwordController.text;
    final confirm  = _confirmPasswordController.text;

    if (username.isEmpty || email.isEmpty || password.isEmpty || confirm.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all the fields'), backgroundColor: Colors.red),
      );
    } else if (password != confirm) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Passwords do not match'), backgroundColor: Colors.red),
      );
    } else {
      // Dispatch Bloc event
      context.read<RegisterViewModel>().add(
        RegisterUserEvent(
          context: context,
          email: email,
          username: username,
          password: password,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterViewModel, RegisterState>(
      builder: (context, state) {
        return Scaffold(
          resizeToAvoidBottomInset: true,
          body: Stack(
            children: [
              Container(
                height: double.infinity,
                width: double.infinity,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color.fromARGB(255, 217, 51, 13),
                      Color.fromARGB(255, 12, 16, 12),
                    ],
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(top: 60, left: 22),
                child: Text(
                  "Sign up",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 40, color: Colors.white),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 200),
                child: Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    child: SingleChildScrollView(
                      padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
                      ),
                      child: Column(
                        children: [
                          const SizedBox(height: 30),
                          const Align(
                            alignment: Alignment.topLeft,
                            child: Text("New Account", style: TextStyle(fontSize: 30, color: Colors.black)),
                          ),
                          const SizedBox(height: 20),
                          TextField(
                            controller: _usernameController,
                            decoration: const InputDecoration(
                              suffixIcon: Icon(Icons.check, color: Colors.grey),
                              label: Text("Username", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.black)),
                            ),
                          ),
                          TextField(
                            controller: _emailController,
                            decoration: const InputDecoration(
                              suffixIcon: Icon(Icons.check, color: Colors.grey),
                              label: Text("Email", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.black)),
                            ),
                          ),
                          TextField(
                            controller: _passwordController,
                            obscureText: true,
                            decoration: const InputDecoration(
                              suffixIcon: Icon(Icons.visibility_off, color: Colors.grey),
                              label: Text("Password", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.black)),
                            ),
                          ),
                          TextField(
                            controller: _confirmPasswordController,
                            obscureText: true,
                            decoration: const InputDecoration(
                              suffixIcon: Icon(Icons.visibility_off, color: Colors.grey),
                              label: Text("Confirm Password", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.black)),
                            ),
                          ),
                          const SizedBox(height: 70),
                          GestureDetector(
                            key: const Key('signUpButton'),
                            onTap: state.isLoading ? null : () => _handleSignup(context),
                            child: Container(
                              height: 50,
                              width: 300,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                gradient: const LinearGradient(
                                  colors: [
                                    Color.fromARGB(255, 217, 51, 13),
                                    Color.fromARGB(255, 12, 16, 12),
                                  ],
                                ),
                              ),
                              child: Center(
                                child: state.isLoading
                                  ? const CircularProgressIndicator(color: Colors.white)
                                  : const Text(
                                      "Sign Up",
                                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30, color: Colors.white),
                                    ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 100),
                          Align(
                            alignment: Alignment.bottomRight,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                const Text(
                                  "Already Have An Account?",
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.grey),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => const LoginView()),
                                    );
                                  },
                                  child: const Text(
                                    "Sign In",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                      color: Colors.black,
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
