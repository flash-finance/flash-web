class CommonProvider {
  static int _homeIndex = 0;

  static int get homeIndex => _homeIndex;

  static changeHomeIndex(int value) {
    _homeIndex = value;
  }

}
