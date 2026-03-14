import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/contact_provider.dart';
import '../models/contact.dart';
import 'contact_detail_screen.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final favorites = context.watch<ContactProvider>().favorites;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 16, 20, 16),
              child: Text('Favorites',
                  style:
                      TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
            ),
            Expanded(
              child: favorites.isEmpty
                  ? const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.star_outline,
                              size: 64, color: Colors.grey),
                          SizedBox(height: 12),
                          Text('No favorites yet',
                              style: TextStyle(color: Colors.grey)),
                          SizedBox(height: 4),
                          Text(
                              'Open a contact and tap\n"Add to Favorites"',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.grey, fontSize: 12)),
                        ],
                      ),
                    )
                  : ListView.builder(
                      itemCount: favorites.length,
                      itemBuilder: (_, i) =>
                          _FavTile(contact: favorites[i]),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FavTile extends StatelessWidget {
  final Contact contact;
  const _FavTile({required this.contact});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 20, vertical: 2),
      leading: CircleAvatar(
        backgroundColor: const Color(0xFF6C5CE7),
        child: Text(contact.name[0].toUpperCase(),
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      title: Text(contact.name,
          style: const TextStyle(fontWeight: FontWeight.w600)),
      subtitle: Text(contact.phone),
      trailing:
          const Icon(Icons.star, color: Color(0xFF6C5CE7), size: 20),
      onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => ContactDetailScreen(contact: contact))),
    );
  }
}