class User {
  int id = 0;
  String? email;
  String? name;
  String? lastLogin;
  List<Post> posts = [];

  User({required this.id, required this.email, required this.name, this.lastLogin});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    email = json['email'];
    name = json['name'];
    lastLogin = json['last_login'];
    if (json['posts'] != null) {
      json['posts'].forEach((v) {
        posts.add(Post.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['email'] = email;
    data['name'] = name;
    data['last_login'] = lastLogin;
    data['posts'] = posts.map((v) => v.toJson()).toList();
    return data;
  }
}

class Post {
  int id = 0;
  String? title;
  String? description;
  String? insertDate;
  List<Comment> comments = [];

  Post({required this.id, required this.title, required this.description, required this.comments});

  Post.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    insertDate = json['insert_date'];
    if (json['comments'] != null) {
      json['comments'].forEach((v) {
        comments.add(Comment.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = title;
    data['description'] = description;
    data['insert_date'] = insertDate;
    data['comments'] = comments.map((v) => v.toJson()).toList();
    return data;
  }
}

class Comment {
  int id = 0;
  String? email;
  String? insertDate;
  String? commentText;

  Comment({required this.id, required this.email, required this.commentText});

  Comment.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    email = json['email'];
    insertDate = json['insert_date'];
    commentText = json['comment_text'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['email'] = email;
    data['insert_date'] = insertDate;
    data['comment_text'] = commentText;
    return data;
  }
}
