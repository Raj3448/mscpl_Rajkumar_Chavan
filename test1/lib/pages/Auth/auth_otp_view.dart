import 'package:flutter/material.dart';
import 'package:zapx/zapx.dart';

// ignore: must_be_immutable
class AuthOtpView extends StatefulWidget {
  (String countryCode, String mobileNo) mobileNumberDetails;
  AuthOtpView({Key? key, required this.mobileNumberDetails}) : super(key: key);

  @override
  State<AuthOtpView> createState() => _AuthOtpViewState();
}

class _AuthOtpViewState extends State<AuthOtpView> {
  late List<FocusNode> _focusNodes;
  late List<TextEditingController> _controllers;
  int _otpLength = 4;
  bool _isVerify = false;

  int currentIndex = 0;
  @override
  void initState() {
    super.initState();
    _focusNodes = List.generate(_otpLength, (index) => FocusNode());
    _controllers =
        List.generate(_otpLength, (index) => TextEditingController());
  }

  @override
  void dispose() {
    for (int i = 0; i < _otpLength; i++) {
      _focusNodes[i].dispose();
      _controllers[i].dispose();
    }
    super.dispose();
  }

  void _onDigitInput(int index, String value) {
    if (value.isNotEmpty) {
      if (index < _otpLength - 1) {
        FocusScope.of(context).requestFocus(_focusNodes[index + 1]);
      } else {
        _focusNodes[index].unfocus();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: !_isVerify
          ? AppBar(
              backgroundColor: const Color(0xfffaf9f6),
              title: Text(
                'Verify Code',
                style: Theme.of(context).textTheme.displayLarge,
              ),
              centerTitle: true,
            )
          : null,
      body: Container(
        color: const Color(0xfffaf9f6),
        height: MediaQuery.of(context).size.height,
        child: _isVerify
            ? Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(
                    child: SizedBox(
                      height: 150,
                      width: 150,
                      child: Image.asset(
                        'assets/images/check (1).png',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Success !!!',
                          style: Theme.of(context).textTheme.displayLarge,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const Text(
                          'Congratulations! You have been successfully authenticated',
                          style: TextStyle(
                              fontFamily: 'MyUniqueFont',
                              fontSize: 19,
                              color: Colors.black),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                      ]),
                  Center(
                    child: ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor: const MaterialStatePropertyAll(
                              Color(0xFFF397B6),
                            ),
                            fixedSize: MaterialStatePropertyAll(Size(
                                MediaQuery.of(context).size.width * 0.6, 50))),
                        onPressed: () {
                          
                        },
                        child: const Text(
                          'Continue  →',
                          style: TextStyle(
                              fontFamily: 'MyUniqueFont',
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        )),
                  ),
                ],
              )
            : SingleChildScrollView(
                physics: const NeverScrollableScrollPhysics(),
                child: SizedBox(
                  height: MediaQuery.of(context).size.height,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Center(
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 500),
                          height:
                              _focusNodes[currentIndex].hasFocus ? 100 : 120,
                          width: _focusNodes[currentIndex].hasFocus ? 100 : 120,
                          child: Image.asset(
                            'assets/images/business-and-finance.png',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ).paddingOnly(top: 40, bottom: 20),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Enter Code',
                            style: Theme.of(context).textTheme.displayLarge,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            'Please type the verification code sent to  ${widget.mobileNumberDetails.$1} ${widget.mobileNumberDetails.$2}',
                            style: const TextStyle(
                                fontFamily: 'MyUniqueFont',
                                fontSize: 19,
                                color: Colors.black),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: SizedBox(
                              width: 300,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                  vertical: 15.0),
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                              borderSide: const BorderSide(
                                                width: 2,
                                                color: Color.fromARGB(
                                                    255, 243, 151, 182),
                                              ))),
                                    ),
                                  );
                                }),
                              ),
                            ),
                          ),
                        ],
                      ).paddingAll(20),
                      Center(
                        child: ElevatedButton(
                            style: ButtonStyle(
                                backgroundColor: const MaterialStatePropertyAll(
                                  Color.fromARGB(255, 243, 151, 182),
                                ),
                                fixedSize: MaterialStatePropertyAll(Size(
                                    MediaQuery.of(context).size.width * 0.6,
                                    50))),
                            onPressed: () {
                              setState(() {
                                _isVerify = true;
                              });
                            },
                            child: const Text(
                              'Continue  →',
                              style: TextStyle(
                                  fontFamily: 'MyUniqueFont',
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            )),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'If you didn\'t receive a code ',
                            style: Theme.of(context).textTheme.displayMedium,
                          ),
                          TextButton(
                              onPressed: () {},
                              child: const Text(
                                'Resend OTP',
                                style: TextStyle(
                                    color: Color.fromARGB(255, 243, 151, 182),
                                    fontSize: 16),
                              ))
                        ],
                      )
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
