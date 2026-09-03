import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/providers/auth_providers.dart';
import '../../../core/providers/vault_providers.dart';
import '../../../router/app_router.dart';
import '../../../shared/theme/app_palette.dart';
import '../widgets/vault_card.dart';
import '../widgets/backup_status_banner.dart';
import '../widgets/recent_item_tile.dart';
import '../widgets/vault_health_card.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  DateTime? _lastBackPressTime;
  final TextEditingController _searchCtrl = TextEditingController();
  String _searchQuery = '';
  VaultItemType? _selectedCategoryFilter;

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  Future<void> _onBackPressed(BuildContext context) async {
    final now = DateTime.now();
    final isSecondPress = _lastBackPressTime != null &&
        now.difference(_lastBackPressTime!) < const Duration(seconds: 2);

    if (isSecondPress) {
      await SystemNavigator.pop();
      return;
    }

    _lastBackPressTime = now;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        const SnackBar(
          content: Text('Press back again to exit'),
          duration: Duration(seconds: 2),
        ),
      );
  }

  void _openItem(BuildContext context, VaultItemSummary item) {
    HapticFeedback.lightImpact();
    switch (item.type) {
      case VaultItemType.document:
        context.push(
          AppRoutes.documentDetail,
          extra: {
            'id': item.id,
            'type': item.documentType ?? 'other',
            'data': item.data,
          },
        );
        break;
      case VaultItemType.note:
        context.push(
          AppRoutes.noteDetail,
          extra: {'id': item.id, 'data': item.data},
        );
        break;
      case VaultItemType.password:
        context.push(
          AppRoutes.passwordDetail,
          extra: {'id': item.id, 'data': item.data},
        );
        break;
      case VaultItemType.page:
        context.push(
          AppRoutes.pageDetail,
          extra: {'id': item.id, 'data': item.data},
        );
        break;
    }
  }

  void _lockVault() {
    HapticFeedback.mediumImpact();
    ref.read(authStateProvider.notifier).lock();
  }

  @override
  Widget build(BuildContext context) {
    final counts = ref.watch(vaultCountsProvider);
    final allItemsAsync = ref.watch(allVaultItemsProvider);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        await _onBackPressed(context);
      },
      child: Scaffold(
        backgroundColor: context.palette.background,
        body: RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(vaultCountsProvider);
            ref.invalidate(allVaultItemsProvider);
            ref.invalidate(documentsProvider);
            ref.invalidate(notesProvider);
            ref.invalidate(passwordsProvider);
            ref.invalidate(pagesProvider);
          },
          color: context.palette.primary,
          backgroundColor: context.palette.surface,
          child: CustomScrollView(
            slivers: [
              // ── Header / App Bar ──────────────────────────────────────────
              SliverAppBar(
                backgroundColor: context.palette.background,
                pinned: true,
                elevation: 0,
                scrolledUnderElevation: 0,
                titleSpacing: 20,
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'CipherBox',
                      style: TextStyle(
                        color: context.palette.textPrimary,
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.6,
                      ),
                    ),
                    Text(
                      'SECURE VAULT',
                      style: TextStyle(
                        color: context.palette.textSecondary,
                        fontSize: 9.5,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.1,
                      ),
                    ),
                  ],
                ),
                actions: [
                  _HeaderActionButton(
                    icon: Icons.lock_outline_rounded,
                    tooltip: 'Lock Vault',
                    onPressed: _lockVault,
                  ),
                  const SizedBox(width: 8),
                  _HeaderActionButton(
                    icon: Icons.settings_outlined,
                    tooltip: 'Settings',
                    onPressed: () {
                      HapticFeedback.lightImpact();
                      context.push(AppRoutes.settings);
                    },
                  ),
                  const SizedBox(width: 16),
                ],
              ),

              // ── Backup Alert Banner ──────────────────────────────────────
              const SliverToBoxAdapter(child: BackupStatusBanner()),

              // ── Global Search Bar ─────────────────────────────────────────
              SliverToBoxAdapter(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Container(
                    decoration: BoxDecoration(
                      color: context.palette.surface,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: context.palette.border,
                        width: 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.02),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: _searchCtrl,
                      onChanged: (val) {
                        setState(() {
                          _searchQuery = val.trim();
                        });
                      },
                      style: TextStyle(
                        color: context.palette.textPrimary,
                        fontSize: 14.5,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Search documents, notes, passwords...',
                        hintStyle: TextStyle(
                          color: context.palette.textSecondary
                              .withValues(alpha: 0.8),
                          fontSize: 14,
                        ),
                        prefixIcon: Icon(
                          Icons.search_rounded,
                          color: context.palette.textSecondary,
                          size: 20,
                        ),
                        suffixIcon: _searchQuery.isNotEmpty
                            ? IconButton(
                                icon: Icon(
                                  Icons.close_rounded,
                                  color: context.palette.textSecondary,
                                  size: 18,
                                ),
                                onPressed: () {
                                  _searchCtrl.clear();
                                  setState(() {
                                    _searchQuery = '';
                                  });
                                },
                              )
                            : null,
                        border: InputBorder.none,
                        contentPadding:
                            const EdgeInsets.symmetric(vertical: 13),
                      ),
                    ),
                  ),
                ),
              ),

              // ── Conditional Body: Search Results OR Main Dashboard ─────────
              if (_searchQuery.isNotEmpty) ...[
                // Search filter chips & matching items
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 6, 16, 10),
                    child: _buildSearchFilterChips(context),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
                  sliver: allItemsAsync.when(
                    data: (allItems) {
                      final query = _searchQuery.toLowerCase();
                      final filtered = allItems.where((item) {
                        if (_selectedCategoryFilter != null &&
                            item.type != _selectedCategoryFilter) {
                          return false;
                        }
                        final matchTitle =
                            item.title.toLowerCase().contains(query);
                        final matchSubtitle =
                            item.subtitle.toLowerCase().contains(query);
                        final matchType = item.type.displayName
                            .toLowerCase()
                            .contains(query);
                        return matchTitle || matchSubtitle || matchType;
                      }).toList();

                      if (filtered.isEmpty) {
                        return SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 40),
                            child: Center(
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.search_off_rounded,
                                    size: 44,
                                    color: context.palette.textSecondary
                                        .withValues(alpha: 0.5),
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    'No results for "$_searchQuery"',
                                    style: TextStyle(
                                      color: context.palette.textPrimary,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Try searching with a different term',
                                    style: TextStyle(
                                      color: context.palette.textSecondary,
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }

                      return SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (ctx, i) {
                            final item = filtered[i];
                            return RecentItemTile(
                              item: item,
                              onTap: () => _openItem(context, item),
                            )
                                .animate(delay: (i * 30).ms)
                                .fadeIn(duration: 200.ms)
                                .slideY(begin: 0.05, duration: 200.ms);
                          },
                          childCount: filtered.length,
                        ),
                      );
                    },
                    loading: () => SliverToBoxAdapter(
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(32),
                          child: CircularProgressIndicator(
                              color: context.palette.primary),
                        ),
                      ),
                    ),
                    error: (e, _) => SliverToBoxAdapter(
                      child: Center(
                        child: Text('Error loading results',
                            style: TextStyle(color: context.palette.error)),
                      ),
                    ),
                  ),
                ),
              ] else ...[
                // Standard Dashboard: Categories Grid
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                  sliver: counts.when(
                    data: (c) {
                      final cards = [
                        _CardData(
                          icon: Icons.folder_outlined,
                          title: 'Documents',
                          count: c['documents'] ?? 0,
                          color: context.palette.accentDocuments,
                          route: AppRoutes.documents,
                        ),
                        _CardData(
                          icon: Icons.sticky_note_2_outlined,
                          title: 'Notes',
                          count: c['notes'] ?? 0,
                          color: context.palette.accentNotes,
                          route: AppRoutes.notes,
                        ),
                        _CardData(
                          icon: Icons.key_outlined,
                          title: 'Passwords',
                          count: c['passwords'] ?? 0,
                          color: context.palette.accentPasswords,
                          route: AppRoutes.passwords,
                        ),
                        _CardData(
                          icon: Icons.article_outlined,
                          title: 'Pages',
                          count: c['pages'] ?? 0,
                          color: context.palette.accentPages,
                          route: AppRoutes.pages,
                        ),
                      ];

                      return SliverGrid.count(
                        crossAxisCount: 2,
                        mainAxisSpacing: 12,
                        crossAxisSpacing: 12,
                        childAspectRatio: 1.05,
                        children: [
                          for (var i = 0; i < cards.length; i++)
                            VaultCard(
                              icon: cards[i].icon,
                              title: cards[i].title,
                              count: cards[i].count,
                              color: cards[i].color,
                              onTap: () {
                                HapticFeedback.lightImpact();
                                context.push(cards[i].route);
                              },
                            )
                                .animate(delay: (i * 80).ms)
                                .fadeIn(duration: 260.ms)
                                .slideY(
                                    begin: 0.1,
                                    duration: 260.ms,
                                    curve: Curves.easeOut),
                        ],
                      );
                    },
                    loading: () => SliverToBoxAdapter(
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(40),
                          child: CircularProgressIndicator(
                              color: context.palette.primary),
                        ),
                      ),
                    ),
                    error: (e, _) => SliverToBoxAdapter(
                      child: Center(
                        child: Text('Error loading categories',
                            style: TextStyle(color: context.palette.error)),
                      ),
                    ),
                  ),
                ),

                // ── Recent Activity / Quick Start Section ────────────────────
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
                  sliver: allItemsAsync.when(
                    data: (allItems) {
                      if (allItems.isEmpty) {
                        return const SliverToBoxAdapter(
                          child: VaultQuickStartCard(),
                        );
                      }

                      final recentItems = allItems.take(5).toList();

                      return SliverList(
                        delegate: SliverChildListDelegate([
                          Padding(
                            padding:
                                const EdgeInsets.only(top: 4, bottom: 12),
                            child: Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Recent Activity',
                                  style: TextStyle(
                                    color: context.palette.textPrimary,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: -0.3,
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: context.palette.surfaceLight,
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      color: context.palette.border,
                                      width: 0.8,
                                    ),
                                  ),
                                  child: Text(
                                    '${allItems.length} total',
                                    style: TextStyle(
                                      color: context.palette.textSecondary,
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          for (var i = 0; i < recentItems.length; i++)
                            RecentItemTile(
                              item: recentItems[i],
                              onTap: () => _openItem(context, recentItems[i]),
                            )
                                .animate(delay: (i * 50).ms)
                                .fadeIn(duration: 220.ms)
                                .slideX(begin: -0.02, duration: 220.ms),
                        ]),
                      );
                    },
                    loading: () => const SliverToBoxAdapter(
                      child: SizedBox.shrink(),
                    ),
                    error: (_, __) => const SliverToBoxAdapter(
                      child: SizedBox.shrink(),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => _showAddMenu(context),
          icon: const Icon(Icons.add_rounded, size: 20),
          label: const Text(
            'New',
            style: TextStyle(
                fontSize: 15, fontWeight: FontWeight.w600, letterSpacing: 0.2),
          ),
          backgroundColor: context.palette.primary,
          foregroundColor: Theme.of(context).colorScheme.onPrimary,
          elevation: 3,
        ),
      ),
    );
  }

  Widget _buildSearchFilterChips(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _FilterChip(
            label: 'All',
            isSelected: _selectedCategoryFilter == null,
            onTap: () {
              setState(() {
                _selectedCategoryFilter = null;
              });
            },
          ),
          const SizedBox(width: 8),
          _FilterChip(
            label: 'Documents',
            isSelected: _selectedCategoryFilter == VaultItemType.document,
            color: context.palette.accentDocuments,
            onTap: () {
              setState(() {
                _selectedCategoryFilter = VaultItemType.document;
              });
            },
          ),
          const SizedBox(width: 8),
          _FilterChip(
            label: 'Notes',
            isSelected: _selectedCategoryFilter == VaultItemType.note,
            color: context.palette.accentNotes,
            onTap: () {
              setState(() {
                _selectedCategoryFilter = VaultItemType.note;
              });
            },
          ),
          const SizedBox(width: 8),
          _FilterChip(
            label: 'Passwords',
            isSelected: _selectedCategoryFilter == VaultItemType.password,
            color: context.palette.accentPasswords,
            onTap: () {
              setState(() {
                _selectedCategoryFilter = VaultItemType.password;
              });
            },
          ),
          const SizedBox(width: 8),
          _FilterChip(
            label: 'Pages',
            isSelected: _selectedCategoryFilter == VaultItemType.page,
            color: context.palette.accentPages,
            onTap: () {
              setState(() {
                _selectedCategoryFilter = VaultItemType.page;
              });
            },
          ),
        ],
      ),
    );
  }

  void _showAddMenu(BuildContext context) {
    HapticFeedback.lightImpact();
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      backgroundColor: context.palette.surface,
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 14),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 38,
                height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: context.palette.border,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Add New Item',
                    style: TextStyle(
                      color: context.palette.textPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              _AddMenuItem(
                icon: Icons.folder_outlined,
                label: 'Add Document',
                subtitle: 'ID cards, PAN, Aadhaar, Passport & files',
                color: context.palette.accentDocuments,
                onTap: () {
                  HapticFeedback.selectionClick();
                  Navigator.pop(ctx);
                  context.push(AppRoutes.addDocument);
                },
              ),
              _AddMenuItem(
                icon: Icons.sticky_note_2_outlined,
                label: 'Add Note',
                subtitle: 'Secure notes, memos & confidential links',
                color: context.palette.accentNotes,
                onTap: () {
                  HapticFeedback.selectionClick();
                  Navigator.pop(ctx);
                  context.push(AppRoutes.addNote);
                },
              ),
              _AddMenuItem(
                icon: Icons.key_outlined,
                label: 'Add Password',
                subtitle: 'Logins, Wi-Fi keys, PINs & credit cards',
                color: context.palette.accentPasswords,
                onTap: () {
                  HapticFeedback.selectionClick();
                  Navigator.pop(ctx);
                  context.push(AppRoutes.addPassword);
                },
              ),
              _AddMenuItem(
                icon: Icons.article_outlined,
                label: 'New Page',
                subtitle: 'Rich text docs, markdown & formatted pages',
                color: context.palette.accentPages,
                onTap: () {
                  HapticFeedback.selectionClick();
                  Navigator.pop(ctx);
                  context.push(AppRoutes.addPage);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HeaderActionButton extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final VoidCallback onPressed;

  const _HeaderActionButton({
    required this.icon,
    required this.tooltip,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Tooltip(
        message: tooltip,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(10),
          child: Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: context.palette.surface,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: context.palette.border,
                width: 1,
              ),
            ),
            child: Icon(
              icon,
              color: context.palette.textPrimary,
              size: 19,
            ),
          ),
        ),
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final Color? color;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.isSelected,
    this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final activeColor = color ?? context.palette.primary;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected
              ? activeColor.withValues(alpha: 0.15)
              : context.palette.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? activeColor : context.palette.border,
            width: 1,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? activeColor : context.palette.textSecondary,
            fontSize: 12.5,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

class _CardData {
  final IconData icon;
  final String title;
  final int count;
  final Color color;
  final String route;

  const _CardData({
    required this.icon,
    required this.title,
    required this.count,
    required this.color,
    required this.route,
  });
}

class _AddMenuItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const _AddMenuItem({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 2),
      leading: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.14),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: color.withValues(alpha: 0.22),
            width: 1,
          ),
        ),
        child: Icon(icon, color: color, size: 21),
      ),
      title: Text(
        label,
        style: TextStyle(
          color: context.palette.textPrimary,
          fontWeight: FontWeight.w600,
          fontSize: 15,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          color: context.palette.textSecondary,
          fontSize: 12,
        ),
      ),
      trailing: Icon(
        Icons.chevron_right_rounded,
        color: context.palette.textSecondary.withValues(alpha: 0.5),
        size: 20,
      ),
      onTap: onTap,
    );
  }
}
