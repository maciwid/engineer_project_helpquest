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
  Future updateQuestData(String qid,String type, String title, String category, String region, String description, String status, num prize, String employerID, String empUserName, num time) async {
    return await questCollection.document(key).setData({
      'qid' : qid,
      'type' : type,
      'title' : title,
      'category' : category,
      'region' : region,
      'description' : description,
      'status': status,
      'prize': prize,
      'employerID' : employerID,
      'empUserName' : empUserName,
      'time' : time,
    });
  }
  //quest list from snapshot
  List<Quest> _questListFromSnapshot(QuerySnapshot snapshot){
    return snapshot.documents.map((doc){
      return Quest(
        qid: doc.data['qid'] ?? '',
        type: doc.data['type'] ?? '',
        title: doc.data['title'] ?? '',
        employerID: doc.data['employerID'] ?? '',
        empUserName: doc.data['empUserName'] ?? '',
        category: doc.data['category'] ?? '',
        region: doc.data['region'] ?? '',
        description: doc.data['description']?? '',
        status: doc.data['status'] ?? '',
        prize: doc.data['prize'] ?? '',
        time: doc.data['time'] ?? 0,
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
      type: snapshot.data['type'],
      title: snapshot.data['title'],
      category: snapshot.data['category'],
      region: snapshot.data['region'],
      description: snapshot.data['description'],
      status: snapshot.data['status'],
      prize: snapshot.data['prize'],
      employerID: snapshot.data['employerID'],
      empUserName: snapshot.data['empUserName'],
      time: snapshot.data['time']
    );
  }

  //get quest stream
Stream<List<Quest>> get quests {
    return questCollection.orderBy("time", descending: true).snapshots()
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
  checkIfUserNameAvailable(String username) async {

    final QuerySnapshot result = await Future.value(userCollection
        .where('username', isEqualTo: username)
        .limit(1)
        .getDocuments());
    print(" heyyy ${result.documents[0].data.toString()}");
    //final List<DocumentSnapshot> documents = result.documents;
    if (result.documents.length == 1) {
      print("UserName Already Exits");
        return false; //= documents.length == 1;
    } else {
      print("UserName is Available");
      return true; //= documents.length == 1;
    }
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