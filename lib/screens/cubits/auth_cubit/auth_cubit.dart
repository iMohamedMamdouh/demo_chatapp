import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  Future<void> loginUser(
      {required String email, required String password}) async {
    emit(LoginLoading());
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      emit(LoginSuccess());
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        emit(
          LoginFailure(
            errMessage: 'No user found for that email.',
          ),
        );
      } else if (e.code == 'wrong-password') {
        emit(
          LoginFailure(errMessage: 'Wrong password provided for that user.'),
        );
      } else {
        emit(LoginFailure(errMessage: 'some error occurred.'));
      }
    }
  }

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
