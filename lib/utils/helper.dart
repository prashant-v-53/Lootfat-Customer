class Helper {
  static bool isEmail(String em) {
    return RegExp(
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(em);
  }

  static bool isPassword(String em) {
    return em.length > 5;
  }

  static bool isPhoneNumber(String em) {
    return (RegExp(r'^(?:[+0][1-9])?[0-9]{10}$').hasMatch(em));
  }

  static bool isFullName(String em) {
    // return (RegExp(r'^(?:[+0][1-9])?[0-9]{10}$').hasMatch(em));
    return (RegExp(
            "^([a-zA-Z]{2,}\\s[a-zA-Z]{1,}'?-?[a-zA-Z]{1,}\\s?([a-zA-Z]{1,})?)")
        .hasMatch(em));
  }
  // static bool isOwnerName(String em) {
  //   // return (RegExp(r'^(?:[+0][1-9])?[0-9]{10}$').hasMatch(em));
  //   return (RegExp(r'^[a-zA-Z][a-zA-Z0-9_.]+[a-zA-Z0-9]$').hasMatch(em));
  // }

  static bool isShopName(String em) {
    return (RegExp(r'^[a-zA-Z][a-zA-Z0-9_.]+[a-zA-Z0-9]$').hasMatch(em));
  }

  static bool iscardNo(String em) {
    return (RegExp(r'^[0-9]').hasMatch(em) && em.length >= 16);
  }

  static bool isCVV(String em) {
    return (RegExp(r'^[0-9]').hasMatch(em) && em.length == 3);
  }

  static bool isPinCode(String em) {
    return (RegExp(r'^[0-9]').hasMatch(em) && em.length == 6);
  }
}

extension StringExtensions on String {
  String capitalizeFirst() {
    return "${this[0].toUpperCase()}${this.substring(1)}";
  }
}
