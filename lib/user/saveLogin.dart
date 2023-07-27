class SaveLogin {
  static String username = "";
  static int level = 1;
  static int cartId = -1;

  void setUsername(String usernameLogin) {
    username = usernameLogin;
  }

  void setLevel(int levelLogin) {
    level = levelLogin;
  }

  void setCartId(int cart) {
    cartId = cart;
  }

  String getUsername() {
    return username;
  }

  int getLevel() {
    return level;
  }

  int getCartId() {
    return cartId;
  }

  void reset() {
    username = "";
    level = 1;
    cartId = -1;
  }
}
