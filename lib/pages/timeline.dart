import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_social_app/widgets/header.dart';

final usersRef = FirebaseFirestore.instance.collection('users');

class Timeline extends StatefulWidget {
  @override
  _TimelineState createState() => _TimelineState();
}

class _TimelineState extends State<Timeline> {
  @override
  @override
  Widget build(context) {
    return Scaffold(
      appBar: header(
        context,
        isAppTitle: true,
      ),
      body: Text('TimeLine'),
    );
  }
}

// body: StreamBuilder<QuerySnapshot>(
//   stream: usersRef.snapshots(),
//   builder: (context, snapshot) {
//     if (!snapshot.hasData) {
//       return Center(child: CircularProgressIndicator());
//     }
//     final List<Text> users = snapshot.data.docs.map(
//       (doc) {
//         // print("DOC DATA IS: ${doc.data()['username']}");
//         return Text(doc.data()['username']);
//       },
//     ).toList();
//     // print("THE DOC DATA IS: ${snapshot.data.docs.}");
//
//     return Container(
//       // child: Center(
//       //   child: Text('Hello'),
//       // ),
//       child: ListView(
//         children: users,
//       ),
//     );
//   },
// ),

// void initState() {
//   getUsers();
//   deleteUser();
//   // updateData();
//   // createUser();
//   // getUserById();
//   // TODO: implement initState
//   super.initState();
// }
//
// createUser() {
//   usersRef
//       .doc("dsafjsdlkf")
//       .set({"username": "Altaf", "postsCount": 12, "isAdmin": false});
// }
//
// updateData() async {
//   final doc = await usersRef.doc("dsafjsdlkf").get();
//   if (doc.exists) {
//     doc.reference
//         .update({"username": "My Nigga", "isAdmin": false, "postsCount": 12});
//   }
// }
//
// deleteUser() async {
//   final doc = await usersRef.doc("dsafjsdlkf").get();
//   if (doc.exists) {
//     doc.reference.delete();
//   }
// }
//
// getUsers() async {
//   final QuerySnapshot snapshot = await usersRef
//       .where("postsCount", isLessThan: 10)
//       .where("isAdmin", isEqualTo: true)
//       .get();
//   snapshot.docs.forEach((doc) {
//     print(doc.data());
//     print(doc.id);
//     print(doc.exists);
//   });
// }
//
// getUserById() async {
//   final String id = "FsYMhpcj2qrKC5uD3me3";
//   final DocumentSnapshot doc = await usersRef.doc(id).get();
//   print(doc.data());
//   print(doc.id);
//   print(doc.exists);
// }
