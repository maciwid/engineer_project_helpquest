import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:helpquest/models/quest.dart';
import 'package:helpquest/models/user.dart';

class DatabaseService{

  final String key;
  DatabaseService({this.key});
  //collection reference
  final CollectionReference questCollection = Firestore.instance.collection('quests');
  final CollectionReference userCollection = Firestore.instance.collection('users');
  final CollectionReference chatRoomCollection = Firestore.instance.collection('chatRoom');

//upload user info
  Future updateUserData(String username, String email, String bio, bool isOnline) async{
    return await userCollection.document(key).setData({
      'uid': key,
      'username' : username,
      'email' : email,
      'bio' : bio,
      'isOnline' : isOnline,
    });
  }
  Future setStatus(bool isOnline) async{
    return await userCollection.document(key).updateData({'isOnline': isOnline});
  }

  Future addQuestToCollection(String qid, bool isOwner) async{
    return await userCollection.document(key).collection("quests").add({"questID" : qid, "isOwner" : isOwner});
  }
  //upload quest info
  Future updateQuestData(String qid, String title, String category, String description, String status, num prize, String employerID) async {
    return await questCollection.document(key).setData({
      'qid' : qid,
      'title' : title,
      'category' : category,
      'description' : description,
      'status': status,
      'prize': prize,
      'employerID' : employerID
    });
  }
  //quest list from snapshot
  List<Quest> _questListFromSnapshot(QuerySnapshot snapshot){
    return snapshot.documents.map((doc){
      return Quest(
        qid: doc.data['qid'] ?? '',
        title: doc.data['title'] ?? '',
        employerID: doc.data['employerID'] ?? '',
        category: doc.data['category'] ?? '',
        description: doc.data['description']?? '',
        status: doc.data['status'] ?? '',
        prize: doc.data['prize'] ?? ''
      );
    }).toList();
  }
  //userData form snapshot
  UserData _userDataFromSnapshot(DocumentSnapshot snapshot){
    return UserData(
      uid: key,
      email: snapshot.data['email'],
      username: snapshot.data['username'],
      isOnline: snapshot.data['isOnline'],
      bio: snapshot.data['bio'],
    );
  }
  Quest _questDataFromSnapshot(DocumentSnapshot snapshot){
    return Quest(
      qid: key,
      title: snapshot.data['title'],
      category: snapshot.data['category'],
      description: snapshot.data['description'],
      status: snapshot.data['status'],
      prize: snapshot.data['prize'],
      employerID: snapshot.data['employerID'],
    );
  }

  //get quest stream
Stream<List<Quest>> get quests {
    return questCollection.snapshots()
      .map(_questListFromSnapshot);
}
//get quest doc stream
  Stream<Quest> get quest{
    return questCollection.document(key).snapshots()
        .map(_questDataFromSnapshot);
  }
  //get user doc stream
Stream<UserData> get userData {
    return userCollection.document(key).snapshots()
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

  Future getUserByUid(String uid) async{
    return await userCollection.where("uid", isEqualTo: uid).getDocuments();

  }

  Future createChatRoom(String chatRoomID, dynamic users) async {
    return await chatRoomCollection.document(chatRoomID).setData({
      'chatRoomID' : chatRoomID,
      'users' : users,
    });
}

  Future addConversationMessages(String chatRoomId, messageMap) async{
  return await chatRoomCollection.document(chatRoomId).collection("chats")
      .add(messageMap).catchError((e){print(e.toString());});
}
   getConversationMessages(String chatRoomId) async {
    return await chatRoomCollection.document(chatRoomId).collection("chats")
        .orderBy("time", descending: false).snapshots();
  }
 getChatRooms(String userName) async {
    return await chatRoomCollection.where("users", arrayContains: userName)
        .snapshots();
}
  getChatRoomsById(String chatRoomId) async {
    return await chatRoomCollection.where("chatRoomID", isEqualTo: chatRoomId)
        .snapshots();
  }
}