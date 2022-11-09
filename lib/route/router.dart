import 'package:friendview/views/add_friend_view.dart';
import 'package:go_router/go_router.dart';

class CoreRouter {
  static final coreRouter = GoRouter(
    initialLocation: '/dashboard',
    debugLogDiagnostics: true,
    errorBuilder: (context, state) => AddFriendView(),
    routes: [
      GoRoute(
      name: 'routerview',
      path: '/intro',
      builder: (context, state) => AddFriendView(),
      ),
    ],
  );
}
