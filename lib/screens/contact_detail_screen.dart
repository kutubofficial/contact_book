import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/contact.dart';
import '../providers/contact_provider.dart';
import 'add_edit_screen.dart';

class ContactDetailScreen extends StatelessWidget {
  final Contact contact;
  const ContactDetailScreen({super.key, required this.contact});

  @override
  Widget build(BuildContext context) {
    final provider = context.read<ContactProvider>();

    return Scaffold(
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
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(32),
                bottomRight: Radius.circular(32),
              ),
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
                        const Text('Contact',style: TextStyle(color: Colors.white, fontSize: 16)),
                      ]),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.push( context,MaterialPageRoute( builder: (_) => AddEditScreen(contact: contact))),
                      child: const Text('Edit', style:TextStyle(color: Colors.white, fontSize: 16)),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                CircleAvatar(
                  radius: 45,
                  backgroundColor: Color.fromRGBO(255, 255, 255, 0.25),
                  child: Text(contact.name[0].toUpperCase(),style: const TextStyle(color: Colors.white,fontSize: 36,fontWeight: FontWeight.bold)),
                ),
                const SizedBox(height: 12),
                Text(contact.name,style: const TextStyle( color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(contact.phone,
                    style: TextStyle( color: Color.fromRGBO(255, 255, 255, 0.8), fontSize: 14)),
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
                const SizedBox(height: 8),
                const Divider(),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(
                    (contact.isFavorite ?? false) ? Icons.star: Icons.star_outline,
                    color: const Color(0xFF6C5CE7),
                  ),
                  title: Text((contact.isFavorite ?? false) ? 'Remove from Favorites' : 'Add to Favorites'),
                  onTap: () {
                    provider.toggleFavorite(contact);
                    Navigator.pop(context);
                  },
                ),
                const Divider(height: 0),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.share_outlined, color: Color(0xFF6C5CE7)),
                  title: const Text('Share Contact'),
                  onTap: () {},
                ),
                const Divider(height: 0),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Image.asset('assets/icons/delete.png', width: 20, color: Colors.red),
                  title: const Text('Delete Contact', style: TextStyle(color: Colors.red)),
                  onTap: () {
                    provider.deleteContact(contact.id);
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
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
        Text(label,style: const TextStyle(color: Colors.white, fontSize: 12)),
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
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,style: const TextStyle( fontWeight: FontWeight.bold, fontSize: 14)),
          const SizedBox(height: 4),
          Text(value, style: TextStyle(color: Colors.grey[600], fontSize: 14)),
          const Divider(),
        ],
      ),
    );
  }
}