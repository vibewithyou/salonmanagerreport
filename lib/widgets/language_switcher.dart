import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../core/constants/app_colors.dart';

class LanguageSwitcher extends StatelessWidget {
  const LanguageSwitcher({super.key});

  @override
  Widget build(BuildContext context) {
    final currentLocale = context.locale;

    return PopupMenuButton<Locale>(
      icon: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.language, color: AppColors.gold, size: 20),
          const SizedBox(width: 4),
          Text(
            currentLocale.languageCode.toUpperCase(),
            style: TextStyle(
              color: AppColors.gold,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
        ],
      ),
      onSelected: (Locale locale) {
        context.setLocale(locale);
      },
      itemBuilder: (BuildContext context) => [
        PopupMenuItem<Locale>(
          value: const Locale('de'),
          child: Row(
            children: [
              Text('🇩🇪', style: const TextStyle(fontSize: 20)),
              const SizedBox(width: 12),
              const Text('Deutsch'),
              if (currentLocale.languageCode == 'de') ...[
                const Spacer(),
                Icon(Icons.check, color: AppColors.gold, size: 20),
              ],
            ],
          ),
        ),
        PopupMenuItem<Locale>(
          value: const Locale('en'),
          child: Row(
            children: [
              Text('🇬🇧', style: const TextStyle(fontSize: 20)),
              const SizedBox(width: 12),
              const Text('English'),
              if (currentLocale.languageCode == 'en') ...[
                const Spacer(),
                Icon(Icons.check, color: AppColors.gold, size: 20),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
