import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import 'package:hp3ki/providers/profile/profile.dart';

import 'package:hp3ki/data/models/feedv2/feedDetail.dart';
import 'package:hp3ki/data/repository/auth/auth.dart';
import 'package:hp3ki/data/repository/feedv2/feed.dart';

import 'package:hp3ki/utils/exceptions.dart';

enum FeedDetailStatus { idle, loading, loaded, empty, error }

class FeedDetailProviderV2 with ChangeNotifier {
  final AuthRepo ar;
  final FeedRepoV2 fr;
  FeedDetailProviderV2({
    required this.ar,
    required this.fr
  });

  late TextEditingController commentC;

  String commentVal = "";

  bool hasMore = true;
  int pageKey = 1;

  FeedDetailStatus _feedDetailStatus = FeedDetailStatus.loading;
  FeedDetailStatus get feedDetailStatus => _feedDetailStatus;

  void setStateFeedDetailStatus(FeedDetailStatus feedDetailStatus) {
    _feedDetailStatus = feedDetailStatus;
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  FeedDetailData _feedDetailData = FeedDetailData();
  FeedDetailData get feedDetailData => _feedDetailData;

  List<CommentElement> _comments = [];
  List<CommentElement> get comments => [..._comments];

  void onChangeComment(String val) {
    commentVal = val;

    notifyListeners();
  }

  Future<void> getFeedDetail(BuildContext context, String postId) async {
    pageKey = 1;
    hasMore = true;

    try {
      FeedDetailModel? fdm = await fr.fetchDetail(context, pageKey, postId);
      _feedDetailData = fdm!.data;

      _comments.clear();
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

  Future<void> loadMoreComment({required BuildContext context, required String postId}) async {
    pageKey++;

    FeedDetailModel? g = await fr.fetchDetail(context, pageKey, postId);

    hasMore = g!.data.pageDetail!.hasMore;
    _comments.addAll(g.data.forum!.comment!.comments);
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  Future<void> postComment(
    BuildContext context,
    String feedId,
    ) async {
    try {
      
      if (commentC.text.trim() == "") {
        commentC.text = "";
        return;
      }

      commentC.text = "";

      _comments.add(
        CommentElement(
          id: feedId, 
          comment: commentVal, 
          createdAt: "beberapa detik yang lalu", 
          user: User(
            id: context.read<ProfileProvider>().user!.id.toString(),
            avatar: context.read<ProfileProvider>().user!.avatar.toString(), 
            username: context.read<ProfileProvider>().user!.fullname.toString()
          ), 
          reply: CommentReply(
            total: 0,
            replies: [],
          ), 
          like: FeedLikes(
            total: 0, 
            likes: []
          )
        )
      );

      await fr.postComment(
        context: context, feedId: feedId, 
        comment: commentVal, userId: ar.getUserId().toString()
      );

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
    required String feedId, 
    required FeedLikes feedLikes
  }) async {
    try {
      int idxLikes = feedLikes.likes.indexWhere((el) => el.user!.id == ar.getUserId().toString());
      if (idxLikes != -1) {
        feedLikes.likes.removeAt(idxLikes);
        feedLikes.total = feedLikes.total - 1;
      } else {
        feedLikes.likes.add(UserLikes(
          user: User(
          id: ar.getUserId().toString(),
          avatar: "-",
          username: ar.getUserFullname())
        ));
        feedLikes.total = feedLikes.total + 1;
      }
      await fr.toggleLike(context: context, feedId: feedId, userId: ar.getUserId().toString());
      Future.delayed(Duration.zero, () => notifyListeners());
    } on CustomException catch (e) {
      debugPrint(e.toString());
    } catch (_) {}
  }

  Future<void> toggleLikeComment(
      {
      required BuildContext context,
      required String feedId, 
      required String commentId, 
      required FeedLikes feedLikes}) async {
    try {
      int idxLikes = feedLikes.likes.indexWhere((el) => el.user!.id == ar.getUserId().toString());
      if (idxLikes != -1) {
        feedLikes.likes.removeAt(idxLikes);
        feedLikes.total = feedLikes.total - 1;
      } else {
        feedLikes.likes.add(UserLikes(
            user: User(
            id: ar.getUserId().toString(),
            avatar: "-",
            username: ar.getUserFullname())));
        feedLikes.total = feedLikes.total + 1;
      }
      await fr.toggleLikeComment(context: context, feedId: feedId, userId: ar.getUserId().toString(), commentId: commentId);
      Future.delayed(Duration.zero, () => notifyListeners());
    } on CustomException catch (e) {
      debugPrint("Error like : ${e.toString()}");
    } catch (e) {
      debugPrint("Error like : ${e.toString()}");
    }
  }

  Future<void> deleteComment( 
      {
        required BuildContext context, 
        required String feedId, 
        required String deleteId
      }) async {
    try {
      await fr.deleteComment(context, deleteId);

      FeedDetailModel? fdm = await fr.fetchDetail(context, 1, feedId);
      _feedDetailData = fdm!.data;

      _comments.clear();
      _comments.addAll(fdm.data.forum!.comment!.comments);
      
      setStateFeedDetailStatus(FeedDetailStatus.loaded);
    } on CustomException catch (e) {
      debugPrint(e.toString());
    } catch (_) {}
  }
}