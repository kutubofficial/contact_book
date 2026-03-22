import 'package:contact_book/screens/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:contact_book/models/contact.dart';
import 'package:contact_book/providers/contact_provider.dart';

class AddEditScreen extends StatefulWidget {
  final Contact? contact;
  const AddEditScreen({super.key, this.contact});

  @override
  State<AddEditScreen> createState() => _AddEditScreenState();
}

class _AddEditScreenState extends State<AddEditScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _name, _phone, _email;
  String _group = 'All Contacts';

  bool get isEditing => widget.contact != null;

  @override
  void initState() {
    super.initState();
    _name = TextEditingController(text: widget.contact?.name ?? '');
    _phone = TextEditingController(text: widget.contact?.phone ?? '');
    _email = TextEditingController(text: widget.contact?.email ?? '');
    _group = widget.contact?.group ?? 'All Contacts';
  }

  @override
  void dispose() {
    _name.dispose();
    _phone.dispose();
    _email.dispose();
    super.dispose();
  }

  void _save() {
    if (_formKey.currentState!.validate()) {
      final provider = context.read<ContactProvider>();
      final contact = Contact(
        id: widget.contact?.id ?? const Uuid().v4(),
        name: _name.text.trim(),
        phone: _phone.text.trim(),
        email: _email.text.trim(),
        group: _group,
        isFavorite: widget.contact?.isFavorite ?? false,
      );
      isEditing ? provider.updateContact(contact) : provider.addContact(contact);
      // Navigator.pop(context);
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const MainScreen()), (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Contact' : 'New Contact'),
        backgroundColor: const Color(0xFF6C5CE7),
        foregroundColor: Colors.white,
        actions: [
          TextButton(
              onPressed: _save,
              child: const Text('Save', style: TextStyle(color: Colors.white, fontSize: 16))),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(height: 10),
              CircleAvatar(
                radius: 40,
                backgroundColor: const Color(0xFF6C5CE7),
                child: const Icon(Icons.person, color: Colors.white, size: 40),
              ),
              const SizedBox(height: 24),
              _field(_name, 'Name', Icons.person),
              const SizedBox(height: 16),
              _field(_phone, 'Phone', Icons.phone, TextInputType.phone),
              const SizedBox(height: 16),
              _field(_email, 'Email', Icons.email, TextInputType.emailAddress),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _group,
                decoration: InputDecoration(
                  labelText: 'Group',
                  prefixIcon: const Icon(Icons.group_outlined),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  filled: true,
                  fillColor: Colors.grey[50],
                ),
                items: context.read<ContactProvider>().groups .map((g) => DropdownMenuItem(value: g, child: Text(g))).toList(),
                onChanged: (val) => setState(() => _group = val!),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _field(TextEditingController c, String label, IconData icon,
      [TextInputType? type]) {
    return TextFormField(
      controller: c,
      keyboardType: type,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border:
            OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: Colors.grey[50],
      ),
      validator: (val) =>
          val == null || val.isEmpty ? '$label is required' : null,
    );
  }
}
