import 'package:bloc/bloc.dart';
import 'package:demo_chatapp/screens/cubits/register_cubit/register_state.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegisterCubit extends Cubit<RegisterState> {
  RegisterCubit() : super(RegisterInitial());

  Future<void> registerUser(
      {required String email, required String password}) async {
    emit(RegisterLoading());
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      emit(RegisterSuccess());
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        emit(
          RegisterFailure(
            errMessage: 'The password provided is too weak.',
          ),
        );
      } else if (e.code == 'emiail-already-in-use') {
        emit(
          RegisterFailure(
              errMessage: 'The account already exists for that email.'),
        );
      } else {
        emit(RegisterFailure(errMessage: 'Something went wrong'));
      }
    }
  }
}
