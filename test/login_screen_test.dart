import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:extrahub/features/auth/data/auth_repository.dart';
import 'package:extrahub/features/auth/presentation/screens/login_screen.dart';
import 'package:extrahub/features/auth/domain/auth_failure.dart';
import 'package:extrahub/features/auth/presentation/providers/auth_providers.dart';

class FakeAuthRepository implements AuthRepository {
  @override
  Future<UserCredential> signIn({
    required String email,
    required String password,
  }) async {
    throw const NotUspEmail();
  }

  @override
  Future<UserCredential> signUp({
    required String displayName,
    required String email,
    required String password,
  }) async {
    throw UnimplementedError();
  }

  @override
  Future<void> signOut() async {}

  @override
  Stream<User?> authStateChanges() => Stream.value(null);

  @override
  User? get currentUser => null;

  @override
  Future<void> sendPasswordResetEmail(String email) async {}

  @override
  Future<void> sendEmailVerification() async {}

  @override
  Future<void> reloadCurrentUser() async {}
}

void main() {
  testWidgets('Cenário de Erro: Deve exibir mensagem quando o login falha', (tester) async {
    final fakeRepo = FakeAuthRepository();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authRepositoryProvider.overrideWithValue(fakeRepo),
        ],
        child: const MaterialApp(
          home: LoginScreen(),
        ),
      ),
    );

    await tester.enterText(find.byType(TextFormField).first, 'aluno@usp.br');
    await tester.enterText(find.byType(TextFormField).last, 'senhaErrada123');

    await tester.tap(find.text('Entrar'));

    await tester.pumpAndSettle();

    expect(
      find.text('Use seu e-mail institucional da USP (@usp.br).'),
      findsOneWidget,
    );
  });
}
