sealed class StringRes {
  static const String appName = 'Wifi Logger';
  static const String fontFamily = 'Nunito';

  static const String submit = 'Submit';
  static const String success = 'Success';
  static const String home = 'Home';
  static const String search = 'Search';
  static const String cancel = 'Cancel';
  static const String close = 'Close';
  static const String share = 'Share';
  static const String settings = 'Settings';
  static const String refresh = 'Refresh';

  // errors
  static const String errorEmail = 'Invalid Email';
  static const String errorPhone = 'Invalid Phone Number';
  static const String errorWeakPass = 'The password provided is too weak';
  static const String errorCriteria = 'Password criteria dosen\'t match';
  static String errorEmpty(String title) => '$title is required';
  static const String errorUnknown = 'Something went wrong, try again';
  static const String errorLoad = 'Failed to load data, refresh to load again';
  static const String errorCredentials =
      'Something went wrong,'
      ' please login again';
}
