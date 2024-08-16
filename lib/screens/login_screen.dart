import 'package:demo_chatapp/constants.dart';
import 'package:demo_chatapp/helper/show_snack_bar.dart';
import 'package:demo_chatapp/screens/chat_screen.dart';
import 'package:demo_chatapp/screens/cubits/chat_cubit/chat_cubit.dart';
import 'package:demo_chatapp/screens/cubits/login_cubit/login_cubit.dart';
import 'package:demo_chatapp/screens/cubits/login_cubit/login_state.dart';
import 'package:demo_chatapp/screens/register_screen.dart';
import 'package:demo_chatapp/widget/custom_button.dart';
import 'package:demo_chatapp/widget/custom_text_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class LoginScreen extends StatelessWidget {
  bool isLoading = false;

  static String id = 'loginScreen';

  GlobalKey<FormState> formkey = GlobalKey();

  String? email, password;
  TextEditingController controller = TextEditingController();

  LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state is LoginLoading) {
          isLoading = true;
        } else if (state is LoginSuccess) {
          BlocProvider.of<ChatCubit>(context).getMessages();
          Navigator.pushNamed(context, ChatScreen.id);
          isLoading = false;
        } else if (state is LoginFailure) {
          showSnackBar(context, state.errMessage);
          isLoading = false;
        }
      },
      child: ModalProgressHUD(
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
                  padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
                  child: Row(
                    children: [
                      Text(
                        'Login',
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
                      BlocProvider.of<LoginCubit>(context)
                          .loginUser(email: email!, password: password!);
                    }
                  },
                  text: 'LOGIN',
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'dont\'t have an account?',
                      style: TextStyle(color: kPrimaryColor),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, RegisterScreen.id);
                      },
                      child: const Text(
                        ' Register',
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
      ),
    );
  }

  Future<void> loginUser() async {
    UserCredential userCredential =
        await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email!,
      password: password!,
    );
  }
}
