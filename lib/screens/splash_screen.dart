import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'register_screen.dart';
import 'chat_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() { super.initState(); Future.delayed(const Duration(milliseconds: 1200), _next); }

  Future<void> _next() async {
    if (!mounted) return;
    final prefs = await SharedPreferences.getInstance();
    final registered = (prefs.getString('uid') ?? '').isNotEmpty && (prefs.getString('name') ?? '').isNotEmpty;
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => registered ? const ChatScreen() : const RegisterScreen()));
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFF27878), Color(0xFFE85C5C), Color(0xFFC94444)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 118,
                  height: 118,
                  decoration: BoxDecoration(
                    color: const Color(0xFF111111),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: const Center(
                    child: Text('A', style: TextStyle(color: Color(0xFFFF7B7B), fontSize: 68, fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Ahmed Saad Community',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
      );
}
