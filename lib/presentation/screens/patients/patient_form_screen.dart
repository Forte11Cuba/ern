import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/l10n/generated/app_localizations.dart';
import '../../../domain/entities/patient.dart';
import '../../providers/database_providers.dart';

class PatientFormScreen extends ConsumerStatefulWidget {
  final Patient? patient;

  const PatientFormScreen({super.key, this.patient});

  @override
  ConsumerState<PatientFormScreen> createState() => _PatientFormScreenState();
}

class _PatientFormScreenState extends ConsumerState<PatientFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _codeController;
  late final TextEditingController _nameController;
  late final TextEditingController _ageController;
  late final TextEditingController _medicalRecordController;
  late final TextEditingController _notesController;
  String? _sex;
  DateTime? _birthDate;
  bool _saving = false;

  bool get _isEditing => widget.patient != null;

  @override
  void initState() {
    super.initState();
    final p = widget.patient;
    _codeController = TextEditingController(text: p?.patientCode ?? '');
    _nameController = TextEditingController(text: p?.name ?? '');
    _ageController = TextEditingController(text: p != null ? '${p.age}' : '');
    _medicalRecordController =
        TextEditingController(text: p?.medicalRecord ?? '');
    _notesController = TextEditingController(text: p?.notes ?? '');
    _sex = p?.sex;
    _birthDate = p?.birthDate;
  }

  @override
  void dispose() {
    _codeController.dispose();
    _nameController.dispose();
    _ageController.dispose();
    _medicalRecordController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? l.editPatient : l.newPatient),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _codeController,
              decoration: InputDecoration(
                labelText: '${l.patientCode} *',
                prefixIcon: const Icon(Icons.badge_outlined),
              ),
              textCapitalization: TextCapitalization.characters,
              enabled: !_isEditing,
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? l.required : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: l.patientName,
                prefixIcon: const Icon(Icons.person_outline),
              ),
              textCapitalization: TextCapitalization.words,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _ageController,
              decoration: InputDecoration(
                labelText: '${l.age} *',
                prefixIcon: const Icon(Icons.cake_outlined),
              ),
              keyboardType: TextInputType.number,
              validator: (v) {
                if (v == null || v.trim().isEmpty) return l.required;
                final age = int.tryParse(v.trim());
                if (age == null || age < 0 || age > 150) return l.invalidAge;
                return null;
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _sex,
              decoration: InputDecoration(
                labelText: l.sex,
                prefixIcon: const Icon(Icons.wc_outlined),
              ),
              items: [
                DropdownMenuItem(value: 'M', child: Text(l.male)),
                DropdownMenuItem(value: 'F', child: Text(l.female)),
              ],
              onChanged: (v) => setState(() => _sex = v),
            ),
            const SizedBox(height: 16),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.calendar_today_outlined),
              title: Text(
                _birthDate != null
                    ? '${_birthDate!.day}/${_birthDate!.month}/${_birthDate!.year}'
                    : l.birthDate,
              ),
              trailing: _birthDate != null
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () => setState(() => _birthDate = null),
                    )
                  : null,
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: _birthDate ?? DateTime(1970),
                  firstDate: DateTime(1900),
                  lastDate: DateTime.now(),
                );
                if (date != null) setState(() => _birthDate = date);
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _medicalRecordController,
              decoration: InputDecoration(
                labelText: l.medicalRecord,
                prefixIcon: const Icon(Icons.folder_outlined),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _notesController,
              decoration: InputDecoration(
                labelText: l.notes,
                prefixIcon: const Icon(Icons.note_outlined),
                alignLabelWithHint: true,
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 32),
            FilledButton.icon(
              onPressed: _saving ? null : _save,
              icon: _saving
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: Colors.white),
                    )
                  : const Icon(Icons.save),
              label: Text(_isEditing ? l.saveChanges : l.registerPatient),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _saving = true);
    final l = AppLocalizations.of(context)!;

    try {
      final repo = ref.read(patientRepositoryProvider);
      final now = DateTime.now();

      if (_isEditing) {
        final updated = widget.patient!.copyWith(
          name: _nameController.text.trim().isEmpty
              ? null
              : _nameController.text.trim(),
          age: int.parse(_ageController.text.trim()),
          sex: _sex,
          birthDate: _birthDate,
          medicalRecord: _medicalRecordController.text.trim().isEmpty
              ? null
              : _medicalRecordController.text.trim(),
          notes: _notesController.text.trim().isEmpty
              ? null
              : _notesController.text.trim(),
          updatedAt: now,
        );
        await repo.update(updated);
      } else {
        final patient = Patient(
          patientCode: _codeController.text.trim(),
          name: _nameController.text.trim().isEmpty
              ? null
              : _nameController.text.trim(),
          age: int.parse(_ageController.text.trim()),
          sex: _sex,
          birthDate: _birthDate,
          medicalRecord: _medicalRecordController.text.trim().isEmpty
              ? null
              : _medicalRecordController.text.trim(),
          notes: _notesController.text.trim().isEmpty
              ? null
              : _notesController.text.trim(),
          createdAt: now,
        );
        await repo.create(patient);
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                _isEditing ? l.patientUpdated : l.patientRegistered),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.of(context).pop(true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${l.error}: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }
}
