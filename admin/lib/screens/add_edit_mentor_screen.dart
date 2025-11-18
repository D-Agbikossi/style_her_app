import 'package:flutter/material.dart';
import '../services/admin_service.dart';
import '../main.dart';

class AddEditMentorScreen extends StatefulWidget {
  final Map<String, dynamic>? mentor;

  const AddEditMentorScreen({super.key, this.mentor});

  @override
  State<AddEditMentorScreen> createState() => _AddEditMentorScreenState();
}

class _AddEditMentorScreenState extends State<AddEditMentorScreen> {
  final _formKey = GlobalKey<FormState>();
  final _adminService = AdminService();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _specialtyController = TextEditingController();

  String _selectedStatus = 'active';
  bool _isLoading = false;
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    if (widget.mentor != null) {
      _populateForm();
    }
  }

  void _populateForm() {
    final mentor = widget.mentor!;
    _nameController.text = mentor['displayName'] ?? '';
    _emailController.text = mentor['email'] ?? '';
    _specialtyController.text = mentor['specialty'] ?? '';
    _selectedStatus = mentor['status'] ?? 'active';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _specialtyController.dispose();
    super.dispose();
  }

  Future<void> _saveMentor() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      try {
        if (widget.mentor != null) {
          // Update existing mentor
          await _adminService.updateMentor(
            widget.mentor!['id'],
            {
              'displayName': _nameController.text.trim(),
              'specialty': _specialtyController.text.trim(),
              'status': _selectedStatus,
            },
          );
        } else {
          // Create new mentor
          await _adminService.createMentor(
            email: _emailController.text.trim(),
            password: _passwordController.text.trim(),
            displayName: _nameController.text.trim(),
            specialty: _specialtyController.text.trim(),
          );
        }

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(widget.mentor != null ? 'Mentor updated!' : 'Mentor created!'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context, true);
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: ${e.toString()}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } finally {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kScaffoldBackground,
      appBar: AppBar(
        title: Text(widget.mentor != null ? 'Edit Mentor' : 'Add Mentor'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Full Name',
                  prefixIcon: const Icon(Icons.person),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
                validator: (v) => v?.isEmpty ?? true ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                enabled: widget.mentor == null,
                decoration: InputDecoration(
                  labelText: 'Email',
                  prefixIcon: const Icon(Icons.email),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (v) {
                  if (v?.isEmpty ?? true) return 'Required';
                  if (!v!.contains('@')) return 'Invalid email';
                  return null;
                },
              ),
              if (widget.mentor == null) ...[
                const SizedBox(height: 16),
                TextFormField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    prefixIcon: const Icon(Icons.lock),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword ? Icons.visibility : Icons.visibility_off,
                      ),
                      onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  validator: (v) {
                    if (v?.isEmpty ?? true) return 'Required';
                    if (v!.length < 6) return 'Min 6 characters';
                    return null;
                  },
                ),
              ],
              const SizedBox(height: 16),
              TextFormField(
                controller: _specialtyController,
                decoration: InputDecoration(
                  labelText: 'Specialty',
                  prefixIcon: const Icon(Icons.work),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
                validator: (v) => v?.isEmpty ?? true ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedStatus,
                decoration: InputDecoration(
                  labelText: 'Status',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
                items: const [
                  DropdownMenuItem(value: 'active', child: Text('Active')),
                  DropdownMenuItem(value: 'suspended', child: Text('Suspended')),
                ],
                onChanged: (v) => setState(() => _selectedStatus = v!),
              ),
              const SizedBox(height: 32),
              SizedBox(
                height: 56,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _saveMentor,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kPrimaryColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text(
                          widget.mentor != null ? 'Update Mentor' : 'Create Mentor',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

