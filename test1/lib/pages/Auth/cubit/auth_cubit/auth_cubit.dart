import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  void submitAndGetOTP(String phoneNumber, String countryCode) async {
    emit(AuthLoading());
    FirebaseAuth _auth = FirebaseAuth.instance;

    await _auth.verifyPhoneNumber(
        verificationCompleted: (PhoneAuthCredential credential) {},
        verificationFailed: (FirebaseAuthException exception) {},
        codeSent: (String verificationCode, int? resendToken) {
          print("Received otp code $verificationCode");
          emit(AuthSuccess(verificationCode: verificationCode));
        },
        codeAutoRetrievalTimeout: (String verficationId) {},
        phoneNumber: '$countryCode $phoneNumber');
  }

  void setToAuthInitial() {
    emit(AuthInitial());
  }

  void isOTPCorrect(String verificationCode, String smsCode) async {
    try {
      PhoneAuthCredential credential = await PhoneAuthProvider.credential(
          verificationId: verificationCode, smsCode: smsCode);
      FirebaseAuth.instance.signInWithCredential(credential).then((value) {
        if (value.user != null) {
          emit(AuthSuccess(verificationCode: smsCode));

          print("Phone number verify successfully");
        } else {
          emit(AuthFailure(error: 'Phone Number Verification failed'));
          print("Phone number verification failed");
        }
      }).catchError((error) {
        emit(AuthFailure(error: 'Error during verifying phone number'));
        print("Error during verifying phone number : $error");
      });
    } catch (error) {
      emit(AuthFailure(error: 'Error during verifying phone number'));
      print("Error during verifying Phone number");
    }
  }
}
