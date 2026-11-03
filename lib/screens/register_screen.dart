import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/device_uid.dart';
import 'chat_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});
  @override State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _name = TextEditingController();
  String _uid = '...';
  bool _busy = false;

  @override
  void initState() { super.initState(); _loadUid(); }
  Future<void> _loadUid() async { try { final id = await DeviceUid.get(); if (mounted) setState(() => _uid = id); } catch (_) {} }
  @override
  void dispose() { _name.dispose(); super.dispose(); }

  Future<void> _continue() async {
    final name = _name.text.trim();
    if (name.isEmpty) { _toast('اكتب اسم المستخدم أولًا'); return; }
    if (_busy) return;
    setState(() => _busy = true);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('uid', _uid);
    await prefs.setString('name', name);
    await prefs.setBool('show_id', false);
    try {
      await FirebaseDatabase.instance.ref('users/$_uid').set({'name': name, 'showId': false, 'createdAt': ServerValue.timestamp});
    } catch (_) {}
    if (!mounted) return;
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const ChatScreen()));
  }

  void _toast(String text) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text, textDirection: TextDirection.rtl)));

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: const Color(0xFFFFF8F8),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(24, 35, 24, 72),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(colors: [Color(0xFFF27878), Color(0xFFE85C5C)]),
                    borderRadius: BorderRadius.vertical(bottom: Radius.circular(40)),
                  ),
                  child: Column(
                    children: [
                      Container(
                        width: 82,
                        height: 82,
                        decoration: BoxDecoration(
                          color: const Color(0xFF111111),
                          borderRadius: BorderRadius.circular(23),
                        ),
                        child: const Center(
                          child: Text('A', style: TextStyle(color: Color(0xFFFF7B7B), fontSize: 46, fontWeight: FontWeight.bold)),
                        ),
                      ),
                      const SizedBox(height: 18),
                      const Text(
                        'Welcome to Ahmed Saad Community',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Color(0xFF111111), fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                Transform.translate(
                  offset: const Offset(0, -36),
                  child: Card(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    elevation: 8,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          _label('معرّف المستخدم'),
                          TextField(
                            controller: TextEditingController(text: _uid),
                            readOnly: true,
                            textDirection: TextDirection.ltr,
                            decoration: _decoration(),
                          ),
                          const SizedBox(height: 16),
                          _label('اسم المستخدم'),
                          TextField(
                            controller: _name,
                            maxLength: 20,
                            textDirection: TextDirection.rtl,
                            textInputAction: TextInputAction.done,
                            onSubmitted: (_) => _continue(),
                            decoration: _decoration('اكتب اسمك هنا'),
                          ),
                          const Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              'اليوزر مش هيتعرض لحد',
                              textDirection: TextDirection.rtl,
                              style: TextStyle(color: Color(0xFF9A8A8A), fontSize: 12),
                            ),
                          ),
                          const SizedBox(height: 22),
                          SizedBox(
                            width: double.infinity,
                            height: 52,
                            child: ElevatedButton(
                              onPressed: _busy ? null : _continue,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF111111),
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(26)),
                              ),
                              child: Text(_busy ? 'جاري الحفظ...' : 'Continue'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );

  Widget _label(String text) => Align(
        alignment: Alignment.centerRight,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 6),
          child: Text(
            text,
            textDirection: TextDirection.rtl,
            style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF5A4A4A)),
          ),
        ),
      );

  InputDecoration _decoration([String? hint]) => InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: const Color(0xFFFFF1F1),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFFF3C9C9)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFFF3C9C9)),
        ),
      );
}
