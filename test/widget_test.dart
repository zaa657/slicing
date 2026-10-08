import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:slicing/main.dart';

/// Membuka halaman menu utama lewat alur splash -> login.
Future<void> _masukKeMenu(WidgetTester tester) async {
  await tester.pumpWidget(const LeafboardApp());
  await tester.tap(find.text('Get Started for Free'));
  await tester.pumpAndSettle();

  await tester.enterText(find.byType(TextField).first, 'reyza@mail.com');
  await tester.enterText(find.byType(TextField).last, 'password123');
  await tester.pumpAndSettle();

  await tester.tap(find.text('Continue'));
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

    expect(find.text('Morning, Ralph'), findsOneWidget);
    expect(find.text('Design Wireframe'), findsOneWidget);
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
