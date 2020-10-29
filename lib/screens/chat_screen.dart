import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/constants.dart';

// creating an instance of the firestore class here so that we would be able to
// acess it anywhere inside this file
final _fireStore = FirebaseFirestore.instance;

// creating an instance of the User class here so that we would be able to access
// it anywhere inside this file
User loggedInUser;

class ChatScreen extends StatefulWidget {
  // creating a static constant or class variable here to help us to navigate to
  // the chat screen
  static const chatScreenId = '/chatScreen';

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  // creating a new property here called messageTextController of type
  // TextEditingController() widget to clear the text field widget when the
  // user clicks on the send button to send the message
  final messageTextController = TextEditingController();
  // creating a new instance of the FirebaseAuth class
  final _auth = FirebaseAuth.instance;
  // creating a property named messageText of type string to get the message
  // entered by the user entered in the message field
  String messageText;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() async {
    try {
      // creating a new final variable called currentUser to get the values(email address etc... )
      // of the current user
      final currentUser = _auth.currentUser;

      if (currentUser != null) {
        loggedInUser = currentUser;
      }
    } catch (e) {
      print('The error is: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.close),
            onPressed: () {
              _auth.signOut();
              Navigator.pop(context);
            },
          ),
        ],
        title: Text('⚡️Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            MessageStream(),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: messageTextController,
                      onChanged: (value) {
                        messageText = value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  FlatButton(
                    onPressed: () {
                      messageTextController.clear();
                      _fireStore.collection('messages').add({
                        'text': messageText,
                        'sender': loggedInUser.email,
                      });
                    },
                    child: Text(
                      'Send',
                      style: kSendButtonTextStyle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// creating a new stateless widget here called MessageStream to return a stream
// builder widget to get the messages from the firestore database and display that
// in our app
class MessageStream extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _fireStore.collection('messages').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.lightBlueAccent,
            ),
          );
        } else {
          final messages = snapshot.data.docs.reversed;
          List<MessageBubble> messageBubbleWidget =
              []; // initially this list is empty

          // using the for in loop to loop over the snapshot of the
          // data that we are getting from the firebase firestore
          for (var message in messages) {
            final messageSender = message.data()['sender']; // this variable
            // contains the email of the message Sender

            // getting the text send by the sender from the database
            final messageText = message.data()['text'];

            // creating a new final Variable to get the email of the current user
            final currentUser = loggedInUser.email;

            final messageTextBubble = MessageBubble(
              sender: messageSender,
              text: messageText,
              isMe: currentUser == messageSender,
            );

            messageBubbleWidget.add(messageTextBubble);
          }

          return Expanded(
            child: ListView(
              reverse: true,
              padding: EdgeInsets.symmetric(
                vertical: 20.0,
                horizontal: 10.0,
              ),
              children: messageBubbleWidget,
            ),
          );
        }
      },
    );
  }
}

// creating a new widget here called the MessageBubble to display the message that
// the user has send or the messages that are being recieved by the user
class MessageBubble extends StatelessWidget {
  // creating a property below so as to get the email of the message sender
  final String sender;
  // creating a property here so as to get the text of the message sent
  final String text;
  // creating a new property of boolean type to check if I am the current user or not
  final bool isMe;

  MessageBubble({
    this.sender,
    this.text,
    this.isMe,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            sender,
            style: TextStyle(
              fontSize: 12.0,
              color: Colors.black54,
            ),
          ),
          Material(
            elevation: 5.0,
            borderRadius: isMe
                ? BorderRadius.only(
                    topLeft: Radius.circular(30.0),
                    bottomLeft: Radius.circular(30.0),
                    bottomRight: Radius.circular(30.0),
                  )
                : BorderRadius.only(
                    topRight: Radius.circular(30.0),
                    bottomLeft: Radius.circular(30.0),
                    bottomRight: Radius.circular(30.0),
                  ),
            color: isMe ? Colors.lightBlueAccent : Colors.white,
            child: Padding(
              padding: EdgeInsets.symmetric(
                vertical: 10.0,
                horizontal: 20.0,
              ),
              child: Text(
                '$text',
                style: TextStyle(
                  fontSize: 15.0,
                  color: isMe ? Colors.white : Colors.black54,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
