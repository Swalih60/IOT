import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:iot/auth/signup_screen.dart';
import 'package:iot/screens/admin_screen.dart';
import 'package:iot/screens/bottom_nav.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class GlassLoginScreen extends StatefulWidget {
  const GlassLoginScreen({Key? key}) : super(key: key);

  @override
  _GlassLoginScreenState createState() => _GlassLoginScreenState();
}

class _GlassLoginScreenState extends State<GlassLoginScreen> {
  bool _isPasswordVisible = false;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Vending Machine Background
          Image.asset(
            'assets/images/robo.jpg',
            fit: BoxFit.cover,
          ),

          // Glass Morphic Effect
          Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  width: 350,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.2),
                      width: 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 15,
                        spreadRadius: 5,
                      )
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Login',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Email TextField
                      TextField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.email_outlined,
                              color: Colors.white),
                          hintText: 'Email',
                          hintStyle: const TextStyle(color: Colors.white70),
                          filled: true,
                          fillColor: Colors.white.withOpacity(0.2),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              color: Colors.white.withOpacity(0.3),
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              color: Colors.white.withOpacity(0.3),
                            ),
                          ),
                        ),
                        style: const TextStyle(color: Colors.white),
                      ),

                      const SizedBox(height: 15),

                      // Password TextField
                      TextField(
                        controller: _passwordController,
                        obscureText: !_isPasswordVisible,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.lock_outline,
                              color: Colors.white),
                          hintText: 'Password',
                          hintStyle: const TextStyle(color: Colors.white70),
                          filled: true,
                          fillColor: Colors.white.withOpacity(0.2),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              color: Colors.white.withOpacity(0.3),
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              color: Colors.white.withOpacity(0.3),
                            ),
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isPasswordVisible
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              setState(() {
                                _isPasswordVisible = !_isPasswordVisible;
                              });
                            },
                          ),
                        ),
                        style: const TextStyle(color: Colors.white),
                      ),

                      const SizedBox(height: 20),

                      // Login Button
                      ElevatedButton(
                        onPressed: () async {
                          if (_passwordController.text.isEmpty ||
                              _emailController.text.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  "Field Empty",
                                  style: TextStyle(color: Colors.red),
                                ),
                                padding: EdgeInsets.all(8),
                              ),
                            );
                          } else {
                            try {
                              await Supabase.instance.client.auth
                                  .signInWithPassword(
                                      password: _passwordController.text.trim(),
                                      email: _emailController.text.trim())
                                  .then((value) {
                                if (value.user!.id ==
                                    "6cf67ce9-cd2e-473e-bf94-4e491efff6f8") {
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const AdminScreen(),
                                      ));
                                } else if (value.session != null &&
                                    value.user != null) {
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => NavScreen(),
                                      ));
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        "User not found",
                                        style: TextStyle(color: Colors.red),
                                      ),
                                      padding: EdgeInsets.all(8),
                                    ),
                                  );
                                }
                              });
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    "${e.toString().split(':').last.trim()}",
                                    style: TextStyle(color: Colors.red),
                                  ),
                                  padding: EdgeInsets.all(8),
                                ),
                              );
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 50),
                          backgroundColor: Colors.blue.withOpacity(0.7),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          'Sign In',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => SignUpScreen(),
                                    ));
                              },
                              child: const Text(
                                "Sign Up",
                                style: TextStyle(
                                  color: Colors.blue,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 6),

                      // Divider
                      Row(
                        children: [
                          Expanded(
                            child:
                                Divider(color: Colors.white.withOpacity(0.5)),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Text(
                              'or',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.7),
                              ),
                            ),
                          ),
                          Expanded(
                            child:
                                Divider(color: Colors.white.withOpacity(0.5)),
                          ),
                        ],
                      ),

                      const SizedBox(height: 15),

                      // Google Sign In Button (Only Icon)
                      IconButton(
                        icon: const FaIcon(
                          FontAwesomeIcons.google,
                          color: Colors.white,
                          size: 40,
                        ),
                        onPressed: () {
                          Supabase.instance.client.auth
                              .signInWithOAuth(OAuthProvider.google);
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
