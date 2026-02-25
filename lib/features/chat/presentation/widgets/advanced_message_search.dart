import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../domain/models/chat_thread.dart';

/// Advanced Message Search mit erweiterten Filtern
class AdvancedMessageSearch extends ConsumerStatefulWidget {
  final String conversationId;
  final Function(MessageSearchParams params) onSearch;

  const AdvancedMessageSearch({
    super.key,
    required this.conversationId,
    required this.onSearch,
  });

  @override
  ConsumerState<AdvancedMessageSearch> createState() =>
      _AdvancedMessageSearchState();
}

class MessageSearchParams {
  final String? conversationId;
  final String? query;
  final ChatMessageType? messageType;
  final String? senderId;
  final DateTime? dateFrom;
  final DateTime? dateTo;
  final List<String>? excludeSenderIds;
  final bool? hasReactions;
  final bool? isPinned;

  MessageSearchParams({
    this.conversationId,
    this.query,
    this.messageType,
    this.senderId,
    this.dateFrom,
    this.dateTo,
    this.excludeSenderIds,
    this.hasReactions,
    this.isPinned,
  });

  /// Konvertiere zu Supabase Filter String für Full-Text Search
  String toSupabaseQuery({String? conversationId}) {
    final filters = <String>[];
    final targetConversationId = conversationId ?? this.conversationId;

    if (query != null && query!.isNotEmpty) {
      filters.add('content @@ plainto_tsquery(\'$query\')');
    }

    if (messageType != null) {
      filters.add('message_type = \'${messageType!.name}\'');
    }

    if (senderId != null) {
      filters.add('sender_id = \'$senderId\'');
    }

    if (dateFrom != null) {
      filters.add('created_at >= \'${dateFrom!.toIso8601String()}\'');
    }

    if (dateTo != null) {
      filters.add('created_at <= \'${dateTo!.toIso8601String()}\'');
    }

    if (excludeSenderIds != null && excludeSenderIds!.isNotEmpty) {
      final ids = excludeSenderIds!.map((id) => '\'$id\'').join(',');
      filters.add('sender_id NOT IN ($ids)');
    }

    if (hasReactions == true) {
      filters.add('reactions IS NOT NULL AND reactions != \'{}\'');
    }

    if (isPinned == true) {
      filters.add('pinned_by IS NOT NULL');
    }

    if (targetConversationId == null || targetConversationId.isEmpty) {
      return filters.join(' AND ');
    }

    return filters.isEmpty
        ? 'conversation_id = \'$targetConversationId\''
        : '${filters.join(' AND ')} AND conversation_id = \'$targetConversationId\'';
  }

  /// Prüfe ob irgendwelche Filter aktiv sind
  bool get hasActiveFilters =>
      query?.isNotEmpty == true ||
      messageType != null ||
      senderId != null ||
      dateFrom != null ||
      dateTo != null ||
      excludeSenderIds?.isNotEmpty == true ||
      hasReactions == true ||
      isPinned == true;

  /// Kopiere mit neuen Werten
  MessageSearchParams copyWith({
    String? conversationId,
    String? query,
    ChatMessageType? messageType,
    String? senderId,
    DateTime? dateFrom,
    DateTime? dateTo,
    List<String>? excludeSenderIds,
    bool? hasReactions,
    bool? isPinned,
  }) {
    return MessageSearchParams(
      conversationId: conversationId ?? this.conversationId,
      query: query ?? this.query,
      messageType: messageType ?? this.messageType,
      senderId: senderId ?? this.senderId,
      dateFrom: dateFrom ?? this.dateFrom,
      dateTo: dateTo ?? this.dateTo,
      excludeSenderIds: excludeSenderIds ?? this.excludeSenderIds,
      hasReactions: hasReactions ?? this.hasReactions,
      isPinned: isPinned ?? this.isPinned,
    );
  }

  @override
  String toString() {
    return 'MessageSearchParams(query: $query, type: $messageType, sender: $senderId, from: $dateFrom, to: $dateTo, reactions: $hasReactions, pinned: $isPinned)';
  }
}

class _AdvancedMessageSearchState extends ConsumerState<AdvancedMessageSearch> {
  late TextEditingController _searchController;
  late MessageSearchParams _currentParams;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _currentParams = MessageSearchParams();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _performSearch() {
    final params = _currentParams.copyWith(
      query: _searchController.text.isEmpty ? null : _searchController.text,
    );
    widget.onSearch(params);
  }

  void _clearFilters() {
    setState(() {
      _searchController.clear();
      _currentParams = MessageSearchParams();
    });
    widget.onSearch(MessageSearchParams());
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Search TextField
        Padding(
          padding: const EdgeInsets.all(12),
          child: TextField(
            controller: _searchController,
            onChanged: (_) => _performSearch(),
            decoration: InputDecoration(
              hintText: 'Search messages...',
              prefixIcon: const Icon(LucideIcons.search),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(LucideIcons.x),
                      onPressed: () {
                        _searchController.clear();
                        _performSearch();
                      },
                    )
                  : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 10,
              ),
            ),
          ),
        ),

        // Filter Buttons
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                _FilterChip(
                  label: 'Message Type',
                  isActive: _currentParams.messageType != null,
                  onTap: () => _showMessageTypeFilter(),
                ),
                const SizedBox(width: 8),
                _FilterChip(
                  label: 'Date Range',
                  isActive:
                      _currentParams.dateFrom != null ||
                      _currentParams.dateTo != null,
                  onTap: () => _showDateRangeFilter(),
                ),
                const SizedBox(width: 8),
                _FilterChip(
                  label: 'Has Reactions',
                  isActive: _currentParams.hasReactions == true,
                  onTap: () {
                    setState(() {
                      _currentParams = _currentParams.copyWith(
                        hasReactions: _currentParams.hasReactions != true
                            ? true
                            : null,
                      );
                    });
                    _performSearch();
                  },
                ),
                const SizedBox(width: 8),
                _FilterChip(
                  label: 'Pinned',
                  isActive: _currentParams.isPinned == true,
                  onTap: () {
                    setState(() {
                      _currentParams = _currentParams.copyWith(
                        isPinned:
                            _currentParams.isPinned != true ? true : null,
                      );
                    });
                    _performSearch();
                  },
                ),
                if (_currentParams.hasActiveFilters) ...[
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: _clearFilters,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.red.shade100,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.red.shade300),
                      ),
                      child: Row(
                        children: [
                          const Icon(LucideIcons.x, size: 14),
                          const SizedBox(width: 6),
                          Text(
                            'Clear',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.red.shade700,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),

        // Active Filters Display
        if (_currentParams.hasActiveFilters)
          Padding(
            padding: const EdgeInsets.all(12),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                if (_searchController.text.isNotEmpty)
                  _ActiveFilterTag(
                    label:
                        'Query: "${_searchController.text}"',
                    onRemove: () {
                      _searchController.clear();
                      _performSearch();
                    },
                  ),
                if (_currentParams.messageType != null)
                  _ActiveFilterTag(
                    label: 'Type: ${_currentParams.messageType?.name}',
                    onRemove: () {
                      setState(() {
                        _currentParams =
                            _currentParams.copyWith(messageType: null);
                      });
                      _performSearch();
                    },
                  ),
                if (_currentParams.dateFrom != null ||
                    _currentParams.dateTo != null)
                  _ActiveFilterTag(
                    label:
                        'Date: ${_formatDate(_currentParams.dateFrom)} - ${_formatDate(_currentParams.dateTo)}',
                    onRemove: () {
                      setState(() {
                        _currentParams = _currentParams.copyWith(
                          dateFrom: null,
                          dateTo: null,
                        );
                      });
                      _performSearch();
                    },
                  ),
                if (_currentParams.hasReactions == true)
                  _ActiveFilterTag(
                    label: 'With Reactions 👍',
                    onRemove: () {
                      setState(() {
                        _currentParams =
                            _currentParams.copyWith(hasReactions: null);
                      });
                      _performSearch();
                    },
                  ),
                if (_currentParams.isPinned == true)
                  _ActiveFilterTag(
                    label: 'Pinned Messages',
                    onRemove: () {
                      setState(() {
                        _currentParams =
                            _currentParams.copyWith(isPinned: null);
                      });
                      _performSearch();
                    },
                  ),
              ],
            ),
          ),
      ],
    );
  }

  void _showMessageTypeFilter() {
    showModalBottomSheet(
      context: context,
      builder: (_) => _MessageTypeFilterSheet(
        selectedType: _currentParams.messageType,
        onSelect: (type) {
          Navigator.pop(context);
          setState(() {
            _currentParams = _currentParams.copyWith(messageType: type);
          });
          _performSearch();
        },
      ),
    );
  }

  void _showDateRangeFilter() {
    showModalBottomSheet(
      context: context,
      builder: (_) => _DateRangeFilterSheet(
        dateFrom: _currentParams.dateFrom,
        dateTo: _currentParams.dateTo,
        onApply: (from, to) {
          Navigator.pop(context);
          setState(() {
            _currentParams = _currentParams.copyWith(
              dateFrom: from,
              dateTo: to,
            );
          });
          _performSearch();
        },
      ),
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'Any';
    return DateFormat('MMM d, yyyy').format(date);
  }
}

/// Filter Chip Widget
class _FilterChip extends StatelessWidget {
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 6,
        ),
        decoration: BoxDecoration(
          color: isActive
              ? Theme.of(context).colorScheme.primary.withOpacity(0.2)
              : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isActive
                ? Theme.of(context).colorScheme.primary
                : Colors.grey.shade400,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: isActive
                    ? Theme.of(context).colorScheme.primary
                    : Colors.grey.shade700,
              ),
            ),
            const SizedBox(width: 6),
            Icon(
              LucideIcons.chevronDown,
              size: 12,
              color: isActive
                  ? Theme.of(context).colorScheme.primary
                  : Colors.grey.shade700,
            ),
          ],
        ),
      ),
    );
  }
}

/// Active Filter Tag zum Anzeigen und Entfernen
class _ActiveFilterTag extends StatelessWidget {
  final String label;
  final VoidCallback onRemove;

  const _ActiveFilterTag({
    required this.label,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          const SizedBox(width: 6),
          GestureDetector(
            onTap: onRemove,
            child: Icon(
              LucideIcons.x,
              size: 12,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }
}

/// Message Type Filter Bottom Sheet
class _MessageTypeFilterSheet extends StatelessWidget {
  final ChatMessageType? selectedType;
  final Function(ChatMessageType? type) onSelect;

  const _MessageTypeFilterSheet({
    required this.selectedType,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Text(
              'Filter by Message Type',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
              ),
            ),
          ),
          GestureDetector(
            onTap: () => onSelect(null),
            child: _TypeFilterOption(
              label: 'All Messages',
              isSelected: selectedType == null,
            ),
          ),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: () => onSelect(ChatMessageType.text),
            child: _TypeFilterOption(
              label: 'Text Messages',
              isSelected: selectedType == ChatMessageType.text,
            ),
          ),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: () => onSelect(ChatMessageType.image),
            child: _TypeFilterOption(
              label: 'Images',
              isSelected: selectedType == ChatMessageType.image,
            ),
          ),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: () => onSelect(ChatMessageType.video),
            child: _TypeFilterOption(
              label: 'Videos',
              isSelected: selectedType == ChatMessageType.video,
            ),
          ),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: () => onSelect(ChatMessageType.file),
            child: _TypeFilterOption(
              label: 'Documents',
              isSelected: selectedType == ChatMessageType.file,
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

/// Type Filter Option Widget
class _TypeFilterOption extends StatelessWidget {
  final String label;
  final bool isSelected;

  const _TypeFilterOption({
    required this.label,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 10,
      ),
      decoration: BoxDecoration(
        color: isSelected
            ? Theme.of(context).colorScheme.primary.withOpacity(0.1)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isSelected
              ? Theme.of(context).colorScheme.primary
              : Colors.grey.shade300,
        ),
      ),
      child: Row(
        children: [
          Icon(
            isSelected
                ? LucideIcons.checkCircle2
                : LucideIcons.circle,
            size: 20,
            color: isSelected
                ? Theme.of(context).colorScheme.primary
                : Colors.grey.shade400,
          ),
          const SizedBox(width: 12),
          Text(
            label,
            style: TextStyle(
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              color: isSelected
                  ? Theme.of(context).colorScheme.primary
                  : Colors.grey.shade700,
            ),
          ),
        ],
      ),
    );
  }
}

/// Date Range Filter Bottom Sheet
class _DateRangeFilterSheet extends StatefulWidget {
  final DateTime? dateFrom;
  final DateTime? dateTo;
  final Function(DateTime? from, DateTime? to) onApply;

  const _DateRangeFilterSheet({
    required this.dateFrom,
    required this.dateTo,
    required this.onApply,
  });

  @override
  State<_DateRangeFilterSheet> createState() => _DateRangeFilterSheetState();
}

class _DateRangeFilterSheetState extends State<_DateRangeFilterSheet> {
  late DateTime? _selectedFrom;
  late DateTime? _selectedTo;

  @override
  void initState() {
    super.initState();
    _selectedFrom = widget.dateFrom;
    _selectedTo = widget.dateTo;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Text(
              'Filter by Date Range',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
              ),
            ),
          ),
          GestureDetector(
            onTap: () => _selectDate(context, true),
            child: _DateField(
              label: 'From',
              date: _selectedFrom,
            ),
          ),
          const SizedBox(height: 12),
          GestureDetector(
            onTap: () => _selectDate(context, false),
            child: _DateField(
              label: 'To',
              date: _selectedTo,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => widget.onApply(_selectedFrom, _selectedTo),
              child: const Text('Apply'),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _selectDate(BuildContext context, bool isFrom) async {
    final date = await showDatePicker(
      context: context,
      initialDate: isFrom ? _selectedFrom ?? DateTime.now() : _selectedTo ?? DateTime.now(),
      firstDate: DateTime(2024),
      lastDate: DateTime.now(),
    );

    if (date != null) {
      setState(() {
        if (isFrom) {
          _selectedFrom = date;
        } else {
          _selectedTo = date;
        }
      });
    }
  }
}

/// Date Field Widget
class _DateField extends StatelessWidget {
  final String label;
  final DateTime? date;

  const _DateField({
    required this.label,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 12,
      ),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(
            LucideIcons.calendar,
            size: 18,
            color: Colors.grey.shade600,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
                Text(
                  date != null
                      ? DateFormat('MMM d, yyyy').format(date!)
                      : 'Not selected',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
