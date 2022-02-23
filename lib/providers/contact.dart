
import 'package:amulet/services/sqlite.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';


enum SaveContactsStatus { idle, loading, loaded, empty, error }
enum ContactsStatus { idle, loading, loaded, empty, error } 

class ContactProvider with ChangeNotifier {
 
  ContactsStatus _contactsStatus = ContactsStatus.idle;
  ContactsStatus get contactsStatus => _contactsStatus;

  SaveContactsStatus _saveContactsStatus = SaveContactsStatus.idle;
  SaveContactsStatus get saveContactsStatus => _saveContactsStatus;

  List<Contact> _contacts = [];
  List<Contact> get contacts => [..._contacts];
  
  List _saveContacts = [];
  List get saveContacts => [..._saveContacts];

  void setStateContactsStatus(ContactsStatus contactsStatus) {
    _contactsStatus = contactsStatus;
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  void setStateSaveContactsStatus(SaveContactsStatus saveContactsStatus) {
    _saveContactsStatus = saveContactsStatus;
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  Future<void> getContacts(BuildContext context) async {
    setStateContactsStatus(ContactsStatus.loading);
    try {
      _contacts = [];
      List<Contact> cs = await ContactsService.getContacts();
      setStateContactsStatus(ContactsStatus.loaded);
      _contacts.addAll(cs);
    } catch(e) {
      setStateContactsStatus(ContactsStatus.error);
      debugPrint(e.toString());
    }
  }

  Future<void> saveContact(BuildContext context) async {
    setStateSaveContactsStatus(SaveContactsStatus.loading);
    try { 
      _saveContacts = [];
      List sc = await DBHelper.fetchSaveContacts(context);
      _saveContacts.addAll(sc);
      setStateSaveContactsStatus(SaveContactsStatus.loaded);
    } catch(e) {
      setStateSaveContactsStatus(SaveContactsStatus.error);
      debugPrint(e.toString());
    }
  }

  Future<void> addContact(BuildContext context, {required String identifier}) async {
    try {
      await DBHelper.insert("contacts", {
        "identifier": identifier
      });
      Future.delayed(Duration.zero, () async {
        await saveContact(context);
      });
      Navigator.of(context).pop();
    } catch(e) {
      debugPrint(e.toString());
    }
  }

} 