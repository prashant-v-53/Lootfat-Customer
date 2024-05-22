import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:lootfat_user/utils/colors.dart';
import 'package:lootfat_user/view/dashboard/profile_screen.dart';

import 'package:lootfat_user/view/widgets/app_text_field.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../api_provider-/auth_api.dart';
import '../../model/uer_data_model.dart';
import '../../utils/helper.dart';
import '../../utils/utils.dart';
import '../widgets/loading_overlay.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  List<String> phoneCodes = ["+91", "+92", "+93", "+94", "+08"];
  String phoneCode = "+91";
  TextEditingController firstName = TextEditingController();
  TextEditingController lastName = TextEditingController();
  TextEditingController phoneNumber = TextEditingController();
  TextEditingController shopName = TextEditingController();
  String dob = '';

  String firstNameError = '';
  String lastNameError = '';
  String phoneNumberError = '';

  @override
  void initState() {
    getUserData();
    super.initState();
  }

  getUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    firstName.text = prefs.getString('firstName').toString();
    lastName.text = prefs.getString('lastName').toString();
    phoneNumber.text = prefs.getString('phoneNumber').toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Profile"),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                Center(
                  child: Container(
                      width: 80,
                      height: 80,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: AppColors.main,
                      ),
                      child: Text(
                        'KD',
                        style: TextStyle(
                            fontSize: 25, fontWeight: FontWeight.w500, color: AppColors.white),
                      )),
                ),
                const SizedBox(height: 30),
                const Text(
                  "First name*",
                  style: TextStyle(
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 8),
                AppTextField(
                  hintText: "First name",
                  errorMessage: firstNameError,
                  controller: firstName,
                  onChange: (val) {
                    print(val);
                  },
                ),
                const SizedBox(height: 15),
                const Text(
                  "Last name*",
                  style: TextStyle(
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 8),
                AppTextField(
                  hintText: "Last name",
                  controller: lastName,
                  errorMessage: lastNameError,
                  onChange: (val) {
                    print(val);
                  },
                ),
                const SizedBox(height: 10),
                const Text(
                  "Enter mobile number*",
                  style: TextStyle(
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Container(
                      width: 80,
                      height: 48,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(
                          color: AppColors.main.withOpacity(0.1),
                        ),
                      ),
                      child: Center(
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: phoneCode,
                            items: phoneCodes.map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(
                                  value,
                                ),
                              );
                            }).toList(),
                            hint: const Text(""),
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
                        hintText: "Mobile Number",
                        errorMessage: phoneNumberError,
                        controller: phoneNumber,
                        onChange: (val) {
                          print(val);
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () {
                    if (validationUser()) {
                      apiUserUpdate();
                    }
                  },
                  child: const Center(
                    child: Text(
                      'Submit',
                    ),
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool validationUser() {
    bool isValid = true;
    setState(() {
      firstNameError = '';
      lastNameError = '';
      phoneNumberError = '';
    });
    if (firstName.text.isEmpty) {
      setState(() {
        firstNameError = "Please Enter First Name";
      });
      isValid = false;
    }
    if (lastName.text.isEmpty) {
      setState(() {
        lastNameError = "Please Enter Last Name";
      });
      isValid = false;
    }

    if (phoneNumber.text.isEmpty) {
      setState(() {
        phoneNumberError = "Please Enter Mobile Number";
      });
      isValid = false;
    } else if (!Helper.isPhoneNumber(phoneNumber.text)) {
      setState(() {
        phoneNumberError = "Please Enter a valid Mobile Number";
      });
      isValid = false;
    }
    return isValid;
  }

  apiUserUpdate() async {
    LoadingOverlay.of(context).show();
    try {
      FocusScope.of(context).requestFocus(FocusNode());
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var longitude = prefs.getString('longitude');
      var latitude = prefs.getString('latitude');

      AuthAPI.updateUser(firstName.text, lastName.text, phoneNumber.text, longitude, latitude, dob)
          .then((response) {
        var res = json.decode(response.body);
        print(res);
        if (response.statusCode == 200 || response.statusCode == 201) {
          UserDataModal registerModelData = UserDataModal.fromJson(res);
          print(registerModelData);
          storePreferences();
          Utils.toastMessage(registerModelData.message);
          LoadingOverlay.of(context).hide();
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const ProfileScreen()),
          );
        } else if ([409, 403, 401, 400, 422].contains(response.statusCode)) {
          Utils.toastMessage(res['message']);
          LoadingOverlay.of(context).hide();
        } else if (response.statusCode == 500) {
          Utils.toastMessage('500 Server not found!');
          LoadingOverlay.of(context).hide();
        } else if (response.statusCode == 001 || response.statusCode == 002) {
          Utils.toastMessage(response.body);
          LoadingOverlay.of(context).hide();
        }
      });
    } catch (e) {
      LoadingOverlay.of(context).hide();
    }
  }

  Future storePreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('firstName', firstName.text);
    prefs.setString('lastName', lastName.text);
    prefs.setString('phoneNumber', phoneNumber.text);
  }
}
