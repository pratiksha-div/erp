
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../bloc/AuthenticationBloc/authentication_bloc.dart';
import '../../../bloc/AuthenticationBloc/verify_otp_bloc.dart';
import '../../Utils/colors_constants.dart';
import '../../Utils/dialogs_utils.dart';
import '../../Utils/images_constants.dart';
import '../../Utils/messages_constants.dart';
import '../../Utils/utils.dart';
import '../../Widgets/Custom_Button.dart';
import '../../Widgets/Custom_Dialog.dart';
import '../Dashbaord/Home.dart';
import 'Login.dart';

class OTPVerification extends StatefulWidget {
  const OTPVerification({super.key});
  @override
  State<OTPVerification> createState() => _OTPVerificationState();
}

class _OTPVerificationState extends State<OTPVerification> {
  bool _obscure = true;
  final TextEditingController otpController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    otpController.dispose();
    super.dispose();
  }

  void _showErrorDialog(String title, String subtitle) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        backgroundColor: Colors.transparent,
        child: UploadErrorCard(
          title: title,
          subtitle: subtitle,
          onRetry: () {
            Navigator.pop(context);
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    return Scaffold(
      backgroundColor: ColorConstants.background,
      body: BlocConsumer<VerifyOTPBloc, VerifyOTPState>(
        listener: (context, state) {
          if (state is VerifyOTPSuccess) {
            print("VerifyOTPSuccess");
            Utils.navigateTo(context,Home());
            // Utils.navigateRemoveAll(context, Home());
          } else if (state is VerifyOTPFailed) {
            UploadErrorCard(title:'Failed', subtitle:state.message,);
          }
        },
        builder: (context, state) {
          final isLoading = state is VerifyOTPLoading;

          return SafeArea(
            child: Stack(
              children: [
                // background decorative element
                Positioned(
                  top: -40,
                  right: -40,
                  child: Transform.rotate(
                    angle: -0.6,
                    child: Container(
                      width: 220,
                      height: 220,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            ColorConstants.primary,
                            ColorConstants.secondary
                          ],
                        ),
                        borderRadius: BorderRadius.circular(40),
                      ),
                    ),
                  ),
                ),
                // main content (disabled while loading via AbsorbPointer)
                AbsorbPointer(
                  absorbing: isLoading, // blocks interaction when loading
                  child: Opacity(
                    opacity: isLoading ? 0.6 : 1.0, // dim while loading
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          const SizedBox(height: 28),

                          // logo heart + welcome text
                          Center(
                            child: Column(
                              children: [
                                // heart badge
                                Container(
                                  width: 100,
                                  height: 100,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 10),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.08),
                                        blurRadius: 8,
                                        offset: const Offset(0, 4),
                                      )
                                    ],
                                  ),
                                  child: Center(
                                    child: Container(
                                      child: Image.asset(
                                        ImageConstants.logoURl,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 18),
                                Text(
                                  'OTP Sent',
                                  style: GoogleFonts.poppins(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                SizedBox(
                                  width: width * 0.72,
                                  child: Text(
                                    'Please enter 4 digit OTP sent to your registered gmail',
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.poppins(
                                      fontSize: 13,
                                      color: Colors.black54,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 26),

                          // main card with fields
                          Padding(
                            padding:
                            const EdgeInsets.symmetric(horizontal: 22.0),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 18, vertical: 18),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    ColorConstants.primary,
                                    ColorConstants.secondary
                                  ],
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.12),
                                    blurRadius: 12,
                                    offset: const Offset(0, 6),
                                  )
                                ],
                              ),
                              child: Form(
                                key: _formKey,
                                child: Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.stretch,
                                  children: [
                                    const SizedBox(height: 20),
                                    Text(
                                      'Check your registered email',
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.poppins(
                                        fontSize: 13,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    OtpTextField(
                                      numberOfFields: 4,
                                      borderColor: Colors.black,
                                      borderWidth: 1,
                                      showFieldAsBox: true,
                                      enabledBorderColor: Colors.black,
                                      cursorColor:Colors.black,
                                      focusedBorderColor: Colors.black,
                                      onCodeChanged: (String code) {
                                        //handle validation or checks here
                                      },
                                      //runs when every textfield is filled
                                      onSubmit: (String verificationCode){
                                        otpController.text = verificationCode;
                                      }, // end onSubmit
                                    ),
                                    const SizedBox(height: 40),
                                    ButtonWhite(
                                      title: isLoading ? "Please wait..." : "Submit",
                                      onAction: () {
                                        print("tapped");
                                        // simple validation + error dialogs
                                        if (otpController.text.isEmpty) {
                                          showDialog(
                                            context: context,
                                            builder: (context) => Dialog(
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(20),
                                              ),
                                              backgroundColor: Colors.transparent,
                                              child: UploadErrorCard(
                                                title:'Failed',
                                                subtitle: "Please enter OTP sent in your email address",
                                                onRetry: () {
                                                  Navigator.pop(context);
                                                },
                                              ),
                                            ),
                                          );
                                        } else {
                                          BlocProvider.of<VerifyOTPBloc>(
                                              context)
                                              .add(
                                            VerifyOTPEventPressed(
                                              otpController.text,
                                            ),
                                          );
                                        }
                                      },
                                    ),

                                  ],
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                ),
                // Loading overlay
                if (isLoading) ...[
                  // Prevent taps below and dim the background
                  ModalBarrier(
                    dismissible: false,
                    color: Colors.black.withOpacity(0.3),
                  ),
                  Center(
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black.withOpacity(0.15),
                              blurRadius: 10)
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children:  [
                          SizedBox(
                            width: 40,
                            height: 40,
                            child: CircularProgressIndicator(
                              color: ColorConstants.primary,
                            ),
                          ),
                          SizedBox(height: 12),
                          Text("Signing in..."),
                        ],
                      ),
                    ),
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}
