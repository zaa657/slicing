import 'package:flutter/material.dart';

import '../main.dart';

/// Tab Profile: identitas pengguna, dokumen, dan kartu bank.
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  static const _info = <({IconData icon, String label, String value})>[
    (
      icon: Icons.call_outlined,
      label: 'Phone',
      value: '+62 812 3456 7890',
    ),
    (
      icon: Icons.mail_outline,
      label: 'Email',
      value: 'dilerragip@gmail.com',
    ),
    (
      icon: Icons.location_on_outlined,
      label: 'Address',
      value: 'Jl. Melati No. 24, Jakarta',
    ),
  ];

  static const _documents = <({IconData icon, String name})>[
    (icon: Icons.badge_outlined, name: 'KTP'),
    (icon: Icons.school_outlined, name: 'Student ID'),
    (icon: Icons.receipt_long_outlined, name: 'NPWP'),
  ];

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(18, 8, 18, 100),
      children: [
        Row(
          children: [
            Text('Profile', style: serifStyle(size: 27)),
            const Spacer(),
            const RoundIconButton(icon: Icons.settings_outlined),
          ],
        ),
        const SizedBox(height: 22),
        Center(
          child: Column(
            children: [
              Container(
                width: 96,
                height: 96,
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.purple, width: 2),
                ),
                child: ClipOval(
                  child: Image.asset(
                    'assets/images/avatar.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 14),
              Text('Sigit H.P', style: serifStyle(size: 21)),
              const SizedBox(height: 5),
              const Text(
                'Product Designer',
                style: TextStyle(fontSize: 12, color: AppColors.muted),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 4),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
          ),
          child: Column(
            children: [
              for (var i = 0; i < _info.length; i++) ...[
                if (i > 0)
                  const Divider(height: 1, color: AppColors.border),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  child: Row(
                    children: [
                      Container(
                        width: 36,
                        height: 36,
                        alignment: Alignment.center,
                        decoration: const BoxDecoration(
                          color: AppColors.canvas,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(_info[i].icon,
                            size: 17, color: AppColors.ink),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _info[i].label.toUpperCase(),
                              style: const TextStyle(
                                fontSize: 9.5,
                                letterSpacing: 0.6,
                                fontWeight: FontWeight.w600,
                                color: AppColors.muted,
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              _info[i].value,
                              style: const TextStyle(
                                fontSize: 12.5,
                                fontWeight: FontWeight.w500,
                                color: AppColors.ink,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: 24),
        const SectionTitle(title: 'My documents'),
        Row(
          children: [
            for (var i = 0; i < _documents.length; i++) ...[
              if (i > 0) const SizedBox(width: 10),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      Container(
                        width: 36,
                        height: 36,
                        alignment: Alignment.center,
                        decoration: const BoxDecoration(
                          color: AppColors.lavender,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(_documents[i].icon,
                            size: 17, color: AppColors.navy),
                      ),
                      const SizedBox(height: 9),
                      Text(
                        _documents[i].name,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: AppColors.ink,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: 24),
        const SectionTitle(title: 'Banking Documents'),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.navy,
            borderRadius: BorderRadius.circular(18),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.account_balance_outlined,
                      size: 18, color: AppColors.green),
                  const SizedBox(width: 8),
                  Text(
                    'Bank Mandiri',
                    style: serifStyle(
                      size: 15,
                      color: Colors.white,
                      weight: 500,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              const Text(
                '•••• •••• •••• 4821',
                style: TextStyle(
                  fontSize: 14,
                  letterSpacing: 2,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'SIGIT H.P',
                style: TextStyle(
                  fontSize: 9.5,
                  letterSpacing: 1.2,
                  color: Colors.white70,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        PillButton(
          label: 'Sign out',
          onTap: () => Navigator.of(context).popUntil((route) => false),
        ),
      ],
    );
  }
}
