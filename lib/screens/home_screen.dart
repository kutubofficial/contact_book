import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/contact_provider.dart';
import '../models/contact.dart';
import 'add_edit_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ContactProvider>();
    final contacts = provider.contacts;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Contact Book'),
        centerTitle: true,
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: contacts.isEmpty
          ? const Center(
              child: Text(
                'No contacts yet.\nTap + to add one!',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            )
          : ListView.builder(
              itemCount: contacts.length,
              itemBuilder: (context, index) {
                final contact = contacts[index];
                return _ContactTile(contact: contact);
              },
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddEditScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _ContactTile extends StatelessWidget {
  final Contact contact;
  const _ContactTile({required this.contact});

  @override
  Widget build(BuildContext context) {
    final provider = context.read<ContactProvider>();

    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.indigo,
        child: Text(
          contact.name[0].toUpperCase(),
          style: const TextStyle(color: Colors.white),
        ),
      ),
      title: Text(
        contact.name,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Text(contact.phone),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // EDIT
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.indigo),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => AddEditScreen(contact: contact),
                ),
              );
            },
          ),
          // DELETE
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: () {
              provider.deleteContact(contact.id);
            },
          ),
        ],
      ),
    );
  }
}
