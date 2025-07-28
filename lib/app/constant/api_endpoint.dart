class ApiEndpoints {
  ApiEndpoints._();

  // Timeouts
  static const connectionTimeout = Duration(seconds: 1000);
  static const receiveTimeout = Duration(seconds: 1000);

  // Server base (Android Emulator: 10.0.2.2)
  static const String serverAddress = "http://10.0.2.2:5000";

  // Base URLs
  static const String userBaseUrl = "$serverAddress/api/users/";
  static const String trekBaseUrl = "$serverAddress/api/treks/";
  static const String journalBaseUrl = "$serverAddress/api/journals/";

  // Auth / Users
  static const String register = "signup";                      // POST userBaseUrl + signup
  static const String login = "login";                          // POST userBaseUrl + login
  static String getProfileById(String userId) => "profile/$userId"; // GET userBaseUrl + profile/{userId}
  static const String getAllUsers = "getAllUsers";              // GET userBaseUrl + getAllUsers
  static String deleteUserById(String userId) => "deleteUsers/$userId"; // DELETE userBaseUrl + deleteUsers/{userId}
  static const String uploadImage = "uploadImage";              // POST userBaseUrl + uploadImage
  static const String updateProfile = "updateProfile";          // PUT userBaseUrl + updateProfile

  // Treks
  static const String getAllTreks = "";                         // GET trekBaseUrl
  static String getTrekById(String id) => "$id";                // trekBaseUrl + {id}
  static const String createTrek = "";                          // POST trekBaseUrl
  static String updateTrekById(String id) => "$id";             // PUT trekBaseUrl + {id}
  static String deleteTrekById(String id) => "$id";             // DELETE trekBaseUrl + {id}
  static const String uploadTrekImage = "upload";               // POST trekBaseUrl + upload

  // Reviews
  static String addReview(String trekId) => "$trekId/reviews";  // POST trekBaseUrl + {trekId}/reviews
  static String getReviews(String trekId) => "$trekId/reviews"; // GET trekBaseUrl + {trekId}/reviews
  static const String getAllReviewsFromAllTreks = "reviews/all";// GET trekBaseUrl + reviews/all

  // Journals
  static const String getAllJournals = "";                      // GET journalBaseUrl
  static String getJournalById(String id) => "$id";             // journalBaseUrl + {id}
  static const String createJournal = "";                       // POST journalBaseUrl
  static String updateJournalById(String id) => "$id";          // PUT journalBaseUrl + {id}
  static String deleteJournalById(String id) => "$id";          // DELETE journalBaseUrl + {id}
}
