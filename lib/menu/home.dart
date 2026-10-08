import 'package:flutter/material.dart';

import '../main.dart';

/// Tab Home: sapaan, pencarian, lalu daftar tugas.
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(18, 8, 18, 110),
      children: [
        const _HomeTopBar(),
        const SizedBox(height: 22),
        Center(
          child: Column(
            children: [
              Text('Morning, Ralph', style: serifStyle(size: 27)),
              const SizedBox(height: 6),
              const Text(
                'April 27, 2026',
                style: TextStyle(fontSize: 12, color: AppColors.muted),
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),
        const SearchField(),
        const SizedBox(height: 22),
        const SectionTitle(title: 'Today (3)'),
        TaskCard(
          title: 'Design Wireframe',
          time: '08:00 AM - 09:00 AM',
          date: 'Friday',
          tag: 'Work',
          onTap: () => openTaskDetail(context, 'Design Wireframe'),
        ),
        TaskCard(
          title: 'Meet with client',
          time: '10:00 AM - 11:00 AM',
          date: 'Friday',
          tag: 'Meeting',
          tagColor: AppColors.greenSoft,
          onTap: () => openTaskDetail(context, 'Meet with client'),
        ),
        const NoteCard(
          text: "April's content selection — pilih 3 topik utama sebelum "
              'meeting dengan klien besok pagi.',
        ),
        const SizedBox(height: 8),
        const SectionTitle(title: '30 Apr (1)'),
        TaskCard(
          title: 'Brainstorming session - ideas',
          time: '08:00 AM - 05:00 PM',
          date: 'Saturday',
          tag: 'Ideas',
          onTap: () => openTaskDetail(context, 'Brainstorming session - ideas'),
        ),
      ],
    );
  }
}

/// Membuka halaman detail tugas.
void openTaskDetail(BuildContext context, String title) {
  Navigator.of(context).push(
    MaterialPageRoute(builder: (_) => TaskDetailPage(title: title)),
  );
}

class _HomeTopBar extends StatelessWidget {
  const _HomeTopBar();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Avatar berinisial dengan cincin hijau tipis.
        Container(
          width: 40,
          height: 40,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.green, width: 1.5),
          ),
          child: const Text(
            'FR',
            style: TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w700,
              color: AppColors.ink,
            ),
          ),
        ),
        const Spacer(),
        // Bell dan "lainnya" menyatu dalam satu pill putih.
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Row(
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  const Icon(Icons.notifications_none,
                      size: 20, color: AppColors.ink),
                  Positioned(
                    right: -1,
                    top: -1,
                    child: Container(
                      width: 7,
                      height: 7,
                      decoration: const BoxDecoration(
                        color: Color(0xFFE5484D),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 12),
              GestureDetector(
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const CalendarPage()),
                ),
                child: const Icon(Icons.more_horiz,
                    size: 20, color: AppColors.ink),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Kolom pencarian dengan ikon di kiri.
class SearchField extends StatelessWidget {
  const SearchField({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 46,
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: Color(0xFFF2F1EF),
        borderRadius: BorderRadius.circular(23),
      ),
      child: const Row(
        children: [
          Icon(Icons.search, size: 18, color: AppColors.muted),
          SizedBox(width: 10),
          Text(
            'Search',
            style: TextStyle(fontSize: 12.5, color: AppColors.muted),
          ),
        ],
      ),
    );
  }
}

// ------------------------------------------------------------ task detail

/// Detail tugas: judul, jadwal, deskripsi, dan daftar sub-tugas.
class TaskDetailPage extends StatefulWidget {
  const TaskDetailPage({super.key, required this.title});

  final String title;

  @override
  State<TaskDetailPage> createState() => _TaskDetailPageState();
}

class _TaskDetailPageState extends State<TaskDetailPage> {
  static const _subtasks = <String>[
    'Riset referensi layout',
    'Buat wireframe halaman utama',
    'Review bersama tim desain',
  ];

  final _done = <bool>[true, false, false];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.canvas,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(18, 8, 18, 28),
          children: [
            Row(
              children: [
                GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: const RoundIconButton(icon: Icons.arrow_back),
                ),
                const Spacer(),
                const RoundIconButton(icon: Icons.more_horiz),
              ],
            ),
            const SizedBox(height: 22),
            Text(
              widget.title,
              style: serifStyle(size: 26, height: 1.25),
            ),
            const SizedBox(height: 14),
            Row(
              children: const [
                _MetaChip(icon: Icons.calendar_today_outlined, label: 'Friday'),
                SizedBox(width: 8),
                _MetaChip(icon: Icons.schedule, label: '08:00 - 09:00'),
              ],
            ),
            const SizedBox(height: 24),
            const SectionTitle(title: 'Description'),
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Text(
                'Buat wireframe halaman e-commerce: header, katalog produk, '
                'halaman detail, dan alur checkout. Gunakan grid 8pt dan '
                'sertakan state kosong untuk tiap halaman.',
                style: TextStyle(
                  fontSize: 12,
                  height: 1.6,
                  color: AppColors.ink,
                ),
              ),
            ),
            const SizedBox(height: 24),
            const SectionTitle(title: 'Sub-tasks'),
            for (var i = 0; i < _subtasks.length; i++)
              GestureDetector(
                onTap: () => setState(() => _done[i] = !_done[i]),
                behavior: HitTestBehavior.opaque,
                child: Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        _done[i]
                            ? Icons.check_circle
                            : Icons.radio_button_unchecked,
                        size: 19,
                        color: _done[i] ? AppColors.purple : AppColors.muted,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          _subtasks[i],
                          style: TextStyle(
                            fontSize: 12.5,
                            color: _done[i]
                                ? AppColors.muted
                                : AppColors.ink,
                            decoration: _done[i]
                                ? TextDecoration.lineThrough
                                : null,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            const SizedBox(height: 14),
            const NoteCard(
              text: 'Deadline mundur satu hari karena revisi brief dari klien.',
            ),
            const SizedBox(height: 10),
            PillButton(label: 'Mark as done', onTap: () {}),
          ],
        ),
      ),
    );
  }
}

class _MetaChip extends StatelessWidget {
  const _MetaChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Icon(icon, size: 13, color: AppColors.muted),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: AppColors.ink,
            ),
          ),
        ],
      ),
    );
  }
}

// --------------------------------------------------------------- calendar

/// Kalender bulanan dengan penanda tanggal yang punya agenda.
class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  /// 1 April 2026 jatuh pada hari Rabu, jadi minggu pertama kosong 2 sel.
  static const _leadingBlanks = 2;
  static const _daysInMonth = 30;
  static const _weekdays = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];

  int _selected = 27;

  @override
  Widget build(BuildContext context) {
    final cells = <int?>[
      ...List<int?>.filled(_leadingBlanks, null),
      for (var d = 1; d <= _daysInMonth; d++) d,
    ];
    while (cells.length % 7 != 0) {
      cells.add(null);
    }

    return Scaffold(
      backgroundColor: AppColors.canvas,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(18, 8, 18, 28),
          children: [
            Row(
              children: [
                GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: const RoundIconButton(icon: Icons.arrow_back),
                ),
                const Spacer(),
                const RoundIconButton(icon: Icons.more_horiz),
              ],
            ),
            const SizedBox(height: 22),
            Text('April 2026', style: serifStyle(size: 26)),
            const SizedBox(height: 18),
            Container(
              padding: const EdgeInsets.fromLTRB(10, 16, 10, 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      for (final w in _weekdays)
                        Expanded(
                          child: Center(
                            child: Text(
                              w,
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: AppColors.muted,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  for (var row = 0; row < cells.length ~/ 7; row++)
                    Row(
                      children: [
                        for (var col = 0; col < 7; col++)
                          Expanded(
                            child: _DayCell(
                              day: cells[row * 7 + col],
                              selected: cells[row * 7 + col] == _selected,
                              hasEvent: cells[row * 7 + col] == 27 ||
                                  cells[row * 7 + col] == 30,
                              onTap: () => setState(
                                () => _selected = cells[row * 7 + col] ?? 0,
                              ),
                            ),
                          ),
                      ],
                    ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            SectionTitle(title: 'Agenda · April $_selected'),
            const TaskCard(
              title: 'Design Wireframe',
              time: '08:00 AM - 09:00 AM',
              date: 'Friday',
              tag: 'Work',
            ),
            const TaskCard(
              title: 'Meet with client',
              time: '10:00 AM - 11:00 AM',
              date: 'Friday',
              tag: 'Meeting',
              tagColor: AppColors.greenSoft,
            ),
          ],
        ),
      ),
    );
  }
}

class _DayCell extends StatelessWidget {
  const _DayCell({
    required this.day,
    required this.selected,
    required this.hasEvent,
    required this.onTap,
  });

  final int? day;
  final bool selected;
  final bool hasEvent;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    if (day == null) {
      return const SizedBox(height: 42);
    }
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        height: 42,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 30,
              height: 30,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: selected ? AppColors.purple : Colors.transparent,
                shape: BoxShape.circle,
              ),
              child: Text(
                '$day',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                  color: selected ? Colors.white : AppColors.ink,
                ),
              ),
            ),
            const SizedBox(height: 3),
            Container(
              width: 5,
              height: 5,
              decoration: BoxDecoration(
                color: hasEvent && !selected
                    ? AppColors.purple
                    : Colors.transparent,
                shape: BoxShape.circle,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
