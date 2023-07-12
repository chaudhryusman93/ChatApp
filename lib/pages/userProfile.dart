import 'dart:io';

import 'package:chatter/pages/RegisterationPage.dart';
import 'package:chatter/pages/homePage.dart';
import 'package:chatter/validators/validators.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
// import 'package:phone_authentication/HomeScreen.dart';
// import 'package:phone_authentication/phoneNumber.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({super.key});
  static const pageName = '/userProfile';

  @override
  State<UserProfile> createState() => _UserProfileState();
}

TextEditingController nameController = TextEditingController();
// late File imageFile;

class _UserProfileState extends State<UserProfile> with FormValidationMixin {
  // for image picker
  File? pickedImage;
  Reference? ref;
  UploadTask? putFile;

  Future<void> _pickImage(ImageSource source) async {
    final result = await ImagePicker().pickImage(source: source);
    if (result != null) {
      final File imageFile = File(result.path);
      setState(() {
        pickedImage = imageFile;
      });

      final file = File(pickedImage!.path);
      String filePath =
          "profile/${DateTime.now().millisecondsSinceEpoch.toString()}";

      // putFile
      ref = FirebaseStorage.instance.ref().child(filePath);
      putFile = ref!.putFile(file);
    }
  }

// Add User details to firestore
  Future<void> addUserDetails({
    String? name,
    String? imageUrl,
    String? phoneNumber,
  }) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(phoneNumberController.text)
        .set({
      'name': name,
      'imageUrl': imageUrl,
      'phoneNumber': phoneNumber,
    });
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ScreenSize = MediaQuery.of(context).size;
    final ScreenWidth = ScreenSize.width;
    final ScreenHeight = ScreenSize.height;
    final ClientHeight = ScreenHeight - kToolbarHeight;
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.grey,
        appBar: AppBar(
          title: const Text('Create profile'),
          backgroundColor: Colors.blueGrey,
        ),
        body: Padding(
          padding: EdgeInsets.only(top: ClientHeight * 0.1),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () {
                  PickImage();
                },
                child: CircleAvatar(
                  backgroundColor: Colors.transparent,
                  foregroundImage:
                      pickedImage != null ? FileImage(pickedImage!) : null,
                  radius: ClientHeight * 0.12,
                  child: Icon(
                    Icons.person,
                    size: ClientHeight * 0.2,
                  ),
                ),
              ),
              SizedBox(
                height: ClientHeight * 0.10,
              ),
              TextFormField(
                validator: nameValidation,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                cursorColor: Colors.black,
                controller: nameController,
                // keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    labelText: 'Enter your Name',
                    labelStyle: const TextStyle(color: Colors.black),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            width: ScreenWidth * 0.002, color: Colors.black),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(15))),
                    enabledBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15)))),
              ),
              SizedBox(
                height: ClientHeight * 0.1,
              ),
              Card(
                elevation: 20,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        minimumSize:
                            Size(ScreenWidth * 0.6, ClientHeight * 0.06),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20))),
                    onPressed: () async {
                      putFile?.whenComplete(() {
                        ref!.getDownloadURL().then((value) {
                          // Add to firestore
                          addUserDetails(
                            name: nameController.text.trim(),
                            imageUrl: value,
                            phoneNumber: phoneNumberController.text,
                          );

                          Navigator.of(context).pushNamed(HomePage.pageName);
                        });
                      });
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
    );
  }

  void PickImage() {
    if (pickedImage != null) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            actions: [
              TextButton(
                  onPressed: () {
                    pickedImage = null;
                    Navigator.pop(context);
                  },
                  child: const Text('Clear Image'))
            ],
          );
        },
      );
    } else {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Pick Image'),
            actions: [
              TextButton(
                  onPressed: () {
                    _pickImage(ImageSource.gallery);
                    Navigator.pop(context);
                  },
                  child: const Text('From gallery')),
              TextButton(
                  onPressed: () {
                    _pickImage(ImageSource.camera);
                    Navigator.pop(context);
                  },
                  child: const Text('From Camera'))
            ],
          );
        },
      );
    }
  }
}
