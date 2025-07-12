import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sp_app/Modules/Shared/Screens/SHHomeScreen.dart';
import 'package:sp_app/Modules/Shared/Widgets/CustomSnackBar.dart';
import 'package:sp_app/Provider/Data.dart';

import '../../../constant.dart';

class ChangePasswordScreen extends StatefulWidget {
  bool isForgot;
  ChangePasswordScreen(this.isForgot);
  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  bool passenable = true;
  bool isLoading = false;
  bool trySubmitted = false;

  final TextEditingController _password = TextEditingController();
  final TextEditingController _repassword = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  Future<void> _submitted() async {
    FocusManager.instance.primaryFocus?.unfocus();
    trySubmitted = true;

    if (_formKey.currentState!.validate()) {
      final provider = Provider.of<Data>(context, listen: false);
      final SharedPreferences sharedpref =
          await SharedPreferences.getInstance();
      var result = await provider.changePassword(
          {"email": sharedpref.getString('email'), "password": _password.text});
      setState(() {
        isLoading = false;
      });
      if (result["code"] == '200') {
        ScaffoldMessenger.of(context).showSnackBar(
          customSnackBar(
            content: 'Password Updated Successfully',
          ),
        );
        if (widget.isForgot) {
          await provider.getWorks();
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => SHHomeScreen(
                  sharedpref.getString('name'),
                ),
              ),
              (route) => false);
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          customSnackBar(
            content: result['message'].toString(),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: widget.isForgot
              ? null
              : InkWell(
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
                  'Change Password',
                  style: TextStyle(
                    color: Color(0xff2C364E),
                    fontSize: 21,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * .11,
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Container(
                        height: 50,
                        child: TextFormField(
                          decoration: TextFieldDecoration.copyWith(
                            hintText: 'Enter Password',
                          ),
                          controller: _password,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Enter a email';
                            }
                            return null;
                          },
                        ),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      TextFormField(
                        controller: _repassword,
                        obscureText: !passenable,
                        decoration: TextFieldDecoration.copyWith(
                          hintText: 'Password',
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                passenable = !passenable;
                              });
                            },
                            icon: Icon(
                              !passenable
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: kPrimary,
                            ),
                          ),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Enter a password';
                          }
                          return null;
                        },
                        cursorColor: Color(0xff3B73E9),
                        onChanged: (value) {
                          if (trySubmitted) _formKey.currentState!.validate();
                        },
                      ),
                      SizedBox(height: 50),
                      ElevatedButton(
                        onPressed: _submitted,
                        child: const Text(
                          'Change Password',
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
