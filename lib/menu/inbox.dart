import 'package:flutter/material.dart';

import '../main.dart';

/// Tab Inbox: daftar notifikasi aktivitas.
class InboxPage extends StatelessWidget {
  const InboxPage({super.key});

  static const _items = <({
    IconData icon,
    Color tint,
    String title,
    String body,
    Color bodyColor,
    String time,
    bool unread,
  })>[
    (
      icon: Icons.lock_outline,
      tint: Color(0xFFA79B6A),
      title: 'Aktifitas Login baru',
      body: 'Lorem Ipsmu dolor is amet for a...',
      bodyColor: AppColors.brown,
      time: '2m',
      unread: true,
    ),
    (
      icon: Icons.alarm,
      tint: AppColors.purple,
      title: 'Pengingat Tugas',
      body: 'Design Wireframe harus selesai hari ini pukul 09:00.',
      bodyColor: AppColors.muted,
      time: '1j',
      unread: true,
    ),
    (
      icon: Icons.emoji_events_outlined,
      tint: AppColors.green,
      title: 'Pencapaian Baru!',
      body: 'Kamu menyelesaikan 5 tugas minggu ini. Pertahankan!',
      bodyColor: AppColors.muted,
      time: '1h',
      unread: false,
    ),
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
                  Text('Inbox', style: serifStyle(size: 27)),
                  const SizedBox(height: 5),
                  const Text(
                    '2 notifikasi belum dibaca',
                    style: TextStyle(fontSize: 12, color: AppColors.muted),
                  ),
                ],
              ),
            ),
            Container(
              width: 40,
              height: 40,
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child:
                  const Icon(Icons.done_all, size: 19, color: AppColors.ink),
            ),
          ],
        ),
        const SizedBox(height: 20),
        for (final item in _items)
          Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 38,
                  height: 38,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: item.tint,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(item.icon, size: 18, color: Colors.white),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              item.title,
                              style: const TextStyle(
                                fontSize: 12.5,
                                fontWeight: FontWeight.w700,
                                color: AppColors.ink,
                              ),
                            ),
                          ),
                          Text(
                            item.time,
                            style: const TextStyle(
                              fontSize: 10,
                              color: AppColors.muted,
                            ),
                          ),
                          if (item.unread) ...[
                            const SizedBox(width: 6),
                            Container(
                              width: 7,
                              height: 7,
                              decoration: const BoxDecoration(
                                color: AppColors.purple,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 5),
                      Text(
                        item.body,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 11,
                          height: 1.4,
                          fontWeight: FontWeight.w600,
                          color: item.bodyColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        const SizedBox(height: 8),
        Center(
          child: Text(
            'Tandai semua sudah dibaca',
            style: TextStyle(
              fontSize: 11.5,
              fontWeight: FontWeight.w600,
              color: AppColors.muted,
              decoration: TextDecoration.underline,
              decorationColor: AppColors.muted,
            ),
          ),
        ),
      ],
    );
  }
}
