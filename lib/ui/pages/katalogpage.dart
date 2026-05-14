import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ucp2/data/models/katalog_model.dart';
import 'package:ucp2/logic/bloc/auth/auth_bloc.dart';
import 'package:ucp2/logic/bloc/auth/auth_event.dart';
import 'package:ucp2/logic/bloc/auth/auth_state.dart';
import 'package:ucp2/logic/bloc/katalog/katalog_bloc.dart';
import 'package:ucp2/ui/theme/app_theme.dart';
import 'package:ucp2/ui/widgets/car_card.dart';
import 'package:ucp2/ui/pages/car_page.dart';
import 'package:ucp2/ui/pages/katalog_form_page.dart';

class KatalogPage extends StatefulWidget {
  @override
  State<KatalogPage> createState() => _KatalogPageState();
}

class _KatalogPageState extends State<KatalogPage> {
  final _searchController = TextEditingController();
  final int _currentIndex = 1;
  String _searchQuery = '';
  String _selectedFilter = 'Semua';

  final List<String> _filterOptions = ['Semua', 'Tersedia', 'Tidak Tersedia', 'Perbaikan'];

  @override
  void initState() {
    super.initState();
    context.read<KatalogBloc>().add(FetchKatalog());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearch(String query) {
    setState(() => _searchQuery = query);
    context.read<KatalogBloc>().add(SearchKatalog(query: query));
  }

  void _clearSearch() {
    _searchController.clear();
    setState(() => _searchQuery = '');
    context.read<KatalogBloc>().add(SearchKatalog(query: ''));
  }

  void _navigateToForm({KatalogModel? katalog}) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: context.read<KatalogBloc>(),
          child: KatalogFormPage(katalog: katalog),
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext ctx, KatalogModel katalog) {
    showDialog(
      context: ctx,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Hapus Katalog',
          style: TextStyle(
            fontFamily: 'Mont',
            fontWeight: FontWeight.w700,
            fontSize: 16,
          ),
        ),
        content: RichText(
          text: TextSpan(
            style: const TextStyle(
              fontFamily: 'Mont',
              fontSize: 14,
              color: AppTheme.textSecondary,
              height: 1.5,
            ),
            children: [
              const TextSpan(text: 'Yakin ingin menghapus '),
              TextSpan(
                text: '${katalog.brand} ${katalog.model}',
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textPrimary,
                ),
              ),
              const TextSpan(text: '? Tindakan ini tidak dapat dibatalkan.'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text(
              'Batal',
              style: TextStyle(
                fontFamily: 'Mont',
                color: AppTheme.textSecondary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              context.read<KatalogBloc>().add(DeleteKatalog(id: katalog.id));
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.errorColor,
              foregroundColor: AppTheme.surfaceColor,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              elevation: 0,
            ),
            child: const Text(
              'Hapus',
              style: TextStyle(
                fontFamily: 'Mont',
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<KatalogModel> _applyFilter(List<KatalogModel> list) {
    if (_selectedFilter == 'Semua') return list;
    final map = {
      'Tersedia': 'tersedia',
      'Tidak Tersedia': 'tidak tersedia',
      'Perbaikan': 'perbaikan',
    };
    return list.where((k) => k.status == map[_selectedFilter]).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('Katalog Mobil'),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: AppTheme.surfaceColor,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_outlined),
            tooltip: 'Refresh',
            onPressed: () {
              _clearSearch();
              setState(() => _selectedFilter = 'Semua');
              context.read<KatalogBloc>().add(FetchKatalog());
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _navigateToForm(),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: AppTheme.surfaceColor,
        icon: const Icon(Icons.add),
        label: const Text(
          'Tambah',
          style: TextStyle(
            fontFamily: 'Mont',
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, authState) {
          if (authState is Unauthenticated) {
            Navigator.of(context).pushNamedAndRemoveUntil(
              '/login',
              (route) => false,
            );
          }
        },
        child: BlocConsumer<KatalogBloc, KatalogState>(
        listener: (context, state) {
          if (state is KatalogActionSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Row(
                  children: [
                    const Icon(Icons.check_circle, color: Colors.white, size: 18),
                    const SizedBox(width: 8),
                    Text(
                      state.message,
                      style: const TextStyle(fontFamily: 'Mont'),
                    ),
                  ],
                ),
                backgroundColor: AppTheme.successColor,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
            );
          } else if (state is KatalogError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Row(
                  children: [
                    const Icon(Icons.error_outline, color: Colors.white, size: 18),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        state.message,
                        style: const TextStyle(fontFamily: 'Mont'),
                      ),
                    ),
                  ],
                ),
                backgroundColor: AppTheme.errorColor,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
            );
          }
        },
        builder: (context, state) {
          return Column(
            children: [
              // ── Search & Filter Bar ──────────────────────────────
              Container(
                color: AppTheme.primaryColor,
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: Column(
                  children: [
                    // Search field
                    Container(
                      decoration: BoxDecoration(
                        color: AppTheme.surfaceColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: TextField(
                        controller: _searchController,
                        onChanged: _onSearch,
                        style: const TextStyle(
                          fontFamily: 'Mont',
                          fontSize: 14,
                          color: AppTheme.textPrimary,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Cari brand, model, transmisi...',
                          hintStyle: const TextStyle(
                            fontFamily: 'Mont',
                            fontSize: 14,
                            color: AppTheme.textTertiary,
                          ),
                          prefixIcon: const Icon(Icons.search, color: AppTheme.textSecondary),
                          suffixIcon: _searchQuery.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(Icons.clear, color: AppTheme.textSecondary),
                                  onPressed: _clearSearch,
                                )
                              : null,
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    // Filter chips
                    SizedBox(
                      height: 34,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: _filterOptions.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 8),
                        itemBuilder: (_, i) {
                          final opt = _filterOptions[i];
                          final selected = _selectedFilter == opt;
                          return GestureDetector(
                            onTap: () => setState(() => _selectedFilter = opt),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                              decoration: BoxDecoration(
                                color: selected
                                    ? AppTheme.secondaryColor
                                    : Colors.white.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: selected
                                      ? AppTheme.secondaryColor
                                      : Colors.white.withOpacity(0.3),
                                ),
                              ),
                              child: Text(
                                opt,
                                style: TextStyle(
                                  fontFamily: 'Mont',
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: selected
                                      ? AppTheme.primaryColor
                                      : Colors.white,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),

              // ── Body Content ─────────────────────────────────────
              Expanded(
                child: _buildBody(context, state),
              ),
            ],
          );
        },
      ), // end BlocConsumer
      ), // end BlocListener
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        selectedLabelStyle: const TextStyle(
            fontFamily: 'Mont', fontWeight: FontWeight.w700, fontSize: 11),
        unselectedLabelStyle:
            const TextStyle(fontFamily: 'Mont', fontSize: 11),
        selectedItemColor: AppTheme.primaryColor,
        onTap: (index) {
          if (index == 0) {
            Navigator.of(context).pushNamed('/home');
          } else if (index == 2) {
            Navigator.of(context).pushNamed('/kategori');
          } else if (index == 3) {
            context.read<AuthBloc>().add(LogoutRequested());
          }
        },
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: 'Beranda'),
          BottomNavigationBarItem(
              icon: Icon(Icons.car_rental_outlined),
              activeIcon: Icon(Icons.car_rental),
              label: 'Katalog'),
          BottomNavigationBarItem(
              icon: Icon(Icons.category_outlined),
              activeIcon: Icon(Icons.category),
              label: 'Kategori'),
          BottomNavigationBarItem(
              icon: Icon(Icons.logout_outlined),
              activeIcon: Icon(Icons.logout),
              label: 'Keluar'),
        ],
      ),
    );
  }

  Widget _buildBody(BuildContext context, KatalogState state) {
    if (state is KatalogLoading) {
      return const Center(
        child: CircularProgressIndicator(color: AppTheme.primaryColor),
      );
    }

    if (state is KatalogError && !(state is KatalogLoaded)) {
      return _buildError(context, state.message);
    }

    if (state is KatalogLoaded) {
      final displayed = _applyFilter(state.filteredList);

      if (displayed.isEmpty) {
        return _buildEmpty();
      }

      return RefreshIndicator(
        color: AppTheme.primaryColor,
        onRefresh: () async {
          _clearSearch();
          setState(() => _selectedFilter = 'Semua');
          context.read<KatalogBloc>().add(FetchKatalog());
        },
        child: Column(
          children: [
            // Jumlah hasil
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
              child: Row(
                children: [
                  Text(
                    '${displayed.length} kendaraan ditemukan',
                    style: const TextStyle(
                      fontFamily: 'Mont',
                      fontSize: 12,
                      color: AppTheme.textTertiary,
                    ),
                  ),
                ],
              ),
            ),
            // Grid
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.63,
                ),
                itemCount: displayed.length,
                itemBuilder: (context, index) {
                  final katalog = displayed[index];
                  return _buildKatalogCard(context, katalog);
                },
              ),
            ),
          ],
        ),
      );
    }

    return const SizedBox.shrink();
  }

  Widget _buildKatalogCard(BuildContext context, KatalogModel katalog) {
    return Stack(
      children: [
        // CarCard utama (tap → detail)
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => CarPage(katalog: katalog),
              ),
            );
          },
          child: CarCard(
            brand: katalog.brand,
            model: katalog.model,
            year: katalog.year,
            imageUrl: katalog.imageUrl,
            transmisi: katalog.transmisi,
            kapasitas: katalog.kapasitas,
            status: katalog.status,
          ),
        ),

        // Action buttons (edit & delete) — pojok kanan bawah card
        Positioned(
          bottom: 8,
          right: 8,
          child: Row(
            children: [
              // Edit
              _actionBtn(
                icon: Icons.edit_outlined,
                color: AppTheme.primaryColor,
                onTap: () => _navigateToForm(katalog: katalog),
              ),
              const SizedBox(width: 6),
              // Delete
              _actionBtn(
                icon: Icons.delete_outline,
                color: AppTheme.errorColor,
                onTap: () => _confirmDelete(context, katalog),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _actionBtn({
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          color: color.withOpacity(0.12),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Icon(icon, size: 16, color: color),
      ),
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withOpacity(0.06),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.directions_car_outlined,
              size: 40,
              color: AppTheme.textTertiary,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Tidak ada kendaraan',
            style: TextStyle(
              fontFamily: 'Mont',
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Coba ubah kata kunci atau filter',
            style: TextStyle(
              fontFamily: 'Mont',
              fontSize: 13,
              color: AppTheme.textTertiary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildError(BuildContext context, String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppTheme.errorColor.withOpacity(0.08),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.wifi_off_outlined,
                size: 40,
                color: AppTheme.errorColor,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Gagal memuat data',
              style: TextStyle(
                fontFamily: 'Mont',
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              message,
              style: const TextStyle(
                fontFamily: 'Mont',
                fontSize: 13,
                color: AppTheme.textTertiary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () => context.read<KatalogBloc>().add(FetchKatalog()),
              icon: const Icon(Icons.refresh),
              label: const Text(
                'Coba Lagi',
                style: TextStyle(fontFamily: 'Mont', fontWeight: FontWeight.w700),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
                foregroundColor: AppTheme.surfaceColor,
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}