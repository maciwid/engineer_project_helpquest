import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:helpquest/models/quest.dart';
import 'package:helpquest/models/user.dart';

class DatabaseService{

  final String uid;
  DatabaseService({this.uid});
  //collection reference
  final CollectionReference questCollection = Firestore.instance.collection('quests');
  final CollectionReference userCollection = Firestore.instance.collection('users');
  final CollectionReference chatRoomCollection = Firestore.instance.collection('chatRoom');

  Future updateUserData(String title, String topic, String description, String status, int priority) async {
    return await questCollection.document(uid).setData({
      'title' : title,
      'topic' : topic,
      'description' : description,
      'status': status,
      'priority': priority
    });
  }
  //quest list from snapshot
  List<Quest> _questListFromSnapshot(QuerySnapshot snapshot){
    return snapshot.documents.map((doc){
      return Quest(
        title: doc.data['title'] ?? '',
        topic: doc.data['topic'] ?? '',
        description: doc.data['description']?? '',
        status: doc.data['status'] ?? '',
        priority: doc.data['priority'] ?? 0
      );
    }).toList();
  }
  //userData form snapshot
  UserData _userDataFromSnapshot(DocumentSnapshot snapshot){
    return UserData(
      uid: uid,
      title: snapshot.data['title'],
    );
  }

  //get quest stream
Stream<List<Quest>> get quests {
    return questCollection.snapshots()
      .map(_questListFromSnapshot);
}
  //get user doc stream
Stream<UserData> get userData {
    return questCollection.document(uid).snapshots()
    .map(_userDataFromSnapshot);
}
  //get user by username
Future getUserByUsername(String username) async{
  return await userCollection.where("username", isEqualTo: username)
      .getDocuments();
}
  Future getUserByEmail(String email) async{
    return await userCollection.where("email", isEqualTo: email)
        .getDocuments();
  }
//upload user info
Future uploadUserData(String username, String email) async{
  return await userCollection.document(uid).setData({
    'username' : username,
    'email' : email,
  });
}

createChatRoom(String chatRoomID, String userName){
    chatRoomCollection.document(chatRoomID).setData({
      'chatRoomID' : chatRoomID,
    });
}
}