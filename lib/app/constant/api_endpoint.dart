class ApiEndpoints {
  ApiEndpoints._();

  // Timeouts
  static const connectionTimeout = Duration(seconds: 1000);
  static const receiveTimeout = Duration(seconds: 1000);

  // For Android Emulator use 10.0.2.2
  static const String serverAddress = "http://10.0.2.2:5000";

  // Base URL matches your backend
  static const String baseUrl = "$serverAddress/api/users/";

  // Auth
  static const String register = "signup";
  static const String login = "login";
  static const String getAllUsers = "getAllUsers"; // if you have it
  static const String deleteUsers = "deleteUsers/"; // if you have it
  static const String uploadImage = "uploadImage";  // if you have it

  // Example usage in your code:
  // final url = ApiEndpoints.baseUrl + ApiEndpoints.register;
}
