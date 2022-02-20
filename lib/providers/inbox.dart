import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:panic_button/providers/auth.dart';
import 'package:panic_button/data/models/inbox/inbox.dart';
import 'package:panic_button/data/repository/inbox/inbox.dart';

enum InboxStatus { idle, loading, loaded, empty, error }

class InboxProvider with ChangeNotifier {
  final AuthProvider authProvider;
  final SharedPreferences sharedPreferences;
  final InboxRepo inboxRepo;

  InboxProvider({
    required this.authProvider,
    required this.sharedPreferences,
    required this.inboxRepo
  });

  int totalUnread = 0;
  
  InboxStatus _inboxStatus = InboxStatus.loading;
  InboxStatus get inboxStatus => _inboxStatus;

  List<InboxData> _inboxes = [];
  List<InboxData> get inboxes => [..._inboxes];

  void setStateInboxStatus(InboxStatus inboxStatus) {
    _inboxStatus = inboxStatus;
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  Future<void> fetchInbox(BuildContext context) async {
    try {
      InboxModel? inboxModel = await inboxRepo.fetchInbox(context, userId: authProvider.getUserId());
      totalUnread = inboxModel!.totalUnread!;
      List<InboxData> inboxData = inboxModel.data!;
      List<InboxData> inboxAssign = [];
      for (InboxData inbox in inboxData) {
        inboxAssign.add(
          InboxData(
            uid: inbox.uid,
            isRead: inbox.isRead,
            title: inbox.title,
            content: inbox.content,
            createdAt: inbox.createdAt,
            updatedAt: inbox.updatedAt
          )
        );
      }
      _inboxes = inboxAssign;
      setStateInboxStatus(InboxStatus.loaded);
      if(inboxes.isEmpty) {
        setStateInboxStatus(InboxStatus.empty);
      }
    } catch(e) {
      debugPrint(e.toString());
    }
  }

  Future<void> insertInbox(BuildContext context, {required String title, required String content, required String userId}) async {
    try {
      await inboxRepo.insertInbox(context, 
        title: title, 
        content: content,
        userId: userId
      );
      Future.delayed(Duration.zero, () {
        fetchInbox(context);
      });
    } catch(e) {
      debugPrint(e.toString());
    } 
  }

  Future<void> updateInbox(BuildContext context, {required String uid}) async {
    try {
      await inboxRepo.updateInbox(context, uid: uid);
      Future.delayed(Duration.zero, () {
        fetchInbox(context);
      });
    } catch(e) {
      debugPrint(e.toString());
    }
  }

}