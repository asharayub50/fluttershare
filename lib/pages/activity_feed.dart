import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_social_app/pages/home.dart';
import 'package:flutter_social_app/pages/post_screen.dart';
import 'package:flutter_social_app/pages/profile.dart';
import 'package:flutter_social_app/widgets/header.dart';
import 'package:flutter_social_app/widgets/post.dart';
import 'package:flutter_social_app/widgets/progress.dart';
import 'package:timeago/timeago.dart' as timeago;

class ActivityFeed extends StatefulWidget {
  @override
  _ActivityFeedState createState() => _ActivityFeedState();
}

class _ActivityFeedState extends State<ActivityFeed> {
  getActivityFeed() async {
    QuerySnapshot snapshot = await activityFeedRef
        .doc(currentUser.id)
        .collection('feeditems')
        .orderBy('timestamp', descending: true)
        .limit(50)
        .get();
    List<ActivityFeedItem> feedItems = [];

    snapshot.docs.forEach((doc) {
      feedItems.add(ActivityFeedItem.fromDocument(doc));
    });
    return feedItems;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor.withOpacity(0.9),
      appBar: header(context, titleText: 'Activity Feed'),
      body: Container(
        child: FutureBuilder(
          future: getActivityFeed(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return circularProgress();
            }
            return ListView(
              children: snapshot.data,
            );
          },
        ),
      ),
    );
  }
}

class ActivityFeedItem extends StatelessWidget {
  Widget mediaPreview;
  String activityItemText;
  final String username;
  final String userId;
  final String type; //like, follow and comment
  final String mediaUrl;
  final String postId;
  final String userProfileImage;
  final String commentData;
  final Timestamp timestamp;

  ActivityFeedItem(
      {this.username,
      this.userId,
      this.type, //like, follow and comment
      this.mediaUrl,
      this.postId,
      this.userProfileImage,
      this.commentData,
      this.timestamp});

  factory ActivityFeedItem.fromDocument(DocumentSnapshot doc) {
    return ActivityFeedItem(
      username: doc.data()['username'],
      userId: doc.data()['userId'],
      type: doc.data()['type'],
      mediaUrl: doc.data()['mediaUrl'],
      postId: doc.data()['postId'],
      userProfileImage: doc.data()['userProfileImage'],
      commentData: doc.data()['commentData'],
      timestamp: doc.data()['timestamp'],
    );
  }

  displayPost(BuildContext context) async {
    // print(userId);
    // print(postId);
    DocumentSnapshot doc = await postsRef
        .doc(currentUser.id)
        .collection('userPosts')
        .doc(postId)
        .get();
    if (doc.exists) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) {
            return PostScreen(
              post: Post.fromDocument(doc),
            );
          },
        ),
      );
    } else {
      print('document of this post does not exist');
    }
  }

  configureMediaPreview({Function onTap}) {
    if (type == 'like' || type == 'comment') {
      mediaPreview = GestureDetector(
        onTap: onTap,
        child: Container(
          height: 50,
          width: 50,
          child: AspectRatio(
            aspectRatio: 16 / 9,
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: CachedNetworkImageProvider(mediaUrl),
                ),
              ),
            ),
          ),
        ),
      );
    } else {
      mediaPreview = Text('');
    }

    if (type == 'like') {
      activityItemText = 'liked your post';
    } else if (type == 'follow') {
      activityItemText = 'followed you';
    } else if (type == 'comment') {
      activityItemText = 'commented on your post';
    } else {
      activityItemText = 'Unknown error $type';
    }
  }

  @override
  Widget build(BuildContext context) {
    configureMediaPreview(onTap: () => displayPost(context));
    return Padding(
      padding: EdgeInsets.only(bottom: 2.0),
      child: Container(
        color: Colors.white54,
        child: ListTile(
          title: GestureDetector(
            onTap: () => showProfile(context, profileId: userId),
            child: RichText(
              overflow: TextOverflow.ellipsis,
              text: TextSpan(
                style: TextStyle(
                  fontSize: 14.0,
                  color: Colors.black,
                ),
                children: [
                  TextSpan(
                    text: username,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text: ' $activityItemText',
                  ),
                ],
              ),
            ),
          ),
          leading: CircleAvatar(
            backgroundImage: CachedNetworkImageProvider(userProfileImage),
          ),
          subtitle: Text(
            timeago.format(
              timestamp.toDate(),
            ),
            overflow: TextOverflow.ellipsis,
          ),
          trailing: mediaPreview,
        ),
      ),
    );
  }
}

showProfile(BuildContext context, {String profileId}) {
  Navigator.push(context, MaterialPageRoute(builder: (context) {
    return Profile(
      profileId: profileId,
    );
  }));
}
