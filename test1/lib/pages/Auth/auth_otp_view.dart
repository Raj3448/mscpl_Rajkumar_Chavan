import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test1/constant/app_theme.dart';
import 'package:test1/pages/Auth/cubit/auth_cubit/auth_cubit.dart';
import 'package:zapx/zapx.dart';

class AuthOtpView extends StatefulWidget {
  final String verificationCode;

  (String countryCode, String mobileNo) mobileNumberDetails;
  AuthOtpView(
      {Key? key,
      required this.mobileNumberDetails,
      required this.verificationCode})
      : super(key: key);

  @override
  State<AuthOtpView> createState() => _AuthOtpViewState();
}

class _AuthOtpViewState extends State<AuthOtpView>
    with SingleTickerProviderStateMixin {
  late List<FocusNode> _focusNodes;
  late List<TextEditingController> _controllers;
  final int _otpLength = 6;
  bool _isVerify = false;

  int _remainingSeconds = 170;

  void _updateRemainingSeconds(Timer timer) {
    if (_remainingSeconds > 0) {
      setState(() {
        _remainingSeconds--;
      });
    }
  }

  formattedTime({required int timeInSecond}) {
    int sec = timeInSecond % 60;
    int min = (timeInSecond / 60).floor();
    String minute = min.toString().length <= 1 ? "0$min" : "$min";
    String second = sec.toString().length <= 1 ? "0$sec" : "$sec";
    return "$minute : $second";
  }

  late AnimationController _animatedcontroller;
  late Animation<Alignment> _topAlignmentAnimation;
  late Animation<Alignment> _bottomAlignmentAnimation;

  int currentIndex = 0;
  @override
  void initState() {
    super.initState();
    _focusNodes = List.generate(_otpLength, (index) => FocusNode());
    _controllers =
        List.generate(_otpLength, (index) => TextEditingController());
    Timer.periodic(const Duration(seconds: 1), _updateRemainingSeconds);

    _animatedcontroller =
        AnimationController(vsync: this, duration: const Duration(seconds: 2));

    _topAlignmentAnimation = TweenSequence<Alignment>([
      TweenSequenceItem<Alignment>(
          tween: Tween<Alignment>(
              begin: Alignment.topLeft, end: Alignment.topRight),
          weight: 1),
      TweenSequenceItem<Alignment>(
          tween: Tween<Alignment>(
              begin: Alignment.topRight, end: Alignment.bottomRight),
          weight: 1),
      TweenSequenceItem<Alignment>(
          tween: Tween<Alignment>(
              begin: Alignment.bottomRight, end: Alignment.bottomLeft),
          weight: 1),
      TweenSequenceItem<Alignment>(
          tween: Tween<Alignment>(
              begin: Alignment.bottomLeft, end: Alignment.topLeft),
          weight: 1),
    ]).animate(_animatedcontroller);

    _bottomAlignmentAnimation = TweenSequence<Alignment>([
      TweenSequenceItem<Alignment>(
          tween: Tween<Alignment>(
              begin: Alignment.bottomRight, end: Alignment.bottomLeft),
          weight: 1),
      TweenSequenceItem<Alignment>(
          tween: Tween<Alignment>(
              begin: Alignment.bottomLeft, end: Alignment.topLeft),
          weight: 1),
      TweenSequenceItem<Alignment>(
          tween: Tween<Alignment>(
              begin: Alignment.topLeft, end: Alignment.topRight),
          weight: 1),
      TweenSequenceItem<Alignment>(
          tween: Tween<Alignment>(
              begin: Alignment.topRight, end: Alignment.bottomRight),
          weight: 1),
    ]).animate(_animatedcontroller);

    _animatedcontroller.repeat();
  }

  @override
  void dispose() {
    for (int i = 0; i < _otpLength; i++) {
      _focusNodes[i].dispose();
      _controllers[i].dispose();
    }
    _animatedcontroller.dispose();
    super.dispose();
  }

  int isCorrectOTP = 0;
  String generateOTP = '';

  void _onDigitInput(int index, String value, BuildContext context) async {
    if (value.isNotEmpty) {
      generateOTP += value;
      if (index < _otpLength - 1) {
        FocusScope.of(context).requestFocus(_focusNodes[index + 1]);
      } else {
        _focusNodes[index].unfocus();

        context
            .read<AuthCubit>()
            .isOTPCorrect(widget.verificationCode, generateOTP);
        print(generateOTP);
        generateOTP = '';
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xfffaf9f6),
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(Icons.arrow_back_ios_new_rounded)),
        centerTitle: true,
      ),
      resizeToAvoidBottomInset: false,
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
        
        },
        builder: (context, state) {
          return Container(
            color: const Color(0xfffaf9f6),
            height: MediaQuery.of(context).size.height,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Verify your phone',
                      style: Theme.of(context).textTheme.displayLarge,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Enter the verification code sent to  ${widget.mobileNumberDetails.$1} ${widget.mobileNumberDetails.$2}',
                      style: const TextStyle(
                          fontFamily: 'MyUniqueFont',
                          fontSize: 19,
                          color: Colors.black),
                      textAlign: TextAlign.left,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: AnimatedBuilder(
                            animation: _animatedcontroller,
                            builder: (context, _) {
                              return Container(
                                width: screenSize.width,
                                height: screenSize.height * 0.17,
                                decoration: isCorrectOTP != 0
                                    ? BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        
                                        gradient: LinearGradient(
                                            colors: isCorrectOTP == 1
                                                ? [
                                                    const Color(0xFF107714),
                                                    const Color(0xFF0EDA15)
                                                  ]
                                                : [
                                                    const Color(0xFFFF1100),
                                                    const Color(0xFFC5342A)
                                                  ],
                                            begin: _topAlignmentAnimation.value,
                                            end: _bottomAlignmentAnimation
                                                .value))
                                    : null,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children:
                                          List.generate(_otpLength, (index) {
                                        return SizedBox(
                                          width: 50.0,
                                          child: TextField(
                                            controller: _controllers[index],
                                            focusNode: _focusNodes[index],
                                            onChanged: (value) => _onDigitInput(
                                                index, value, context),
                                            maxLength: 1,
                                            keyboardType: TextInputType.number,
                                            textAlign: TextAlign.center,
                                            onTap: () {
                                              currentIndex = index;
                                            },
                                            decoration: InputDecoration(
                                                counter: const Offstage(),
                                                fillColor:
                                                    const Color(0xFFDCDADA),
                                                border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.0),
                                                    borderSide:
                                                        BorderSide.none),
                                                filled: true,
                                                contentPadding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 15.0),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0),
                                                )),
                                          ),
                                        ).paddingOnly(
                                          right: 5,
                                        );
                                      }),
                                    ).paddingOnly(left: 5),
                                    if (isCorrectOTP != 0)
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          if (isCorrectOTP == 1)
                                            const Icon(
                                              Icons.verified_outlined,
                                              color: Colors.white,
                                            ),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          Text(
                                            isCorrectOTP == 1
                                                ? 'Verified'
                                                : 'X Invalid OTP',
                                            style: AppTheme.copyWith(
                                              color: Colors.white,
                                            ),
                                          )
                                        ],
                                      ).paddingOnly(top: 5)
                                  ],
                                ),
                              );
                            }),
                      ),
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: Text(
                        'Verification code expires in ${formattedTime(timeInSecond: _remainingSeconds)}',
                        style: AppTheme.displayMedium,
                        textAlign: TextAlign.center,
                      ),
                    )
                  ],
                ).paddingAll(20),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.24,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor: const MaterialStatePropertyAll(
                                AppTheme.secondaryColor,
                              ),
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    side: const BorderSide(
                                        width: 1, color: Colors.grey)),
                              ),
                              fixedSize: MaterialStatePropertyAll(Size(
                                  screenSize.width * 0.8,
                                  screenSize.height * 0.06))),
                          onPressed: () {},
                          child: const Text(
                            'Verify OTP',
                            style: TextStyle(
                                fontFamily: 'MyUniqueFont',
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.primaryColor),
                          )),
                      ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor: const MaterialStatePropertyAll(
                                AppTheme.secondaryColor,
                              ),
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    side: const BorderSide(
                                        width: 1, color: Colors.grey)),
                              ),
                              fixedSize: MaterialStatePropertyAll(Size(
                                  screenSize.width * 0.8,
                                  screenSize.height * 0.06))),
                          onPressed: () {
                            if (_focusNodes[currentIndex].hasFocus) {
                              _focusNodes[currentIndex].unfocus();
                            }
                            for (int i = 0; i < _otpLength; i++) {
                              _controllers[i].clear();
                            }
                            setState(() {
                              _remainingSeconds = 170;
                            });
                          },
                          child: const Text(
                            'Resend OTP',
                            style: TextStyle(
                                fontFamily: 'MyUniqueFont',
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.primaryColor),
                          )),
                      ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor: const MaterialStatePropertyAll(
                                AppTheme.secondaryColor,
                              ),
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    side: const BorderSide(
                                        width: 1, color: Colors.grey)),
                              ),
                              fixedSize: MaterialStatePropertyAll(Size(
                                  screenSize.width * 0.8,
                                  screenSize.height * 0.06))),
                          onPressed: () {
                            setState(() {
                              _isVerify = true;
                            });
                          },
                          child: const Text(
                            'Change Number',
                            style: TextStyle(
                                fontFamily: 'MyUniqueFont',
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.primaryColor),
                          )),
                      const SizedBox(
                        height: 10,
                      )
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
