import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ucp2/data/models/kategori_model.dart';
import 'package:ucp2/logic/bloc/auth/auth_bloc.dart';
import 'package:ucp2/logic/bloc/auth/auth_event.dart';
import 'package:ucp2/logic/bloc/kategori/kategori_bloc.dart';
import 'package:ucp2/ui/theme/app_theme.dart';

class KategoriPage extends StatefulWidget {
  @override
  State<KategoriPage> createState() => _KategoriPageState();
}

class _KategoriPageState extends State<KategoriPage> {
  final int _currentIndex = 2;

  // Daftar warna & icon yang di-assign bergiliran per kategori
  final List<Color> _cardColors = [
    const Color(0xFF6C5CE7),
    const Color(0xFF00B894),
    const Color(0xFFE17055),
    const Color(0xFF0984E3),
    const Color(0xFFE84393),
    const Color(0xFFFDAB50),
  ];

  final List<IconData> _cardIcons = [
    Icons.directions_car,
    Icons.directions_car_filled,
    Icons.airport_shuttle,
    Icons.local_taxi,
    Icons.local_shipping,
    Icons.electric_car,
  ];

  @override
  void initState() {
    super.initState();
    context.read<KategoriBloc>().add(FetchKategori());
  }

  // ── Form Dialog ──────────────────────────────────────────────────

  void _showFormDialog({KategoriModel? kategori}) {
    final namaCtrl = TextEditingController(text: kategori?.nama ?? '');
    final deskripsiCtrl = TextEditingController(text: kategori?.deskripsi ?? '');
    final formKey = GlobalKey<FormState>();
    final isEdit = kategori != null;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogCtx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        contentPadding: EdgeInsets.zero,
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header dialog
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  color: AppTheme.primaryColor,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                child: Row(
                  children: [
                    Icon(
                      isEdit ? Icons.edit_note : Icons.add_circle_outline,
                      color: AppTheme.surfaceColor,
                      size: 22,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      isEdit ? 'Edit Kategori' : 'Tambah Kategori',
                      style: const TextStyle(
                        fontFamily: 'Mont',
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.surfaceColor,
                      ),
                    ),
                  ],
                ),
              ),
              // Form body
              Padding(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Nama
                      const Text(
                        'Nama Kategori',
                        style: TextStyle(
                          fontFamily: 'Mont',
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 6),
                      TextFormField(
                        controller: namaCtrl,
                        style: const TextStyle(
                          fontFamily: 'Mont',
                          fontSize: 14,
                          color: AppTheme.textPrimary,
                        ),
                        decoration: _inputDecoration(
                          hint: 'Contoh: SUV, Sedan, Truck',
                          icon: Icons.category_outlined,
                        ),
                        validator: (v) => (v == null || v.trim().isEmpty)
                            ? 'Nama kategori wajib diisi'
                            : null,
                      ),
                      const SizedBox(height: 16),
                      // Deskripsi
                      const Text(
                        'Deskripsi (Opsional)',
                        style: TextStyle(
                          fontFamily: 'Mont',
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 6),
                      TextFormField(
                        controller: deskripsiCtrl,
                        maxLines: 3,
                        style: const TextStyle(
                          fontFamily: 'Mont',
                          fontSize: 14,
                          color: AppTheme.textPrimary,
                        ),
                        decoration: _inputDecoration(
                          hint: 'Deskripsi singkat tentang kategori ini...',
                          icon: Icons.notes_outlined,
                        ),
                      ),
                      const SizedBox(height: 24),
                      // Buttons
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () => Navigator.pop(dialogCtx),
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(
                                    color: AppTheme.borderColor),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                padding: const EdgeInsets.symmetric(
                                    vertical: 12),
                              ),
                              child: const Text(
                                'Batal',
                                style: TextStyle(
                                  fontFamily: 'Mont',
                                  fontWeight: FontWeight.w700,
                                  color: AppTheme.textSecondary,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                if (!formKey.currentState!.validate()) return;
                                final data = {
                                  'nama': namaCtrl.text.trim(),
                                  'deskripsi': deskripsiCtrl.text
                                          .trim()
                                          .isEmpty
                                      ? null
                                      : deskripsiCtrl.text.trim(),
                                };
                                if (isEdit) {
                                  context.read<KategoriBloc>().add(
                                        UpdateKategori(
                                            id: kategori.id, data: data),
                                      );
                                } else {
                                  context.read<KategoriBloc>().add(
                                        CreateKategori(data: data),
                                      );
                                }
                                Navigator.pop(dialogCtx);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppTheme.primaryColor,
                                foregroundColor: AppTheme.surfaceColor,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                padding: const EdgeInsets.symmetric(
                                    vertical: 12),
                              ),
                              child: Text(
                                isEdit ? 'Simpan' : 'Tambah',
                                style: const TextStyle(
                                  fontFamily: 'Mont',
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _confirmDelete(KategoriModel kategori) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Hapus Kategori',
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
              const TextSpan(text: 'Yakin ingin menghapus kategori '),
              TextSpan(
                text: '"${kategori.nama}"',
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textPrimary,
                ),
              ),
              const TextSpan(
                  text:
                      '? Semua data katalog dalam kategori ini mungkin terpengaruh.'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
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
              Navigator.pop(context);
              context
                  .read<KategoriBloc>()
                  .add(DeleteKategori(id: kategori.id));
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.errorColor,
              foregroundColor: AppTheme.surfaceColor,
              elevation: 0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
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

  // ── Build ─────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('Manajemen Kategori'),
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
            onPressed: () =>
                context.read<KategoriBloc>().add(FetchKategori()),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showFormDialog(),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: AppTheme.surfaceColor,
        icon: const Icon(Icons.add),
        label: const Text(
          'Tambah',
          style: TextStyle(fontFamily: 'Mont', fontWeight: FontWeight.w700),
        ),
      ),
      body: BlocConsumer<KategoriBloc, KategoriState>(
        listener: (context, state) {
          if (state is KategoriActionSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Row(
                  children: [
                    const Icon(Icons.check_circle,
                        color: Colors.white, size: 18),
                    const SizedBox(width: 8),
                    Text(
                      state.message,
                      style: const TextStyle(fontFamily: 'Mont'),
                    ),
                  ],
                ),
                backgroundColor: AppTheme.successColor,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
            );
          } else if (state is KategoriError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Row(
                  children: [
                    const Icon(Icons.error_outline,
                        color: Colors.white, size: 18),
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
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is KategoriLoading) {
            return const Center(
              child:
                  CircularProgressIndicator(color: AppTheme.primaryColor),
            );
          }

          if (state is KategoriError) {
            return _buildError(context, state.message);
          }

          if (state is KategoriLoaded) {
            if (state.kategoriList.isEmpty) {
              return _buildEmpty();
            }
            return _buildList(state.kategoriList);
          }

          return const SizedBox.shrink();
        },
      ),
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
          } else if (index == 1) {
            Navigator.of(context).pushNamed('/katalog');
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

  // ── List View ─────────────────────────────────────────────────────

  Widget _buildList(List<KategoriModel> list) {
    return RefreshIndicator(
      color: AppTheme.primaryColor,
      onRefresh: () async =>
          context.read<KategoriBloc>().add(FetchKategori()),
      child: ListView.builder(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
        itemCount: list.length,
        itemBuilder: (context, index) {
          final kategori = list[index];
          final color = _cardColors[index % _cardColors.length];
          final icon = _cardIcons[index % _cardIcons.length];
          return _buildKategoriCard(kategori, color, icon);
        },
      ),
    );
  }

  Widget _buildKategoriCard(
      KategoriModel kategori, Color color, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            // Color accent bar kiri
            Container(
              width: 6,
              decoration: BoxDecoration(
                color: color,
                borderRadius: const BorderRadius.horizontal(
                    left: Radius.circular(16)),
              ),
            ),
            // Icon
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 24),
              ),
            ),
            // Content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      kategori.nama,
                      style: const TextStyle(
                        fontFamily: 'Mont',
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    if (kategori.deskripsi != null &&
                        kategori.deskripsi!.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        kategori.deskripsi!,
                        style: const TextStyle(
                          fontFamily: 'Mont',
                          fontSize: 12,
                          color: AppTheme.textTertiary,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'ID: ${kategori.id}',
                        style: TextStyle(
                          fontFamily: 'Mont',
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: color,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Action buttons
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _actionBtn(
                    icon: Icons.edit_outlined,
                    color: AppTheme.primaryColor,
                    onTap: () => _showFormDialog(kategori: kategori),
                  ),
                  const SizedBox(height: 8),
                  _actionBtn(
                    icon: Icons.delete_outline,
                    color: AppTheme.errorColor,
                    onTap: () => _confirmDelete(kategori),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
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
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withOpacity(0.25)),
        ),
        child: Icon(icon, size: 16, color: color),
      ),
    );
  }

  // ── Empty & Error ─────────────────────────────────────────────────

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
            child: const Icon(Icons.category_outlined,
                size: 40, color: AppTheme.textTertiary),
          ),
          const SizedBox(height: 16),
          const Text(
            'Belum ada kategori',
            style: TextStyle(
              fontFamily: 'Mont',
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Tap tombol "Tambah" untuk menambah kategori baru',
            style: TextStyle(
              fontFamily: 'Mont',
              fontSize: 13,
              color: AppTheme.textTertiary,
            ),
            textAlign: TextAlign.center,
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
              child: const Icon(Icons.wifi_off_outlined,
                  size: 40, color: AppTheme.errorColor),
            ),
            const SizedBox(height: 16),
            const Text(
              'Gagal memuat kategori',
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
              onPressed: () =>
                  context.read<KategoriBloc>().add(FetchKategori()),
              icon: const Icon(Icons.refresh),
              label: const Text(
                'Coba Lagi',
                style: TextStyle(
                    fontFamily: 'Mont', fontWeight: FontWeight.w700),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
                foregroundColor: AppTheme.surfaceColor,
                elevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Helpers ───────────────────────────────────────────────────────

  InputDecoration _inputDecoration(
      {required String hint, required IconData icon}) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: Icon(icon, color: AppTheme.textSecondary, size: 20),
      hintStyle: const TextStyle(
        fontFamily: 'Mont',
        fontSize: 14,
        color: Color(0xFF9A9A9A),
      ),
      filled: true,
      fillColor: AppTheme.backgroundColor,
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppTheme.borderColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppTheme.borderColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide:
            const BorderSide(color: AppTheme.primaryColor, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppTheme.errorColor),
      ),
    );
  }
}