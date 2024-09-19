import 'package:firebase_core/firebase_core.dart';

class Exceptions {
  static String handleFireBaseException(FirebaseException e) {
    switch (e.code) {
      case 'permission-denied':
        return 'Access Denied: You do not have the required permissions to perform this action. Please contact support if you believe this is an error.';

      case 'not-found':
        return 'Data Not Found: The requested resource could not be located. Ensure the item exists before attempting to access it.';

      case 'already-exists':
        return 'Duplicate Entry: The resource you are trying to add already exists. Please verify the details or update the existing entry.';

      case 'unavailable':
        return 'Service Unavailable: The server is currently unreachable. Please try again later or check the service status.';

      default:
        return 'Unexpected Error: An unknown error occurred. Please try again or contact support if the problem persists.';
    }
  }
}
