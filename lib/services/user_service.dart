import 'package:warisan_kating/shared/models/user_model.dart';

/// Contract for user data operations.
abstract class UserService {
  Future<User?> getUserById(String id);
  Future<void> createUser(User user);
  Future<void> updateUser(User user);
}
