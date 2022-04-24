import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_social_app/pages/post_screen.dart';
import 'package:flutter_social_app/widgets/post.dart';

class PostTile extends StatelessWidget {
  final Post post;

  PostTile({this.post});
  @override
  Widget build(BuildContext context) {
    displayPost() {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PostScreen(
              post: post,
            ),
          ));
    }

    return GestureDetector(
      onTap: displayPost,
      child: CachedNetworkImage(imageUrl: post.mediaUrl),
    );
  }
}
