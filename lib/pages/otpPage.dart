import 'package:chatter/pages/RegisterationPage.dart';
import 'package:chatter/pages/userProfile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_text_field/pin_code_text_field.dart';

class OtpPage extends StatefulWidget {
  const OtpPage({super.key, this.verificationId});
  final String? verificationId;
  static const pageName = '/otp';

  @override
  State<OtpPage> createState() => _OtpPageState();
}

TextEditingController otpController = TextEditingController();

class _OtpPageState extends State<OtpPage> {
  @override
  void dispose() {
    otpController.dispose();
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
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        title: Text('chatter'),
      ),
      backgroundColor: Colors.grey,
      body: SafeArea(
          child: Column(
        children: [
          //PIN CODE FIELD
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(top: ClientHeight * 0.07),
                child: SizedBox(
                  width: ScreenWidth * 0.8,
                  child: const FittedBox(
                    child: Text(
                      'verification code',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: ClientHeight * 0.05),
                child: SizedBox(
                    width: ScreenWidth * 0.7,
                    child: const FittedBox(
                        child: Text(
                      'Enter 6-digit code sent on your number',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ))),
              ),
              Padding(
                padding: EdgeInsets.only(top: ClientHeight * 0.06),
                child: Container(
                  width: double.infinity,
                  // color: const Color.fromRGBO(33, 150, 243, 1),
                  child: Padding(
                    padding: EdgeInsets.only(left: ScreenWidth * 0.15),
                    child: PinCodeTextField(
                      controller: otpController,
                      pinBoxWidth: ScreenWidth * 0.1,
                      pinBoxHeight: ClientHeight * 0.08,
                      autofocus: true,
                      isCupertino: true,
                      highlight: true,
                      maxLength: 6,
                      keyboardType: TextInputType.number,
                      pinBoxColor: Colors.grey,
                      errorBorderColor: Colors.red,
                      onDone: (pin) {
                        if (pin == otpController) {
                          const Center(child: CircularProgressIndicator());
                        } else {
                          'Invalid OTP';
                        }
                      },
                    ),
                  ),
                ),
              ),

              //OTP BUTTON
              Padding(
                padding: EdgeInsets.only(top: ClientHeight * 0.05),
                child: Card(
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
                        ReceiveOtp();
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
                ),
              )
            ],
          ),
        ],
      )),
    );
  }

  Future<void> ReceiveOtp() async {
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: widget.verificationId!,
        smsCode: otpController.text.trim());

    // Sign the user in (or link) with the credential
    firebaseAuth.signInWithCredential(credential).then((value) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Verified Successfully")));

      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => UserProfile(),
          ));
    }).onError((error, stackTrace) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(error.toString())));
    });
  }
}
