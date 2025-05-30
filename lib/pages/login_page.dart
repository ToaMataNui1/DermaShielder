import 'package:DermaShielder/components/button.dart';
import 'package:DermaShielder/components/textfield.dart';
import 'package:DermaShielder/components/square_tile.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'home_page.dart';
//comment test

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with TickerProviderStateMixin {
  // text editing controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // sign user in
  void signUserIn() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      Navigator.of(context).pop(); // Remove loading circle

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Login successful!'),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 500),
          pageBuilder: (context, animation, secondaryAnimation) => const HomePage(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(1.0, 0.0);
            const end = Offset.zero;
            const curve = Curves.easeInOut;

            var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
            var offsetAnimation = animation.drive(tween);

            return SlideTransition(position: offsetAnimation, child: child);
          },
        ),
      );
    } on FirebaseAuthException catch (e) {
      Navigator.of(context).pop(); // Remove loading circle on error

      String message = "An error occurred. Please double-check your username and/or password.";

      if (e.code == 'user-not-found') {
        message = "No user found for that email.";
      } else if (e.code == 'wrong-password') {
        message = "Incorrect password. Please try again.";
      } else if (e.code == 'invalid-email') {
        message = "Invalid email format.";
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red,
        ),
      );
    }
  }



  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _slideAnimation = Tween<Offset>(begin: const Offset(0, 1), end: const Offset(0, 0))
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    // Start the animation after the page is loaded
    Future.delayed(const Duration(milliseconds: 100), () {
      _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView( // Use SingleChildScrollView for better handling on small screens
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildSlideIn(50, SizedBox(
                  width: 100, // Set the desired width
                  height: 100, // Set the desired height
                  child: Image.asset("lib/assets/images/logo_transparent.png"),
                ))
                ,
                _buildSlideIn(100, const SizedBox(height: 20)), // Added spacing
                _buildSlideIn(150, Text(
                  'Welcome back, you\'ve been missed!',
                  style: TextStyle(color: Colors.grey[700], fontSize: 16),
                )),
                _buildSlideIn(200, const SizedBox(height: 30)), // Added spacing
                _buildSlideIn(250, MyTextField(
                  controller: emailController,
                  hintText: 'Email',
                  obscureText: false,
                )),
                _buildSlideIn(300, const SizedBox(height: 20)), // Added spacing
                _buildSlideIn(350, MyTextField(
                  controller: passwordController,
                  hintText: 'Password',
                  obscureText: true,
                )),
                _buildSlideIn(400, const SizedBox(height: 20)), // Added spacing
                _buildSlideIn(450, Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text('Forgot Password?', style: TextStyle(color: Colors.grey[600])),
                    ],
                  ),
                )),
                _buildSlideIn(500, const SizedBox(height: 30)), // Added spacing
                _buildSlideIn(550, MyButton(onTap: signUserIn)),
                _buildSlideIn(600, const SizedBox(height: 30)), // Added spacing
                _buildSlideIn(650, Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Divider(
                          thickness: 0.5,
                          color: Colors.grey[400],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Text('Or continue with', style: TextStyle(color: Colors.grey[700])),
                      ),
                      Expanded(
                        child: Divider(
                          thickness: 0.5,
                          color: Colors.grey[400],
                        ),
                      )
                    ],
                  ),
                )),
                _buildSlideIn(700, const SizedBox(height: 30)), // Added spacing
                _buildSlideIn(750, const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SquareTile(imagePath: 'lib/assets/images/google_logo.png'),
                    SizedBox(width: 25),
                    SquareTile(imagePath: 'lib/assets/images/github_logo.png')
                  ],
                )),
                _buildSlideIn(800, const SizedBox(height: 30)), // Added spacing
                _buildSlideIn(850, Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Not a member?", style: TextStyle(color: Colors.grey[700])),
                    const SizedBox(width: 4),
                    const Text("Register now!", style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
                  ],
                )),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSlideIn(double delay, Widget child) {
    return SlideTransition(
      position: _slideAnimation,
      child: child,
    );
  }
}
