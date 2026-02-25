import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_dimensions.dart';

/// AppTabs - Tab navigation component
class AppTabs extends StatefulWidget {
  final List<String> tabs;
  final List<Widget> children;
  final void Function(int)? onTabChanged;
  final int initialIndex;
  final bool isScrollable;

  const AppTabs({
    Key? key,
    required this.tabs,
    required this.children,
    this.onTabChanged,
    this.initialIndex = 0,
    this.isScrollable = false,
  })  : assert(tabs.length == children.length),
        super(key: key);

  @override
  State<AppTabs> createState() => _AppTabsState();
}

class _AppTabsState extends State<AppTabs>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: widget.tabs.length,
      vsync: this,
      initialIndex: widget.initialIndex,
    );
    _tabController.addListener(() {
      widget.onTabChanged?.call(_tabController.index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: AppColors.border,
                width: 1,
              ),
            ),
          ),
          child: TabBar(
            controller: _tabController,
            isScrollable: widget.isScrollable,
            labelColor: AppColors.primary,
            unselectedLabelColor: AppColors.textSecondary,
            indicatorColor: AppColors.primary,
            indicatorWeight: 3,
            labelStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
            unselectedLabelStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
            tabs: [
              for (final tab in widget.tabs)
                Tab(text: tab),
            ],
          ),
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: widget.children,
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}

/// AppAccordion - Expandable accordion component
class AppAccordion extends StatefulWidget {
  final List<AccordionItem> items;
  final bool allowMultiple;
  final int? initiallyExpandedIndex;

  const AppAccordion({
    Key? key,
    required this.items,
    this.allowMultiple = false,
    this.initiallyExpandedIndex,
  }) : super(key: key);

  @override
  State<AppAccordion> createState() => _AppAccordionState();
}

class _AppAccordionState extends State<AppAccordion> {
  late Set<int> _expandedItems;

  @override
  void initState() {
    super.initState();
    _expandedItems = {};
    if (widget.initiallyExpandedIndex != null) {
      _expandedItems.add(widget.initiallyExpandedIndex!);
    }
  }

  void _toggleItem(int index) {
    setState(() {
      if (_expandedItems.contains(index)) {
        _expandedItems.remove(index);
      } else {
        if (!widget.allowMultiple) {
          _expandedItems.clear();
        }
        _expandedItems.add(index);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (int i = 0; i < widget.items.length; i++) ...[
          AccordionItemWidget(
            item: widget.items[i],
            isExpanded: _expandedItems.contains(i),
            onTap: () => _toggleItem(i),
          ),
          if (i < widget.items.length - 1)
            Divider(
              height: 1,
              color: AppColors.border,
            ),
        ],
      ],
    );
  }
}

class AccordionItem {
  final String title;
  final Widget content;
  final IconData? icon;
  final Widget? trailing;

  AccordionItem({
    required this.title,
    required this.content,
    this.icon,
    this.trailing,
  });
}

class AccordionItemWidget extends StatelessWidget {
  final AccordionItem item;
  final bool isExpanded;
  final VoidCallback onTap;

  const AccordionItemWidget({
    Key? key,
    required this.item,
    required this.isExpanded,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: AppColors.border,
          width: 1,
        ),
        borderRadius: AppRadius.borderMd,
      ),
      margin: EdgeInsets.symmetric(vertical: AppSpacing.xs),
      child: Column(
        children: [
          GestureDetector(
            onTap: onTap,
            child: Padding(
              padding: EdgeInsets.all(AppSpacing.lg),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        if (item.icon != null) ...[
                          Icon(item.icon, color: AppColors.primary),
                          SizedBox(width: AppSpacing.md),
                        ],
                        Expanded(
                          child: Text(
                            item.title,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: AppColors.foreground,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (item.trailing != null) item.trailing!,
                  SizedBox(width: AppSpacing.md),
                  AnimatedRotation(
                    turns: isExpanded ? 0.5 : 0,
                    duration: const Duration(milliseconds: 200),
                    child: const Icon(
                      Icons.expand_more,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (isExpanded) ...[
            Divider(
              height: 1,
              color: AppColors.border,
            ),
            Padding(
              padding: EdgeInsets.all(AppSpacing.lg),
              child: item.content,
            ),
          ],
        ],
      ),
    );
  }
}

/// AppCollapsible - Simple collapsible widget
class AppCollapsible extends StatefulWidget {
  final String title;
  final Widget content;
  final bool initiallyExpanded;
  final Widget? trailing;

  const AppCollapsible({
    Key? key,
    required this.title,
    required this.content,
    this.initiallyExpanded = false,
    this.trailing,
  }) : super(key: key);

  @override
  State<AppCollapsible> createState() => _AppCollapsibleState();
}

class _AppCollapsibleState extends State<AppCollapsible> {
  late bool _isExpanded;

  @override
  void initState() {
    super.initState();
    _isExpanded = widget.initiallyExpanded;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: AppColors.border,
          width: 1,
        ),
        borderRadius: AppRadius.borderMd,
      ),
      child: Column(
        children: [
          GestureDetector(
            onTap: () => setState(() => _isExpanded = !_isExpanded),
            child: Padding(
              padding: EdgeInsets.all(AppSpacing.lg),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      widget.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.foreground,
                      ),
                    ),
                  ),
                  if (widget.trailing != null) widget.trailing!,
                  SizedBox(width: AppSpacing.md),
                  AnimatedRotation(
                    turns: _isExpanded ? 0.5 : 0,
                    duration: const Duration(milliseconds: 200),
                    child: const Icon(
                      Icons.expand_more,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (_isExpanded) ...[
            Divider(
              height: 1,
              color: AppColors.border,
            ),
            Padding(
              padding: EdgeInsets.all(AppSpacing.lg),
              child: widget.content,
            ),
          ],
        ],
      ),
    );
  }
}
