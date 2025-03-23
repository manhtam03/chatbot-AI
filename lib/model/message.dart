class Message {
  final String text;
  final bool isUser;
  Message({required this.text, required this.isUser,});

  // Convert the object to a JSON map
  Map<String, dynamic> toJson() => {
    'text': text,
    'isUser': isUser,
  };

  // Create an object from a JSON map
  factory Message.fromJson(Map<String, dynamic> json) => Message(
    text: json['text'],
    isUser: json['isUser'],
  );
}