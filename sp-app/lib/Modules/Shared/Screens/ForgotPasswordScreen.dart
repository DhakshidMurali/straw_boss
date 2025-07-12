import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sp_app/Modules/Shared/Screens/ChangePasswordScreen.dart';
import 'package:sp_app/Modules/Shared/Widgets/CustomSnackBar.dart';
import 'package:sp_app/Provider/Data.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../../constant.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  bool passenable = true;
  bool isLoading = false;
  bool trySubmitted = false;
  bool isOTP = false;
  var response;
  late String verificationId;

  final auth = FirebaseAuth.instance;

  final TextEditingController _number = TextEditingController();
  final TextEditingController _otp = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  Future<void> _submitted() async {
    FocusManager.instance.primaryFocus?.unfocus();
    trySubmitted = true;
    final SharedPreferences sharedpref = await SharedPreferences.getInstance();
    if (!isOTP) {
      if (!_formKey.currentState!.validate()) return;
      final provider = Provider.of<Data>(context, listen: false);

      setState(() {
        isLoading = true;
      });

      var result = await provider.getUserByNumber({
        "number": _number.text,
      });

      if (result["code"] == '200') {
        print(result);
        setState(() {
          isOTP = true;
          response = result;
        });
        sendOTP();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          customSnackBar(
            content: result['message'].toString(),
          ),
        );
        setState(() {
          isLoading = false;
        });
      }
    } else {
      try {
        PhoneAuthCredential phoneAuthCredential = PhoneAuthProvider.credential(
            verificationId: verificationId, smsCode: _otp.text);

        final _auth = FirebaseAuth.instance;
        final authCredential =
            await _auth.signInWithCredential(phoneAuthCredential);

        if (authCredential.user != null) {
          print(phoneAuthCredential);
          print(authCredential.user!.uid);
          SharedPreferences sharedpref = await SharedPreferences.getInstance();

          sharedpref.setString('id', response['id']);
          sharedpref.setString('email', response['email']);
          sharedpref.setString('name', response['name']);
          sharedpref.setString('role', response['role']);
          if (response['role'] == 'staff') {
            List<String> classes = [];
            for (int i = 0; i < response['class'].length; i++) {
              classes.add(response['class'][i]);
            }
            sharedpref.setStringList('classes', classes);
          } else {
            sharedpref.setString('class', response['class']);
          }

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => ChangePasswordScreen(true),
            ),
          );
        }
      } on FirebaseException catch (err) {
        var message = 'An error occured, Please check your credentials';

        if (err.message != null) {
          message = err.message!;
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
          ),
        );
      }
    }
  }

  sendOTP() async {
    setState(() {
      isLoading = true;
    });
    await auth.verifyPhoneNumber(
      phoneNumber: '+91${_number.text}',
      verificationCompleted: (phoneAuthCredential) async {
        setState(() {});
      },
      verificationFailed: (verificationFailed) async {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(verificationFailed.message!),
          ),
        );
      },
      codeSent: (verificationId, resendingToken) async {
        setState(() {
          isOTP = true;
          this.verificationId = verificationId;
        });
      },
      codeAutoRetrievalTimeout: (verificationId) async {},
    );
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: LoadingOverlay(
        color: Colors.black,
        isLoading: isLoading,
        progressIndicator: Center(
          child: Material(
            child: Container(
              color: Color(0xff6E7FFC),
              height: 130,
              width: 130,
              padding: EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Loading',
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).size.height * 0.025,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Container(
                    height: 40,
                    width: 40,
                    child: LoadingIndicator(
                        indicatorType: Indicator.ballPulseSync,
                        colors: const [Colors.white],
                        strokeWidth: 0,
                        backgroundColor: Colors.transparent,
                        pathBackgroundColor: Colors.black),
                  ),
                ],
              ),
            ),
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            automaticallyImplyLeading: true,
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Icon(
                  Icons.arrow_back,
                  color: Color(0xff2C364E),
                ),
              ),
            ),
          ),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    height: MediaQuery.of(context).size.height * .1,
                  ),
                  Text(
                    'Forgot Password',
                    style: TextStyle(
                      color: Color(0xff2C364E),
                      fontSize: 21,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * .11,
                  ),
                  if (!isOTP)
                    Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextFormField(
                            decoration: TextFieldDecoration.copyWith(
                              hintText: 'Enter Number',
                            ),
                            keyboardType: TextInputType.number,
                            controller: _number,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Enter a mobile number';
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),
                  if (isOTP)
                    PinCodeTextField(
                      length: 6,
                      obscureText: false,
                      animationType: AnimationType.fade,
                      keyboardType: TextInputType.number,
                      pinTheme: PinTheme(
                        shape: PinCodeFieldShape.box,
                        inactiveColor: Color(0xff2C364E),
                        activeColor: Color(0xff2C364E),
                        selectedColor: Color(0xff2C364E),
                        selectedFillColor: Colors.transparent,
                        borderRadius: BorderRadius.circular(5),
                        fieldHeight: 50,
                        fieldWidth: 40,
                        activeFillColor: Colors.white,
                        inactiveFillColor: Colors.transparent,
                      ),
                      backgroundColor: Colors.transparent,
                      animationDuration: Duration(milliseconds: 300),
                      enableActiveFill: true,
                      controller: _otp,
                      appContext: context,
                      onChanged: (String value) {},
                    ),
                  SizedBox(
                    height: 70.0,
                  ),
                  ElevatedButton(
                    onPressed: _submitted,
                    child: Text(
                      isOTP ? 'Sumbit' : 'Next',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      primary: Color(0xff6E7FFC),
                      fixedSize: Size(350, 50),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
