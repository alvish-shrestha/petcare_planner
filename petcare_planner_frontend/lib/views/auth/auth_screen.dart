import 'package:flutter/material.dart';
import 'package:petcare_planner_frontend/view_models/auth_view_model.dart';
import 'package:petcare_planner_frontend/views/auth/login.dart';
import 'package:petcare_planner_frontend/views/auth/register.dart';
import 'package:provider/provider.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool isLogin = true;

  // --- Controllers for Login ---
  final TextEditingController loginEmailController = TextEditingController();
  final TextEditingController loginPasswordController = TextEditingController();

  // --- Controllers for Register ---
  final TextEditingController regUsernameController = TextEditingController();
  final TextEditingController regEmailController = TextEditingController();
  final TextEditingController regPasswordController = TextEditingController();
  final TextEditingController regConfirmPasswordController =
      TextEditingController();

  @override
  void dispose() {
    loginEmailController.dispose();
    loginPasswordController.dispose();

    regUsernameController.dispose();
    regEmailController.dispose();
    regPasswordController.dispose();
    regConfirmPasswordController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authVM = Provider.of<AuthViewModel>(context);
    return Scaffold(
      backgroundColor: const Color(0xFFF7EDD9),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              physics: ClampingScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Column(
                    children: [
                      const SizedBox(height: 45),

                      /// --- App Title ---
                      const Text(
                        "PetCare Planner",
                        style: TextStyle(
                          fontFamily: "Poppins-Bold",
                          fontSize: 36,
                          color: Color(0xFF725E5E),
                        ),
                      ),

                      const SizedBox(height: 20),

                      /// --- Toggle Buttons ---
                      _buildToggle(),

                      const SizedBox(height: 10),

                      /// --- Forms ---
                      Flexible(
                        fit: FlexFit.loose,
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 300),
                          switchInCurve: Curves.easeOut,
                          switchOutCurve: Curves.easeIn,
                          transitionBuilder: (child, animation) {
                            final isLogin =
                                child.key == const ValueKey("login");

                            final offsetAnimation = Tween<Offset>(
                              begin: isLogin
                                  ? const Offset(-1, 0)
                                  : const Offset(1, 0),
                              end: Offset.zero,
                            ).animate(animation);

                            return SlideTransition(
                              position: offsetAnimation,
                              child: child,
                            );
                          },
                          child: isLogin
                              ? LoginForm(
                                  key: const ValueKey("login"),
                                  onLoginSuccess: () {
                                    // Navigate on success, e.g.
                                    // Navigator.pushReplacementNamed(
                                    //   context,
                                    //   '/home',
                                    // );
                                    print("Login Successful");
                                  },
                                  emailController: loginEmailController,
                                  passwordController: loginPasswordController,
                                  authViewModel: authVM,
                                )
                              : RegisterForm(
                                  key: const ValueKey("register"),
                                  onRegisterSuccess: () {
                                    setState(() {
                                      isLogin = true;
                                    });
                                  },
                                  usernameController: regUsernameController,
                                  emailController: regEmailController,
                                  passwordController: regPasswordController,
                                  confirmPasswordController:
                                      regConfirmPasswordController,
                                  authViewModel: authVM,
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildToggle() {
    return Container(
      height: 48,
      width: 364,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Color(0xFFF7EDD9),
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: const Color(0x4D000000),
            offset: const Offset(0, 4),
            blurRadius: 4,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Row(
        children: [
          _toggleButton("Login", isLogin),
          _toggleButton("Register", !isLogin),
        ],
      ),
    );
  }

  Widget _toggleButton(String text, bool active) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            isLogin = text == "Login";
          });
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: active ? const Color(0xFF7BAF9E) : Colors.transparent,
            borderRadius: BorderRadius.circular(25),
          ),
          child: Text(
            text,
            style: TextStyle(
              fontFamily: "Poppins-Bold",
              color: active ? Colors.white : const Color(0xFF725E5E),
            ),
          ),
        ),
      ),
    );
  }
}
