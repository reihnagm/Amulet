import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:amulet/providers/auth.dart';
import 'package:amulet/data/models/inbox/inbox.dart';
import 'package:amulet/data/repository/inbox/inbox.dart';

enum InboxStatus { idle, loading, loaded, empty, error }
enum InboxTotalUnreadStatus { idle, loading, loaded, empty, error }

class InboxProvider with ChangeNotifier {
  final AuthProvider authProvider;
  final SharedPreferences sharedPreferences;
  final InboxRepo inboxRepo;
  final pagingController = PagingController<int, InboxData>(
    firstPageKey: 1,
  );

  InboxProvider({
    required this.authProvider,
    required this.sharedPreferences,
    required this.inboxRepo
  });

  int _totalUnread = 0;
  int get totalUnread => _totalUnread;
  
  InboxStatus _inboxStatus = InboxStatus.loading;
  InboxStatus get inboxStatus => _inboxStatus;

  InboxTotalUnreadStatus _inboxTotalUnreadStatus = InboxTotalUnreadStatus.loading;
  InboxTotalUnreadStatus get inboxTotalUnreadStatus => _inboxTotalUnreadStatus;

  List<InboxData> _inboxes = [];
  List<InboxData> get inboxes => [..._inboxes];

  void setStateInboxStatus(InboxStatus inboxStatus) {
    _inboxStatus = inboxStatus;
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  void setStateInboxTotalUnreadStatus(InboxTotalUnreadStatus inboxTotalUnreadStatus) {
    _inboxTotalUnreadStatus = inboxTotalUnreadStatus;
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  Future<void> getInbox(BuildContext context, {
    int? pageKey,
  }) async {
    try {
      InboxModel? inboxModel = await inboxRepo.getInbox(context, 
        userId: authProvider.getUserId()!,
        pageKey: pageKey!
      );
      List<InboxData> inboxData = inboxModel!.data!;
      List<InboxData> inboxAssign = [];
      for (InboxData inbox in inboxData) {
        inboxAssign.add(
          InboxData(
            uid: inbox.uid,
            isRead: inbox.isRead,
            mediaUrl: inbox.mediaUrl,
            thumbnail: inbox.thumbnail,
            title: inbox.title,
            type: inbox.type,
            content: inbox.content,
            createdAt: inbox.createdAt,
            updatedAt: inbox.updatedAt
          )
        );
      }
      _inboxes = inboxAssign;
      final previouslyFetchedItemsCount = pagingController.itemList?.length ?? 0;
    
      final isLastPage = _inboxes.length < previouslyFetchedItemsCount;
      final newItems = _inboxes;

      if (isLastPage) {
        pagingController.appendLastPage(newItems);
      } else {
        int nextPageKey = pageKey + 1;
        pagingController.appendPage(newItems, nextPageKey);
      }
      setStateInboxStatus(InboxStatus.loaded);
      if(_inboxes.isEmpty) {
        setStateInboxStatus(InboxStatus.empty);
      }
    } catch(e) {
      debugPrint(e.toString());
    }
  }

  Future<void> getInboxTotalUnread(BuildContext context) async {
    try {
      int itu = await inboxRepo.getInboxTotalUnread(
        context, 
        userId: authProvider.getUserId()!
      );
      _totalUnread = itu;
      setStateInboxTotalUnreadStatus(InboxTotalUnreadStatus.loaded);
    } catch(e) {
      setStateInboxTotalUnreadStatus(InboxTotalUnreadStatus.error);
      debugPrint(e.toString());
    }
  }

  Future<void> insertInbox(BuildContext context, {
    required String title, 
    required String content, 
    required String thumbnail,
    required String mediaUrl,
    required String type,
    required String userId,
  }) async {
    try {
      await inboxRepo.storeInbox(context, 
        title: title, 
        content: content,
        thumbnail: thumbnail,
        mediaUrl: mediaUrl,
        type: type,
        userId: userId,
      );
      pagingController.refresh();
      Future.delayed(Duration.zero, () async {
        await getInboxTotalUnread(context);
      });
    } catch(e) {
      debugPrint(e.toString());
    } 
  }

  Future<void> updateInbox(BuildContext context, {
    required String uid,
  }) async {
    try {
      await inboxRepo.updateInbox(context, uid: uid);
      pagingController.refresh();
      Future.delayed(Duration.zero, () async {
        await getInboxTotalUnread(context);
      });
    } catch(e) {
      debugPrint(e.toString());
    }
  }

}