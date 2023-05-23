class ChatUser {
  String name;
  String imageURL;
  String message;
  String date;
  String time;
  bool seen;
  bool sent;
  String received;
  int newMessages;
  ChatUser(
      {this.name,
      this.imageURL,
      this.message,
      this.date,
      this.time,
      this.seen,
      this.sent,
      this.received,
      this.newMessages});
}

