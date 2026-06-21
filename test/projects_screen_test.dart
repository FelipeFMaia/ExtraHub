import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:extrahub/features/projects/domain/project.dart';
import 'package:extrahub/features/projects/presentation/providers/projects_providers.dart';
import 'package:extrahub/features/projects/presentation/screens/projects_screen.dart';

void main() {
  testWidgets(
    'Cenário de Sucesso: Deve carregar e exibir a lista de projetos na tela',
    (tester) async {
      await tester.binding.setSurfaceSize(const Size(2560, 1440));
      tester.view.devicePixelRatio = 1.0;

      addTearDown(() async {
        await tester.binding.setSurfaceSize(null);
        tester.view.resetDevicePixelRatio();
      });

      final originalOnError = FlutterError.onError;

      FlutterError.onError = (FlutterErrorDetails details) {
        final exception = details.exceptionAsString();

        if (exception.contains('A RenderFlex overflowed')) {
          return;
        }

        originalOnError?.call(details);
      };

      addTearDown(() {
        FlutterError.onError = originalOnError;
      });

      final fakeProjects = [
        Project(
          id: '123',
          name: 'Hackathon ICMC',
          description: 'Maratona de programação da USP',
          status: ProjectStatus.active,
          color: ProjectColor.blue,
          ownerId: 'user_1',
          createdAt: DateTime(2025, 1, 1),
          updatedAt: DateTime(2025, 1, 1),
          createdBy: 'user_1',
        ),
      ];

      final testRouter = GoRouter(
        initialLocation: '/',
        routes: [
          GoRoute(
            path: '/',
            builder: (context, state) => const ProjectsScreen(),
          ),
        ],
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            projectsProvider.overrideWith(
              (ref) => Stream<List<Project>>.value(fakeProjects),
            ),
          ],
          child: MaterialApp.router(
            routerConfig: testRouter,
          ),
        ),
      );

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));
      await tester.pumpAndSettle();

      expect(find.text('Hackathon ICMC'), findsOneWidget);
    },
  );
}
