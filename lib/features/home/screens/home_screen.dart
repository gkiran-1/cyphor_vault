import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/providers/vault_providers.dart';
import '../../../router/app_router.dart';
import '../../../shared/theme/app_palette.dart';
import '../widgets/vault_card.dart';
import '../widgets/backup_status_banner.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  DateTime? _lastBackPressTime;

  Future<void> _onBackPressed(BuildContext context) async {
    final now = DateTime.now();
    final isSecondPress = _lastBackPressTime != null &&
        now.difference(_lastBackPressTime!) < const Duration(seconds: 2);
    debugPrint('HOME_BACK_DEBUG: _onBackPressed lastPress=$_lastBackPressTime isSecondPress=$isSecondPress');

    if (isSecondPress) {
      debugPrint('HOME_BACK_DEBUG: exiting via SystemNavigator.pop()');
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

  @override
  Widget build(BuildContext context) {
    final counts = ref.watch(vaultCountsProvider);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        debugPrint('HOME_BACK_DEBUG: onPopInvokedWithResult didPop=$didPop');
        if (didPop) return;
        await _onBackPressed(context);
      },
      child: Scaffold(
        backgroundColor: context.palette.background,
        body: RefreshIndicator(
          onRefresh: () async => ref.refresh(vaultCountsProvider),
          color: context.palette.primary,
          backgroundColor: context.palette.surface,
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                backgroundColor: context.palette.background,
                pinned: true,
                expandedHeight: 110,
                elevation: 0,
                scrolledUnderElevation: 0,
                actions: [
                  IconButton(
                    icon: Icon(Icons.settings_outlined,
                        color: context.palette.textSecondary),
                    onPressed: () => context.push(AppRoutes.settings),
                  ),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  collapseMode: CollapseMode.pin,
                  titlePadding: const EdgeInsets.only(left: 20, bottom: 14),
                  title: Text(
                    'CipherBox',
                    style: TextStyle(
                      color: context.palette.textPrimary,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  background: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 56, 20, 0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color:
                                context.palette.success.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                                color: context.palette.success
                                    .withValues(alpha: 0.3)),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 6,
                                height: 6,
                                decoration: BoxDecoration(
                                  color: context.palette.success,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                'Encrypted · Offline',
                                style: TextStyle(
                                  color: context.palette.success,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SliverToBoxAdapter(child: BackupStatusBanner()),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
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
                            onTap: () => context.push(cards[i].route),
                          )
                              .animate(delay: (i * 100).ms)
                              .fadeIn(duration: 300.ms)
                              .slideY(
                                  begin: 0.15,
                                  duration: 300.ms,
                                  curve: Curves.easeOut),
                      ],
                    );
                  },
                  loading: () => SliverFillRemaining(
                    child: Center(
                      child: CircularProgressIndicator(
                          color: context.palette.primary),
                    ),
                  ),
                  error: (e, _) => SliverFillRemaining(
                    child: Center(
                      child: Text('Error loading data',
                          style: TextStyle(color: context.palette.error)),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => _showAddMenu(context),
          icon: const Icon(Icons.add),
          label: const Text('New'),
          backgroundColor: context.palette.primary,
          foregroundColor: Colors.white,
        ),
      ),
    );
  }

  void _showAddMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 36,
                height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: context.palette.border,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              _AddMenuItem(
                icon: Icons.folder_outlined,
                label: 'Add Document',
                color: context.palette.accentDocuments,
                onTap: () {
                  Navigator.pop(ctx);
                  context.push(AppRoutes.addDocument);
                },
              ),
              _AddMenuItem(
                icon: Icons.sticky_note_2_outlined,
                label: 'Add Note',
                color: context.palette.accentNotes,
                onTap: () {
                  Navigator.pop(ctx);
                  context.push(AppRoutes.addNote);
                },
              ),
              _AddMenuItem(
                icon: Icons.key_outlined,
                label: 'Add Password',
                color: context.palette.accentPasswords,
                onTap: () {
                  Navigator.pop(ctx);
                  context.push(AppRoutes.addPassword);
                },
              ),
              _AddMenuItem(
                icon: Icons.article_outlined,
                label: 'New Page',
                color: context.palette.accentPages,
                onTap: () {
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
  final Color color;
  final VoidCallback onTap;

  const _AddMenuItem({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: color, size: 18),
      ),
      title: Text(label,
          style: TextStyle(
              color: context.palette.textPrimary, fontWeight: FontWeight.w500)),
      trailing: Icon(Icons.chevron_right,
          color: context.palette.textSecondary, size: 18),
      onTap: onTap,
    );
  }
}
