import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:warisan_kating/core/router/app_router.dart';
import 'package:warisan_kating/core/theme.dart';
import 'package:warisan_kating/services/item_service.dart';
import 'package:warisan_kating/services/user_service.dart';
import 'package:warisan_kating/services/chat_service.dart';
import 'package:warisan_kating/services/barter_service.dart';
import 'package:warisan_kating/services/image_picker_service.dart';
import 'package:warisan_kating/services/image_picker_service_impl.dart';
import 'package:warisan_kating/services/firestore/firestore_item_service.dart';
import 'package:warisan_kating/services/firestore/firestore_barter_service.dart';
import 'package:warisan_kating/services/firestore/firestore_chat_service.dart';
import 'package:warisan_kating/services/mock/mock_user_service.dart';

class WarisanKatingApp extends StatelessWidget {
  const WarisanKatingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // ── Live Firebase services ──
        Provider<ItemService>(create: (_) => FirestoreItemService()),
        Provider<BarterService>(create: (_) => FirestoreBarterService()),
        Provider<ChatService>(create: (_) => FirestoreChatService()),

        // ── Still mocked (swapped in later sprints) ──
        Provider<UserService>(create: (_) => MockUserService()),
        Provider<ImagePickerService>(create: (_) => ImagePickerServiceImpl()),
      ],
      child: MaterialApp(
        title: 'Warisan Kating',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        initialRoute: AppRouter.home,
        onGenerateRoute: AppRouter.onGenerateRoute,
      ),
    );
  }
}
