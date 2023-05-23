import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:seekfighter/Widgets/chat.dart';
import 'package:seekfighter/bloc/message/bloc.dart';
import 'package:seekfighter/constants/constants.dart';
import 'package:seekfighter/constants/size_config.dart';
import 'package:seekfighter/services/messageRepository.dart';

class Messages extends StatefulWidget {
  Messages(this.uid);
  String uid;
  @override
  _MessagesState createState() => _MessagesState();
}

class _MessagesState extends State<Messages> {
  MessageBloc _messageBloc;
  MessageRepository _messagesRepository = MessageRepository();


  @override
  void initState() {


    super.initState();

    _messageBloc = MessageBloc(messageRepository: _messagesRepository);
  }
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MessageBloc, MessageState>(
      bloc: _messageBloc,
      builder: (BuildContext context, MessageState state) {
        if (state is MessageInitialState) {

          _messageBloc.add(ChatStreamEvent(currentUserId: widget.uid));
        }
        if (state is ChatLoadingState) {
          return Center(
            child: SpinKitRing(
              color: kPrimaryColor,
              size: 30,
              lineWidth: 4,
            ),
          );
        }
        if (state is ChatLoadedState) {
          Stream<QuerySnapshot> chatStream = state.chatStream;

          return StreamBuilder<QuerySnapshot>(
            stream: chatStream,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: SpinKitRing(
                    color: kPrimaryColor,
                    size: 30,
                    lineWidth: 4,
                  ),
                );
              }

              if (snapshot.data.documents.isNotEmpty) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  return ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: snapshot.data.documents.length,
                    itemBuilder: (BuildContext context, int index) {
                      return ChatWidget(
                        creationTime:
                        snapshot.data.documents[index].data['timestamp'],
                        userId: widget.uid,
                        selectedUserId:
                        snapshot.data.documents[index].documentID,
                      );
                    },
                  );
                }
              } else
                return Center(
                  child: Text(
                    " You don't have any conversations",
                    style: TextStyle(fontSize: getProportionateScreenWidth(16), fontWeight: FontWeight.bold),
                  ),
                );
            },
          );
        }
        return Container();
      },
    );
  }
}
