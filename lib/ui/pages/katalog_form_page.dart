import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ucp2/data/models/katalog_model.dart';
import 'package:ucp2/data/models/kategori_model.dart';
import 'package:ucp2/data/repositories/kategori_repository.dart';
import 'package:ucp2/logic/bloc/katalog/katalog_bloc.dart';
import 'package:ucp2/ui/theme/app_theme.dart';

class KatalogFormPage extends StatefulWidget {
  final KatalogModel? katalog;
  const KatalogFormPage({super.key, this.katalog});

  @override
  State<KatalogFormPage> createState() => _KatalogFormPageState();
}

class _KatalogFormPageState extends State<KatalogFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _picker = ImagePicker();

  late final TextEditingController _brandCtrl;
  late final TextEditingController _modelCtrl;
  late final TextEditingController _yearCtrl;
  late final TextEditingController _kapasitasCtrl;

  String _transmisi = 'Manual';
  String _status = 'tersedia';

  // Gambar
  File? _selectedImage;
  String? _existingImageUrl; // URL gambar yang sudah ada (mode edit)

  // Kategori
  List<KategoriModel> _kategoriList = [];
  KategoriModel? _selectedKategori;
  bool _loadingKategori = true;

  bool get _isEdit => widget.katalog != null;

  final List<String> _transmisiOptions = ['Manual', 'Matic'];
  final List<String> _statusOptions = ['tersedia', 'tidak tersedia', 'perbaikan'];
  final Map<String, String> _statusLabels = {
    'tersedia': 'Tersedia',
    'tidak tersedia': 'Tidak Tersedia',
    'perbaikan': 'Dalam Perbaikan',
  };

  @override
  void initState() {
    super.initState();
    final k = widget.katalog;
    _brandCtrl = TextEditingController(text: k?.brand ?? '');
    _modelCtrl = TextEditingController(text: k?.model ?? '');
    _yearCtrl = TextEditingController(text: k?.year.toString() ?? '');
    _kapasitasCtrl = TextEditingController(text: k?.kapasitas.toString() ?? '');
    _transmisi = k?.transmisi ?? 'Manual';
    _status = k?.status ?? 'tersedia';
    _existingImageUrl = k?.imageUrl;
    _fetchKategori();
  }

  @override
  void dispose() {
    _brandCtrl.dispose();
    _modelCtrl.dispose();
    _yearCtrl.dispose();
    _kapasitasCtrl.dispose();
    super.dispose();
  }

  Future<void> _fetchKategori() async {
    try {
      final list = await KategoriRepository().getAllKategori();
      setState(() {
        _kategoriList = list;
        _loadingKategori = false;
        if (_isEdit && widget.katalog!.kategoriId != null) {
          _selectedKategori = list.where((k) => k.id == widget.katalog!.kategoriId).firstOrNull;
        }
      });
    } catch (_) {
      setState(() => _loadingKategori = false);
    }
  }

  Future<void> _pickImage() async {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40, height: 4,
              margin: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: AppTheme.borderColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Text(
                'Pilih Sumber Gambar',
                style: TextStyle(
                  fontFamily: 'Mont', fontSize: 15, fontWeight: FontWeight.w700,
                ),
              ),
            ),
            ListTile(
              leading: Container(
                width: 40, height: 40,
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.photo_library_outlined, color: AppTheme.primaryColor),
              ),
              title: const Text('Galeri', style: TextStyle(fontFamily: 'Mont', fontWeight: FontWeight.w700)),
              subtitle: const Text('Pilih dari galeri foto', style: TextStyle(fontFamily: 'Mont', fontSize: 12)),
              onTap: () async {
                Navigator.pop(context);
                final picked = await _picker.pickImage(
                  source: ImageSource.gallery,
                  imageQuality: 80,
                  maxWidth: 1200,
                );
                if (picked != null) setState(() => _selectedImage = File(picked.path));
              },
            ),
            ListTile(
              leading: Container(
                width: 40, height: 40,
                decoration: BoxDecoration(
                  color: AppTheme.secondaryColor.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.camera_alt_outlined, color: AppTheme.secondaryColor),
              ),
              title: const Text('Kamera', style: TextStyle(fontFamily: 'Mont', fontWeight: FontWeight.w700)),
              subtitle: const Text('Ambil foto baru', style: TextStyle(fontFamily: 'Mont', fontSize: 12)),
              onTap: () async {
                Navigator.pop(context);
                final picked = await _picker.pickImage(
                  source: ImageSource.camera,
                  imageQuality: 80,
                  maxWidth: 1200,
                );
                if (picked != null) setState(() => _selectedImage = File(picked.path));
              },
            ),
            if (_selectedImage != null || _existingImageUrl != null)
              ListTile(
                leading: Container(
                  width: 40, height: 40,
                  decoration: BoxDecoration(
                    color: AppTheme.errorColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.delete_outline, color: AppTheme.errorColor),
                ),
                title: const Text('Hapus Gambar', style: TextStyle(fontFamily: 'Mont', fontWeight: FontWeight.w700, color: AppTheme.errorColor)),
                onTap: () {
                  Navigator.pop(context);
                  setState(() {
                    _selectedImage = null;
                    _existingImageUrl = null;
                  });
                },
              ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedKategori == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Pilih kategori terlebih dahulu', style: TextStyle(fontFamily: 'Mont')),
        backgroundColor: AppTheme.errorColor,
        behavior: SnackBarBehavior.floating,
      ));
      return;
    }

    final data = {
      'kategori_id': _selectedKategori!.id,
      'brand': _brandCtrl.text.trim(),
      'model': _modelCtrl.text.trim(),
      'year': int.parse(_yearCtrl.text.trim()),
      'transmisi': _transmisi,
      'kapasitas': int.parse(_kapasitasCtrl.text.trim()),
      'status': _status,
      // image_url dikirim hanya jika tidak ada gambar baru dan ada URL lama
      if (_selectedImage == null && _existingImageUrl != null)
        'image_url': _existingImageUrl,
    };

    if (_isEdit) {
      context.read<KatalogBloc>().add(UpdateKatalog(
        id: widget.katalog!.id,
        data: data,
        imagePath: _selectedImage?.path,
      ));
    } else {
      context.read<KatalogBloc>().add(CreateKatalog(
        data: data,
        imagePath: _selectedImage?.path,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: Text(_isEdit ? 'Edit Katalog' : 'Tambah Katalog'),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: AppTheme.surfaceColor,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => Navigator.pop(context)),
      ),
      body: BlocListener<KatalogBloc, KatalogState>(
        listener: (context, state) {
          if (state is KatalogActionSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(state.message, style: const TextStyle(fontFamily: 'Mont')),
              backgroundColor: AppTheme.successColor,
              behavior: SnackBarBehavior.floating,
            ));
            Navigator.pop(context);
          } else if (state is KatalogError) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(state.message, style: const TextStyle(fontFamily: 'Mont')),
              backgroundColor: AppTheme.errorColor,
              behavior: SnackBarBehavior.floating,
            ));
          }
        },
        child: BlocBuilder<KatalogBloc, KatalogState>(
          builder: (context, state) {
            final isLoading = state is KatalogLoading;
            return Stack(
              children: [
                SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ── Image Picker ───────────────────────────
                        _buildSectionLabel('FOTO KENDARAAN'),
                        const SizedBox(height: 12),
                        _buildImagePicker(),
                        const SizedBox(height: 24),

                        // ── Kategori ───────────────────────────────
                        _buildSectionLabel('KATEGORI'),
                        const SizedBox(height: 12),
                        _buildKategoriDropdown(),
                        const SizedBox(height: 24),

                        // ── Info Kendaraan ─────────────────────────
                        _buildSectionLabel('INFORMASI KENDARAAN'),
                        const SizedBox(height: 12),
                        _buildTextInput(controller: _brandCtrl, label: 'Brand', hint: 'Contoh: Toyota, Honda', icon: Icons.branding_watermark_outlined, validator: (v) => (v == null || v.trim().isEmpty) ? 'Brand wajib diisi' : null),
                        const SizedBox(height: 16),
                        _buildTextInput(controller: _modelCtrl, label: 'Model', hint: 'Contoh: Avanza, Brio', icon: Icons.directions_car_outlined, validator: (v) => (v == null || v.trim().isEmpty) ? 'Model wajib diisi' : null),
                        const SizedBox(height: 16),
                        _buildTextInput(controller: _yearCtrl, label: 'Tahun', hint: 'Contoh: 2022', icon: Icons.calendar_today_outlined, keyboardType: TextInputType.number, inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                          validator: (v) {
                            if (v == null || v.trim().isEmpty) return 'Tahun wajib diisi';
                            final y = int.tryParse(v.trim());
                            if (y == null || y < 1990 || y > DateTime.now().year + 1) return 'Tahun tidak valid';
                            return null;
                          }),
                        const SizedBox(height: 16),
                        _buildTextInput(controller: _kapasitasCtrl, label: 'Kapasitas Mesin (cc)', hint: 'Contoh: 1500', icon: Icons.speed_outlined, keyboardType: TextInputType.number, inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                          validator: (v) {
                            if (v == null || v.trim().isEmpty) return 'Kapasitas wajib diisi';
                            final cc = int.tryParse(v.trim());
                            if (cc == null || cc <= 0) return 'Kapasitas tidak valid';
                            return null;
                          }),
                        const SizedBox(height: 24),

                        // ── Spesifikasi ────────────────────────────
                        _buildSectionLabel('SPESIFIKASI'),
                        const SizedBox(height: 12),
                        _buildDropdown(label: 'Transmisi', icon: Icons.settings_outlined, value: _transmisi, items: _transmisiOptions, onChanged: (v) => setState(() => _transmisi = v!)),
                        const SizedBox(height: 16),
                        _buildDropdown(label: 'Status Ketersediaan', icon: Icons.check_circle_outline, value: _status, items: _statusOptions, itemLabels: _statusLabels, onChanged: (v) => setState(() => _status = v!)),
                        const SizedBox(height: 32),

                        // ── Submit ─────────────────────────────────
                        SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: ElevatedButton.icon(
                            onPressed: isLoading ? null : _submit,
                            icon: isLoading
                                ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: AppTheme.surfaceColor))
                                : Icon(_isEdit ? Icons.save_outlined : Icons.add),
                            label: Text(
                              isLoading ? 'Memproses...' : (_isEdit ? 'Simpan Perubahan' : 'Tambah Katalog'),
                              style: const TextStyle(fontFamily: 'Mont', fontSize: 15, fontWeight: FontWeight.w700),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.primaryColor,
                              foregroundColor: AppTheme.surfaceColor,
                              elevation: 0,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                          ),
                        ),
                        const SizedBox(height: 32),
                      ],
                    ),
                  ),
                ),
                if (isLoading)
                  Container(
                    color: Colors.black.withOpacity(0.15),
                    child: const Center(child: CircularProgressIndicator(color: AppTheme.primaryColor)),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }

  // ── Image Picker Widget ──────────────────────────────────────────

  Widget _buildImagePicker() {
    final hasImage = _selectedImage != null;
    final hasExisting = _existingImageUrl != null && _existingImageUrl!.isNotEmpty;

    return GestureDetector(
      onTap: _pickImage,
      child: Container(
        width: double.infinity,
        height: 180,
        decoration: BoxDecoration(
          color: AppTheme.surfaceColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: hasImage || hasExisting ? AppTheme.primaryColor.withOpacity(0.4) : AppTheme.borderColor,
            width: hasImage || hasExisting ? 2 : 1,
            style: hasImage || hasExisting ? BorderStyle.solid : BorderStyle.solid,
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: hasImage
            ? Stack(
                fit: StackFit.expand,
                children: [
                  Image.file(_selectedImage!, fit: BoxFit.cover),
                  Positioned(
                    bottom: 0, left: 0, right: 0,
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      color: Colors.black.withOpacity(0.5),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.edit, color: Colors.white, size: 14),
                          SizedBox(width: 6),
                          Text('Ganti Gambar', style: TextStyle(fontFamily: 'Mont', fontSize: 12, color: Colors.white, fontWeight: FontWeight.w700)),
                        ],
                      ),
                    ),
                  ),
                ],
              )
            : hasExisting
                ? Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.network(_existingImageUrl!, fit: BoxFit.cover, errorBuilder: (_, __, ___) => _imagePlaceholder(isExisting: true)),
                      Positioned(
                        bottom: 0, left: 0, right: 0,
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          color: Colors.black.withOpacity(0.5),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.edit, color: Colors.white, size: 14),
                              SizedBox(width: 6),
                              Text('Ganti Gambar', style: TextStyle(fontFamily: 'Mont', fontSize: 12, color: Colors.white, fontWeight: FontWeight.w700)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  )
                : _imagePlaceholder(),
      ),
    );
  }

  Widget _imagePlaceholder({bool isExisting = false}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 56, height: 56,
          decoration: BoxDecoration(
            color: AppTheme.primaryColor.withOpacity(0.08),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.add_photo_alternate_outlined, color: AppTheme.primaryColor, size: 28),
        ),
        const SizedBox(height: 12),
        Text(
          isExisting ? 'Tap untuk ganti gambar' : 'Tap untuk pilih gambar',
          style: const TextStyle(fontFamily: 'Mont', fontSize: 13, fontWeight: FontWeight.w700, color: AppTheme.textPrimary),
        ),
        const SizedBox(height: 4),
        const Text('Galeri atau Kamera', style: TextStyle(fontFamily: 'Mont', fontSize: 11, color: AppTheme.textTertiary)),
      ],
    );
  }

  // ── Helper Widgets ───────────────────────────────────────────────

  Widget _buildSectionLabel(String label) {
    return Text(label, style: const TextStyle(fontFamily: 'Mont', fontSize: 11, fontWeight: FontWeight.w700, color: AppTheme.textTertiary, letterSpacing: 1.0));
  }

  Widget _buildKategoriDropdown() {
    if (_loadingKategori) {
      return Container(
        height: 52,
        decoration: BoxDecoration(color: AppTheme.surfaceColor, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppTheme.borderColor)),
        child: const Center(child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: AppTheme.primaryColor)),
          SizedBox(width: 10),
          Text('Memuat kategori...', style: TextStyle(fontFamily: 'Mont', fontSize: 13, color: AppTheme.textTertiary)),
        ])),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Kategori', style: TextStyle(fontFamily: 'Mont', fontSize: 13, fontWeight: FontWeight.w700, color: AppTheme.textPrimary)),
        const SizedBox(height: 6),
        Container(
          decoration: BoxDecoration(color: AppTheme.surfaceColor, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppTheme.borderColor)),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<KategoriModel>(
              value: _selectedKategori,
              isExpanded: true,
              hint: const Text('Pilih kategori', style: TextStyle(fontFamily: 'Mont', fontSize: 14, color: AppTheme.textTertiary)),
              icon: const Icon(Icons.keyboard_arrow_down, color: AppTheme.textSecondary),
              style: const TextStyle(fontFamily: 'Mont', fontSize: 14, color: AppTheme.textPrimary),
              items: _kategoriList.map((k) => DropdownMenuItem<KategoriModel>(
                value: k,
                child: Row(children: [
                  const Icon(Icons.category_outlined, color: AppTheme.textSecondary, size: 18),
                  const SizedBox(width: 10),
                  Text(k.nama),
                ]),
              )).toList(),
              onChanged: (v) => setState(() => _selectedKategori = v),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTextInput({required TextEditingController controller, required String label, required String hint, required IconData icon, TextInputType keyboardType = TextInputType.text, List<TextInputFormatter>? inputFormatters, String? Function(String?)? validator}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontFamily: 'Mont', fontSize: 13, fontWeight: FontWeight.w700, color: AppTheme.textPrimary)),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          validator: validator,
          style: const TextStyle(fontFamily: 'Mont', fontSize: 14, color: AppTheme.textPrimary),
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon, color: AppTheme.textSecondary, size: 20),
            filled: true, fillColor: AppTheme.surfaceColor,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppTheme.borderColor)),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppTheme.borderColor)),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppTheme.primaryColor, width: 2)),
            errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppTheme.errorColor)),
            hintStyle: const TextStyle(fontFamily: 'Mont', fontSize: 14, color: Color(0xFF9A9A9A)),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdown({required String label, required IconData icon, required String value, required List<String> items, Map<String, String>? itemLabels, required void Function(String?) onChanged}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontFamily: 'Mont', fontSize: 13, fontWeight: FontWeight.w700, color: AppTheme.textPrimary)),
        const SizedBox(height: 6),
        Container(
          decoration: BoxDecoration(color: AppTheme.surfaceColor, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppTheme.borderColor)),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value, isExpanded: true,
              icon: const Icon(Icons.keyboard_arrow_down, color: AppTheme.textSecondary),
              style: const TextStyle(fontFamily: 'Mont', fontSize: 14, color: AppTheme.textPrimary),
              items: items.map((item) => DropdownMenuItem<String>(
                value: item,
                child: Row(children: [Icon(icon, color: AppTheme.textSecondary, size: 18), const SizedBox(width: 10), Text(itemLabels?[item] ?? item)]),
              )).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }
}
