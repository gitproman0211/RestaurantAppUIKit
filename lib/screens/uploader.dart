import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:restaurant_ui_kit/screens/profile.dart';
class Uploader extends StatefulWidget {
  final File file;
  Uploader({
    Key key,
    @required this.file,
  }) : super(key: key);
  @override
  _UploaderState createState() => _UploaderState();
}
class _UploaderState extends State<Uploader> {
  final FirebaseStorage _storage =
  FirebaseStorage(storageBucket: 'gs://restaurantapp-65d0e.appspot.com');

  StorageUploadTask _uploadTask;

  /// Starts an upload task
  void _startUpload() {

    /// Unique file name for the file
    String filePath = 'images/${DateTime.now()}.png';

    setState(() {
      _uploadTask = _storage.ref().child(filePath).putFile(widget.file);

    });
  }
  void changeProfilePicture()async{
    User user = FirebaseAuth.instance.currentUser;
    final firestoreInstance = FirebaseFirestore.instance;
    String docUrl = await (await _uploadTask.onComplete).ref.getDownloadURL();
    firestoreInstance
        .collection("users")
        .doc(user.uid)
        .update({
      "profilePicture": docUrl,
    }).then((value) {
      print("Success");
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_uploadTask != null) {

      /// Manage the task state and event subscription with a StreamBuilder
      return StreamBuilder<StorageTaskEvent>(
          stream: _uploadTask.events,
          builder: (_, snapshot) {
            var event = snapshot?.data?.snapshot;

            double progressPercent = event != null
                ? event.bytesTransferred / event.totalByteCount
                : 0;

            return Column(

              children: [
                if (_uploadTask.isComplete)
                  FlatButton(
                    child: Icon(Icons.add_photo_alternate),
                    onPressed: (){
                      changeProfilePicture();
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (BuildContext context){
                            return Profile();
                          },
                        ),
                      );
                    }

                  ),



                if (_uploadTask.isPaused)
                  FlatButton(
                    child: Icon(Icons.play_arrow),
                    onPressed: _uploadTask.resume,
                  ),

                if (_uploadTask.isInProgress)
                  FlatButton(
                    child: Icon(Icons.pause),
                    onPressed: _uploadTask.pause,
                  ),

                // Progress bar
                LinearProgressIndicator(value: progressPercent),
                Text(
                    '${(progressPercent * 100).toStringAsFixed(2)} % '
                ),
              ],
            );
          });


    } else {

      // Allows user to decide when to start the upload
      return FlatButton.icon(
        label: Text('Upload to Firebase'),
        icon: Icon(Icons.cloud_upload),
        onPressed: _startUpload,
      );

    }
  }
}