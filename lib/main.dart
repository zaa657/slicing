import 'package:flutter/material.dart';

import 'auth/splash_screen.dart';
import 'menu/home.dart';
import 'menu/inbox.dart';
import 'menu/profile.dart';
import 'menu/today.dart';

void main() => runApp(const LeafboardApp());

/// Palet diambil langsung dari mockup PDF (sampling piksel, bukan perkiraan).
class AppColors {
  static const green = Color(0xFFA6F77B);
  static const navy = Color(0xFF0B1730);
  static const canvas = Color(0xFFF7F5F4);
  static const ink = Color(0xFF171717);
  static const muted = Color(0xFF777573);
  static const brown = Color(0xFFAD7353);
  static const purple = Color(0xFFAB9CF6);
  static const lavender = Color(0xFFEDE9FE);
  static const border = Color(0xFFEFF1F5);
  static const blueSoft = Color(0xFFE7EEFB);
  static const greenSoft = Color(0xFFE4FCEF);
}

/// Judul besar di mockup berjenis serif.
const kSerif = 'Playfair';

/// Gaya judul serif. Berkasnya font variabel, jadi bobotnya diatur lewat
/// `fontVariations` — bukan `fontWeight`, yang tidak menyentuh sumbu wght.
TextStyle serifStyle({
  required double size,
  Color color = AppColors.ink,
  double? height,
  double letterSpacing = 0,
  double weight = 600,
}) {
  return TextStyle(
    fontFamily: kSerif,
    fontSize: size,
    height: height,
    letterSpacing: letterSpacing,
    color: color,
    fontVariations: [FontVariation('wght', weight)],
  );
}

class LeafboardApp extends StatelessWidget {
  const LeafboardApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Leafboard',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: AppColors.canvas,
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.green),
      ),
      home: const SplashScreen(),
    );
  }
}

/// Shell setelah login: 4 tab menu + bottom navigation.
class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _index = 0;

  static const _pages = <Widget>[
    HomePage(),
    TodayPage(),
    InboxPage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _index == 3 ? Colors.white : AppColors.canvas,
      body: SafeArea(child: _pages[_index]),
      floatingActionButton: _index == 0 ? const AddTaskButton() : null,
      bottomNavigationBar: AppBottomNav(
        currentIndex: _index,
        onTap: (i) => setState(() => _index = i),
      ),
    );
  }
}

// --------------------------------------------------------------- shared UI

/// Tombol pill hijau: label di tengah, chevron di kanan.
class PillButton extends StatelessWidget {
  const PillButton({
    super.key,
    required this.label,
    required this.onTap,
    this.height = 46,
    this.width,
    this.fontSize = 13,
  });

  final String label;
  final VoidCallback? onTap;
  final double height;
  final double? width;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    final enabled = onTap != null;
    final fg = enabled ? AppColors.ink : AppColors.muted;
    return Material(
      color: enabled ? AppColors.green : AppColors.border,
      borderRadius: BorderRadius.circular(height / 2),
      child: InkWell(
        borderRadius: BorderRadius.circular(height / 2),
        onTap: onTap,
        child: SizedBox(
          height: height,
          width: width,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: fontSize,
                  fontWeight: FontWeight.w600,
                  color: fg,
                ),
              ),
              Positioned(
                right: 16,
                child: Icon(Icons.chevron_right, size: 17, color: fg),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Bottom navigation mengambang bergaya pill.
class AppBottomNav extends StatelessWidget {
  const AppBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;

  static const _items = <({IconData icon, String label})>[
    (icon: Icons.home_outlined, label: 'Home'),
    (icon: Icons.event_note_outlined, label: 'Today'),
    (icon: Icons.chat_bubble_outline, label: 'Inbox'),
    (icon: Icons.person_outline, label: 'Profile'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(14, 0, 14, 14),
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 7),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 18,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          for (var i = 0; i < _items.length; i++)
            Expanded(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => onTap(i),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  padding: const EdgeInsets.symmetric(vertical: 9),
                  decoration: BoxDecoration(
                    color: i == currentIndex
                        ? AppColors.lavender
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        _items[i].icon,
                        size: 19,
                        color: i == currentIndex
                            ? AppColors.navy
                            : AppColors.muted,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _items[i].label,
                        style: TextStyle(
                          fontSize: 9.5,
                          fontWeight: FontWeight.w500,
                          color: i == currentIndex
                              ? AppColors.navy
                              : AppColors.muted,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class AddTaskButton extends StatelessWidget {
  const AddTaskButton({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {},
      backgroundColor: AppColors.green,
      foregroundColor: AppColors.navy,
      elevation: 2,
      shape: const CircleBorder(),
      child: const Icon(Icons.add, size: 26),
    );
  }
}

/// Tombol ikon bulat putih.
class RoundIconButton extends StatelessWidget {
  const RoundIconButton({super.key, required this.icon});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: const BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
      ),
      child: Icon(icon, size: 19, color: AppColors.ink),
    );
  }
}

/// Kartu tugas pada daftar Home / Today.
class TaskCard extends StatelessWidget {
  const TaskCard({
    super.key,
    required this.title,
    required this.time,
    required this.date,
    required this.tag,
    this.tagColor = AppColors.blueSoft,
    this.done = false,
    this.onTap,
  });

  final String title;
  final String time;
  final String date;
  final String tag;
  final Color tagColor;
  final bool done;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: done ? AppColors.muted : AppColors.ink,
                decoration: done ? TextDecoration.lineThrough : null,
              ),
            ),
            const SizedBox(height: 9),
            Row(
              children: [
                const Icon(Icons.schedule, size: 13, color: AppColors.muted),
                const SizedBox(width: 5),
                Text(
                  time,
                  style: const TextStyle(fontSize: 11, color: AppColors.muted),
                ),
                const SizedBox(width: 10),
                Text(
                  date,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: AppColors.brown,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 11),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 5),
              decoration: BoxDecoration(
                color: tagColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                tag,
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: AppColors.navy,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Kartu catatan berlatar lavender.
class NoteCard extends StatelessWidget {
  const NoteCard({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: AppColors.lavender,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(
                Icons.sticky_note_2_outlined,
                size: 14,
                color: AppColors.navy,
              ),
              SizedBox(width: 6),
              Text(
                'Note',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: AppColors.navy,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            text,
            style: const TextStyle(
              fontSize: 12,
              height: 1.45,
              color: AppColors.navy,
            ),
          ),
        ],
      ),
    );
  }
}

/// Judul bagian dengan aksi opsional di kanan.
class SectionTitle extends StatelessWidget {
  const SectionTitle({super.key, required this.title, this.trailing});

  final String title;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: AppColors.ink,
            ),
          ),
          ?trailing,
        ],
      ),
    );
  }
}

// ------------------------------------------------------------ auth widgets

/// Logo + wordmark Leafboard di tengah halaman auth.
class AuthHeader extends StatelessWidget {
  const AuthHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset('assets/images/logo_mark.png', width: 42, height: 42),
        const SizedBox(height: 10),
        Text('Leafboard', style: serifStyle(size: 26)),
        const SizedBox(height: 6),
        const Text(
          'Work without limits',
          style: TextStyle(fontSize: 12.5, color: AppColors.muted),
        ),
      ],
    );
  }
}

/// Label + input rounded dengan border tipis.
class AppTextField extends StatelessWidget {
  const AppTextField({
    super.key,
    required this.label,
    required this.controller,
    this.hint,
    this.obscure = false,
    this.suffix,
    this.keyboardType,
  });

  final String label;
  final TextEditingController controller;
  final String? hint;
  final bool obscure;
  final Widget? suffix;
  final TextInputType? keyboardType;

  OutlineInputBorder _border() => OutlineInputBorder(
    borderRadius: BorderRadius.circular(14),
    borderSide: const BorderSide(color: AppColors.border),
  );

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppColors.ink,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          obscureText: obscure,
          keyboardType: keyboardType,
          style: const TextStyle(fontSize: 12.5),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(fontSize: 12, color: Color(0xFFB5B5B5)),
            isDense: true,
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 14,
            ),
            suffixIcon: suffix,
            enabledBorder: _border(),
            focusedBorder: _border(),
            border: _border(),
          ),
        ),
      ],
    );
  }
}

/// Tombol login sosial dengan border tipis.
class SocialButton extends StatelessWidget {
  const SocialButton({super.key, required this.icon, required this.label});

  final Widget icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 46,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(23),
        border: Border.all(color: AppColors.border),
        color: Colors.white,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          icon,
          const SizedBox(width: 9),
          Text(label, style: const TextStyle(fontSize: 12.5)),
        ],
      ),
    );
  }
}

/// Pembatas "or" di antara tombol utama dan tombol sosial.
class OrDivider extends StatelessWidget {
  const OrDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Expanded(child: Divider(color: AppColors.border)),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            'or',
            style: TextStyle(fontSize: 11, color: AppColors.muted),
          ),
        ),
        Expanded(child: Divider(color: AppColors.border)),
      ],
    );
  }
}
