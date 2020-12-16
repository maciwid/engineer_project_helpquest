class User {
  final String uid;

  User({this.uid});
}

class UserData{
  final String uid;
  final String email;
  final String username;
  final String bio;
  final bool isOnline;
  var quests;

  UserData({this.uid, this.email, this.username, this.bio, this.isOnline, this.quests});
}