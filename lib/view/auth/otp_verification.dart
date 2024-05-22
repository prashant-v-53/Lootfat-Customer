import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:lootfat_user/utils/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../api_provider-/auth_api.dart';
import '../../model/common_data_model.dart';
import '../../model/login_model.dart';
import '../../model/register_model.dart';
import '../../utils/utils.dart';
import '../dashboard/bottom_bar_screen.dart';
import '../widgets/app_text_field.dart';
import '../widgets/loading_overlay.dart';

class OtpVerificationScreen extends StatefulWidget {
  final CommonDataModel userData;

  OtpVerificationScreen({
    super.key,
    required this.userData,
  });

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  String otp = '';
  String receivedId = '';

  String mobileNumber = "";
  String phoneCode = "";
  String firstName = "";
  String lastName = "";
  String pinCode = "395010";
  String screenType = '';
  String birthDate = '';

  String otpError = '';

  void initState() {
    if (widget.userData.screenType == 'register') {
      setState(() {
        receivedId = widget.userData.receivedId;
        mobileNumber = widget.userData.phoneNumber;
        phoneCode = widget.userData.phoneCode;
        firstName = widget.userData.firstName;
        lastName = widget.userData.lastName;
        screenType = widget.userData.screenType;
        birthDate = widget.userData.birthDate;
      });
      print(birthDate);
    } else if (widget.userData.screenType == 'login') {
      setState(() {
        receivedId = widget.userData.receivedId;
        mobileNumber = widget.userData.phoneNumber;
        phoneCode = widget.userData.phoneCode;
        screenType = widget.userData.screenType;
      });
    }
    super.initState();
  }

  Future<void> verifyOTPCode() async {
    LoadingOverlay.of(context).show();
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
      verificationId: receivedId,
      smsCode: otp,
    );
    await auth.signInWithCredential(credential).then((value) => screenRoute());
  }

  screenRoute() {
    if (widget.userData.screenType == 'register') {
      LoadingOverlay.of(context).hide();
      apiRegister();
    } else if (widget.userData.screenType == 'login') {
      loginApi();
    }
  }

  apiRegister() {
    LoadingOverlay.of(context).show();
    try {
      FocusScope.of(context).requestFocus(FocusNode());
      AuthAPI.signUpUser(
        mobileNumber,
        firstName,
        lastName,
        birthDate,
      ).then((response) {
        // var res = json.decode(response.body);
        if (response.statusCode == 200 || response.statusCode == 201) {
          var res = json.decode(response.body);
          RegisterModel registerModelData = RegisterModel.fromJson(res);
          storePreferences(registerModelData.data);
          Utils.toastMessage(registerModelData.message);
          LoadingOverlay.of(context).hide();
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => BottomBarScreen(),
            ),
          );
        } else if ([409, 403, 404, 401, 400, 422]
            .contains(response.statusCode)) {
          var res = json.decode(response.body);
          print(res['message']);
          LoadingOverlay.of(context).hide();
          Utils.toastMessage(res['message']);
        } else if (response.statusCode == 500) {
          LoadingOverlay.of(context).hide();
          Utils.toastMessage('500 Server not found!');
        } else if (response.statusCode == 555 || response.statusCode == 002) {
          LoadingOverlay.of(context).hide();
          print(response.body);
          print("============================");
          Utils.toastMessage(response.body);
        }
      });
    } catch (e) {
      LoadingOverlay.of(context).hide();
    }
  }

  Future storePreferences(data) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('firstName', data.user.firstName);
    prefs.setString('lastName', data.user.lastName);
    prefs.setString('phoneNumber', data.user.phoneNumber);
    prefs.setString('phoneCode', phoneCode);
    prefs.setString('latitude', data.user.location.coordinates[0].toString());
    prefs.setString('longitude', data.user.location.coordinates[1].toString());
    prefs.setString('token', data.tokens.access.token);
    prefs.setString('dob', data.user.dob.toString());
  }

  loginApi() {
    try {
      FocusScope.of(context).requestFocus(FocusNode());
      AuthAPI.loginUser(mobileNumber).then((response) {
        var res = json.decode(response.body);
        if (response.statusCode == 200 || response.statusCode == 201) {
          var res = json.decode(response.body);
          LoadingOverlay.of(context).hide();
          LoginModel registerModelData = LoginModel.fromJson(res);
          Utils.toastMessage(registerModelData.message);
          storePreferences(registerModelData.data);
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => BottomBarScreen(),
            ),
          );
        } else if ([409, 403, 401, 404, 400, 422]
            .contains(response.statusCode)) {
          Utils.toastMessage(res['message']);
          LoadingOverlay.of(context).hide();
        } else if (response.statusCode == 500) {
          LoadingOverlay.of(context).hide();
          Utils.toastMessage('500 Server not found!');
        } else if (response.statusCode == 001 || response.statusCode == 002) {
          LoadingOverlay.of(context).hide();
          Utils.toastMessage(response.body);
        }
      });
    } catch (e) {
      LoadingOverlay.of(context).hide();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      floatingActionButton: Container(
        height: 36,
        margin: const EdgeInsets.symmetric(horizontal: 20),
        child: ElevatedButton(
          onPressed: () {
            if (validOtp()) {
              verifyOTPCode();
            }
          },
          child: const Center(
            child: Text(
              'Verify',
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: Center(
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 20),
                const Center(
                  child: Text(
                    "Verify your OTP",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Center(
                  child: Text(
                    "Enter the code from the sms we sent\nto +918469393218",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      height: 1.6,
                      color: AppColors.textLight,
                    ),
                  ),
                ),
                const SizedBox(height: 60),
                OtpTextField(
                  numberOfFields: 6,
                  focusedBorderColor: AppColors.main,
                  showFieldAsBox: true,
                  onCodeChanged: (String code) => setState(() => otp = code),
                  onSubmit: (String verificationCode) {
                    setState(() => otp = verificationCode);
                  },
                ),
                Padding(
                    padding: EdgeInsets.only(left: 35, top: 5, right: 10),
                    child: AppTextField.inputErrorMessage(otpError)),
                const SizedBox(height: 40),
                Center(
                  child: RichText(
                    text: TextSpan(
                      text: 'Did not receive the code? ',
                      style: const TextStyle(
                          color: AppColors.textLight, fontSize: 14),
                      children: <TextSpan>[
                        TextSpan(
                          onEnter: (event) {
                            resendOTP();
                          },
                          text: 'Resend',
                          style: const TextStyle(
                            decoration: TextDecoration.underline,
                            color: AppColors.main,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.pop(context);
                            },
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void resendOTP() {
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
          setState(() {
            receivedId = verificationId;
          });
          screenRoute();
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('User not found');
      } else if (e.code == 'wrong-password') {
        print('Incorrect password');
      } else {
        print('An error occurred while logging in');
      }
    }
  }

  bool validOtp() {
    bool isValid = true;
    setState(() {
      otpError = '';
    });
    if (otp.isEmpty) {
      setState(() {
        otpError = "Please Enter OTP";
      });
      isValid = false;
    } else if (otp.length < 6) {
      setState(() {
        otpError = "Please Enter a valid OTP";
      });
      isValid = false;
    }

    return isValid;
  }
}
