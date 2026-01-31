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
  final primaryOrange = const Color(0xFFE64A19);
  final lightYellow = const Color(0xFFFFF9C4);
  final buttonOrange = const Color(0xFFFFB74D);
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
      await ref
          .read(profileViewModelProvider.notifier)
          .getProfileById(userId: userId);
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadUserData();
    });
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

    if (status.isPermanentlyDenied) {
      // _showPermissionDeniedDialog();
      return false;
    }

    return false;
  }

  Future<void> _pickFromCamera() async {
    final hasPermission = await _requestPermission(Permission.camera);
    if (!hasPermission) return;

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
    try {
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
    } catch (e) {
      debugPrint('Image picker error: $e');
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
    setState(() {
      _profile.clear();
    });
  }

  void _handleSubmit() async {
    if (_formKey.currentState!.validate()) {
      // Process data
      await ref
          .read(profileViewModelProvider.notifier)
          .updateProfile(
            firstName: _firstNameController.text.trim(),
            lastName: _lastNameController.text.trim(),

            profile: _profile.isNotEmpty ? File(_profile.first!.path) : null,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<ProfileState>(profileViewModelProvider, (previous, next) {
      if (next.status == ProfileStatus.loaded &&
          !_isDataLoaded &&
          next.user != null) {
        _isDataLoaded = true;
        _firstNameController.text = next.user!.firstName ?? '';
        _lastNameController.text = next.user!.lastName ?? '';
        _profilePicture = next.user!.profilePicture;
        print("profile picture ${next.user!.profilePicture}");
      } else if (next.status == ProfileStatus.updated) {
        SnackbarUtils.showSuccess(context, 'Profile updated successfully!');
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const ProfileEditScreen()),
        );
      } else if (next.status == ProfileStatus.error &&
          next.errorMessage != null) {
        SnackbarUtils.showError(context, next.errorMessage!);
      }
    });

    final profileState = ref.watch(profileViewModelProvider);
    return Scaffold(
      backgroundColor: lightYellow,
      appBar: AppBar(
        backgroundColor: primaryOrange,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Edit Profile',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      body: profileState.status == ProfileStatus.loading && !_isDataLoaded
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 25,
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      /// Profile Avatar
                      if (_profile.isNotEmpty)
                        GestureDetector(
                          onTap: _showMediaPicker,
                          child: Stack(
                            children: [
                              CircleAvatar(
                                radius: 60,
                                backgroundColor: Colors.pink.shade300,
                                backgroundImage:
                                    FileImage(File(_profile.first!.path))
                                        as ImageProvider?,
                                child: null,
                              ),
                              Positioned(
                                top: 10,
                                right: 10,
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                  ),
                                  child: GestureDetector(
                                    onTap: _clearImage,
                                    child: const Text(
                                      'x',
                                      style: TextStyle(
                                        color: Colors.red,
                                        fontSize: 20,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      else if (_profilePicture != null &&
                          _profilePicture!.isNotEmpty)
                        GestureDetector(
                          onTap: _showMediaPicker,
                          child: Stack(
                            children: [
                              CircleAvatar(
                                radius: 60,
                                backgroundImage: NetworkImage(
                                  '${ApiEndpoints.baseUrl}$_profilePicture',
                                ),
                              ),
                              Positioned(
                                top: 10,
                                right: 10,
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                  ),
                                  child: GestureDetector(
                                    onTap: _clearImage,
                                    child: const Text(
                                      'x',
                                      style: TextStyle(
                                        color: Colors.red,
                                        fontSize: 20,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      else
                        GestureDetector(
                          onTap: _showMediaPicker,
                          child: CircleAvatar(
                            radius: 60,
                            backgroundColor: Colors.pink.shade300,
                            child: const Icon(
                              Icons.camera_alt,
                              size: 40,
                              color: Colors.white,
                            ),
                          ),
                        ),

                      const SizedBox(height: 30),

                      /// Form Card
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(18),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.08),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            _inputField(
                              controller: _firstNameController,

                              label: 'First Name',
                              icon: Icons.person_outline,
                              hint: 'Change first name',
                            ),
                            const SizedBox(height: 16),
                            _inputField(
                              controller: _lastNameController,
                              label: 'Last Name',
                              icon: Icons.person_outline,
                              hint: 'Change last name',
                            ),
                            const SizedBox(height: 16),
                          ],
                        ),
                      ),

                      const SizedBox(height: 30),

                      /// Save Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: buttonOrange,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          onPressed: _handleSubmit,
                          child: const Text(
                            'Save Changes',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 14),

                      /// Cancel Button
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: primaryOrange),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          onPressed: () => Navigator.pop(context),
                          child: Text(
                            'Cancel',
                            style: TextStyle(
                              fontSize: 16,
                              color: primaryOrange,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  Widget _inputField({
    required String label,
    required IconData icon,
    required String hint,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: Colors.orange),
            hintText: hint,
            filled: true,
            fillColor: const Color(0xFFFFFDE7),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
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
