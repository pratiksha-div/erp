import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../bloc/AuthenticationBloc/authentication_bloc.dart';
import '../../Utils/colors_constants.dart';
import '../../Utils/images_constants.dart';
import '../../Utils/utils.dart';
import '../../Widgets/Custom_Button.dart';
import '../../Widgets/Custom_Dialog.dart';
import '../Dashbaord/Home.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _obscure = true;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    return Scaffold(
      backgroundColor: ColorConstants.background,
      body: BlocConsumer<AuthenticationBloc, AuthenticationState>(
        listener: (context, state) {
          if (state is AuthenticationSuccess) {
            Utils.navigateRemoveAll(context, Home());
          } else if (state is AuthenticationFailed) {
            // show the same dialog you use for empty-field validation
            final message = (state.message.isNotEmpty) ? state.message : 'Error in Login';
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) => Dialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                backgroundColor: Colors.transparent,
                child: UploadErrorCard(
                  title: 'Failed',
                  subtitle: message,
                  onRetry: () {
                    Navigator.pop(context);
                  },
                ),
              ),
            );
          }
        },
        builder: (context, state) {
          final isLoading = state is AuthenticationLoading;
          return SafeArea(
            child: Stack(
              children: [
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
                AbsorbPointer(
                  absorbing: isLoading, // blocks interaction when loading
                  child: Opacity(
                    opacity: isLoading ? 0.6 : 1.0, // dim while loading
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          const SizedBox(height: 28),
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
                                  'Sign in to continue',
                                  style: GoogleFonts.poppins(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                SizedBox(
                                  width: width * 0.72,
                                  child: Text(
                                    'Please sign in using your username and password',
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
                                    // Email Field
                                    Text(
                                      'Email Or User Name',
                                      style: GoogleFonts.poppins(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.12),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: TextFormField(
                                        controller: emailController,
                                        style:
                                        const TextStyle(color: Colors.black),
                                        cursorColor: ColorConstants.primary,
                                        decoration: InputDecoration(
                                          prefixIcon: const Icon(
                                            Icons.person,
                                            color: Colors.black,
                                            size: 18,
                                          ),
                                          hintText: 'Enter your username here',
                                          hintStyle: TextStyle(
                                              color: Colors.black
                                                  .withOpacity(0.7),
                                              fontSize: 13),
                                          border: InputBorder.none,
                                          contentPadding:
                                          const EdgeInsets.symmetric(
                                              vertical: 14, horizontal: 8),
                                        ),
                                        validator: (v) =>
                                        (v == null || v.isEmpty)
                                            ? 'Enter username'
                                            : null,
                                      ),
                                    ),
                                    const SizedBox(height: 14),

                                    // Password Field
                                    Text(
                                      'Password',
                                      style: GoogleFonts.poppins(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.12),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: TextFormField(
                                              controller: passwordController,
                                              obscureText: _obscure,
                                              cursorColor:
                                              ColorConstants.primary,
                                              style: const TextStyle(
                                                  color: Colors.black),
                                              decoration: InputDecoration(
                                                prefixIcon: const Icon(
                                                  Icons.lock_clock_rounded,
                                                  color: Colors.black,
                                                  size: 18,
                                                ),
                                                hintText: '••••••••',
                                                hintStyle: TextStyle(
                                                  color: Colors.black
                                                      .withOpacity(0.7),
                                                ),
                                                border: InputBorder.none,
                                                contentPadding:
                                                const EdgeInsets.symmetric(
                                                    vertical: 14,
                                                    horizontal: 8),
                                              ),
                                              validator: (v) =>
                                              (v == null || v.isEmpty)
                                                  ? 'Enter password'
                                                  : null,
                                            ),
                                          ),
                                          IconButton(
                                            icon: Icon(
                                              _obscure
                                                  ? Icons
                                                  .visibility_off_outlined
                                                  : Icons.visibility_outlined,
                                              color: Colors.black,
                                              size: 18,
                                            ),
                                            onPressed: () {
                                              setState(() {
                                                _obscure = !_obscure;
                                              });
                                            },
                                          ),
                                        ],
                                      ),
                                    ),

                                    const SizedBox(height: 12),

                                    // remember + forgot
                                    Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.end,
                                      children: [
                                        TextButton(
                                          onPressed: () {},
                                          child: Text(
                                            'Forgot Password?',
                                            style: GoogleFonts.poppins(
                                              color: Colors.black,
                                              fontSize: 13,
                                              decoration:
                                              TextDecoration.underline,
                                            ),
                                          ),
                                        )
                                      ],
                                    ),

                                    const SizedBox(height: 12),

                                    // Login button: interactions blocked when isLoading by AbsorbPointer above
                                    ButtonWhite(
                                      title:
                                      isLoading ? "Please wait..." : "Login",
                                      onAction: () {
                                        print("login tapped");
                                        // simple validation + error dialogs
                                        if (emailController.text.isEmpty) {
                                          showDialog(
                                            context: context,
                                            builder: (context) => Dialog(
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(20),
                                              ),
                                              backgroundColor: Colors.transparent,
                                              child: UploadErrorCard(
                                                title:'Failed',
                                                subtitle: "Please enter email address or username",
                                                onRetry: () {
                                                  Navigator.pop(context);
                                                },
                                              ),
                                            ),
                                          );
                                        } else if (passwordController
                                            .text.isEmpty) {
                                          showDialog(
                                            context: context,
                                            builder: (context) => Dialog(
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(20),
                                              ),
                                              backgroundColor: Colors.transparent,
                                              child: UploadErrorCard(
                                                title:'Failed',
                                                subtitle: "Please enter your password",
                                                onRetry: () {
                                                  Navigator.pop(context);
                                                },
                                              ),
                                            ),
                                          );
                                        } else {
                                          // dispatch login event
                                          BlocProvider.of<AuthenticationBloc>(
                                              context)
                                              .add(
                                            loginUserEventPressed(
                                              emailController.text,
                                              passwordController.text,
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
                if (isLoading) ...[
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
                        children: const [
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
