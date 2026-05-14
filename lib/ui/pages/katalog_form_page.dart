import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ucp2/data/models/katalog_model.dart';
import 'package:ucp2/logic/bloc/katalog/katalog_bloc.dart';
import 'package:ucp2/ui/theme/app_theme.dart';

class KatalogFormPage extends StatefulWidget {
  /// Jika null → mode Create. Jika ada isi → mode Update.
  final KatalogModel? katalog;

  const KatalogFormPage({super.key, this.katalog});

  @override
  State<KatalogFormPage> createState() => _KatalogFormPageState();
}

class _KatalogFormPageState extends State<KatalogFormPage> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _brandCtrl;
  late final TextEditingController _modelCtrl;
  late final TextEditingController _yearCtrl;
  late final TextEditingController _kapasitasCtrl;
  late final TextEditingController _imageUrlCtrl;

  String _transmisi = 'Manual';
  String _status = 'tersedia';

  bool get _isEdit => widget.katalog != null;

  final List<String> _transmisiOptions = ['Manual', 'Matic'];
  final List<String> _statusOptions = ['tersedia', 'tidak tersedia', 'perbaikan'];

  @override
  void initState() {
    super.initState();
    final k = widget.katalog;
    _brandCtrl = TextEditingController(text: k?.brand ?? '');
    _modelCtrl = TextEditingController(text: k?.model ?? '');
    _yearCtrl = TextEditingController(text: k?.year.toString() ?? '');
    _kapasitasCtrl = TextEditingController(text: k?.kapasitas.toString() ?? '');
    _imageUrlCtrl = TextEditingController(text: k?.imageUrl ?? '');
    _transmisi = k?.transmisi ?? 'Manual';
    _status = k?.status ?? 'tersedia';
  }

  @override
  void dispose() {
    _brandCtrl.dispose();
    _modelCtrl.dispose();
    _yearCtrl.dispose();
    _kapasitasCtrl.dispose();
    _imageUrlCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final data = {
      'brand': _brandCtrl.text.trim(),
      'model': _modelCtrl.text.trim(),
      'year': int.parse(_yearCtrl.text.trim()),
      'transmisi': _transmisi,
      'kapasitas': int.parse(_kapasitasCtrl.text.trim()),
      'image_url': _imageUrlCtrl.text.trim().isEmpty ? null : _imageUrlCtrl.text.trim(),
      'status': _status,
    };

    if (_isEdit) {
      context.read<KatalogBloc>().add(UpdateKatalog(id: widget.katalog!.id, data: data));
    } else {
      context.read<KatalogBloc>().add(CreateKatalog(data: data));
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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: BlocListener<KatalogBloc, KatalogState>(
        listener: (context, state) {
          if (state is KatalogActionSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppTheme.successColor,
                behavior: SnackBarBehavior.floating,
              ),
            );
            Navigator.pop(context);
          } else if (state is KatalogError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppTheme.errorColor,
                behavior: SnackBarBehavior.floating,
              ),
            );
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
                        // Header info
                        Container(
                          padding: const EdgeInsets.all(16),
                          margin: const EdgeInsets.only(bottom: 24),
                          decoration: BoxDecoration(
                            color: AppTheme.primaryColor.withOpacity(0.06),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: AppTheme.primaryColor.withOpacity(0.15),
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                _isEdit ? Icons.edit_note : Icons.add_circle_outline,
                                color: AppTheme.primaryColor,
                                size: 20,
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  _isEdit
                                      ? 'Perbarui informasi kendaraan di bawah ini.'
                                      : 'Isi semua data kendaraan untuk ditambahkan ke katalog.',
                                  style: const TextStyle(
                                    fontFamily: 'Mont',
                                    fontSize: 13,
                                    color: AppTheme.textSecondary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        _buildSectionLabel('Informasi Kendaraan'),
                        const SizedBox(height: 12),

                        // Brand
                        _buildTextInput(
                          controller: _brandCtrl,
                          label: 'Brand',
                          hint: 'Contoh: Toyota, Honda',
                          icon: Icons.branding_watermark_outlined,
                          validator: (v) {
                            if (v == null || v.trim().isEmpty) return 'Brand wajib diisi';
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),

                        // Model
                        _buildTextInput(
                          controller: _modelCtrl,
                          label: 'Model',
                          hint: 'Contoh: Avanza, Brio',
                          icon: Icons.directions_car_outlined,
                          validator: (v) {
                            if (v == null || v.trim().isEmpty) return 'Model wajib diisi';
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),

                        // Year
                        _buildTextInput(
                          controller: _yearCtrl,
                          label: 'Tahun',
                          hint: 'Contoh: 2022',
                          icon: Icons.calendar_today_outlined,
                          keyboardType: TextInputType.number,
                          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                          validator: (v) {
                            if (v == null || v.trim().isEmpty) return 'Tahun wajib diisi';
                            final year = int.tryParse(v.trim());
                            if (year == null) return 'Masukkan angka yang valid';
                            if (year < 1990 || year > DateTime.now().year + 1) {
                              return 'Tahun tidak valid';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),

                        // Kapasitas
                        _buildTextInput(
                          controller: _kapasitasCtrl,
                          label: 'Kapasitas Mesin (cc)',
                          hint: 'Contoh: 1500',
                          icon: Icons.speed_outlined,
                          keyboardType: TextInputType.number,
                          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                          validator: (v) {
                            if (v == null || v.trim().isEmpty) return 'Kapasitas wajib diisi';
                            final cc = int.tryParse(v.trim());
                            if (cc == null || cc <= 0) return 'Masukkan kapasitas yang valid';
                            return null;
                          },
                        ),
                        const SizedBox(height: 24),

                        _buildSectionLabel('Spesifikasi'),
                        const SizedBox(height: 12),

                        // Transmisi dropdown
                        _buildDropdown(
                          label: 'Transmisi',
                          icon: Icons.settings_outlined,
                          value: _transmisi,
                          items: _transmisiOptions,
                          onChanged: (v) => setState(() => _transmisi = v!),
                        ),
                        const SizedBox(height: 16),

                        // Status dropdown
                        _buildDropdown(
                          label: 'Status Ketersediaan',
                          icon: Icons.check_circle_outline,
                          value: _status,
                          items: _statusOptions,
                          itemLabels: {
                            'tersedia': 'Tersedia',
                            'tidak tersedia': 'Tidak Tersedia',
                            'perbaikan': 'Dalam Perbaikan',
                          },
                          onChanged: (v) => setState(() => _status = v!),
                        ),
                        const SizedBox(height: 24),

                        _buildSectionLabel('Media (Opsional)'),
                        const SizedBox(height: 12),

                        // Image URL
                        _buildTextInput(
                          controller: _imageUrlCtrl,
                          label: 'URL Gambar',
                          hint: 'https://contoh.com/gambar.jpg',
                          icon: Icons.image_outlined,
                          keyboardType: TextInputType.url,
                        ),
                        const SizedBox(height: 32),

                        // Submit button
                        SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: ElevatedButton.icon(
                            onPressed: isLoading ? null : _submit,
                            icon: isLoading
                                ? const SizedBox(
                                    width: 18,
                                    height: 18,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: AppTheme.surfaceColor,
                                    ),
                                  )
                                : Icon(_isEdit ? Icons.save_outlined : Icons.add),
                            label: Text(
                              isLoading
                                  ? 'Memproses...'
                                  : (_isEdit ? 'Simpan Perubahan' : 'Tambah Katalog'),
                              style: const TextStyle(
                                fontFamily: 'Mont',
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.primaryColor,
                              foregroundColor: AppTheme.surfaceColor,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),

                // Loading overlay
                if (isLoading)
                  Container(
                    color: Colors.black.withOpacity(0.15),
                    child: const Center(
                      child: CircularProgressIndicator(color: AppTheme.primaryColor),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildSectionLabel(String label) {
    return Text(
      label,
      style: const TextStyle(
        fontFamily: 'Mont',
        fontSize: 13,
        fontWeight: FontWeight.w700,
        color: AppTheme.textTertiary,
        letterSpacing: 0.8,
      ),
    );
  }

  Widget _buildTextInput({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    List<TextInputFormatter>? inputFormatters,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Mont',
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: AppTheme.textPrimary,
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          validator: validator,
          style: const TextStyle(
            fontFamily: 'Mont',
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: AppTheme.textPrimary,
          ),
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon, color: AppTheme.textSecondary, size: 20),
            filled: true,
            fillColor: AppTheme.surfaceColor,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppTheme.borderColor),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppTheme.borderColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppTheme.primaryColor, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppTheme.errorColor),
            ),
            hintStyle: const TextStyle(
              fontFamily: 'Mont',
              fontSize: 14,
              color: Color(0xFF9A9A9A),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdown({
    required String label,
    required IconData icon,
    required String value,
    required List<String> items,
    Map<String, String>? itemLabels,
    required void Function(String?) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Mont',
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: AppTheme.textPrimary,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          decoration: BoxDecoration(
            color: AppTheme.surfaceColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppTheme.borderColor),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              icon: const Icon(Icons.keyboard_arrow_down, color: AppTheme.textSecondary),
              style: const TextStyle(
                fontFamily: 'Mont',
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: AppTheme.textPrimary,
              ),
              items: items
                  .map((item) => DropdownMenuItem<String>(
                        value: item,
                        child: Row(
                          children: [
                            Icon(icon, color: AppTheme.textSecondary, size: 18),
                            const SizedBox(width: 10),
                            Text(itemLabels?[item] ?? item),
                          ],
                        ),
                      ))
                  .toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }
}
