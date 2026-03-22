import 'package:contact_book/screens/add_edit_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class KeypadScreen extends StatefulWidget {
  const KeypadScreen({super.key});

  @override
  State<KeypadScreen> createState() => _KeypadScreenState();
}

class _KeypadScreenState extends State<KeypadScreen> {
  String _input = '';

  final List<Map<String, String>> _keys = [
    {'num': '1', 'sub': ''},
    {'num': '2', 'sub': 'ABC'},
    {'num': '3', 'sub': 'DEF'},
    {'num': '4', 'sub': 'GHI'},
    {'num': '5', 'sub': 'JKL'},
    {'num': '6', 'sub': 'MNO'},
    {'num': '7', 'sub': 'PQRS'},
    {'num': '8', 'sub': 'TUV'},
    {'num': '9', 'sub': 'WXYZ'},
    {'num': '*', 'sub': ''},
    {'num': '0', 'sub': '+'},
    {'num': '#', 'sub': ''},
  ];

  void _onKeyTap(String value) {
    setState(() => _input += value);
  }

  void _onDelete() {
    if (_input.isNotEmpty) {
      setState(() => _input = _input.substring(0, _input.length - 1));
    }
  }

  void _onDeleteLongPress() {
    setState(() => _input = '');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left:24,top:30),
              child: ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: Icon(Icons.person_add_alt_1, color: const Color(0xFF6C5CE7),size: 28,),
                      title: Text('Create new contact',
                      style: GoogleFonts.inter( fontWeight: FontWeight.w500, fontSize: 22)),
                      onTap: () {
                         Navigator.push(context, MaterialPageRoute(builder: (_) => const AddEditScreen()));
                      },
                    ),
            ),
             Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 1),
              child: ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: Icon(Icons.person_add_alt_1, color: const Color(0xFF6C5CE7),size: 28,),
                      title: Text('Add to a contact',
                      style: GoogleFonts.inter( fontWeight: FontWeight.w500, fontSize: 22)),
                      onTap: () {
                         Navigator.push(context, MaterialPageRoute(builder: (_) => const AddEditScreen()));
                      },
                    ),
            ),
            const Spacer(),
Padding(
  padding: const EdgeInsets.symmetric(horizontal: 24),
  child: Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Expanded(
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal, 
          reverse: true,                    
          child: Text( _input,
            style: GoogleFonts.inter(fontSize: 36,fontWeight: FontWeight.w300,color: const Color(0xFF1E293B), letterSpacing: 4,
            ),
          ),
        ),
      ),
      if (_input.isNotEmpty) ...[
        const SizedBox(width: 8),
        GestureDetector(
          onTap: _onDelete,
          onLongPress: _onDeleteLongPress,
          child: const Icon(Icons.backspace_outlined,color: Color(0xFF6C5CE7), size: 24),
        ),
      ],
    ],
  ),
),

            const SizedBox(height: 8),
            const Divider(indent: 40, endIndent: 40),
            const SizedBox(height: 16),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 1.4,
                ),
                itemCount: _keys.length,
                itemBuilder: (_, i) {
                  final key = _keys[i];
                  return _KeyButton(
                    number: key['num']!,
                    sub: key['sub']!,
                    onTap: () => _onKeyTap(key['num']!),
                  );
                },
              ),
            ),

            const SizedBox(height: 16),

            GestureDetector(
              onTap: () {
                // hook up real call 
              },
              child: Container(
                width: 70,
                height: 70,
                decoration: const BoxDecoration(color: Color(0xFF6C5CE7), shape: BoxShape.circle,),
                child: const Icon(Icons.call, color: Colors.white, size: 32),
              ),
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class _KeyButton extends StatelessWidget {
  final String number;
  final String sub;
  final VoidCallback onTap;

  const _KeyButton({
    required this.number,
    required this.sub,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(color: const Color(0xFFF8F7FF),borderRadius: BorderRadius.circular(16),),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(number,
              style: GoogleFonts.inter(fontSize: 24,fontWeight: FontWeight.w400,color: const Color(0xFF1E293B),
              ),
            ),
            if (sub.isNotEmpty)
              Text(sub,
                style: GoogleFonts.inter(fontSize: 9,fontWeight: FontWeight.w500,color: Colors.grey[400],letterSpacing: 1.5,),
              ),
          ],
        ),
      ),
    );
  }
}