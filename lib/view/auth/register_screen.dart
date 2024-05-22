import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lootfat_user/utils/colors.dart';
import 'package:lootfat_user/utils/images.dart';
import 'package:lootfat_user/view/auth/otp_verification.dart';
import 'package:intl/intl.dart';
import '../../model/common_data_model.dart';
import '../../utils/helper.dart';
import '../../utils/utils.dart';
import '../widgets/app_text_field.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  List<String> phoneCodes = ["+91", "+92", "+93", "+94", "+08"];
  String phoneCode = "+91";
  String mobileNumber = "";
  String mobileNumberError = "";
  String firstName = "";
  String firstNameError = "";
  String dateBirth = "";
  String dateBirthError = "";
  String lastName = "";
  String lastNameError = "";
  String receivedID = "";
  final FirebaseAuth auth = FirebaseAuth.instance;
  final phoneController = TextEditingController();
  String initValue = "Select your Birth Date";
  bool isDateSelected = false;
  DateTime? birthDate;
  String birthDateInString = '';
  String birthDateError = '';
  DateTime selectedDate = DateTime.now();

  bool validRegister() {
    bool isValid = true;
    setState(() {
      firstNameError = '';
      lastNameError = '';
      mobileNumberError = '';
    });
    if (firstName.isEmpty) {
      setState(() {
        firstNameError = "Please Enter First Name";
        print(firstNameError);
      });
      isValid = false;
    }

    if (lastName.isEmpty) {
      setState(() {
        lastNameError = "Please Enter Last Name";
      });
      isValid = false;
    }
    if (birthDateInString.isEmpty) {
      setState(() {
        birthDateError = "Please Enter Date of Birth";
      });
      isValid = false;
    }

    if (mobileNumber.isEmpty) {
      setState(() {
        mobileNumberError = "Please Enter Mobile Number";
      });
      isValid = false;
    } else if (!Helper.isPhoneNumber(mobileNumber)) {
      setState(() {
        mobileNumberError = "Please Enter a valid Mobile Number";
      });
      isValid = false;
    }

    return isValid;
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
                const SizedBox(height: 50),
                const Text(
                  "User Registration !!",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  "Create a new account to access exclusive features and content. Registration is quick and easy!",
                  style: TextStyle(
                    color: AppColors.textLight,
                  ),
                ),
                const SizedBox(height: 30),
                AppTextField(
                  inputTitle: "First name*",
                  hintText: "First name",
                  onChange: (value) {
                    setState(() {
                      firstName = value;
                      firstNameError = '';
                    });
                  },
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(60),
                  ],
                  errorMessage: firstNameError,
                ),
                const SizedBox(height: 10),
                AppTextField(
                  inputTitle: "Last name*",
                  hintText: "Last name",
                  onChange: (value) {
                    setState(() {
                      lastName = value;
                      lastNameError = '';
                    });
                  },
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(60),
                  ],
                  errorMessage: lastNameError,
                ),
                const SizedBox(height: 10),
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
                const SizedBox(height: 10),
                AppTextField.inputTitleText('Date of Birth*'),
                InkWell(
                    highlightColor: AppColors.white.withOpacity(0.4),
                    splashColor: AppColors.appColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(5),
                    hoverColor: AppColors.appColor.withOpacity(0.2),
                    child: Container(
                        width: Utils.width(context),
                        height: 48,
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(
                            color: AppColors.textLight,
                          ),
                        ),
                        child: Row(
                          children: [
                            new Icon(Icons.calendar_today),
                            const SizedBox(width: 10),
                            Text(
                              birthDateInString.isEmpty
                                  ? 'DD/MM/YYYY'
                                  : birthDateInString,
                              style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.main),
                            )
                          ],
                        )),
                    onTap: () async {
                      final datePick = await showDatePicker(
                        context: context,
                        // initialEntryMode: DatePickerEntryMode.calendar,
                        initialDate: selectedDate,
                        firstDate: DateTime(1980),
                        lastDate: DateTime.now(),
                        fieldLabelText: 'Date of Birth',
                        fieldHintText: 'Month/Date/Year',
                        errorFormatText: initValue,
                        builder: (context, child) {
                          return Theme(
                            data: ThemeData(
                              colorScheme: ColorScheme.light(
                                primary: AppColors.main,
                                onPrimary: AppColors.white,
                                onSurface: AppColors.main,
                                surface: Colors.pink,
                              ),
                              dialogBackgroundColor: Colors.white,
                              textButtonTheme: TextButtonThemeData(
                                style: TextButton.styleFrom(
                                  foregroundColor:
                                      AppColors.appColor, // button text color
                                ),
                              ),
                            ),
                            child: child!,
                          );
                        },
                      );

                      if (datePick != null && datePick != selectedDate) {
                        setState(() {
                          selectedDate = datePick;

                          isDateSelected = true;
                          birthDateInString = convertDate(datePick.toString());
                        });
                      }
                    }),
                if (birthDateError.isNotEmpty)
                  AppTextField.inputErrorMessage(birthDateError),
                const SizedBox(height: 100),
                ElevatedButton(
                  onPressed: () {
                    if (validRegister()) {
                      verifyUserPhoneNumber();
                    }
                  },
                  child: const Center(
                    child: Text(
                      'Register',
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Center(
                  child: RichText(
                    text: TextSpan(
                      text: 'Already have an account?',
                      style: const TextStyle(
                          color: AppColors.textLight, fontSize: 14),
                      children: <TextSpan>[
                        TextSpan(
                          text: ' Login',
                          style: const TextStyle(
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
              ],
            ),
          ),
        ),
      ),
    );
  }

  void verifyUserPhoneNumber() {
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
          print('=======');
          print(birthDateInString);
        },
        codeSent: (String verificationId, int? resendToken) {
          receivedID = verificationId;
          CommonDataModel data = CommonDataModel(
            receivedId: verificationId,
            phoneNumber: mobileNumber,
            phoneCode: phoneCode,
            firstName: firstName,
            lastName: lastName,
            screenType: 'register',
            birthDate: birthDateInString,
          );
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (value) => OtpVerificationScreen(userData: data),
            ),
          );

          setState(() {});
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

  String convertDate(String date) {
    String convertedDate = '';
    try {
      DateTime dateTime = DateTime.parse(date.toString());
      //'6 Jan, 2021'
      var data = DateFormat('yyyy-MM-dd').format(dateTime);
      convertedDate = data.toString();
      print(convertedDate);
    } catch (e) {
      convertedDate = '';
    }
    return convertedDate;
  }
}
