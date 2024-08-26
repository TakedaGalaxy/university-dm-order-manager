class MyValidator {
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) return 'Email is required';
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) return 'Password is required';
    return null;
  }

  static String? validateUserName(String? value) {
    if (value == null || value.isEmpty) return 'User name is required';
    return null;
  }

  static String? validateCompanyName(String? value) {
    if (value == null || value.isEmpty) return 'Company name is required';
    return null;
  }

  static String? validateDescriptionOrder(String? value) {
    if (value == null || value.isEmpty) return 'Description is required';
    return null;
  }

    static String? validateTableOrder(String? value) {
    if (value == null || value.isEmpty) return 'Table is required';
    return null;
  }
}
