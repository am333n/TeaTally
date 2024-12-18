import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:teatally/core/injection/injection.dart';
import 'package:teatally/features/auth/application/cubit/auth_cubit.dart';
import 'package:teatally/features/auth/presentation/auth_screen.dart';
import 'package:teatally/features/home/presentation/home_page.dart';

part 'router.gr.dart';

@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
        _buildRoute(page: HomeRoute.page, initial: false),
        _buildRoute(page: AuthRoute.page, initial: true, guards: [AuthGuard()]),
      ];

  CustomRoute _buildRoute({
    required PageInfo page,
    List<AutoRouteGuard> guards = const [],
    bool initial = false,
  }) {
    return CustomRoute(
      page: page,
      guards: guards,
      initial: initial,
      transitionsBuilder: TransitionsBuilders.slideRight,
    );
  }
}

class AuthGuard extends AutoRouteGuard {
  AuthGuard();
  @override
  Future<void> onNavigation(
      NavigationResolver resolver, StackRouter router) async {
    final isUserLoggedIn = getIt<AuthCubit>().checkUserSignedInStatus();

    if (isUserLoggedIn) {
      router.replace(const HomeRoute());
    } else {
      resolver.next();
    }
  }
}