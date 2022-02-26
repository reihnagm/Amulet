import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:amulet/views/basewidgets/loader/circular.dart';
import 'package:amulet/views/screens/auth/sign_in.dart';
import 'package:amulet/localization/language_constraints.dart';
import 'package:amulet/utils/color_resources.dart';
import 'package:amulet/utils/dimensions.dart';
import 'package:amulet/providers/auth.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({Key? key}) : super(key: key);

  @override
  OtpScreenState createState() => OtpScreenState();
}

class OtpScreenState extends State<OtpScreen> {
  bool loading = true;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  GlobalKey<ScaffoldState> globalKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    (() async {
      loading = true;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      setState(() {
        Provider.of<AuthProvider>(context, listen: false).changeEmailName = prefs.getString("email_otp")!; 
        loading = false;
      });
    })();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: globalKey,
      backgroundColor: ColorResources.bgGrey,
      body: Consumer<AuthProvider>(
        builder: (BuildContext context, AuthProvider authProvider, Widget? child) {
          return SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text('Verifikasi Alamat E-mail',
                    style: TextStyle(
                      fontWeight: FontWeight.bold, 
                      fontSize: Dimensions.fontSizeDefault
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 8.0),
                  child: RichText(
                    text: TextSpan(
                      text: "Mohon masukkan 4 digit kode telah dikirim ke Alamat E-mail ",
                      children: [
                        TextSpan(
                          text: loading ? "..." : authProvider.changeEmailName,
                          style: TextStyle(
                            color: ColorResources.black,
                            fontWeight: FontWeight.bold,
                            fontSize: Dimensions.fontSizeSmall
                          )
                        ),
                      ],
                      style: TextStyle(
                        color: Colors.black54, 
                        fontSize: Dimensions.fontSizeSmall
                      )
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(
                  height: 20.0
                ),
                authProvider.changeEmail ? Form(
                  key: formKey,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 80.0),
                    child: PinCodeTextField(
                      appContext: context,
                      backgroundColor: Colors.transparent,
                      pastedTextStyle: TextStyle(
                        color: ColorResources.success,
                        fontSize: Dimensions.fontSizeSmall
                      ),
                      length: 4,
                      animationType: AnimationType.fade,
                      pinTheme: PinTheme(
                        shape: PinCodeFieldShape.box,
                        inactiveColor: ColorResources.blueGrey,
                        inactiveFillColor: ColorResources.white,
                        selectedFillColor: ColorResources.white,
                        activeFillColor: ColorResources.white,
                        selectedColor: Colors.transparent,
                        activeColor: ColorResources.redPrimary,
                        borderWidth: 1.5,
                        fieldHeight: 50.0,
                        fieldWidth: 50.0,
                      ),
                      cursorColor: ColorResources.redPrimary,
                      animationDuration: const Duration(milliseconds: 100),
                      enableActiveFill: true,
                      keyboardType: TextInputType.text,
                      onCompleted: (v) {
                        authProvider.otpCompleted(v);
                      },
                      onChanged: (value) {

                      },
                      beforeTextPaste: (text) {
                        return true;
                      },
                    )
                  ),
                ) : Container(),
                
                authProvider.changeEmail 
                ? Container() 
                : Container(
                  margin: const EdgeInsets.only(left: Dimensions.marginSizeSmall, right: Dimensions.marginSizeSmall),
                  child: TextFormField(
                    onChanged: (val) {
                      authProvider.emailCustomChange(val);
                    },
                    initialValue: authProvider.changeEmailName,
                    decoration: InputDecoration(
                      fillColor: ColorResources.white,
                      filled: true,
                      hintText: authProvider.changeEmailName,
                      hintStyle: TextStyle(
                        fontSize: Dimensions.fontSizeSmall
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10.0),
                        ),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10.0),
                        ),
                        borderSide: BorderSide.none,
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.all(16.0),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    style: TextStyle(
                      fontSize: Dimensions.fontSizeSmall
                    )
                  ),
                ),
                authProvider.changeEmail 
                ? Container() 
                : Container(
                  margin: const EdgeInsets.only(top: 20.0),
                  child: Row(
                    children: [
                      Flexible(
                        child: Container(
                          margin: const EdgeInsets.only(left: Dimensions.marginSizeSmall, right: Dimensions.marginSizeSmall),
                          width: double.infinity,
                          height: 50.0,
                          child: TextButton(
                            style: TextButton.styleFrom(
                              shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              side: BorderSide(
                                color: ColorResources.redPrimary,
                                width: 1.0
                              )
                            ),
                              backgroundColor: ColorResources.white,
                            ),
                            child: Text(getTranslated("CANCEL", context),
                              style: TextStyle(
                                color: ColorResources.redPrimary,
                                fontSize: Dimensions.fontSizeSmall,
                                fontWeight: FontWeight.bold
                              )
                            ),
                            onPressed: () {
                              authProvider.cancelCustomEmail();
                            }
                          ),
                        ),
                      ),
                      Flexible(
                        child: Container(
                          margin: const EdgeInsets.only(left: 16.0, right: 16.0),
                          width: double.infinity,
                          height: 50.0,
                          child: TextButton(
                            style: TextButton.styleFrom(
                              shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              side: BorderSide(
                                color: ColorResources.redPrimary,
                                width: 1.0
                              )
                            ),
                              backgroundColor: ColorResources.white,
                            ),
                            child: authProvider.applyChangeEmailOtpStatus == ApplyChangeEmailOtpStatus.loading 
                            ? const SizedBox(
                                width: 18.0,
                                height: 18.0,
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(ColorResources.redPrimary),
                                ),
                              ) 
                            : Text('Apply',
                              style: TextStyle(
                                color: ColorResources.redPrimary,
                                fontSize: Dimensions.fontSizeSmall,
                                fontWeight: FontWeight.bold
                              )
                            ),
                            onPressed: () => authProvider.applyChangeEmailOtp(context, globalKey),
                          ),
                        ),
                      )
                    ],
                  ),
                ), 
                authProvider.whenCompleteCountdown == "start" ? Container(
                  margin: const EdgeInsets.only(top: 15.0, bottom: 15.0, right: 35.0),
                  alignment: Alignment.centerRight,
                  child: CircularCountDownTimer(
                    duration: 120,
                    initialDuration: 0,
                    width: 40.0,
                    height: 40.0,
                    ringColor: Colors.transparent,
                    ringGradient: null,
                    fillColor: ColorResources.redPrimary.withOpacity(0.4),
                    fillGradient: null,
                    backgroundColor: ColorResources.redPrimary,
                    backgroundGradient: null,
                    strokeWidth: 10.0,
                    strokeCap: StrokeCap.round,
                    textStyle: TextStyle(
                      fontSize: Dimensions.fontSizeSmall,
                      color: ColorResources.white,
                      fontWeight: FontWeight.bold
                    ),
                    textFormat: CountdownTextFormat.S,
                    isReverse: true,
                    isReverseAnimation: true,
                    isTimerTextShown: true,
                    autoStart: true,
                    onStart: () {
                    },
                    onComplete: () {
                      authProvider.completeCountDown();
                    },
                  ),
                ) : Container(),
                const SizedBox(
                  height: 5.0,
                ),
                authProvider.whenCompleteCountdown == "completed" 
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(getTranslated("DID_NOT_RECEIVE_CODE", context),
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: Dimensions.fontSizeSmall
                        ),
                      ),
                      TextButton(
                        onPressed: () => authProvider.resendOtpCall(context, globalKey),
                        child: authProvider.resendOtpStatus == ResendOtpStatus.loading 
                        ? const SizedBox(
                          width: 12.0,
                          height: 12.0,
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(ColorResources.redPrimary),
                          ),
                        )
                        : Text(getTranslated("RESEND", context),
                          style: TextStyle(
                            color: ColorResources.redPrimary,
                            fontSize: Dimensions.fontSizeSmall
                          ),
                        )
                      )
                    ],
                  ) 
                : Container(),
                Container(
                  margin: const EdgeInsets.only(left: 16.0, right: 16.0),
                  width: double.infinity,
                  height: 50.0,
                  child: TextButton(
                    style: TextButton.styleFrom(
                      shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                      backgroundColor: ColorResources.redPrimary,
                    ),
                    child: authProvider.verifyOtpStatus == VerifyOtpStatus.loading 
                    ? const Loader(
                        color: ColorResources.white,
                      )
                    : Text('Verify',
                      style: TextStyle(
                        color: ColorResources.white,
                        fontSize: Dimensions.fontSizeSmall,
                        fontWeight: FontWeight.bold
                      )
                    ) ,
                    onPressed: () => authProvider.verifyOtp(context, globalKey)
                  ),
                ),
                const SizedBox(
                  height: 10.0,
                ),
                Container(
                  margin: const EdgeInsets.only(left: 16.0, right: 16.0),
                  child: TextButton(
                    child: Text(getTranslated("BACK", context),
                      style: TextStyle(
                        color: ColorResources.redPrimary,
                        fontSize: Dimensions.fontSizeSmall,
                        fontWeight: FontWeight.bold
                      )
                    ),
                    onPressed: () => Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (BuildContext context) => SignInScreen())
                    )
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 16.0, right: 16.0),
                  child: TextButton(
                    child: Text(getTranslated("CHANGE_EMAIL", context),
                      style: TextStyle(
                        color: ColorResources.redPrimary,
                        fontSize: Dimensions.fontSizeSmall,
                        fontWeight: FontWeight.bold
                      )
                    ),
                    onPressed: () => authProvider.changeEmailCustom(),
                  ),
                ),
              ],
            ),
          );
        },
      )
    );
  }
}
