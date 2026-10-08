import 'package:flutter/material.dart';

import '../main.dart';
import 'home.dart';

/// Tab Today: strip tanggal, daftar tugas hari terpilih, dan catatan.
class TodayPage extends StatelessWidget {
  const TodayPage({super.key});

  static const _strip = <({String day, int date, bool active})>[
    (day: 'M', date: 25, active: false),
    (day: 'T', date: 26, active: false),
    (day: 'W', date: 27, active: true),
    (day: 'T', date: 28, active: false),
    (day: 'F', date: 29, active: false),
    (day: 'S', date: 30, active: false),
  ];

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(18, 8, 18, 100),
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Today', style: serifStyle(size: 27)),
                  const SizedBox(height: 5),
                  const Text(
                    'April 27, 2026',
                    style: TextStyle(fontSize: 12, color: AppColors.muted),
                  ),
                ],
              ),
            ),
            const RoundIconButton(icon: Icons.notifications_none),
          ],
        ),
        const SizedBox(height: 20),
        SizedBox(
          height: 66,
          child: Row(
            children: [
              for (final day in _strip)
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    decoration: BoxDecoration(
                      color: day.active ? AppColors.navy : Colors.white,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          day.day,
                          style: TextStyle(
                            fontSize: 10,
                            color: day.active
                                ? Colors.white70
                                : AppColors.muted,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          '${day.date}',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color:
                                day.active ? AppColors.green : AppColors.ink,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 24),
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
        TaskCard(
          title: 'Send weekly report',
          time: '04:00 PM - 05:00 PM',
          date: 'Friday',
          tag: 'Report',
          done: true,
          onTap: () => openTaskDetail(context, 'Send weekly report'),
        ),
        const SizedBox(height: 8),
        const NoteCard(
          text: 'Fokus hari ini: selesaikan wireframe dulu, baru lanjut '
              'revisi konten.',
        ),
      ],
    );
  }
}
