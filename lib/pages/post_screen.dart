import 'package:flutter/material.dart';
import 'package:flutter_social_app/widgets/post.dart';

class PostScreen extends StatelessWidget {
  final Post post;
  PostScreen({this.post});
  @override
  Widget build(BuildContext context) {
    // return Text('post screen');
    return Scaffold(
        appBar: AppBar(
          title: Text('Post'),
          centerTitle: true,
          backgroundColor: Theme.of(context).primaryColor,
        ),
        body: ListView(
          children: [
            Post(
              postId: post.postId,
              ownerId: post.ownerId,
              username: post.username,
              location: post.location ?? "",
              description: post.description ?? "",
              mediaUrl: post.mediaUrl,
              likes: post.likes,
            ),
          ],
        ));
  }
}
