class User {
  final String? token;
  final String? email;
  final String? nicename;
  final String? name;

  User({
    this.token,
    this.email,
    this.nicename,
    this.name,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    token: json['token'],
    email: json['user_email'],
    nicename: json['user_nicename'],
    name: json['user_display_name'],
  );

  Map<String, dynamic> toJson() => {
    'token': token,
    'user_email': email,
    'user_nicename': nicename,
    'user_display_name': name,
  };
}
