// ignore_for_file: prefer_const_constructors

//TODO 15: import packages cloud firestore,firebase auth, google sign in, scaffold gradient, messages screen and database services
import 'dart:math';
import 'package:chitty_chat_app/screens/message_screen.dart';
import 'package:chitty_chat_app/services/database_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:chitty_chat_app/services/auth_services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:scaffold_gradient_background/scaffold_gradient_background.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  //TODO 16: Create instances of Firebase Auth, Google sign in, firebase firestore and database services

  //TODO 17: Create a List<DocumentSnapshot> to store the data coming from database

 AuthServices authServices =AuthServices();
 DataBaseServices dataBaseServices = DataBaseServices();
 List<DocumentSnapshot>? chats;
 FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
 TextEditingController groupNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;
    return SafeArea(
      child: ScaffoldGradientBackground(
        gradient: const LinearGradient(
          colors: [
            Color(0xffFFF3B0),
            Color(0xffCA26FF),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            //TODO 18: call function to add new group to database
            showGroupAddAlert(context);
          },
          backgroundColor: Color(0xff37007C),
          tooltip: "Add new group",
          child: Icon(
            CupertinoIcons.plus_bubble,
            color: Color(0xffFFF3B0),
            size: w * 0.07,
          ),
        ),
        //TODO 11f:Provide gradient
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          leading: Container(
            margin: EdgeInsets.only(
              left: w * 0.02,
              top: w * 0.01,
            ),
            child: CircleAvatar(
              radius: w * 0.058,
              backgroundColor: const Color(0xff37007C),
              child: CircleAvatar(
                radius: w * 0.052,
                backgroundImage: NetworkImage(
                  //TODO 19: Write the url of profile image using firebase auth instead of the quotes
                  '${authServices.firebaseAuth.currentUser!.photoURL}',
                ),
              ),
            ),
          ),
          title: Text(
            //TODO 20: Write the url of user name using firebase auth after 'Welcome '
            'Welcome ${authServices.firebaseAuth.currentUser!.displayName!.substring(0,authServices.firebaseAuth.currentUser!.displayName!.indexOf(' '))}',
            style: TextStyle(
              color: const Color(0xff37007C),
              fontSize: w * 0.07,
              fontWeight: FontWeight.w600,
              height: 2,
            ),
          ),
          elevation: 0,
          actions: [
            IconButton(
                onPressed: () async {
                  //TODO 21: Write code to Logout from your logged in account and navigate to login screen
                  await authServices.signOutOfGoogle(context);
                },
                icon: Icon(
                  Icons.logout_rounded,
                  color: const Color(0xff37007C),
                  size: w * 0.07,
                ))
          ],
        ),
        body:
            //TODO 22a: specify type of stream as QuerySnapshot
            StreamBuilder<QuerySnapshot>(
          //TODO 22b: Provide chat groups stream. This avoids the error in the line 'snapshot.data!.docs' getter
          stream: firebaseFirestore.collection('chats').orderBy(
            'time',descending: true
          ).snapshots(),

          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text(
                  'Unable to load chats',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: w * 0.08,
                    color: Color(0xff37007C).withOpacity(0.4),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              );
            } else if (snapshot.hasData
                 && snapshot.data!.docs.isNotEmpty
                ) {
              //TODO 23: store the document snapshots of chat groups to created list

              chats = snapshot.data!.docs;

              return Center(
                child: Column(
                  children: [
                    SizedBox(
                      height: h * 0.03,
                    ),
                    SizedBox(
                      height: h * 0.03,
                    ),
                    Expanded(
                      child: ListView.builder(
                          //TODO 24: provide length of List<DocumentSnapshot> instead of the number 10
                          itemCount: chats!.length,
                          itemBuilder: (context, index) {
                            int red = Random().nextInt(255);
                            int blue = Random().nextInt(255);
                            int green = Random().nextInt(255);
                            double overall = sqrt(0.299 * red * red +
                                0.587 * green * green +
                                0.114 * blue * blue);

                                String time = chats![index]['time'];

                            return Container(
                              margin: EdgeInsets.only(
                                left: w * 0.03,
                                right: w * 0.04,
                                top: h * 0.015,
                              ),
                              child: ListTile(
                                onTap: () {
                                  //TODO 25: navigate to messaging screen with fields of document snapshots and colour generated
                                  Navigator.push(context, MaterialPageRoute(builder: (context)=>
                                  MessageScreen(
                                    id: chats?[index]['id'], 
                                    groupName: chats?[index]['groud'], 
                                    color: Color.fromARGB(255, red, green, blue), 
                                    overall: overall
                                  )));
                                },
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(
                                      12,
                                    ),
                                  ),
                                ),
                                tileColor: Color(0xffFFF3B0),
                                leading: CircleAvatar(
                                  backgroundColor: Color.fromARGB(
                                    255,
                                    red,
                                    green,
                                    blue,
                                  ),
                                  child: Text(
                                    //TODO 26:Provide the 1st letter of the group name instead of quotes
                                    '${chats![index]['group']}'.substring(0,1),
                                    style: TextStyle(
                                      color: overall > 127.5
                                          ? Colors.black
                                          : Colors.white,
                                      fontWeight: FontWeight.w600,
                                      fontSize: w * 0.06,
                                    ),
                                  ),
                                ),
                                title: Text(
                                  //TODO 27:Provide the group name instead of quotes
                                  '${chats![index]["group"]}',
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: w * 0.05,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                subtitle: Text(
                                  chats![index]['last user'] == '' ?
                                  '' : chats![index]['last user'] == authServices.firebaseAuth.currentUser!.email
                                  ? 'You: ${chats![index]['last message']}' :
                                  '${chats![index]['last user']} : ${chats![index]['last message']}',
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                trailing: Text(
                                 '${time.substring(24,27).trim()} ${time.substring(8,10).trim} ${time.substring(0,4).trim()} \n ${time.substring(12,17).trim()} ${time.substring(21,23).trim()}',
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: w*0.03
                                  ),
                                ),
                              ),
                            );
                          }),
                    ),
                  ],
                ),
              );
            } else if (snapshot.hasData
                 && snapshot.data!.docs.isEmpty
                ) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text(
                    'Create a new group to start chat',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: w * 0.08,
                      color: Color(0xff37007C).withOpacity(0.4),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              );
            } else {
              return Center(
                child: CircularProgressIndicator(
                  color: Color(0xff37007C),
                ),
              );
            }
          },
        ),
      ),
    );
  }

  showGroupAddAlert(BuildContext context) {
    TextEditingController groupNameController = TextEditingController();
    Widget okButton = TextButton(
      onPressed: () async {
        String groupName = groupNameController.text;
        //TODO 28:Add the data to database using database services
        await dataBaseServices.addchatRoom(groupName,
        DateFormat('YYYY MM dd, hh:mm:ss a MMM E').format(
          DateTime.now()
        )
        );
        groupNameController.dispose();
        Navigator.pop(context);
      },
      child: Text(
        'Add',
        style: TextStyle(
          color: Color(0xff37007C),
        ),
      ),
    );
    AlertDialog alertDialog = AlertDialog(
      title: Text('New Community'),
      content: TextFormField(
        style: TextStyle(
          color: Color(0xff37007C),
        ),
        cursorColor: Color(0xff37007C),
        controller: groupNameController,
        decoration: InputDecoration(
          focusColor: Color(0xff37007C),
          hintText: 'Enter new community name',
          hintStyle: TextStyle(color: Color(0xff37007C).withOpacity(0.3)),
        ),
      ),
      actions: [
        okButton,
      ],
    );
    showDialog(context: context, builder: (context) => alertDialog);
  }

  @override
  void dispose() {
    super.dispose();
  }
}
