// import 'package:cie_335/src/features/characters/presentation/character_creation/character_creation_screen.dart';
// import 'package:cie_335/src/features/characters/presentation/character_profile/character_profile_screen.dart';
// import 'package:cie_335/src/features/characters/presentation/characters_list/characters_list_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';

// enum AppRoute { home, creation, profile }

// final goRouter = GoRouter(
//   initialLocation: '/',
//   debugLogDiagnostics: false,
//   routes: [
//     GoRoute(
//       path: '/',
//       name: AppRoute.home.name,
//       builder: (context, state) => CharactersListScreen(),
//       routes: [
//         GoRoute(
//           path: 'creation',
//           name: AppRoute.creation.name,
//           pageBuilder: (context, state) => MaterialPage(
//             key: state.pageKey,
//             fullscreenDialog: true,
//             child: const CharacterCreationScreen(),
//           ),
//         ),
//         GoRoute(
//           path: 'profile/:id',
//           name: AppRoute.profile.name,
//           builder: (context, state) {
//             final characterId = state.pathParameters['id']!;
//             return CharacterProfileScreen(characterId: characterId);
//           },
//         ),
//       ],
//     ),
//   ],
// );
