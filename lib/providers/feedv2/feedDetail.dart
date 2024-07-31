import 'package:flutter/widgets.dart';

import 'package:flutter_mentions/flutter_mentions.dart';

import 'package:hp3ki/data/models/feedv2/feedDetail.dart';
import 'package:hp3ki/data/models/feedv2/user_mention.dart';
import 'package:hp3ki/data/repository/auth/auth.dart';
import 'package:hp3ki/data/repository/feedv2/feed.dart';

import 'package:hp3ki/utils/exceptions.dart';

enum FeedDetailStatus { idle, loading, loaded, empty, error }
enum UserMentionStatus { idle, loading, loaded, empty, error }

class FeedDetailProviderV2 with ChangeNotifier {
  final AuthRepo ar;
  final FeedRepoV2 fr;
  FeedDetailProviderV2({
    required this.ar,
    required this.fr
  });

  String commentVal = "";

  String highlightedIndex = "";

  Set<String> ids = {}; 

  bool hasMore = true;
  int pageKey = 1;

  final List<Map<String, dynamic>> _userMentions = [];
  List<Map<String, dynamic>> get userMentions  => [..._userMentions];

  List<CommentElement> _comments = [];
  List<CommentElement> get comments => [..._comments];

  FeedDetailData _feedDetailData = FeedDetailData();
  FeedDetailData get feedDetailData => _feedDetailData;

  FeedDetailStatus _feedDetailStatus = FeedDetailStatus.loading;
  FeedDetailStatus get feedDetailStatus => _feedDetailStatus;

  UserMentionStatus _userMentionStatus = UserMentionStatus.loading;
  UserMentionStatus get userMentionStatus => _userMentionStatus;

  void setStateFeedDetailStatus(FeedDetailStatus feedDetailStatus) {
    _feedDetailStatus = feedDetailStatus;

    notifyListeners();
  }

  void setStateUserMentionStatus(UserMentionStatus userMentionStatus) {
    _userMentionStatus = userMentionStatus;

    notifyListeners();
  } 

  void onListenComment(String val) {
    commentVal = val;

    notifyListeners();
  }

  Future<void> getFeedDetail(BuildContext context, String postId) async {
    pageKey = 1;
    hasMore = true;

    try {
      FeedDetailModel? fdm = await fr.fetchDetail(context, pageKey, postId);
      _feedDetailData = fdm!.data;

      _comments = [];
      _comments.addAll(fdm.data.forum!.comment!.comments);

      setStateFeedDetailStatus(FeedDetailStatus.loaded);

      if (comments.isEmpty) {
        setStateFeedDetailStatus(FeedDetailStatus.empty);
      }

    } on CustomException catch (e) {
      setStateFeedDetailStatus(FeedDetailStatus.error);
      debugPrint(e.toString());
    } catch (_) {
      setStateFeedDetailStatus(FeedDetailStatus.error);
    }
  }

  Future<void> getUserMentions(context, username) async {
    setStateUserMentionStatus(UserMentionStatus.loading);

    try {

      List<UserMention>? mentions = await fr.userMentions(context, username.replaceAll('@', ''));

      for (UserMention mention in mentions!) {

        if(!ids.contains(mention.id)) {

          _userMentions.add({
            "id": mention.id.toString(),
            "photo": mention.photo.toString(),
            "display": mention.display.toString(),
            "fullname": mention.username.toString()
          });
          ids.add(mention.id);

        }

      }
      
      setStateUserMentionStatus(UserMentionStatus.loaded);
    } on CustomException catch(e) {
      debugPrint(e.toString());
      setStateUserMentionStatus(UserMentionStatus.error);
    } catch(e) {
      debugPrint(e.toString());
      setStateUserMentionStatus(UserMentionStatus.error);
    } 
  }

  Future<void> loadMoreComment({required BuildContext context, required String postId}) async {
    pageKey++;

    FeedDetailModel? g = await fr.fetchDetail(context, pageKey, postId);

    hasMore = g!.data.pageDetail!.hasMore;
    _comments.addAll(g.data.forum!.comment!.comments);
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  Future<void> postComment(
    BuildContext context,
    GlobalKey<FlutterMentionsState> key,
    String forumId,
    ) async {
    try {

      if (key.currentState!.controller!.text.trim() == "") {
        key.currentState!.controller!.text = "";
        return;
      }

      await fr.postComment(
        context: context, forumId: forumId, 
        comment: commentVal, userId: ar.getUserId().toString(),
      );

      key.currentState!.controller!.text = "";

      FeedDetailModel? fdm = await fr.fetchDetail(context, 1, forumId);
      _feedDetailData = fdm!.data;

      _comments.clear();
      _comments.addAll(fdm.data.forum!.comment!.comments);

       highlightedIndex = comments.last.id;

      Future.delayed(const Duration(milliseconds: 100), () {
        GlobalKey targetContext = comments.last.key;
        Scrollable.ensureVisible(targetContext.currentContext!,
          duration: const Duration(milliseconds: 100),
          curve: Curves.easeOut,
        );
      });

      Future.delayed(const Duration(milliseconds: 1200), () {
        highlightedIndex = "";

        notifyListeners();
      });

      setStateFeedDetailStatus(FeedDetailStatus.loaded);

    } on CustomException catch (e) {
      setStateFeedDetailStatus(FeedDetailStatus.error);
      debugPrint(e.toString());
    } catch (e) {
      debugPrint(e.toString());
      setStateFeedDetailStatus(FeedDetailStatus.error);
    }
  }

  Future<void> toggleLike({
    required BuildContext context,
    required String forumId, 
    required FeedLikes forumLikes
  }) async {
    try {
      int idxLikes = forumLikes.likes.indexWhere((el) => el.user!.id == ar.getUserId().toString());
      if (idxLikes != -1) {
        forumLikes.likes.removeAt(idxLikes);
        forumLikes.total = forumLikes.total - 1;
      } else {
        forumLikes.likes.add(UserLikes(
          user: User(
          id: ar.getUserId().toString(),
          avatar: "-",
          username: ar.getUserFullname())
        ));
        forumLikes.total = forumLikes.total + 1;
      }
      await fr.toggleLike(context: context, feedId: forumId, userId: ar.getUserId().toString());
      Future.delayed(Duration.zero, () => notifyListeners());
    } on CustomException catch (e) {
      debugPrint(e.toString());
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> toggleLikeComment(
      {
      required BuildContext context,
      required String forumId, 
      required String commentId, 
      required FeedLikes forumLikes}) async {
    try {
      int idxLikes = forumLikes.likes.indexWhere((el) => el.user!.id == ar.getUserId().toString());
      if (idxLikes != -1) {
        forumLikes.likes.removeAt(idxLikes);
        forumLikes.total = forumLikes.total - 1;
      } else {
        forumLikes.likes.add(UserLikes(
          user: User(
            id: ar.getUserId().toString(),
            avatar: "-",
            username: ar.getUserFullname()
          )
        ));
        forumLikes.total = forumLikes.total + 1;
      }
      await fr.toggleLikeComment(context: context, feedId: forumId, userId: ar.getUserId().toString(), commentId: commentId);
      Future.delayed(Duration.zero, () => notifyListeners());
    } on CustomException catch (e) {
      debugPrint("Error like : ${e.toString()}");
    } catch (e) {
      debugPrint("Error like : ${e.toString()}");
    }
  }

  Future<void> deleteComment({
    required BuildContext context, 
    required String forumId, 
    required String deleteId
  }) async {
    try {
      await fr.deleteComment(context, deleteId);

      FeedDetailModel? fdm = await fr.fetchDetail(context, 1, forumId);
      _feedDetailData = fdm!.data;

      _comments.clear();
      _comments.addAll(fdm.data.forum!.comment!.comments);
      
      setStateFeedDetailStatus(FeedDetailStatus.loaded);
    } on CustomException catch (e) {
      debugPrint(e.toString());
    } catch (_) {}
  }
}