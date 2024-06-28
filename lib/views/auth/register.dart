import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:form_validator/form_validator.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:threads_clone/controllers/auth_controller.dart';
import 'package:threads_clone/routes/route_name.dart';
import 'package:threads_clone/utils/helper.dart';
import 'package:threads_clone/widgets/auth_input.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var cpasswordController = TextEditingController();
  var userNameController = TextEditingController();
  var nameController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  var authController = Get.put(AuthController());

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
    userNameController.dispose();
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
                          const Text(
                            "Register",
                            style: TextStyle(
                                fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                          const Text("Welcome to the threads world"),
                          const SizedBox(height: 10),
                          AuthInput(
                            validator: ValidationBuilder()
                                .required()
                                .minLength(3)
                                .maxLength(50)
                                .build(),
                            controller: nameController,
                            label: "Name",
                            hintText: "Enter your name",
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Obx(
                            () => AuthInput(
                              validator: ValidationBuilder()
                                  .required()
                                  .minLength(3)
                                  .maxLength(50)
                                  .build(),
                              controller: userNameController,
                              isUnique: authController.isUnique.value,
                              onChanged: (value) {
                                if (value.length >= 3) {
                                  authController.checkUserName(value);
                                }
                              },
                              isUsername: true,
                              label: "Username",
                              hintText: "Enter your username",
                            ),
                          ),
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
                          const SizedBox(height: 10),
                          AuthInput(
                            validator: (value) =>
                                (value != passwordController.text)
                                    ? "Password does not match"
                                    : null,
                            controller: cpasswordController,
                            isPassword: true,
                            label: "Confirm Password",
                            hintText: "Enter your confirm password",
                          ),
                          const SizedBox(height: 20),
                          Obx(
                            () => ElevatedButton(
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  if (authController.isUnique.value) {
                                    authController.register(
                                        username:
                                            userNameController.text.trim(),
                                        name: nameController.text.trim(),
                                        email: emailController.text.trim(),
                                        password:
                                            passwordController.text.trim());
                                  } else {
                                    showSnackBar(
                                        title: "Error",
                                        message: "Username should be unique");
                                  }
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                minimumSize: const Size(double.infinity, 50),
                              ),
                              child: authController.registerLoading.value
                                  ? const Center(
                                      child: CircularProgressIndicator(
                                        color: Colors.black,
                                      ),
                                    )
                                  : const Text("Register"),
                            ),
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                    Text.rich(TextSpan(
                      text: "Have an account? ",
                      children: [
                        TextSpan(
                          text: "Login",
                          style: const TextStyle(
                            // color: Colors.blue,
                            fontWeight: FontWeight.bold,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () => Get.toNamed(RouteNames.login),
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
