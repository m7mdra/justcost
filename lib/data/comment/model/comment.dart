class CommentResponse {
  bool success;
  List<Comment> data;
  String message;

  CommentResponse({this.success, this.data, this.message});

  CommentResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['data'] != null) {
      data = new List<Comment>();
      json['data'].forEach((v) {
        data.add(new Comment.fromJson(v));
      });
    }
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    data['message'] = this.message;
    return data;
  }
}

class Comment {
  int commentId;
  String commentPic;
  String comment;
  String customerName;
  String postedOn;
  List<Rate> rate;
  List<Replay> replies;

  Comment(
      {this.commentId,
      this.commentPic,
      this.comment,
      this.customerName,
      this.postedOn,
      this.rate,
      this.replies});

  Comment.fromJson(Map<String, dynamic> json) {
    commentId = json['commentId'];
    commentPic = json['commentPic'];
    comment = json['comment'];
    customerName = json['customerName'];
    postedOn = json['postedOn'];
    if (json['rate'] != null) {
      rate = new List<Rate>();
      json['rate'].forEach((v) {
        rate.add(new Rate.fromJson(v));
      });
    }
    if (json['replyes'] != null) {
      replies = new List<Replay>();
      json['replyes'].forEach((v) {
        replies.add(new Replay.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['commentId'] = this.commentId;
    data['commentPic'] = this.commentPic;
    data['comment'] = this.comment;
    data['customerName'] = this.customerName;
    data['postedOn'] = this.postedOn;
    if (this.rate != null) {
      data['rate'] = this.rate.map((v) => v.toJson()).toList();
    }
    if (this.replies != null) {
      data['replyes'] = this.replies.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Rate {
  int rate;
  int ratings;

  Rate({this.rate, this.ratings});

  Rate.fromJson(Map<String, dynamic> json) {
    rate = json['rate'];
    ratings = json['ratings'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['rate'] = this.rate;
    data['ratings'] = this.ratings;
    return data;
  }
}

class Replay {
  int commentId;
  Null commentPic;
  String comment;
  String customerName;
  String postedOn;
  List<Rate> rate;

  Replay(
      {this.commentId,
      this.commentPic,
      this.comment,
      this.customerName,
      this.postedOn,
      this.rate});

  Replay.fromJson(Map<String, dynamic> json) {
    commentId = json['commentId'];
    commentPic = json['commentPic'];
    comment = json['comment'];
    customerName = json['customerName'];
    postedOn = json['postedOn'];
    if (json['rate'] != null) {
      rate = new List<Rate>();
      json['rate'].forEach((v) {
        rate.add(new Rate.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['commentId'] = this.commentId;
    data['commentPic'] = this.commentPic;
    data['comment'] = this.comment;
    data['customerName'] = this.customerName;
    data['postedOn'] = this.postedOn;
    if (this.rate != null) {
      data['rate'] = this.rate.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
