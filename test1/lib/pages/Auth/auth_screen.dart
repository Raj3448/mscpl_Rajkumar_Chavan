import 'dart:async';

import 'package:flutter/material.dart';
import 'package:test1/pages/Auth/auth_otp_view.dart';
import 'package:zapx/zapx.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  String _selectedCountryCode = '+91';
  final TextEditingController _phoneNumberController = TextEditingController();
  final FocusNode _phoneFocusNode = FocusNode();
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfffaf9f6),
      body: GestureDetector(
        onTap: () {
          if (_phoneFocusNode.hasFocus) {
            _phoneFocusNode.unfocus();
          }
        },
        child: SingleChildScrollView(
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Enter your mobile number',
                      style: Theme.of(context).textTheme.displayLarge,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Please confirm your country code enter your mobile number',
                      style: Theme.of(context).textTheme.displayMedium,
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              'Country code',
                              style: Theme.of(context).textTheme.displayMedium,
                            ),
                            SizedBox(
                              height: 50,
                              width: MediaQuery.of(context).size.width * 0.23,
                              child: DropdownButton<String>(
                                isExpanded: true,
                                value: _selectedCountryCode,
                                onChanged: (String? value) {
                                  setState(() {
                                    _selectedCountryCode = value!;
                                  });
                                },
                                items: <String>[
                                  '+1',
                                  '+91',
                                  '+44',
                                  '+86'
                                ].map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Center(
                                      child: Text(
                                        value,
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                            color: Colors.black, fontSize: 20),
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(width: 16),
                        Form(
                          key: _globalKey,
                          child: SizedBox(
                            height: 50,
                            width: MediaQuery.of(context).size.width * 0.5,
                            child: TextFormField(
                              controller: _phoneNumberController,
                              focusNode: _phoneFocusNode,
                              keyboardType: TextInputType.phone,
                              style: const TextStyle(
                                  color: Colors.black, fontSize: 20),
                              decoration: const InputDecoration(
                                hintStyle:
                                    TextStyle(color: Colors.grey, fontSize: 20),
                                focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                  color: Color.fromARGB(255, 243, 151, 182),
                                )),
                                hintText: 'Phone number',
                              ),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please Enter Phone No.';
                                }
                                if (value.length != 10) {
                                  return 'Please Enter Valid Phone No.';
                                }
                                return null;
                              },
                              onFieldSubmitted: (val) {
                                _submit();
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Center(
                  child: ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor: const MaterialStatePropertyAll(
                            Color.fromARGB(255, 243, 151, 182),
                          ),
                          fixedSize: MaterialStatePropertyAll(Size(
                              MediaQuery.of(context).size.width * 0.6, 50))),
                      onPressed: _submit,
                      child: const Text(
                        'Continue  →',
                        style: TextStyle(
                            fontFamily: 'MyUniqueFont',
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      )),
                )
              ],
            ).paddingAll(20),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _submit() {
    if (!_globalKey.currentState!.validate()) {
      return;
    } else {
      _globalKey.currentState!.save();
      Navigator.of(context).push(
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 500),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            var begin = const Offset(1.0, 0.0);
            var end = Offset.zero;
            var curve = Curves.bounceInOut;
            var tween =
                Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
            var offsetAnimation = animation.drive(tween);
            return SlideTransition(
              position: offsetAnimation,
              child: child,
            );
          },
          pageBuilder: (context, animation, secondaryAnimation) {
            return AuthOtpView(
              mobileNumberDetails: (
                _selectedCountryCode,
                _phoneNumberController.text
              ),
            );
          },
        ),
      );
    }
  }
}
