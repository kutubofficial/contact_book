import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/contact.dart';

class ContactProvider extends ChangeNotifier {
  final Box<Contact> _box = Hive.box('contacts');

  List<Contact> get contacts => _box.values.toList();

  // CREATE
  void addContact(Contact contact) {
    _box.put(contact.id, contact);
    notifyListeners();
  }

  // UPDATE
  void updateContact(Contact contact) {
    _box.put(contact.id, contact);
    notifyListeners();
  }

  // DELETE
  void deleteContact(String id) {
    _box.delete(id);
    notifyListeners();
  }
}
