import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:contact_book/providers/contact_provider.dart';
import 'package:contact_book/models/contact.dart';
import 'add_edit_screen.dart';
import 'contact_detail_screen.dart';

class ContactsScreen extends StatelessWidget {
  const ContactsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ContactProvider>();
    final grouped = provider.groupedContacts;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('My Contacts',
                          style: TextStyle( fontSize: 26, fontWeight: FontWeight.bold)),
                      // Text('Total (${provider.contacts.length})',
                      //     style:TextStyle(color: Colors.grey[500], fontSize: 13)),
                    ],
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const AddEditScreen()));
                    },
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      child: const Icon(Icons.add,size: 40, color: Color(0xFF6C5CE7),),
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Group Tabs
            _GroupTabs(),
            const SizedBox(height: 12),
            // Search
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                onChanged: provider.setSearch,
                decoration: InputDecoration(
                  hintText: 'Search by name or number',
                  prefixIcon: const Icon(Icons.search, color: Colors.grey),
                  filled: true,
                  fillColor: Colors.grey[100],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 0),
                ),
              ),
            ),
            const SizedBox(height: 8),
            // List
            Expanded(
              child: grouped.isEmpty
                  ? const Center(
                      child: Text('No contacts found.',
                          style: TextStyle(color: Colors.grey)))
                  : ListView.builder(
                      itemCount: grouped.keys.length,
                      itemBuilder: (_, i) {
                        final letter = grouped.keys.elementAt(i);
                        final list = grouped[letter]!;
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(20, 8, 20, 4),
                              child: Text(letter,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey[400],
                                      fontSize: 13)),
                            ),
                            ...list.map((c) => _ContactTile(contact: c)),
                          ],
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   backgroundColor: const Color(0xFF6C5CE7),
      //   foregroundColor: Colors.white,
        // onPressed: () => Navigator.push(context,
        //     MaterialPageRoute(builder: (_) => const AddEditScreen())),
      //   child: const Icon(Icons.add),
      // ),
    );
  }
}

class _GroupTabs extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ContactProvider>();
    final groups = provider.groups;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          // Dynamic group tabs
          ...groups.map((groupName) {
            final selected = provider.selectedGroup == groupName;
            return GestureDetector(
              onTap: () => provider.setGroup(groupName),
              child: Container(
                margin: const EdgeInsets.only(right: 10),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  groupName,
                  style: TextStyle(
                    color: selected ? const Color(0xFF6C5CE7) : Colors.grey[600],
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            );
          }),

          // + New Group Button
          GestureDetector(
            onTap: () => _showAddGroupDialog(context, provider),
            child: Container(
              margin: const EdgeInsets.only(right: 10),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFF6C5CE7),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Row(
                children: [
                  Icon(Icons.add, color: Colors.white, size: 16),
                  SizedBox(width: 4),
                  Text(
                    'New Group',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showAddGroupDialog(BuildContext context, ContactProvider provider) {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('New Group', style: TextStyle(fontWeight: FontWeight.bold)),
        content: TextField(
          controller: controller,
          autofocus: true,
          textCapitalization: TextCapitalization.words,
          decoration: InputDecoration(
            hintText: 'e.g. Friends, Gym, Work...',
            prefixIcon: const Icon(Icons.group_outlined, color: Color(0xFF6C5CE7)),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF6C5CE7), width: 2),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Cancel', style: TextStyle(color: Colors.grey[600])),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF6C5CE7),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () {
              final name = controller.text.trim();
              if (name.isNotEmpty) {
                provider.addGroup(name);
                provider.setGroup(name); // auto-select new group
                Navigator.pop(ctx);
              }
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }
}
class _ContactTile extends StatelessWidget {
  final Contact contact;
  const _ContactTile({required this.contact});

  Color _color(String name) {
    final colors = [
      const Color(0xFF6C5CE7),
      const Color(0xFF00B894),
      const Color(0xFFE17055),
      const Color(0xFF0984E3),
      const Color(0xFFE84393),
    ];
    return colors[name.codeUnitAt(0) % colors.length];
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 2),
      leading: CircleAvatar(
        radius: 24,
        backgroundColor: _color(contact.name),
        child: Text(contact.name[0].toUpperCase(),
            style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18)),
      ),
      title: Text(contact.name,
          style: const TextStyle(fontWeight: FontWeight.w600)),
      subtitle: Text(contact.phone,
          style: TextStyle(color: Colors.grey[500], fontSize: 13)),
      trailing: const Icon(Icons.more_vert, color: Colors.grey),
      onTap: () => Navigator.push(
          context,MaterialPageRoute( builder: (_) => ContactDetailScreen(contact: contact))),);
  }
}