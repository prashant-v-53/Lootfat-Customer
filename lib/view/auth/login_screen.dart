import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lootfat_user/utils/colors.dart';
import 'package:lootfat_user/utils/images.dart';
import 'package:lootfat_user/utils/utils.dart';
import 'package:lootfat_user/view/auth/register_screen.dart';

import '../../model/common_data_model.dart';
import '../../utils/helper.dart';
import '../widgets/app_text_field.dart';
import '../widgets/loading_overlay.dart';
import 'otp_verification.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  List<String> phoneCodes = ["+91", "+92", "+93", "+94", "+08"];
  String phoneCode = "+91";
  var receivedID = '';
  String mobileNumber = '';
  String mobileNumberError = '';
  final phoneController = TextEditingController();
  final FirebaseAuth auth = FirebaseAuth.instance;

  bool validLogin() {
    bool isValid = true;
    setState(() {
      mobileNumberError = '';
    });
    if (mobileNumber.isEmpty) {
      setState(() {
        mobileNumberError = "Please enter mobile number";
      });
      isValid = false;
    } else if (!Helper.isPhoneNumber(mobileNumber)) {
      setState(() {
        mobileNumberError = "please enter a valid mobile number";
      });
      isValid = false;
    }
    return isValid;
  }

  void verifyUserPhoneNumber() {
    if (validLogin()) {
      LoadingOverlay.of(context).show();
      try {
        auth.verifyPhoneNumber(
          phoneNumber: phoneCode + mobileNumber,
          verificationCompleted: (PhoneAuthCredential credential) async {
            await auth.signInWithCredential(credential).then(
                  (value) => print('Logged In Successfully'),
                );
          },
          verificationFailed: (FirebaseAuthException e) {
            print(e.message);
          },
          codeSent: (String verificationId, int? resendToken) {
            CommonDataModel? data;
            setState(() {
              receivedID = verificationId;
              data = CommonDataModel(
                  receivedId: verificationId,
                  phoneNumber: mobileNumber,
                  phoneCode: phoneCode,
                  lastName: '',
                  firstName: '',
                  screenType: 'login',
                  birthDate: '');
            });
            LoadingOverlay.of(context).hide();
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (value) => OtpVerificationScreen(userData: data!),
              ),
            );
          },
          codeAutoRetrievalTimeout: (String verificationId) {},
        );
      } on FirebaseAuthException catch (e) {
        LoadingOverlay.of(context).hide();
        if (e.code == 'user-not-found') {
          print('User not found');
        } else if (e.code == 'wrong-password') {
          print('Incorrect password');
        } else {
          print('An error occurred while logging in');
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 40),
                Center(
                  child: SvgPicture.asset(
                    SvgImages.logo,
                    height: 80,
                  ),
                ),
                SizedBox(height: Utils.height(context) * 0.17),
                const Text(
                  "Hey Welcome !!",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  "To get the One Time Password(OTP) on this mobile number.",
                  style: TextStyle(
                    color: AppColors.textLight,
                  ),
                ),
                const SizedBox(height: 30),
                AppTextField.inputTitleText('Enter mobile number*'),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 80,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(
                          color: AppColors.textLight,
                        ),
                      ),
                      child: Center(
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: phoneCode,
                            items: phoneCodes
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(
                                  value,
                                ),
                              );
                            }).toList(),
                            onChanged: (String? value) {
                              setState(() {
                                phoneCode = value!;
                              });
                            },
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: AppTextField(
                        onChange: (value) {
                          setState(() {
                            mobileNumber = value;
                            mobileNumberError = '';
                          });
                        },
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        controller: phoneController,
                        hintText: "Mobile Number",
                        errorMessage: mobileNumberError,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: Utils.height(context) * 0.15),
                ElevatedButton(
                  onPressed: () {
                    if (validLogin()) {
                      verifyUserPhoneNumber();
                    }
                  },
                  child: const Center(
                    child: Text(
                      'Get OTP',
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Center(
                  child: RichText(
                    text: TextSpan(
                      text: 'Don\'t have an account?',
                      style: const TextStyle(
                          color: AppColors.textLight, fontSize: 14),
                      children: <TextSpan>[
                        TextSpan(
                          text: ' Register',
                          style: TextStyle(
                            color: AppColors.main,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => const RegisterScreen(),
                                ),
                              );
                            },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
