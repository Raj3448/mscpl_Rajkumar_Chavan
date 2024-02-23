import 'package:flutter/material.dart';
import 'package:test1/constant/app_theme.dart';
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
  bool selected = false;

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: const Color(0xfffaf9f6),
      appBar: AppBar(
        backgroundColor: AppTheme.secondaryColor,
        leading: const Icon(Icons.arrow_back_ios_new_rounded),
      ),
      body: GestureDetector(
        onTap: () {
          if (_phoneFocusNode.hasFocus) {
            _phoneFocusNode.unfocus();
          }
        },
        child: SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                      'We need to verify your number',
                      style: Theme.of(context).textTheme.displayMedium,
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Text(
                      'Mobile Number *',
                      style: AppTheme.copyWith(
                          color: AppTheme.primaryColor, fontSize: 14),
                    ).paddingOnly(bottom: 20),
                    SizedBox(
                      height: 50,
                      width: double.infinity,
                      child: TextFormField(
                        controller: _phoneNumberController,
                        keyboardType: TextInputType.phone,
                        focusNode: _phoneFocusNode,
                        decoration: InputDecoration(
                            hintText: 'Enter mobile no',
                            enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    width: 2, color: Colors.grey),
                                borderRadius: BorderRadius.circular(10)),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                    color: AppTheme.primaryColor, width: 2))),
                      ),
                    ),
                  ],
                ).paddingSymmetric(horizontal: 10),
                Center(
                  child: ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor: MaterialStatePropertyAll(
                            _phoneNumberController.text.length == 10
                                ? AppTheme.primaryColor
                                : Colors.grey,
                          ),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          fixedSize: MaterialStatePropertyAll(Size(
                              screenSize.width * 0.8,
                              screenSize.height * 0.06))),
                      onPressed: _phoneNumberController.text.length == 10
                          ? _submit
                          : null,
                      child: const Text(
                        'Get OTP',
                        style: TextStyle(
                            fontFamily: 'MyUniqueFont',
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      )),
                ),
                Row(
                  children: [
                    InkWell(
                      onTap: () {
                        setState(() {
                          selected = !selected;
                        });
                      },
                      child: Container(
                        height: selected ? 20 : 30,
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                                width: 1,
                                color: selected ? Colors.blue : Colors.grey)),
                        child: Padding(
                            padding: EdgeInsets.all(selected ? 2 : 7),
                            child: selected
                                ? const CircleAvatar(
                                    radius: 5,
                                    backgroundColor: Colors.blue,
                                  )
                                : null),
                      ).paddingOnly(right: 10),
                    ),
                    Column(
                      children: [
                        SizedBox(
                          width: screenSize.width * 0.75,
                          child: const Text(
                              "Allow faydaa to send financial knowledge and critical alerts on your WhatsApp",
                              style: AppTheme.displayMedium),
                        ).paddingOnly(bottom: 10),
                        Align(
                          alignment: Alignment.center,
                          child: Container(
                            width: screenSize.width * 0.3,
                            height: 4,
                            decoration: BoxDecoration(
                                color: AppTheme.primaryColor,
                                borderRadius: BorderRadius.circular(10)),
                          ),
                        )
                      ],
                    ),
                  ],
                ).paddingSymmetric(horizontal: 10)
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
