import 'package:demo_chatapp/firebase_options.dart';
import 'package:demo_chatapp/screens/chat_screen.dart';
import 'package:demo_chatapp/screens/cubits/auth_cubit/auth_cubit.dart';
import 'package:demo_chatapp/screens/cubits/chat_cubit/chat_cubit.dart';
import 'package:demo_chatapp/screens/login_screen.dart';
import 'package:demo_chatapp/screens/register_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const DemoChat());
}

class DemoChat extends StatelessWidget {
  const DemoChat({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AuthCubit()),
        BlocProvider(create: (context) => ChatCubit()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        routes: {
          LoginScreen.id: (context) => LoginScreen(),
          RegisterScreen.id: (context) => RegisterScreen(),
          ChatScreen.id: (context) => ChatScreen(),
        },
        initialRoute: LoginScreen.id,
      ),
    );
  }
}
