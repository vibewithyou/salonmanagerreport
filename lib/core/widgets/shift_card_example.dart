import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../theme/shift_card_tokens.dart';

/// BEISPIEL: ShiftCard Widget mit Design Tokens
/// Zeigt How-To für die Verwendung der neu erstellten Tokens
///
/// Verwendung:
/// ```dart
/// ShiftCardExample(
///   startTime: '09:00',
///   endTime: '17:00',
///   breakTime: '30 min',
///   status: 'active',
/// )
/// ```

class ShiftCardExample extends StatelessWidget {
  final String startTime;
  final String endTime;
  final String breakTime;
  final String status; // 'active', 'paused', 'completed', 'cancelled'

  const ShiftCardExample({
    required this.startTime,
    required this.endTime,
    required this.breakTime,
    required this.status,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Card(
      color: isDark
          ? ShiftCardTokens.containerBackgroundDark
          : ShiftCardTokens.containerBackgroundLight,
      elevation: ShiftCardTokens.containerElevation,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(ShiftCardTokens.containerBorderRadius),
        side: BorderSide(
          color: isDark
              ? ShiftCardTokens.containerBorderDark
              : ShiftCardTokens.containerBorderLight,
          width: ShiftCardTokens.containerBorderWidth,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(ShiftCardTokens.paddingLg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Row: Title + Status
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Heute',
                  style: TextStyle(
                    color: isDark
                        ? ShiftCardTokens.headerTextColorDark
                        : ShiftCardTokens.headerTextColor,
                    fontSize: ShiftCardTokens.headerFontSize,
                    fontWeight: ShiftCardTokens.headerFontWeight,
                  ),
                ),
                _buildStatusBadge(isDark),
              ],
            ),
            SizedBox(height: ShiftCardTokens.columnSpacing),

            // Main Time Display
            Row(
              children: [
                Icon(
                  LucideIcons.clock,
                  size: ShiftCardTokens.iconSize,
                  color: ShiftCardTokens.iconColor,
                ),
                SizedBox(width: ShiftCardTokens.paddingMd),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '$startTime - $endTime',
                        style: TextStyle(
                          color: ShiftCardTokens.timeDisplayColor,
                          fontSize: ShiftCardTokens.timeDisplayFontSize,
                          fontWeight: ShiftCardTokens.timeDisplayFontWeight,
                        ),
                      ),
                      SizedBox(height: ShiftCardTokens.timeBlockSpacing),
                      Text(
                        '8 Stunden',
                        style: TextStyle(
                          color: isDark
                              ? ShiftCardTokens.durationTextColorDark
                              : ShiftCardTokens.durationTextColor,
                          fontSize: ShiftCardTokens.durationFontSize,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: ShiftCardTokens.columnSpacing),

            // Divider
            Divider(
              color: isDark
                  ? ShiftCardTokens.dividerColorDark
                  : ShiftCardTokens.dividerColor,
              thickness: ShiftCardTokens.dividerHeight,
              height: ShiftCardTokens.rowSpacing,
            ),
            SizedBox(height: ShiftCardTokens.paddingMd),

            // Info Rows
            _buildInfoRow(
              isDark,
              'Start',
              startTime,
              LucideIcons.playCircle,
            ),
            SizedBox(height: ShiftCardTokens.timeBlockSpacing),

            _buildInfoRow(
              isDark,
              'Ende',
              endTime,
              LucideIcons.pauseCircle,
            ),
            SizedBox(height: ShiftCardTokens.timeBlockSpacing),

            _buildInfoRow(
              isDark,
              'Pause',
              breakTime,
              LucideIcons.coffee,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(
    bool isDark,
    String label,
    String value,
    IconData icon,
  ) {
    return Row(
      children: [
        Icon(
          icon,
          size: ShiftCardTokens.iconSize,
          color: ShiftCardTokens.iconColor,
        ),
        SizedBox(width: ShiftCardTokens.paddingMd),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: isDark
                      ? ShiftCardTokens.infoLabelColorDark
                      : ShiftCardTokens.infoLabelColor,
                  fontSize: ShiftCardTokens.infoLabelFontSize,
                  fontWeight: ShiftCardTokens.infoLabelFontWeight,
                ),
              ),
              SizedBox(height: ShiftCardTokens.paddingSmall),
              Text(
                value,
                style: TextStyle(
                  color: isDark
                      ? ShiftCardTokens.infoValueColorDark
                      : ShiftCardTokens.infoValueColor,
                  fontSize: ShiftCardTokens.infoValueFontSize,
                  fontWeight: ShiftCardTokens.infoValueFontWeight,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatusBadge(bool isDark) {
    late Color bgColor;
    late Color fgColor;
    late String statusText;

    switch (status) {
      case 'active':
        bgColor = ShiftCardTokens.statusActiveBackground;
        fgColor = ShiftCardTokens.statusActiveForeground;
        statusText = 'Aktiv';
        break;
      case 'paused':
        bgColor = ShiftCardTokens.statusPausedBackground;
        fgColor = ShiftCardTokens.statusPausedForeground;
        statusText = 'Pause';
        break;
      case 'completed':
        bgColor = ShiftCardTokens.statusCompletedBackground;
        fgColor = ShiftCardTokens.statusCompletedForeground;
        statusText = 'Fertig';
        break;
      case 'cancelled':
        bgColor = ShiftCardTokens.statusCancelledBackground;
        fgColor = ShiftCardTokens.statusCancelledForeground;
        statusText = 'Abgesagt';
        break;
      default:
        bgColor = ShiftCardTokens.statusActiveBackground;
        fgColor = ShiftCardTokens.statusActiveForeground;
        statusText = status;
    }

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: ShiftCardTokens.statusBadgePaddingX,
        vertical: ShiftCardTokens.statusBadgePaddingY,
      ),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(
          ShiftCardTokens.statusBadgeBorderRadius,
        ),
      ),
      child: Text(
        statusText,
        style: TextStyle(
          color: fgColor,
          fontSize: ShiftCardTokens.statusFontSize,
          fontWeight: ShiftCardTokens.statusFontWeight,
        ),
      ),
    );
  }
}

// ============================================================================
// EXAMPLE USAGE
// ============================================================================

class ShiftCardExampleScreen extends StatelessWidget {
  const ShiftCardExampleScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ShiftCard Examples'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Example 1: Active Shift
            Text(
              'Active Shift',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 12),
            ShiftCardExample(
              startTime: '09:00',
              endTime: '17:00',
              breakTime: '30 min',
              status: 'active',
            ),
            const SizedBox(height: 24),

            // Example 2: Paused Shift
            Text(
              'Paused Shift',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 12),
            ShiftCardExample(
              startTime: '09:00',
              endTime: '17:00',
              breakTime: '15 min',
              status: 'paused',
            ),
            const SizedBox(height: 24),

            // Example 3: Completed Shift
            Text(
              'Completed Shift',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 12),
            ShiftCardExample(
              startTime: '08:00',
              endTime: '16:00',
              breakTime: '30 min',
              status: 'completed',
            ),
            const SizedBox(height: 24),

            // Example 4: Cancelled Shift
            Text(
              'Cancelled Shift',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 12),
            ShiftCardExample(
              startTime: '14:00',
              endTime: '20:00',
              breakTime: '30 min',
              status: 'cancelled',
            ),
          ],
        ),
      ),
    );
  }
}
