import 'dart:async';

import 'package:flutter/material.dart';
import 'package:test1/constant/app_theme.dart';
import 'package:zapx/zapx.dart';


class AuthOtpView extends StatefulWidget {
  (String countryCode, String mobileNo) mobileNumberDetails;
  AuthOtpView({Key? key, required this.mobileNumberDetails}) : super(key: key);

  @override
  State<AuthOtpView> createState() => _AuthOtpViewState();
}

class _AuthOtpViewState extends State<AuthOtpView> {
  late List<FocusNode> _focusNodes;
  late List<TextEditingController> _controllers;
  final int _otpLength = 6;
  bool _isVerify = false;

  String? _verificationCode = '123456';

  late Timer _timer;
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

  int currentIndex = 0;
  @override
  void initState() {
    super.initState();
    _focusNodes = List.generate(_otpLength, (index) => FocusNode());
    _controllers =
        List.generate(_otpLength, (index) => TextEditingController());
    Timer.periodic(const Duration(seconds: 1), _updateRemainingSeconds);
  }

  @override
  void dispose() {
    for (int i = 0; i < _otpLength; i++) {
      _focusNodes[i].dispose();
      _controllers[i].dispose();
    }
    super.dispose();
  }

  int isCorrectOTP = 0;
  String generateOTP = '';

  void _onDigitInput(int index, String value) {
    if (value.isNotEmpty) {
      generateOTP += value;
      if (index < _otpLength - 1) {
        FocusScope.of(context).requestFocus(_focusNodes[index + 1]);
      } else {
        _focusNodes[index].unfocus();
        int length = generateOTP.length;
        if (generateOTP == _verificationCode) {
          setState(() {
            isCorrectOTP = 1; // for green
          });
        } else {
          setState(() {
            isCorrectOTP = 2; // for red
          });
        }
        print(generateOTP);
        generateOTP = '';
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: !_isVerify
          ? AppBar(
              backgroundColor: const Color(0xfffaf9f6),
              leading: IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(Icons.arrow_back_ios_new_rounded)),
              centerTitle: true,
            )
          : null,
      body: Container(
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
                  height: 30,
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Container(
                      width: screenSize.width,
                      height: screenSize.height * 0.17,
                      decoration: isCorrectOTP != 0
                          ? BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color:
                                  isCorrectOTP == 1 ? Colors.green : Colors.red)
                          : null,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: List.generate(_otpLength, (index) {
                              return SizedBox(
                                width: 50.0,
                                child: TextField(
                                  controller: _controllers[index],
                                  focusNode: _focusNodes[index],
                                  onChanged: (value) =>
                                      _onDigitInput(index, value),
                                  maxLength: 1,
                                  keyboardType: TextInputType.number,
                                  textAlign: TextAlign.center,
                                  onTap: () {
                                    currentIndex = index;
                                  },
                                  decoration: InputDecoration(
                                      counter: const Offstage(),
                                      fillColor: const Color(0xFFDCDADA),
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                          borderSide: BorderSide.none),
                                      filled: true,
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              vertical: 15.0),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      )),
                                ),
                              ).paddingOnly(
                                right: 5,
                              );
                            }),
                          ).paddingOnly(left: 5),
                          if (isCorrectOTP != 0)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                if(isCorrectOTP == 1)
                                const Icon(
                                  Icons.verified_outlined,
                                  color: Colors.white,
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  isCorrectOTP == 1?'Verified':'X Invalid OTP',
                                  style: AppTheme.copyWith(
                                    color: Colors.white,
                                  ),
                                )
                              ],
                            ).paddingOnly(top: 5)
                        ],
                      ),
                    ),
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
              height: MediaQuery.of(context).size.height * 0.18,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor: const MaterialStatePropertyAll(
                            AppTheme.secondaryColor,
                          ),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
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
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
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
                    height: 20,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
