import 'dart:math';

import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class Message {
  final String message;
  final bool isYou;
  final String date;

  Message(this.message, this.isYou, this.date);

  @override
  String toString() {
    // TODO: implement toString
    return "$date: $message";
  }
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController _chatController;
  List<Message> messages;

  @override
  void initState() {
    super.initState();
    _chatController = TextEditingController();
    messages = List.generate(4, (index) {
      return index % 2 == 0
          ? Message('Sent Message', true, '${Random().nextInt(60)} min ago')
          : Message(
              'Received Message', false, '${Random().nextInt(60)} min ago');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Send Message to Ahmed'),
      ),
      body: SafeArea(
          child: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              reverse: true,
              itemBuilder: (context, index) {
                var message = messages[index];
                return message.isYou
                    ? _sentMessage(message)
                    : _receivedMessage(message);
              },
              itemCount: messages.length,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(2.0),
            child: Row(
              children: <Widget>[
                Expanded(
                    child: Card(
                  child: TextField(
                    controller: _chatController,
                    keyboardType: TextInputType.multiline,
                    textInputAction: TextInputAction.newline,
                    maxLines: null,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.all(10)),
                  ),
                )),
                FloatingActionButton(
                  onPressed: () {
                    print('sending message $messages');
                    setState(() {
                      var message = _chatController.text;
                      if (message.isNotEmpty)
                        messages.insert(0,
                            Message(_chatController.text, true, '1 Sec ago'));
                    });
                    print('sending message $messages');
                    _chatController.clear();
                  },
                  child: Icon(Icons.send),
                )
              ],
            ),
          )
        ],
      )),
    );
  }

  Widget _sentMessage(Message message) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Container(
          margin: const EdgeInsets.only(right: 8, left: 32, top: 4),
          padding: const EdgeInsets.all(8),
          child: Text(
            message.message,
            style: Theme.of(context).textTheme.body1.copyWith(fontSize: 14),
          ),
          decoration: ShapeDecoration(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(16))),
              color: Theme.of(context).splashColor),
        ),
      ],
    );
  }

  Widget _receivedMessage(Message message) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          margin: const EdgeInsets.only(left: 8, right: 32, top: 4),
          padding: const EdgeInsets.all(8),
          child: Text(
            message.message,
            style: Theme.of(context).textTheme.body1.copyWith(fontSize: 14),
            maxLines: null,
            overflow: TextOverflow.visible,
            softWrap: true,
          ),
          decoration: ShapeDecoration(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(16))),
              color: Theme.of(context).accentColor),
        ),
      ],
    );
  }
}

class MessageBubble extends StatelessWidget {
  final Message message;
  final bool isYour;

  const MessageBubble({Key key, this.message, this.isYour}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 8, right: 8, top: 4),
      padding: const EdgeInsets.all(8),
      alignment: isYour ? Alignment.topRight : Alignment.topLeft,
      child: Text(
        message.message,
        style: Theme.of(context).textTheme.body1.copyWith(fontSize: 14),
        maxLines: null,
        overflow: TextOverflow.visible,
        softWrap: true,
      ),
      decoration: ShapeDecoration(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(16))),
          color: Theme.of(context).accentColor),
    );
  }
}
