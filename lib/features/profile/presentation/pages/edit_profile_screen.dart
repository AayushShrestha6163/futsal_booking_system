import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:futal_booking_system/core/api/api_endpoints.dart';
import 'package:futal_booking_system/core/services/storage/user_session_service.dart';
import 'package:futal_booking_system/core/utils/snackbar_utils.dart';
import 'package:futal_booking_system/features/profile/presentation/pages/profile_edit_screen.dart';
import 'package:futal_booking_system/features/profile/presentation/state/profile_state.dart';
import 'package:futal_booking_system/features/profile/presentation/view_models/profile_view_model.dart';
import 'package:futal_booking_system/features/profile/presentation/widgets/media_picker_buttom_sheet.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  // ✅ Theme Colors (change here)
  static const bg = Color(0xFFF6F7FB);
  static const card = Colors.white;
  static const border = Color(0x14000000);

  static const accent = Color(0xFF16A34A); 
  static const accent2 = Color(0xFF22C55E); 

  final _formKey = GlobalKey<FormState>();

  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();

  bool _isDataLoaded = false;

  final List<XFile?> _profile = [];
  String? _profilePicture;

  final _imagePicker = ImagePicker();

  Future<void> _loadUserData() async {
    final userSession = ref.read(userSessionServiceProvider);
    final userId = userSession.getCurrentUserId();
    if (userId != null) {
      await ref.read(profileViewModelProvider.notifier).getProfileById(userId: userId);
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadUserData());
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    super.dispose();
  }

  Future<bool> _requestPermission(Permission permission) async {
    final status = await permission.status;
    if (status.isGranted) return true;

    if (status.isDenied) {
      final result = await permission.request();
      return result.isGranted;
    }
    if (status.isPermanentlyDenied) return false;
    return false;
  }

  Future<void> _pickFromCamera() async {
    final ok = await _requestPermission(Permission.camera);
    if (!ok) return;

    final XFile? photo = await _imagePicker.pickImage(
      source: ImageSource.camera,
      imageQuality: 80,
    );

    if (photo != null) {
      setState(() {
        _profile.clear();
        _profile.add(XFile(photo.path));
      });
    }
  }

  Future<void> _pickFromGallery() async {
    final XFile? image = await _imagePicker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (image != null) {
      setState(() {
        _profile.clear();
        _profile.add(XFile(image.path));
      });
    }
  }

  void _showMediaPicker() {
    MediaPickerBottomSheet.show(
      context,
      onCameraTap: _pickFromCamera,
      onGalleryTap: _pickFromGallery,
    );
  }

  void _clearImage() {
    setState(() => _profile.clear());
  }

  Future<void> _handleSubmit() async {
    if (_formKey.currentState!.validate()) {
      await ref.read(profileViewModelProvider.notifier).updateProfile(
            firstName: _firstNameController.text.trim(),
            lastName: _lastNameController.text.trim(),
            profile: _profile.isNotEmpty ? File(_profile.first!.path) : null,
          );
    }
  }

  ImageProvider? _avatarImage() {
    if (_profile.isNotEmpty) {
      return FileImage(File(_profile.first!.path));
    }
    if (_profilePicture != null && _profilePicture!.isNotEmpty) {
      return NetworkImage('${ApiEndpoints.baseUrl}$_profilePicture');
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<ProfileState>(profileViewModelProvider, (previous, next) {
      if (next.status == ProfileStatus.loaded && !_isDataLoaded && next.user != null) {
        _isDataLoaded = true;
        _firstNameController.text = next.user!.firstName ?? '';
        _lastNameController.text = next.user!.lastName ?? '';
        _profilePicture = next.user!.profilePicture;
      } else if (next.status == ProfileStatus.updated) {
        SnackbarUtils.showSuccess(context, 'Profile updated successfully!');
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const ProfileEditScreen()),
        );
      } else if (next.status == ProfileStatus.error && next.errorMessage != null) {
        SnackbarUtils.showError(context, next.errorMessage!);
      }
    });

    final st = ref.watch(profileViewModelProvider);

    return Scaffold(
      backgroundColor: bg,
      body: st.status == ProfileStatus.loading && !_isDataLoaded
          ? const Center(child: CircularProgressIndicator())
          : CustomScrollView(
              slivers: [
                SliverAppBar(
                  pinned: true,
                  elevation: 0,
                  backgroundColor: bg,
                  leading: IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                  ),
                  expandedHeight: 210,
                  flexibleSpace: FlexibleSpaceBar(
                    background: Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [accent, Color(0xFF0EA5E9)],
                        ),
                      ),
                      child: SafeArea(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(20, 65, 20, 18),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                "Edit Profile",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              SizedBox(height: 6),
                              Text(
                                "Update your name and profile photo",
                                style: TextStyle(color: Color(0xDFFFFFFF)),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(18, 18, 18, 24),
                    child: Column(
                      children: [
                        
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            color: card,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: border),
                            boxShadow: const [
                              BoxShadow(
                                blurRadius: 18,
                                offset: Offset(0, 10),
                                color: Color(0x12000000),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              Stack(
                                alignment: Alignment.bottomRight,
                                children: [
                                  CircleAvatar(
                                    radius: 56,
                                    backgroundColor: const Color(0xFFEFF6FF),
                                    backgroundImage: _avatarImage(),
                                    child: _avatarImage() == null
                                        ? const Icon(Icons.person, size: 52, color: Colors.black54)
                                        : null,
                                  ),
                                  InkWell(
                                    onTap: _showMediaPicker,
                                    borderRadius: BorderRadius.circular(30),
                                    child: Container(
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        shape: BoxShape.circle,
                                        border: Border.all(color: const Color(0x14000000)),
                                      ),
                                      child: const Icon(Icons.camera_alt, size: 18),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  OutlinedButton.icon(
                                    onPressed: _showMediaPicker,
                                    icon: const Icon(Icons.photo_library_outlined),
                                    label: const Text("Change Photo"),
                                    style: OutlinedButton.styleFrom(
                                      foregroundColor: accent,
                                      side: BorderSide(color: accent.withOpacity(0.35)),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(14),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  if (_profile.isNotEmpty)
                                    OutlinedButton.icon(
                                      onPressed: _clearImage,
                                      icon: const Icon(Icons.close),
                                      label: const Text("Remove"),
                                      style: OutlinedButton.styleFrom(
                                        foregroundColor: Colors.red,
                                        side: BorderSide(color: Colors.red.withOpacity(0.35)),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(14),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 14),

                       
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            color: card,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: border),
                            boxShadow: const [
                              BoxShadow(
                                blurRadius: 18,
                                offset: Offset(0, 10),
                                color: Color(0x12000000),
                              ),
                            ],
                          ),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Personal Info",
                                  style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
                                ),
                                const SizedBox(height: 14),

                                _niceField(
                                  label: "First Name",
                                  controller: _firstNameController,
                                  icon: Icons.person_outline,
                                  hint: "Enter first name",
                                  validator: (v) {
                                    if (v == null || v.trim().isEmpty) return "First name is required";
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 14),
                                _niceField(
                                  label: "Last Name",
                                  controller: _lastNameController,
                                  icon: Icons.person_outline,
                                  hint: "Enter last name",
                                  validator: (v) {
                                    if (v == null || v.trim().isEmpty) return "Last name is required";
                                    return null;
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 16),

                        
                        SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: ElevatedButton(
                            onPressed: _handleSubmit,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: accent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: const Text(
                              "Save Changes",
                              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: OutlinedButton(
                            onPressed: () => Navigator.pop(context),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.black87,
                              side: const BorderSide(color: Color(0x26000000)),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: const Text(
                              "Cancel",
                              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _niceField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    required String hint,
    required String? Function(String?) validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          validator: validator,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon, color: Colors.black54),
            filled: true,
            fillColor: const Color(0xFFF3F5F9),
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }
}