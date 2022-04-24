import 'package:cloud_firestore/cloud_firestore.dart';

class LocalUser {
  final String id;
  final String username;
  final String photoUrl;
  final String displayName;
  final String bio;

  LocalUser(
      {this.displayName, this.photoUrl, this.username, this.id, this.bio});

  factory LocalUser.fromDocument(DocumentSnapshot doc) {
    return LocalUser(
      id: doc.data()['id'],
      username: doc.data()['username'],
      photoUrl: doc.data()['photoUrl'],
      displayName: doc.data()['displayName'],
      bio: doc.data()['bio'],
    );
  }
}
