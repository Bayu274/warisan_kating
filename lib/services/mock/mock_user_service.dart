import 'package:warisan_kating/services/user_service.dart';
import 'package:warisan_kating/shared/models/user_model.dart';

/// In-memory mock for user operations.
class MockUserService implements UserService {
  final Map<String, User> _users = {
    'user-1': const User(id: 'user-1', name: 'Andi', contact: '081234567890'),
    'user-2': const User(id: 'user-2', name: 'Budi', contact: '089876543210'),
  };

  @override
  Future<User?> getUserById(String id) async => _users[id];

  @override
  Future<void> createUser(User user) async => _users[user.id] = user;

  @override
  Future<void> updateUser(User user) async => _users[user.id] = user;
}
