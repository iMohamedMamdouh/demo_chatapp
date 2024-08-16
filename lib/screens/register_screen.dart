import 'package:demo_chatapp/constants.dart';
import 'package:demo_chatapp/helper/show_snack_bar.dart';
import 'package:demo_chatapp/screens/chat_screen.dart';
import 'package:demo_chatapp/screens/cubits/auth_cubit/auth_cubit.dart';
import 'package:demo_chatapp/widget/custom_button.dart';
import 'package:demo_chatapp/widget/custom_text_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class RegisterScreen extends StatelessWidget {
  static String id = 'registerScreen';
  String? email;

  String? password;

  bool isLoading = false;

  GlobalKey<FormState> formkey = GlobalKey();

  RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is RegisterLoading) {
          isLoading = true;
        } else if (state is RegisterSuccess) {
          Navigator.pushNamed(context, ChatScreen.id);
          isLoading = false;
        } else if (state is RegisterFailure) {
          showSnackBar(context, state.errMessage);
          isLoading = false;
        }
      },
      builder: (context, state) {
        return ModalProgressHUD(
          inAsyncCall: isLoading,
          child: Scaffold(
            backgroundColor: Colors.white,
            body: Form(
              key: formkey,
              child: ListView(
                children: [
                  const SizedBox(
                    height: 90,
                  ),
                  const Icon(
                    Icons.chat,
                    size: 80,
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Demo Chat ',
                        style: TextStyle(fontSize: 30),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  const Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
                    child: Row(
                      children: [
                        Text(
                          'Register',
                          style: TextStyle(fontSize: 30),
                        ),
                      ],
                    ),
                  ),
                  CustomFormTextField(
                    onChanged: (data) {
                      email = data;
                    },
                    hintText: 'Email',
                  ),
                  CustomFormTextField(
                    onChanged: (data) {
                      password = data;
                    },
                    hintText: 'Password',
                    obscureText: true,
                  ),
                  CustomButton(
                    onTap: () async {
                      if (formkey.currentState!.validate()) {
                        BlocProvider.of<AuthCubit>(context).registerUser(
                          email: email!,
                          password: password!,
                        );
                      }
                    },
                    text: 'REGISTER',
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Already have an account?',
                        style: TextStyle(color: kPrimaryColor),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: const Text(
                          ' Login',
                          style: TextStyle(
                            color: kPrimaryColor,
                            fontSize: 16,
                            fontFamily: 'poppins',
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> registerUser() async {
    UserCredential userCredential =
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email!,
      password: password!,
    );
  }
}
