import 'package:flutter_social_app/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_social_app/pages/activity_feed.dart';
import 'package:flutter_social_app/pages/create_account.dart';
import 'package:flutter_social_app/pages/profile.dart';
import 'package:flutter_social_app/pages/search.dart';
import 'package:flutter_social_app/pages/upload.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_social_app/widgets/header.dart  ';
import 'package:firebase_storage/firebase_storage.dart';

final GoogleSignIn googleSignIn = GoogleSignIn();
final StorageReference storageRef = FirebaseStorage.instance.ref();
final usersRef = FirebaseFirestore.instance.collection('users');
final postsRef = FirebaseFirestore.instance.collection('posts');
final commentsRef = FirebaseFirestore.instance.collection('comments');
final activityFeedRef = FirebaseFirestore.instance.collection('feed');
final followersRef = FirebaseFirestore.instance.collection('followers');
final followingRef = FirebaseFirestore.instance.collection('following');
final timeStamp = DateTime.now();
LocalUser currentUser;

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  PageController pageController;
  int pageIndex = 0;

  bool isAuth = false;

  @override
  void initState() {
    super.initState();

    pageController = PageController(
      initialPage: pageIndex,
    );

    // Detects when user signed in
    googleSignIn.onCurrentUserChanged.listen((account) {
      handleSignIn(account);
    }, onError: (err) {
      print('Error signing in: $err');
    });
    // Reauthenticate user when app is opened
    googleSignIn.signInSilently(suppressErrors: false).then((account) {
      handleSignIn(account);
    }).catchError((err) {
      print('Error signing in: $err');
    });
  }

  handleSignIn(GoogleSignInAccount account) {
    if (account != null) {
      // print('User signed in!: $account');
      createUserInFireStore();
      setState(() {
        isAuth = true;
      });
    } else {
      setState(() {
        isAuth = false;
      });
    }
  }

  createUserInFireStore() async {
    //check if user exists or not
    final GoogleSignInAccount user = googleSignIn.currentUser;
    DocumentSnapshot doc = await usersRef.doc(user.id).get();

    //if user doesn't exist, take the user to the create user page
    if (!doc.exists) {
      final username = await Navigator.push(
          context, MaterialPageRoute(builder: (context) => CreateAccount()));

      // Now create a document with that name in firebase
      usersRef.doc(user.id).set({
        "id": user.id,
        "username": username,
        "photoUrl": user.photoUrl,
        "displayName": user.displayName,
        "bio": "",
        "timeStamp": timeStamp,
      });

      doc = await usersRef.doc(user.id).get();
    }

    currentUser = LocalUser.fromDocument(doc);
  }

  signIn() {
    googleSignIn.signIn();
  }

  signOut() {
    googleSignIn.signOut();
  }

  onPageChanged(int pageIndex) {
    setState(() {
      this.pageIndex = pageIndex;
    });
  }

  onTap(int pageIndex) {
    pageController.animateToPage(
      pageIndex,
      duration: Duration(milliseconds: 200),
      curve: Curves.easeInOut,
    );
  }

  Scaffold buildAuthScreen() {
    return Scaffold(
      body: PageView(
        children: <Widget>[
          // Timeline(),
          Scaffold(
            appBar: header(
              context,
              isAppTitle: true,
            ),
            body: RaisedButton(
              child: Text('logout'),
              onPressed: signOut,
            ),
          ),
          ActivityFeed(),
          Upload(currentUser: currentUser),
          Search(),
          Profile(profileId: currentUser?.id),
        ],
        controller: pageController,
        onPageChanged: onPageChanged,
        physics: NeverScrollableScrollPhysics(),
      ),
      bottomNavigationBar: CupertinoTabBar(
        currentIndex: pageIndex,
        onTap: onTap,
        activeColor: Theme.of(context).primaryColor,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.whatshot)),
          BottomNavigationBarItem(icon: Icon(Icons.notifications_active)),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.photo_camera,
              size: 35,
            ),
          ),
          BottomNavigationBarItem(icon: Icon(Icons.search)),
          BottomNavigationBarItem(icon: Icon(Icons.account_circle)),
        ],
      ),
    );
  }

  Scaffold buildUnAuthScreen() {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              Theme.of(context).accentColor,
              Theme.of(context).primaryColor,
            ],
          ),
        ),
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Flutter Social App',
              style: TextStyle(
                fontFamily: "Signatra",
                fontSize: 70,
                color: Colors.white,
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            GestureDetector(
              onTap: () => signIn(),
              child: Container(
                height: 60,
                width: 260,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: AssetImage('assets/images/google_signin_button.png'),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    pageController.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return isAuth ? buildAuthScreen() : buildUnAuthScreen();
  }
}

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_social_app/pages/activity_feed.dart';
// import 'package:flutter_social_app/pages/create_account.dart';
// import 'package:flutter_social_app/pages/profile.dart';
// import 'package:flutter_social_app/pages/search.dart';
// import 'package:flutter_social_app/pages/timeline.dart';
// import 'package:flutter_social_app/pages/upload.dart';
// import 'package:google_sign_in/google_sign_in.dart';
//
// final GoogleSignIn googleSignIn = GoogleSignIn();
// final usersRef = Firestore.instance.collection('users');
// final DateTime timestamp = DateTime.now();
//
// class Home extends StatefulWidget {
//   @override
//   _HomeState createState() => _HomeState();
// }
//
// class _HomeState extends State<Home> {
//   bool isAuth = false;
//   PageController pageController;
//   int pageIndex = 0;
//
//   @override
//   void initState() {
//     super.initState();
//     pageController = PageController();
//     // Detects when user signed in
//     googleSignIn.onCurrentUserChanged.listen((account) {
//       handleSignIn(account);
//     }, onError: (err) {
//       print('Error signing in: $err');
//     });
//     // Reauthenticate user when app is opened
//     googleSignIn.signInSilently(suppressErrors: false).then((account) {
//       handleSignIn(account);
//     }).catchError((err) {
//       print('Error signing in: $err');
//     });
//   }
//
//   handleSignIn(GoogleSignInAccount account) {
//     if (account != null) {
//       createUserInFirestore();
//       setState(() {
//         isAuth = true;
//       });
//     } else {
//       setState(() {
//         isAuth = false;
//       });
//     }
//   }
//
//   createUserInFirestore() async {
//     // 1) check if user exists in users collection in database (according to their id)
//     final GoogleSignInAccount user = googleSignIn.currentUser;
//     final DocumentSnapshot doc = await usersRef.document(user.id).get();
//
//     if (!doc.exists) {
//       // 2) if the user doesn't exist, then we want to take them to the create account page
//       final username = await Navigator.push(
//           context, MaterialPageRoute(builder: (context) => CreateAccount()));
//
//       // 3) get username from create account, use it to make new user document in users collection
//       usersRef.document(user.id).setData({
//         "id": user.id,
//         "username": username,
//         "photoUrl": user.photoUrl,
//         "email": user.email,
//         "displayName": user.displayName,
//         "bio": "",
//         "timestamp": timestamp
//       });
//     }
//   }
//
//   @override
//   void dispose() {
//     pageController.dispose();
//     super.dispose();
//   }
//
//   login() {
//     googleSignIn.signIn();
//   }
//
//   logout() {
//     googleSignIn.signOut();
//   }
//
//   onPageChanged(int pageIndex) {
//     setState(() {
//       this.pageIndex = pageIndex;
//     });
//   }
//
//   onTap(int pageIndex) {
//     pageController.animateToPage(
//       pageIndex,
//       duration: Duration(milliseconds: 300),
//       curve: Curves.easeInOut,
//     );
//   }
//
//   Scaffold buildAuthScreen() {
//     return Scaffold(
//       body: PageView(
//         children: <Widget>[
//           // Timeline(),
//           RaisedButton(
//             child: Text('Logout'),
//             onPressed: logout,
//           ),
//           ActivityFeed(),
//           Upload(),
//           Search(),
//           Profile(),
//         ],
//         controller: pageController,
//         onPageChanged: onPageChanged,
//         physics: NeverScrollableScrollPhysics(),
//       ),
//       bottomNavigationBar: CupertinoTabBar(
//           currentIndex: pageIndex,
//           onTap: onTap,
//           activeColor: Theme.of(context).primaryColor,
//           items: [
//             BottomNavigationBarItem(icon: Icon(Icons.whatshot)),
//             BottomNavigationBarItem(icon: Icon(Icons.notifications_active)),
//             BottomNavigationBarItem(
//               icon: Icon(
//                 Icons.photo_camera,
//                 size: 35.0,
//               ),
//             ),
//             BottomNavigationBarItem(icon: Icon(Icons.search)),
//             BottomNavigationBarItem(icon: Icon(Icons.account_circle)),
//           ]),
//     );
//     // return RaisedButton(
//     //   child: Text('Logout'),
//     //   onPressed: logout,
//     // );
//   }
//
//   Scaffold buildUnAuthScreen() {
//     return Scaffold(
//       body: Container(
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             begin: Alignment.topRight,
//             end: Alignment.bottomLeft,
//             colors: [
//               Theme.of(context).accentColor,
//               Theme.of(context).primaryColor,
//             ],
//           ),
//         ),
//         alignment: Alignment.center,
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: <Widget>[
//             Text(
//               'FlutterShare',
//               style: TextStyle(
//                 fontFamily: "Signatra",
//                 fontSize: 90.0,
//                 color: Colors.white,
//               ),
//             ),
//             GestureDetector(
//               onTap: login,
//               child: Container(
//                 width: 260.0,
//                 height: 60.0,
//                 decoration: BoxDecoration(
//                   image: DecorationImage(
//                     image: AssetImage(
//                       'assets/images/google_signin_button.png',
//                     ),
//                     fit: BoxFit.cover,
//                   ),
//                 ),
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return isAuth ? buildAuthScreen() : buildUnAuthScreen();
//   }
// }
