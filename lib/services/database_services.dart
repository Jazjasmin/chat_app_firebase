//TODO 13: import firebase auth and cloud firestore packages
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

 
class DataBaseServices {
  //TODO 14: Write necessary code to do database functions
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  Future<void> addchatRoom(
    String groupName,
    String time,
  ) async{
    final docRef = await firebaseFirestore.collection('chats').add(
      {
        'group':groupName,

      }
    );
    await docRef.set({
      'id':docRef.id,
      'group':groupName,
      'time':time,
      'last message':'',
      'last user':'',
      'last user email':'',

    });
  }

  Future<void> addMessage(
    String id,
    String message,
    String time,
    String groupName,
  ) async {
    final user = FirebaseAuth.instance.currentUser;
    await firebaseFirestore.collection('chats').doc(id).collection('messages').
    add({
      'Username':user!.displayName,
      'E-mail':user.email,
      'Profile pic':user.photoURL,
      'Message':message,
      'Time':time
    }).then((value) {
      firebaseFirestore.collection('chats').doc(id).update({
      
      'time':time,
      'last message':message,
      'last user': user.displayName!.substring(0,user.displayName!.indexOf(' ')),
      'last user email': user.email,
      });
    });
  }
}
