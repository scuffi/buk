import 'package:buk/pages/auth/number_input.dart';
import 'package:buk/providers/user_provider.dart';
import 'package:buk/widgets/translate/language_switch.dart';
import 'package:buk/widgets/translate/translate_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final controller = TextEditingController();
  final focusNode = FocusNode();

  String number = '';
  String verificationID = '';
  final _formKey = GlobalKey<FormState>();
  String code = '';

  bool submit = false;

  bool failed = false;

  @override
  void dispose() {
    controller.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigoAccent,
      body: Stack(
        alignment: AlignmentDirectional.center,
        children: [
          // const Positioned(
          //   left: 280,
          //   top: 50,
          //   child: LanguageSwitch(),
          // ),
          Positioned(
            top: 40,
            child: Image.asset(
              "assets/logo_blank.png",
              height: 100,
              width: 100,
            ),
          ),
          Positioned(
            top: 120,
            child: Text(
              "UK2BUK",
              style: GoogleFonts.poppins(
                textStyle: const TextStyle(fontSize: 48, color: Colors.white),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 200.0),
            child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16)),
                ),
                child: Center(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 20.0, bottom: 10.0),
                        child: TranslateText(
                          text: "Sign in",
                          selectable: false,
                          style: GoogleFonts.poppins(
                              textStyle: const TextStyle(
                                  color: Colors.indigoAccent, fontSize: 35)),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: NumberInput(
                          form: _formKey,
                          onChanged: (phone, country) => setState(() {
                            number = "+${country.dial_code}$phone";
                          }),
                        ),
                      ),
                      ElevatedButton(
                        style: ButtonStyle(
                          fixedSize: MaterialStateProperty.all(
                            const Size(350, 50),
                          ),
                          backgroundColor:
                              MaterialStateProperty.all(Colors.indigoAccent),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(32.0),
                            ),
                          ),
                        ),
                        onPressed: () async {
                          print(number);
                          setState(() {
                            code = '';
                            verificationID = '';
                            submit = false;
                          });
                          if (_formKey.currentState!.validate()) {
                            loginWithPhone();
                          }
                        },
                        child: TranslateText(
                          text: "Sign in",
                          selectable: false,
                          style: GoogleFonts.poppins(
                            textStyle: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.normal,
                                fontSize: 16),
                          ),
                        ),
                      ),
                      GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: () {
                          print("Open terms and conditions");
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: TranslateText(
                            selectable: false,
                            text:
                                "By Signing in, you agree to our Terms & Conditions",
                            style: GoogleFonts.lato(
                                textStyle: const TextStyle(
                                    color: Colors.black38, fontSize: 10)),
                          ),
                        ),
                      ),
                      const Spacer(),
                      const Padding(
                        padding: EdgeInsets.only(bottom: 50.0),
                        child: LanguageSwitch(),
                      ),
                    ],
                  ),
                )),
          ),
        ],
      ),
    );
  }

  void loginWithPhone() async {
    FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: number,
      verificationCompleted: (PhoneAuthCredential credential) async {
        await FirebaseAuth.instance
            .signInWithCredential(credential)
            .then((value) {
          print("You are logged in successfully");
        });
      },
      verificationFailed: (FirebaseAuthException e) {
        print(e.message);
      },
      codeSent: (String verificationId, int? resendToken) {
        // verified = true;
        verificationID = verificationId;
        setState(() {});
        print("Verified: ${verificationID != ''}");
        openOTPDialog();
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  void openOTPDialog() {
    showDialog(
        context: context,
        builder: (context) {
          final defaultPinTheme = PinTheme(
            width: 60,
            height: 64,
            textStyle: GoogleFonts.poppins(
                fontSize: 20, color: const Color.fromRGBO(70, 69, 66, 1)),
            decoration: BoxDecoration(
              color: const Color.fromRGBO(232, 235, 241, 0.37),
              borderRadius: BorderRadius.circular(24),
            ),
          );
          return StatefulBuilder(
            builder: (context, setState) => AlertDialog(
              contentPadding: EdgeInsets.zero,
              content: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Container(
                        height: 80,
                        width: 80,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: failed
                              ? Colors.red.withOpacity(0.1)
                              : Colors.indigoAccent.withOpacity(0.1),
                        ),
                        child: Center(
                            child: Icon(
                          Icons.lock_outline_rounded,
                          color: failed ? Colors.red : Colors.indigoAccent,
                          size: 50,
                        )),
                      ),
                    ),
                    TranslateText(
                      text: "Authenticate",
                      style: GoogleFonts.lato(
                        textStyle: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 24),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: TranslateText(
                        text: "Enter the 6-digit code sent to your phone",
                        style: GoogleFonts.poppins(
                          textStyle: TextStyle(
                              color: Colors.grey.shade600,
                              fontWeight: FontWeight.normal,
                              fontSize: 13),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                      child: Pinput(
                        controller: controller,
                        focusNode: focusNode,
                        readOnly: submit,
                        length: 6,
                        autofocus: true,
                        onChanged: (pin) {
                          setState(() {
                            code = pin;
                          });
                          if (pin != '') {
                            setState(
                              () => failed = false,
                            );
                          }
                        },
                        onCompleted: (pin) async {
                          print("Pin completed $pin");
                          submit = true;
                          await verifyOTP(pin).then(
                            (value) {
                              Navigator.pop(context);
                              setState(() {
                                Provider.of<UserProvider>(context,
                                        listen: false)
                                    .setUser(
                                        FirebaseAuth.instance.currentUser!);
                                // ? Should set user?
                              });
                            },
                          ).catchError((err) {
                            print(err);
                            setState(() {
                              submit = false;
                              failed = true;
                            });
                            controller.setText('');
                            focusNode.previousFocus();
                          });
                        },
                        defaultPinTheme: defaultPinTheme,
                        separator: const SizedBox(width: 16),
                        focusedPinTheme: defaultPinTheme.copyWith(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: const [
                              BoxShadow(
                                color: Color.fromRGBO(
                                    0, 0, 0, 0.05999999865889549),
                                offset: Offset(0, 3),
                                blurRadius: 16,
                              )
                            ],
                          ),
                        ),
                        showCursor: true,
                        // cursor: cursor,
                      ),
                    ),
                    failed
                        ? Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Center(
                              child: Row(
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.only(right: 4.0),
                                    child: Icon(
                                      Icons.error_outline,
                                      color: Colors.red,
                                    ),
                                  ),
                                  TranslateText(
                                    text: "Incorrect code, please try again",
                                    style: GoogleFonts.poppins(
                                        textStyle: const TextStyle(
                                            color: Colors.red, fontSize: 15)),
                                  ),
                                ],
                              ),
                            ),
                          )
                        : Container(),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      height: 50,
                      width: 200,
                      child: Center(
                          child: Text(
                        "${6 - code.length} ${code.length == 5 ? 'digit' : 'digits'} left",
                        style: GoogleFonts.poppins(
                          textStyle: TextStyle(color: Colors.grey.shade600),
                        ),
                      )),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  Future<UserCredential> verifyOTP(String code) async {
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationID, smsCode: code);

    return await FirebaseAuth.instance.signInWithCredential(credential);
  }
}
