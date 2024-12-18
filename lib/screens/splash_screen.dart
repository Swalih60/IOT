import 'package:flutter/material.dart';
import 'package:iot/auth/login_screen.dart';
import 'package:iot/screens/bottom_nav.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _productDropAnimation;
  late Animation<double> _opacityAnimation;
  late Animation<double> _opacityAnimation1;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 3),
    );

    _productDropAnimation = Tween<double>(begin: 0, end: 150).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _opacityAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Interval(0.6, 1.0)),
    );

    _opacityAnimation1 = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Interval(2.0, 3.6)),
    );

    _controller.forward().then((_) {
      // Check user status after animation completes
      _checkUser();
    });
  }

  Future<void> _checkUser() async {
    final user = Supabase.instance.client.auth.currentUser;

    // Use a slight delay to ensure the animation is fully complete
    await Future.delayed(Duration(milliseconds: 300));

    if (user != null) {
      // If user is logged in, navigate to Home Screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => NavScreen()),
      );
    } else {
      // If user is not logged in, navigate to Login Screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => GlassLoginScreen()),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Vending Machine Icon
            Positioned(
              top: 100,
              child: Icon(
                Icons.local_drink,
                size: 100,
                color: Colors.blue,
              ),
            ),
            // Product dropping animation
            AnimatedBuilder(
              animation: _productDropAnimation,
              builder: (context, child) {
                return Positioned(
                  top: 150 + _productDropAnimation.value,
                  child: Icon(
                    Icons.fastfood,
                    size: 50,
                    color: Colors.orange,
                  ),
                );
              },
            ),
            AnimatedBuilder(
              animation: _opacityAnimation1,
              builder: (context, child) {
                return Positioned(
                  bottom: 260,
                  child: Opacity(
                    opacity: _opacityAnimation.value,
                    child: Text(
                      'Your Smart Vending Solution',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                );
              },
            ),
            // Basket Icon
            Positioned(
              bottom: 100,
              child: Icon(
                Icons.shopping_basket,
                size: 80,
                color: Colors.green,
              ),
            ),
            // App Name (fades in)
            AnimatedBuilder(
              animation: _opacityAnimation,
              builder: (context, child) {
                return Positioned(
                  bottom: 40,
                  child: Opacity(
                    opacity: _opacityAnimation.value,
                    child: Text(
                      'I-VEND',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
