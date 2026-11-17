import 'package:flutter/material.dart';
import 'package:warisan_kating/features/chat/screens/chat_room_screen.dart';
import 'package:warisan_kating/features/item_detail/screens/item_detail_screen.dart';
import 'package:warisan_kating/features/main_shell/screens/main_shell_screen.dart';
import 'package:warisan_kating/shared/models/item_model.dart';

/// Centralized named-route definitions.
class AppRouter {
  AppRouter._();

  static const String home = '/';
  static const String addProduct = '/add-product';
  static const String chat = '/chat';
  static const String profile = '/profile';
  static const String itemDetail = '/item-detail';
  static const String chatRoom = '/chat-room';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case home:
        return MaterialPageRoute(builder: (_) => const MainShellScreen());

      case itemDetail:
        final item = settings.arguments as Item;
        return MaterialPageRoute(
          builder: (_) => ItemDetailScreen(item: item),
        );

      case chatRoom:
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => ChatRoomScreen(
            chatId: args['chatId'] as String,
            peerName: args['peerName'] as String,
          ),
        );

      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('404 — Route not found')),
          ),
        );
    }
  }
}
