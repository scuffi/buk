import 'package:buk/providers/initial/initial_provider.dart';
import 'package:buk/providers/screen/screen_provider.dart';
import 'package:buk/providers/user_provider.dart';
import 'package:buk/screens/feed_screen.dart';
import 'package:buk/widgets/translate/translate_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DeleteDialog extends StatefulWidget {
  const DeleteDialog({Key? key}) : super(key: key);

  @override
  State<DeleteDialog> createState() => _DeleteDialogState();
}

class _DeleteDialogState extends State<DeleteDialog> {
  bool verified = false;
  String otp = '';
  String verificationID = '';
  bool canDelete = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Column(mainAxisSize: MainAxisSize.min, children: [
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: TranslateText(
            textAlign: TextAlign.center,
            text: "Delete account by confirming one time pin",
            style: GoogleFonts.poppins(
              textStyle: TextStyle(fontSize: 24, color: Colors.grey[800]),
            ),
          ),
        ),
        Column(
          children: [
            canDelete
                ? ElevatedButton(
                    onPressed: () async {
                      if (otp != '') {
                        // print("Delete account");
                        var userProvider =
                            Provider.of<UserProvider>(context, listen: false);

                        // print("User: ${userProvider.user}");

                        userProvider.user!.delete();
                        // FirebaseAuth.instance.signOut();

                        Navigator.pop(context);

                        Provider.of<InitialProvider>(context, listen: false)
                            .setPassed(false);
                        Provider.of<UserProvider>(context, listen: false)
                            .clearUser();
                        Provider.of<Screen>(context, listen: false)
                            .setScreen(const FeedScreen(), context);
                      }
                    },
                    child: TranslateText(
                      text: "Delete account",
                      selectable: false,
                      style: GoogleFonts.lato(
                        textStyle:
                            TextStyle(color: Colors.grey[700], fontSize: 16),
                      ),
                    ),
                  )
                : verified
                    ? const Padding(
                        padding: EdgeInsets.all(8.0),
                        // child: OTPTextField(
                        //   width: 250,
                        //   length: 6,
                        //   onCompleted: (code) {
                        //     otp = code;
                        //     verifyOTP();
                        //   },
                        // ),
                      )
                    : ElevatedButton(
                        onPressed: () {
                          loginWithPhone(
                              Provider.of<UserProvider>(context, listen: false)
                                  .user!);
                        },
                        child: TranslateText(
                          text: "Get code",
                          selectable: false,
                          style: GoogleFonts.lato(
                              textStyle: const TextStyle(
                                  color: Colors.white, fontSize: 16)),
                        ),
                      ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              OutlinedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: TranslateText(
                  text: "Cancel",
                  selectable: false,
                  style: GoogleFonts.lato(
                    textStyle:
                        const TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ]),
    );
  }

  void loginWithPhone(User user) async {
    FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: user.phoneNumber!,
      verificationCompleted: (PhoneAuthCredential credential) async {
        await FirebaseAuth.instance
            .signInWithCredential(credential)
            .then((value) {
          // print("You are logged in successfully");
        });
      },
      verificationFailed: (FirebaseAuthException e) {
        // print(e.message);
      },
      codeSent: (String verificationId, int? resendToken) {
        verified = true;
        verificationID = verificationId;
        setState(() {});
        // print("Verified: $verified");
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  void verifyOTP() async {
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationID, smsCode: otp);

    await FirebaseAuth.instance.signInWithCredential(credential).then(
      (value) {
        setState(() {
          // Provider.of<UserProvider>(context, listen: false)
          //     .setUser(FirebaseAuth.instance.currentUser!);
          // ? Should set user?
        });
      },
    ).whenComplete(
      () {
        if (Provider.of<UserProvider>(context, listen: false).user != null) {
          // print("Logged in");
          setState(() {
            canDelete = true;
          });
        } else {
          // print("Login failed");
          setState(() {
            verified = false;
            otp = '';
          });
        }
      },
    );
  }
}
// ? For later if using email&pass:
// return AlertDialog(
//                     content: Column(mainAxisSize: MainAxisSize.min, children: [
//                       Padding(
//                         padding: const EdgeInsets.all(12.0),
//                         child: TranslateText(
//                           textAlign: TextAlign.center,
//                           text:
//                               Provider.of<UserProvider>(context).user!.email ==
//                                       null
//                                   ? "Request one time code to confirm deletion"
//                                   : "Type your password to confirm deletion",
//                           style: GoogleFonts.poppins(
//                             textStyle: TextStyle(
//                                 fontSize: 24, color: Colors.grey[800]),
//                           ),
//                         ),
//                       ),
//                       Provider.of<UserProvider>(context).user!.email == null
//                           ? Column(
//                               children: [
//                                 verified
//                                     ? Padding(
//                                         padding: const EdgeInsets.all(8.0),
//                                         child: OTPTextField(
//                                           width: 250,
//                                           length: 6,
//                                           onCompleted: (code) {
//                                             otp = code;
//                                             verifyOTP();
//                                           },
//                                         ),
//                                       )
//                                     : Container(),
//                                 !verified
//                                     ? ElevatedButton(
//                                         onPressed: () {
//                                           loginWithPhone(
//                                               Provider.of<UserProvider>(context,
//                                                       listen: false)
//                                                   .user!);
//                                         },
//                                         child: TranslateText(
//                                           text: "Get code",
//                                           selectable: false,
//                                           style: GoogleFonts.lato(
//                                               textStyle: const TextStyle(
//                                                   color: Colors.white,
//                                                   fontSize: 16)),
//                                         ),
//                                       )
//                                     : Container(),
//                               ],
//                             )
//                           : Padding(
//                               padding: const EdgeInsets.all(8.0),
//                               child: Form(
//                                 key: _formKey,
//                                 child: TextFormField(
//                                   onChanged: (value) {
//                                     setState(() {
//                                       passwordInput = value;
//                                     });
//                                   },
//                                   obscureText: true,
//                                   autocorrect: false,
//                                   enableSuggestions: false,
//                                   decoration: const InputDecoration(
//                                     labelText: "Password",
//                                   ),
//                                   validator: (val) {
//                                     print(val);
//                                     if (val == null ||
//                                         val.trim().isEmpty ||
//                                         val == '') {
//                                       return "Password is required";
//                                     }
//                                     return null;
//                                   },
//                                 ),
//                               ),
//                             ),
//                       Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: Row(
//                           children: [
//                             const Spacer(),
//                             ElevatedButton(
//                               onPressed: () {
//                                 Navigator.pop(context);
//                               },
//                               child: TranslateText(
//                                 text: "Cancel",
//                                 selectable: false,
//                                 style: GoogleFonts.lato(
//                                   textStyle: const TextStyle(
//                                       color: Colors.white, fontSize: 16),
//                                 ),
//                               ),
//                             ),
//                             const Spacer(),
//                             OutlinedButton(
//                               onPressed: () async {
//                                 if (otp != '') {
//                                   print("Delete account");
//                                   var userProvider = Provider.of<UserProvider>(
//                                       context,
//                                       listen: false);

//                                   print("User: ${userProvider.user}");

//                                   userProvider.user!.delete();
//                                   // FirebaseAuth.instance.signOut();

//                                   Navigator.pop(context);

//                                   Provider.of<InitialProvider>(context,
//                                           listen: false)
//                                       .setPassed(false);
//                                   Provider.of<UserProvider>(context,
//                                           listen: false)
//                                       .clearUser();
//                                   Provider.of<Screen>(context, listen: false)
//                                       .setScreen(const FeedScreen(), context);
//                                 }
//                               },
//                               child: TranslateText(
//                                 text: "Delete",
//                                 selectable: false,
//                                 style: GoogleFonts.lato(
//                                   textStyle: TextStyle(
//                                       color: Colors.grey[700], fontSize: 16),
//                                 ),
//                               ),
//                             ),
//                             const Spacer(),
//                           ],
//                         ),
//                       ),
//                     ]),
//                   );
//                 });