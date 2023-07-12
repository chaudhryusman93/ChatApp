import 'package:chatter/pages/otpPage.dart';
import 'package:chatter/validators/validators.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});
  static const pageName = '/Registration';

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

TextEditingController phoneNumberController = TextEditingController();
FirebaseAuth firebaseAuth = FirebaseAuth.instance;

class _RegistrationPageState extends State<RegistrationPage>
    with FormValidationMixin {
  @override
  void dispose() {
    phoneNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ScreenSize = MediaQuery.of(context).size;
    final ScreenWidth = ScreenSize.width;
    final ScreenHeight = ScreenSize.height;
    final ClientHeight = ScreenHeight - kToolbarHeight;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.grey,
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        title: const Text('chatter'),
      ),
      body: SafeArea(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 5,
            child: Padding(
              padding: EdgeInsets.only(left: ScreenWidth * 0.07),
              child: Container(
                width: ScreenWidth * 0.88,
                decoration: const BoxDecoration(
                    // color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(25)),
                    boxShadow: [
                      BoxShadow(
                          offset: Offset(5, 5),
                          spreadRadius: 5,
                          blurRadius: 5,
                          color: Colors.black12),
                      BoxShadow(
                          offset: Offset(-5, -5),
                          blurRadius: 5,
                          color: Colors.white10)
                    ]),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                      width: ScreenWidth * 0.8,
                      // height: ClientHeight * 0.1,
                      child: const FittedBox(
                        fit: BoxFit.contain,
                        child: Text(
                          'WELCOME INTO CHATTER!',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    Padding(
                        padding: EdgeInsets.only(top: ClientHeight * 0),
                        child: const SizedBox(
                            child: FittedBox(
                                child: Text(
                          'Enter phone number with country code we will send you otp',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )))),
                    SizedBox(
                      width: ScreenWidth * 0.8,
                      height: ClientHeight * 0.08,
                      child: TextFormField(
                        validator: phoneNumberValidation,
                        controller: phoneNumberController,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        cursorColor: Colors.black,
                        decoration: const InputDecoration(
                            labelText: 'Enter Your phone number',
                            hintText: '+923...',
                            labelStyle: TextStyle(color: Colors.black),
                            prefixIcon: Icon(
                              Icons.phone,
                              color: Colors.black,
                            ),
                            enabledBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20)),
                                borderSide: BorderSide(color: Colors.black)),
                            focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20)),
                                borderSide: BorderSide(color: Colors.black)),
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20)))),
                      ),
                    ),
                    Card(
                      color: Colors.grey,
                      elevation: 20,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)),
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              minimumSize:
                                  Size(ScreenWidth * 0.6, ClientHeight * 0.06),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20))),
                          onPressed: () {
                            PhoneAuthentication();
                          },
                          child: SizedBox(
                            width: ScreenWidth * 0.15,
                            height: ClientHeight * 0.05,
                            child: const FittedBox(
                              child: Text(
                                'Continue',
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                          )),
                    )
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Container(
              // width: 350,
              // height: 350,

              child: const Column(
                children: [],
              ),
            ),
          ),
        ],
      )),
    );
  }

  Future<void> PhoneAuthentication() async {
    await firebaseAuth.setSettings(appVerificationDisabledForTesting: true);
    await firebaseAuth.verifyPhoneNumber(
      phoneNumber: phoneNumberController.text.trim(),
      verificationCompleted: (PhoneAuthCredential credential) async {
        await firebaseAuth.signInWithCredential(credential);
      },
      verificationFailed: (FirebaseAuthException e) {
        print(e);
      },
      codeSent: (String verificationId, int? resendToken) async {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OtpPage(
                verificationId: verificationId,
              ),
            ));
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }
}
