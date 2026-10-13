import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:slicing/main.dart';
import 'package:slicing/service/api.dart';

/// Ditiru dari seed API: email demo sudah terdaftar, jadi register memakainya
/// akan ditolak 409.
const _emailTerdaftar = 'email@gmail.com';

/// Login & register menembak API sungguhan, dan di lingkungan test tidak ada
/// server yang menjawab — request-nya menggantung sehingga spinner berputar
/// selamanya. Klien HTTP diganti fake supaya alurnya bisa diuji tanpa jaringan.
void _pasangApiFake({bool emailSudahTerdaftar = false}) {
  ApiService.client = MockClient((request) async {
    final headers = {'content-type': 'application/json'};

    http.Response sukses(String pesan, Map<String, dynamic> body) =>
        http.Response(
          jsonEncode({'message': pesan, 'data': body}),
          200,
          headers: headers,
        );

    http.Response gagal(int status, String pesan) => http.Response(
      jsonEncode({'message': pesan}),
      status,
      headers: headers,
    );

    switch (request.url.path) {
      case '/api/auth/login':
        final body = jsonDecode(request.body) as Map<String, dynamic>;
        if (body['password'] != 'password123') {
          return gagal(401, 'Email atau password salah');
        }
        return sukses('Login berhasil', {
          'token': 'token-uji',
          'user': {'id': 1, 'name': 'Reyza', 'email': body['email']},
        });

      case '/api/auth/register':
        final body = jsonDecode(request.body) as Map<String, dynamic>;
        if (emailSudahTerdaftar || body['email'] == _emailTerdaftar) {
          return gagal(409, 'Email sudah terdaftar');
        }
        return http.Response(
          jsonEncode({
            'message': 'Registrasi berhasil',
            'data': {
              'token': 'token-uji',
              'user': {
                'id': 2,
                'name': body['name'],
                'email': body['email'],
              },
            },
          }),
          201,
          headers: headers,
        );

      default:
        return gagal(404, 'Endpoint tidak dikenal');
    }
  });
}

/// Membuka halaman menu utama lewat alur splash -> login.
Future<void> _masukKeMenu(WidgetTester tester) async {
  SharedPreferences.setMockInitialValues({});
  _pasangApiFake();

  await tester.pumpWidget(const LeafboardApp());
  await tester.tap(find.text('Get Started for Free'));
  await tester.pumpAndSettle();

  await tester.enterText(find.byType(TextField).first, 'reyza@mail.com');
  await tester.enterText(find.byType(TextField).last, 'password123');
  await tester.pumpAndSettle();

  await tester.tap(find.text('Continue'));
  await tester.pumpAndSettle();
}

/// Membuka halaman register dari splash: login -> tautan "Sign up".
///
/// Tautan "Sign up" ada di bawah lipatan viewport test (800x600), jadi harus
/// digulir dulu — tanpa itu tap-nya meleset dan test tetap di halaman login.
Future<void> _bukaRegister(WidgetTester tester) async {
  SharedPreferences.setMockInitialValues({});
  await tester.pumpWidget(const LeafboardApp());
  await tester.tap(find.text('Get Started for Free'));
  await tester.pumpAndSettle();

  await tester.ensureVisible(find.text('Sign up'));
  await tester.pumpAndSettle();
  await tester.tap(find.text('Sign up'));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('splash membuka halaman login', (tester) async {
    await tester.pumpWidget(const LeafboardApp());

    expect(find.text('Leafboard'), findsOneWidget);
    expect(find.text('Get Started for Free'), findsOneWidget);

    await tester.tap(find.text('Get Started for Free'));
    await tester.pumpAndSettle();

    expect(find.text('Work without limits'), findsOneWidget);
    expect(find.text('Continue'), findsOneWidget);
  });

  testWidgets('login yang valid masuk ke menu utama', (tester) async {
    await _masukKeMenu(tester);

    expect(find.text('Morning, Sigit'), findsOneWidget);
    expect(find.text('Design Wireframe'), findsOneWidget);
  });

  testWidgets('login yang ditolak API menampilkan pesan dari server', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({});
    _pasangApiFake();

    await tester.pumpWidget(const LeafboardApp());
    await tester.tap(find.text('Get Started for Free'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField).first, 'reyza@mail.com');
    await tester.enterText(find.byType(TextField).last, 'salahsekali');
    await tester.pumpAndSettle();

    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();

    expect(find.text('Email atau password salah'), findsOneWidget);
    expect(find.text('Morning, Sigit'), findsNothing);
  });

  testWidgets('register yang valid masuk ke menu utama', (tester) async {
    _pasangApiFake();
    await _bukaRegister(tester);

    await tester.enterText(find.byType(TextField).at(0), 'Reyza');
    await tester.enterText(find.byType(TextField).at(1), 'reyza@mail.com');
    await tester.enterText(find.byType(TextField).at(2), 'password123');
    await tester.pumpAndSettle();

    await tester.tap(find.text('Create Account'));
    await tester.pumpAndSettle();

    expect(find.text('Morning, Sigit'), findsOneWidget);
  });

  testWidgets('register dengan email terdaftar menampilkan pesan dari server', (
    tester,
  ) async {
    _pasangApiFake(emailSudahTerdaftar: true);
    await _bukaRegister(tester);

    await tester.enterText(find.byType(TextField).at(0), 'Reyza');
    await tester.enterText(find.byType(TextField).at(1), 'baru@mail.com');
    await tester.enterText(find.byType(TextField).at(2), 'password123');
    await tester.pumpAndSettle();

    await tester.tap(find.text('Create Account'));
    await tester.pumpAndSettle();

    expect(find.text('Email sudah terdaftar'), findsOneWidget);
    expect(find.text('Morning, Sigit'), findsNothing);
  });

  testWidgets('tab Inbox menampilkan notifikasi', (tester) async {
    await _masukKeMenu(tester);

    await tester.tap(find.text('Inbox'));
    await tester.pumpAndSettle();

    expect(find.text('Aktifitas Login baru'), findsOneWidget);
    expect(find.text('Pencapaian Baru!'), findsOneWidget);
  });

  testWidgets('kartu tugas membuka halaman detail', (tester) async {
    await _masukKeMenu(tester);

    await tester.tap(find.text('Design Wireframe'));
    await tester.pumpAndSettle();

    expect(find.text('Sub-tasks'), findsOneWidget);

    // Tombol aksi ada di bawah daftar, jadi perlu digulir dulu.
    await tester.drag(find.byType(ListView), const Offset(0, -500));
    await tester.pumpAndSettle();

    expect(find.text('Mark as done'), findsOneWidget);
  });
}
