import 'package:contacts_service/contacts_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'package:amulet/data/models/contact/contact.dart';
import 'package:amulet/data/repository/auth/auth.dart';
import 'package:amulet/utils/color_resources.dart';
import 'package:amulet/utils/constant.dart';
import 'package:amulet/views/basewidgets/snackbar/snackbar.dart';

enum SaveContactsStatus { idle, loading, loaded, empty, error }
enum ContactsStatus { idle, loading, loaded, empty, error } 

class ContactProvider with ChangeNotifier {
  final AuthRepo authRepo;
  ContactProvider({
    required this.authRepo
  });
 
  ContactsStatus _contactsStatus = ContactsStatus.idle;
  ContactsStatus get contactsStatus => _contactsStatus;

  SaveContactsStatus _saveContactsStatus = SaveContactsStatus.idle;
  SaveContactsStatus get saveContactsStatus => _saveContactsStatus;

  List _addContacts = [];
  List get addContacts => [..._addContacts]; 

  List<Contact> _selectedContacts = [];
  List<Contact> get selectedContacts => [..._selectedContacts]; 

  List<ContactData> _selectedContactsDelete = [];
  List<ContactData> get selectedContacsDelete => [..._selectedContactsDelete];
  
  List<ContactData> _results = [];
  List<ContactData> get results => [..._results];

  List<Contact> _contacts = [];
  List<Contact> get contacts => [..._contacts].where((el) => el.displayName != null && el.phones!.isNotEmpty).toList();
  
  List<ContactData> _saveContacts = [];
  List<ContactData> get saveContacts => [..._saveContacts];

  List<ContactData> _saveContactsResults = [];
  List<ContactData> get saveContactsResults => [..._saveContactsResults];

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
      // List sc = await DBHelper.fetchSaveContacts(context);
      Dio dio = Dio ();
      Response res = await dio.get("${AppConstants.baseUrl}/contacts");
      Map<String, dynamic> data = res.data;
      ContactModel cm = ContactModel.fromJson(data);
      List<ContactData> cd = cm.data!;
      _saveContacts.addAll(cd);
      setStateSaveContactsStatus(SaveContactsStatus.loaded);
      if(_saveContacts.isEmpty) {
        setStateSaveContactsStatus(SaveContactsStatus.empty);
      }
    } catch(e) {
      setStateSaveContactsStatus(SaveContactsStatus.error);
      debugPrint(e.toString());
    }
  }

  Future<void> addContact(BuildContext context) async {
    try {
      Dio dio = Dio();
      for (Contact contact in selectedContacts) {
        if(contact.phones!.isNotEmpty) {
          await dio.post("${AppConstants.baseUrl}/contacts/create", data: {
            "uid": contact.phones![0].value!.replaceAll(RegExp(r"[^0-9]"), ""),
            "name": contact.displayName,
            "identifier": contact.phones![0].value!.replaceAll(RegExp(r"[^0-9]"), ""),
            "user_id": authRepo.getUserId()
          });
        }
      }
      Future.delayed(Duration.zero, () async {
        await saveContact(context);
      });
      _selectedContacts = [];
      notifyListeners();
      Navigator.of(context).pop();
    } on DioError catch(e) {
      if(
        e.response!.statusCode == 400
        || e.response!.statusCode == 401
        || e.response!.statusCode == 402 
        || e.response!.statusCode == 403
        || e.response!.statusCode == 404 
        || e.response!.statusCode == 405 
        || e.response!.statusCode == 500 
        || e.response!.statusCode == 501
        || e.response!.statusCode == 502
        || e.response!.statusCode == 503
        || e.response!.statusCode == 504
        || e.response!.statusCode == 505
      ) {
        ShowSnackbar.snackbar(context, "(${e.response!.statusCode.toString()}) : Internal Server Error", "", ColorResources.error);
      }
    } catch(e) {
      debugPrint(e.toString());
    }
  }

  Future<void> removeContact(BuildContext context) async {
    try {
      Dio dio = Dio();
      for (ContactData contacsDelete in selectedContacsDelete) {
        await dio.delete("${AppConstants.baseUrl}/contacts/${contacsDelete.uid}/delete"); 
      }
      Future.delayed(Duration.zero, () async {
        await saveContact(context);
      });
      _selectedContactsDelete = [];
      notifyListeners();
    } on DioError catch(e) {
      if(
        e.response!.statusCode == 400
        || e.response!.statusCode == 401
        || e.response!.statusCode == 402 
        || e.response!.statusCode == 403
        || e.response!.statusCode == 404 
        || e.response!.statusCode == 405 
        || e.response!.statusCode == 500 
        || e.response!.statusCode == 501
        || e.response!.statusCode == 502
        || e.response!.statusCode == 503
        || e.response!.statusCode == 504
        || e.response!.statusCode == 505
      ) {
        ShowSnackbar.snackbar(context, "(${e.response!.statusCode.toString()}) : Internal Server Error", "", ColorResources.error);
      }
    } catch(e) {
      debugPrint(e.toString());
    }
  }

  Future<void> removeContactPerId(BuildContext context, {required String contactId}) async {
    try {
      Dio dio = Dio();
      await dio.delete("${AppConstants.baseUrl}/contacts/${contactId}/delete"); 
      Future.delayed(Duration.zero, () async {
        await saveContact(context);
      });
      _selectedContactsDelete = [];
      notifyListeners();
    } on DioError catch(e) {
      if(
        e.response!.statusCode == 400
        || e.response!.statusCode == 401
        || e.response!.statusCode == 402 
        || e.response!.statusCode == 403
        || e.response!.statusCode == 404 
        || e.response!.statusCode == 405 
        || e.response!.statusCode == 500 
        || e.response!.statusCode == 501
        || e.response!.statusCode == 502
        || e.response!.statusCode == 503
        || e.response!.statusCode == 504
        || e.response!.statusCode == 505
      ) {
        ShowSnackbar.snackbar(context, "(${e.response!.statusCode.toString()}) : Internal Server Error", "", ColorResources.error);
      }
    } catch(e) {
      debugPrint(e.toString());
    } 
  }

  void runFilter({required String enteredKeyword}) {
    if (enteredKeyword.isEmpty) {
      _results = [];
    } else {
      _results = _saveContacts
      .where((contact) => contact.name!.toLowerCase().contains(enteredKeyword.toLowerCase()))
      .toList();   
    }
    _saveContactsResults = results;
    notifyListeners();
  }

  void toggleContactRemove({required ContactData contacts}) {
    if(_selectedContactsDelete.contains(contacts)) {
      _selectedContactsDelete.remove(contacts);
    } else {
      _selectedContactsDelete.add(contacts);
    }
    notifyListeners();
  }

  void toggleContact({required Contact contacts}) {
    if(_selectedContacts.contains(contacts)) {
      _selectedContacts.remove(contacts);
    } else {
      if(_selectedContacts.length < 5) {
        _selectedContacts.add(contacts);
      }
    }
    notifyListeners();
  }

} 