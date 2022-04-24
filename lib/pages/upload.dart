import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_social_app/models/user.dart';
import 'package:flutter_social_app/widgets/progress.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as Im;
import 'package:uuid/uuid.dart';
import 'home.dart';

class Upload extends StatefulWidget {
  final LocalUser currentUser;

  Upload({this.currentUser});
  @override
  _UploadState createState() => _UploadState();
}

class _UploadState extends State<Upload> {
  String caption;
  String location;
  TextEditingController locationController = TextEditingController();
  File file;
  bool isUploading = false;
  String postId = Uuid().v4();

  handleTakePhoto () async {
    Navigator.pop(context);
    File file = await ImagePicker.pickImage(source: ImageSource.camera, maxWidth: 675, maxHeight: 960);
    setState(() {
      this.file = file;
    });
  }

  handleChooseFromGallery () async {
    Navigator.pop(context);
    File file = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      this.file = file;
    });
  }

  selectImage(parentContext) {
    return showDialog(
      context: parentContext,
      builder: (context) {
        return SimpleDialog(
          title: Text('Create Post'),
          children: [
            SimpleDialogOption(
              child: Text('Photo with camera'),
              onPressed: handleTakePhoto,
            ),
            SimpleDialogOption(
              child: Text('Image from gallery'),
              onPressed: handleChooseFromGallery,
            ),
            SimpleDialogOption(
              child: Text('Close'),
              onPressed: () => Navigator.pop(parentContext),
            ),
          ],
        );
      }
    );

  }

  Container buildSplashScreen() {
    return Container(
      color: Theme.of(context).accentColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset('assets/images/upload.svg'),
          SizedBox(height: 20,),
          RaisedButton(
            color: Colors.deepOrange,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Text('upload image'),
            onPressed: () => selectImage(context),
          ),

        ],
      ),
    );
  }

  clearImage() {
    setState(() {
      file = null;
    });

  }

  compressImage() async {
    final tempDir = await getTemporaryDirectory();
    final path = tempDir.path;
    Im.Image imageFile = Im.decodeImage(file.readAsBytesSync());
    final compressedImageFile = File('$path/img_$postId.jpg')..writeAsBytesSync(Im.encodeJpg(imageFile, quality: 85));
    setState(() {
      file = compressedImageFile;
    });
  }

  Future<String> uploadImage(imageFile) async {
    StorageUploadTask uploadTask = storageRef.child('post_$postId').putFile(file);
    StorageTaskSnapshot storageSnap = await uploadTask.onComplete;
    String downloadUrl = await storageSnap.ref.getDownloadURL();
    return downloadUrl;
  }

  createPostInFireStore({String mediaURL, String location, String description}) {
    postsRef
        .doc(widget.currentUser.id)
        .collection('userPosts')
        .doc(postId)
        .set({
          "postId" : postId,
          "ownerId" : widget.currentUser.id,
          "username" : widget.currentUser.username,
          "mediaUrl" : mediaURL,
          "description": description,
          "location" : location,
          "timestamp": timeStamp,
          "likes" : {},
        });

    this.location = null;
    caption = null;
    setState(() {
      file = null;
      isUploading = false;
      postId = Uuid().v4();
    });
  }

  handleSubmit() async{
    setState(() {
      isUploading = true;
      print('HANDLE SUBMIT CALLED');
    });
    await compressImage();
    String mediaURL = await uploadImage(file);
    createPostInFireStore(
      mediaURL : mediaURL,
      location : location,
      description: caption
    );
  }

  Scaffold buildUploadForm() {
    return Scaffold(
      appBar: AppBar(
        title: Text('Caption Post',style: TextStyle(
          color: Colors.black,
        ),),
        backgroundColor: Colors.white70,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: Colors.black,
          onPressed: clearImage,
        ),
        actions: [
          FlatButton(
            child: Text('Post',style: TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.bold, fontSize: 20),),
            onPressed: () => isUploading? null : handleSubmit(),
          ),
        ],
      ),
      body: ListView(
        children: [
          isUploading? linearProgress() : Text(''),
          Container(
            height: 220,
            width: MediaQuery.of(context).size.width * 0.8,
            child: Center(
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: FileImage(file),
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          ListTile(
            leading: CircleAvatar(
              backgroundImage: CachedNetworkImageProvider(widget.currentUser.photoUrl),
            ),
            title: Container(
              width: 250,
              child: TextField(
                onChanged: (val) => caption = val,
                decoration: InputDecoration(
                  hintText: 'Write a caption',
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.pin_drop, color: Colors.orange,),
            title: TextField(
              controller: locationController,
              onChanged: (val) => location = val,
              decoration: InputDecoration(
                hintText: 'Where was this photo taken?',
                border: InputBorder.none,
              ),
            ),
          ),
          Container(
            width: 200,
            height: 100,
            alignment: Alignment.center,
            child: RaisedButton.icon(
              color: Colors.blue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
              onPressed: getUserLocation,
              icon: Icon(
                Icons.my_location,
                color: Colors.white,
              ),
              label: Text('User Current Location',
                style: TextStyle(
                color: Colors.white
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  getUserLocation() async {
    print('USER LOCATION CALLED');
    Position position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    List<Placemark> placeMarks = await Geolocator().placemarkFromCoordinates(position.latitude, position.longitude);
    Placemark placeMark = placeMarks[0];
    String completeAddress =
        '${placeMark.subThoroughfare} ${placeMark.thoroughfare}, ${placeMark.subLocality} ${placeMark.locality}, ${placeMark.subAdministrativeArea}, ${placeMark.administrativeArea} ${placeMark.postalCode}, ${placeMark.country}';
    print(completeAddress);
    String formattedAdress = "${placeMark.locality}, ${placeMark.country}";
    locationController.text = formattedAdress;
    print("CURRENT LOCATION IS: $formattedAdress");

  }

  @override
  Widget build(BuildContext context) {
    return file == null? buildSplashScreen() : buildUploadForm();
  }
}
