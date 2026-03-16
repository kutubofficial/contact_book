import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:contact_book/models/contact.dart';

class ContactProvider extends ChangeNotifier {
  final Box<Contact> _box = Hive.box('contacts');
  String _searchQuery = '';
  String _selectedGroup = 'All Contacts'; 

  
  final List<String> _groups = ['All Contacts', 'Office', 'Family'];
  List<String> get groups => _groups;

  String get selectedGroup => _selectedGroup;

  List<Contact> get contacts =>
      _box.values.toList()..sort((a, b) => a.name.compareTo(b.name));

  List<Contact> get filteredContacts => contacts.where((c) {
        final matchSearch =
            c.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                c.phone.contains(_searchQuery);
        final matchGroup =
            _selectedGroup == 'All Contacts' || (c.group ?? 'All Contacts') == _selectedGroup;
        return matchSearch && matchGroup;
      }).toList();

  Map<String, List<Contact>> get groupedContacts {
    final Map<String, List<Contact>> grouped = {};
    for (final c in filteredContacts) {
      final letter = c.name[0].toUpperCase();
      grouped.putIfAbsent(letter, () => []).add(c);
    }
    return Map.fromEntries(
        grouped.entries.toList()..sort((a, b) => a.key.compareTo(b.key)));
  }

  List<Contact> get favorites =>
      contacts.where((c) => c.isFavorite == true).toList();

  void setSearch(String q) {
    _searchQuery = q;
    notifyListeners();
  }

  void setGroup(String g) {
    _selectedGroup = g;
    notifyListeners();
  }

  void addGroup(String groupName) {
    if (!_groups.contains(groupName)) {
      _groups.add(groupName);
      notifyListeners();
    }
  }

  void addContact(Contact c) {
    _box.put(c.id, c);
    notifyListeners();
  }

  void updateContact(Contact c) {
    _box.put(c.id, c);
    notifyListeners();
  }

  void deleteContact(String id) {
    _box.delete(id);
    notifyListeners();
  }

  void toggleFavorite(Contact c) {
    c.isFavorite = !(c.isFavorite ?? false);
    c.save();
    notifyListeners();
  }
}