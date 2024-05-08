import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:form_validator/form_validator.dart';
import 'package:get/get.dart';
import 'package:threads_clone/controllers/auth_controller.dart';
import 'package:threads_clone/routes/route_name.dart';
import 'package:threads_clone/widgets/auth_input.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  var authController = Get.put(AuthController());

  @override
  void dispose() {
    passwordController.dispose();
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Image.asset(
                      'assets/images/logo.png',
                      height: 80,
                      width: 80,
                    ),
                    // const SizedBox(height: 20),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Login",
                            style: TextStyle(
                                fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                          Text("Welcome back"),
                          const SizedBox(height: 10),
                          AuthInput(
                            validator: ValidationBuilder()
                                .required()
                                .email()
                                .maxLength(50)
                                .build(),
                            controller: emailController,
                            label: "Email",
                            hintText: "Enter your email",
                          ),
                          const SizedBox(height: 10),
                          AuthInput(
                            validator: ValidationBuilder()
                                .required()
                                .minLength(6)
                                .maxLength(50)
                                .build(),
                            controller: passwordController,
                            isPassword: true,
                            label: "Password",
                            hintText: "Enter your password",
                          ),
                          const SizedBox(height: 20),
                          Obx(() => ElevatedButton(
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    authController.loginUser(
                                        email: emailController.text.trim(),
                                        password:
                                            passwordController.text.trim());
                                  }
                                },
                                child: authController.loginLoading.value
                                    ? Center(
                                        child: CircularProgressIndicator(
                                          color: Colors.black,
                                        ),
                                      )
                                    : Text("Login"),
                                style: ElevatedButton.styleFrom(
                                  minimumSize: Size(double.infinity, 50),
                                ),
                              )),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                    Text.rich(TextSpan(
                      text: "Don't have an account? ",
                      children: [
                        TextSpan(
                          text: "Register",
                          style: TextStyle(
                            // color: Colors.blue,
                            fontWeight: FontWeight.bold,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () => Get.toNamed(RouteNames.register),
                        )
                      ],
                    ))
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
