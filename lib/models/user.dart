class User {
  final String uid;

  User({this.uid});
}

class UserData{
  final String uid;
  final String title;
  final String topic;
  final String description;
  final String status;
  final int priority;
  UserData({this.uid, this.title, this.topic, this.priority, this.status, this.description});
}