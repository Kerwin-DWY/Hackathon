import 'package:flutter/material.dart';
import '../../../../Data/Services/AWS/aws_cognito.dart';
import '../../../Components/app_bar.dart';
import '../../../Components/primary_btn.dart';
import '../../../Components/spacer.dart';
import '../../../Declarations/Constants/Images/image_files.dart';
import '../../../Declarations/Constants/constants.dart';
import '../Widgets/input_field.dart';
import 'homePage.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key, required this.title});

  final String title;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late TextEditingController emailController;
  late TextEditingController passwordController;

  @override
  void initState() {
    // Initialize the controllers with default text
    emailController = TextEditingController(text: "wdu07@student.ubc.ca");
    passwordController = TextEditingController(text: "Kerwin@1234");
    super.initState();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(appBarTitle: widget.title),
      // Ensures content resizes when the keyboard is up
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView( // Make the content scrollable
        child: Padding(
          padding: kHPadding,
          child: Column(
            children: [
              Image.asset(
                loginImages[0],
                width: 350,
                height: 350,
                fit: BoxFit.cover,
              ),
              InputField(
                controller: emailController,
                isPassword: false,
                labelTxt: 'Email',
                icon: Icons.person,
              ),
              HeightSpacer(myHeight: kSpacing),
              InputField(
                controller: passwordController,
                isPassword: true,
                labelTxt: 'Password',
                icon: Icons.lock,
              ),
              HeightSpacer(myHeight: kSpacing),
              PrimaryBtn(
                btnText: 'Login',
                btnFun: () => login(emailController.text, passwordController.text),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Update the login function
  Future<void> login(String email, String password) async {
    try {
      final success = await AWSServices().createInitialRecord(email, password);

      if (success) {
        // Navigate to HomePage after successful login
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
      } else {
        // Handle login failure (show an error message, etc.)
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Login failed!')),
        );
      }
    } catch (e) {
      // Handle exceptions
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }
}
