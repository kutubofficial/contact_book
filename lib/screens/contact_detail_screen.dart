import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:contact_book/models/contact.dart';
import 'package:contact_book/providers/contact_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'add_edit_screen.dart';
import 'package:flutter/services.dart';

class ContactDetailScreen extends StatelessWidget {
  final Contact contact;
  const ContactDetailScreen({super.key, required this.contact});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ContactProvider>();

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF6C5CE7), Color(0xFF4834D4)],
                ),
                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(32),bottomRight: Radius.circular(32),),
              ),
              padding: const EdgeInsets.fromLTRB(20, 52, 20, 30),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Row(children: [
                          Image.asset('assets/icons/back.png', width: 25, color: Colors.white),
                           Text('Contact',style: GoogleFonts.inter(color: Colors.white, fontSize: 16)),
                        ]),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.push( context,MaterialPageRoute( builder: (_) => AddEditScreen(contact: contact))),
                        child:  Text('Edit', style: GoogleFonts.inter(color: Colors.white, fontSize: 16)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  CircleAvatar(
                    radius: 45,
                    backgroundColor: Color.fromRGBO(255, 255, 255, 0.25),
                    child: Text(contact.name[0].toUpperCase(),style: const TextStyle(color: Colors.white,fontSize: 36,fontWeight: FontWeight.w600)),
                  ),
                  const SizedBox(height: 12),
                  Text(contact.name,style:  GoogleFonts.inter( color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(contact.phone,
                      style: GoogleFonts.inter( color: Color.fromRGBO(255, 255, 255, 0.8), fontSize: 14)),
                  const SizedBox(height: 24),
                  //-- Action buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: const [
                      _ActionBtn(icon: 'assets/icons/msg.png', label: 'Message'),
                      _ActionBtn(icon: 'assets/icons/call.png', label: 'Call'),
                      _ActionBtn(icon: 'assets/icons/video.png', label: 'Video'),
                      _ActionBtn(icon: 'assets/icons/mail.png', label: 'Mail'),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                children: [
                  _DetailRow(label: 'Mobile', value: contact.phone),
                  _DetailRow(label: 'Email', value: contact.email),
                  _DetailRow(label: 'Group', value: contact.group ?? 'All Contacts'),
                  Column(
                    // mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                       Text('Links', style: GoogleFonts.inter( fontWeight: FontWeight.w600, fontSize: 14)),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Image.asset('assets/icons/whatsapp.png',width: 24, height: 24,),
                          const SizedBox(width: 6),
                          Image.asset('assets/icons/telegram.png',width: 23.5, height: 23.5,),
                          const SizedBox(width: 6),
                          Image.asset('assets/icons/instagram.png',width: 26.5, height: 26.5,),
                          const SizedBox(width: 6),
                        ],
                      ),
                      const Divider(),
                    ],
                  ),
                  // const Divider(),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(
                      (contact.isFavorite ?? false) ? Icons.star: Icons.star_outline,
                      color: const Color(0xFF6C5CE7),
                    ),
                    title: Text((contact.isFavorite ?? false) ? 'Remove from Favorites' : 'Add to Favorites',
                    style: GoogleFonts.inter( fontWeight: FontWeight.w500, fontSize: 14)),
                    onTap: () {
                      provider.toggleFavorite(contact);
                      // Navigator.pop(context);
                    },
                  ),
                  const Divider(height: 0),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.share_outlined, color: Color(0xFF6C5CE7)),
                    title:  Text('Share Contact',style: GoogleFonts.inter( fontWeight: FontWeight.w500, fontSize: 14),),
                    onTap: () {
                      SharePlus.instance.share(ShareParams(text: 'Name: ${contact.name}\nPhone: ${contact.phone}\nEmail: ${contact.email}'));
                    },
                  ),
                   const Divider(height: 0),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.location_on_outlined, color: Color(0xFF6C5CE7)),
                    title:  Text('Share My Location',style: GoogleFonts.inter( fontWeight: FontWeight.w500, fontSize: 14),),
                    onTap: () {},
                  ),
                  const Divider(height: 0),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Image.asset('assets/icons/delete.png', width: 20, color: Colors.red),
                    title:  Text('Delete Contact', style: GoogleFonts.inter(color: Colors.red,fontWeight: FontWeight.w500, fontSize: 14)),
                    onTap: () {
                      // provider.deleteContact(contact.id);
                      // Navigator.pop(context);
                      _showDeleteConfirmation(context);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

    void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          insetPadding: const EdgeInsets.symmetric(horizontal: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24),),
          backgroundColor: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Delete Contact",
                      style: GoogleFonts.inter(fontSize: 20,fontWeight: FontWeight.w600,),
                    ),
                    InkWell(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(Icons.close,size: 24,),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                Text(
                  "Are you sure you want to delete this contact?",
                  style: GoogleFonts.inter(fontSize: 16,fontWeight: FontWeight.w500,height: 1.4,),
                ),
                const SizedBox(height: 8),
                Text(
                  "This action cannot be undone",
                  style: GoogleFonts.inter(fontSize: 14,fontWeight: FontWeight.w400,color: const Color(0xFF64748B),),
                ),
                const SizedBox(height: 8),
                Divider(color: Color(0xFFE2E8F0)),
                const SizedBox(height: 8),
                // Action Buttons
                Row(
                  children: [
                    // Cancel Button
                    Expanded(
                      child: SizedBox(
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () => Navigator.pop(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFEDE9FE),
                            elevation: 0,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8),),
                          ),
                          child: Text(
                            "Cancel",
                            style: GoogleFonts.inter(color: const Color(0xFF4834D4),fontSize: 14,fontWeight: FontWeight.w600,),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Yes, Delete Button
                    Expanded(
                      child: SizedBox(
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () {
                             context.read<ContactProvider>().deleteContact(contact.id);
                            Navigator.pop(context);
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFDC2626),
                            elevation: 0,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8),),
                          ),
                          child: Text(
                            "Yes, Delete",
                            style: GoogleFonts.inter(color: Colors.white,fontSize: 14,fontWeight: FontWeight.w600,),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

}

class _ActionBtn extends StatelessWidget {
  final String icon;
  final String label;
  const _ActionBtn({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 52,
          height: 52,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration( color: Colors.white, shape: BoxShape.circle,),
          child: Image.asset(icon, fit: BoxFit.contain),
        ),
        const SizedBox(height: 6),
        Text(label,style: GoogleFonts.inter(color: Colors.white, fontSize: 12)),
      ],
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  const _DetailRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,style: GoogleFonts.inter( fontWeight: FontWeight.w600, fontSize: 14)),
          const SizedBox(height: 4),
          Text(value, style: GoogleFonts.inter(color: Colors.grey[700], fontSize: 14)),
          const Divider(),
        ],
      ),
    );
  }
}