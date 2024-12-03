import 'package:flutter/material.dart';
import 'package:iot/providers/bottom_nav_provider.dart';
import 'package:iot/providers/cart_provider.dart';
import 'package:iot/screens/splash_screen.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

const supabaseUrl = 'https://rwqgjmhzjbyrnqoxffha.supabase.co';
const supabaseKey = String.fromEnvironment(
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InJ3cWdqbWh6amJ5cm5xb3hmZmhhIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzMyMzY1MTksImV4cCI6MjA0ODgxMjUxOX0.6QhE37vt_VwxWwj5FQZjSQIubUf5Wq6OBhzVRUm7Klg');

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(url: supabaseUrl, anonKey: supabaseKey);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => BottomProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => CartProvider(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData.dark(),
        home: SplashScreen(),
      ),
    );
  }
}
