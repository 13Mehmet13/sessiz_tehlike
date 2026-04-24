import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sessiz_tehlike/screens/about_screen.dart';
import 'package:sessiz_tehlike/screens/history_screen.dart';
import 'package:sessiz_tehlike/screens/home_screen.dart';
import 'package:sessiz_tehlike/screens/live_detector_screen.dart';
import 'package:sessiz_tehlike/screens/settings_screen.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      name: 'home',
      builder: (BuildContext context, GoRouterState state) {
        return const HomeScreen();
      },
    ),
    GoRoute(
      path: '/live',
      name: 'live',
      builder: (BuildContext context, GoRouterState state) {
        return const LiveDetectorScreen();
      },
    ),
    GoRoute(
      path: '/history',
      name: 'history',
      builder: (BuildContext context, GoRouterState state) {
        return const HistoryScreen();
      },
    ),
    GoRoute(
      path: '/settings',
      name: 'settings',
      builder: (BuildContext context, GoRouterState state) {
        return const SettingsScreen();
      },
    ),
    GoRoute(
      path: '/about',
      name: 'about',
      builder: (BuildContext context, GoRouterState state) {
        return const AboutScreen();
      },
    ),
  ],
);
