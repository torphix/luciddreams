class User {
  final String? token;
  final String? email;
  User({
    this.token = '',
    this.email = '',
  });

  bool isLoggedIn(){
    return email != null && email != '' ? true : false;
  }
}
