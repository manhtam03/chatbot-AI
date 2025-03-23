import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:chatbot/model/message.dart';

class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  // Lưu tin nhắn vào Firestore
  // Future<void> saveMessagesToFirestore(List<Message> messages, String userId) async {
  //   try {
  //     List<Map<String, dynamic>> messagesJson =
  //     messages.map((msg) => msg.toJson()).toList();
  //
  //     await _firestore.collection('chats').doc(userId).set({
  //       'messages': messagesJson,
  //       'timestamp': FieldValue.serverTimestamp(),
  //     });
  //   } catch (e) {
  //     print('Error saving messages to Firestore: $e');
  //   }
  // }

  Future<void> saveMessageToFirestore(Message message, String userId) async {
    try {
      await _firestore.collection('chats').doc(userId).collection('messages').add({
        'text': message.text,
        'isUser': message.isUser,
        'timestamp': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Error saving message to Firestore: $e');
    }
  }


  // Đọc tin nhắn từ Firestore
  // Future<List<Message>> loadMessagesFromFirestore(String userId) async {
  //   try {
  //     DocumentSnapshot doc =
  //     await _firestore.collection('chats').doc(userId).get();
  //
  //     if (doc.exists) {
  //       List<dynamic> messagesJson = (doc.data() as Map<String, dynamic>)['messages'];
  //       return messagesJson.map((msg) => Message.fromJson(msg)).toList();
  //     }
  //   } catch (e) {
  //     print('Error loading messages from Firestore: $e');
  //   }
  //   return [];
  // }
  Future<List<Message>> loadMessagesFromFirestore(String userId) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('chats')
          .doc(userId)
          .collection('messages')
          .orderBy('timestamp', descending: false) // Sắp xếp theo thời gian
          .get();

      return querySnapshot.docs.map((doc) {
        var data = doc.data() as Map<String, dynamic>;
        return Message(
          text: data['text'],
          isUser: data['isUser'],
        );
      }).toList();
    } catch (e) {
      print('Error loading messages from Firestore: $e');
    }
    return [];
  }


  // xóa tin nhắn
  Future<void> deleteConversation(String userId) async {
    try {
      var collection = _firestore.collection('chats').doc(userId).collection('messages');
      var snapshots = await collection.get();
      for (var doc in snapshots.docs) {
        await doc.reference.delete();
      }
      await _firestore.collection('chats').doc(userId).delete(); // Xóa cả document chính
    } catch (e) {
      print("Error deleting conversation: $e");
    }
  }
}
