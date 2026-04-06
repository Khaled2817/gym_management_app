import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AppImagePicker extends StatefulWidget {
  final XFile? initialImage;
  final ValueChanged<XFile?> onChanged;

  // UI
  final double height;
  final double width;
  final double borderRadius;
  final double borderWidth;

  final Color borderColor;
  final Color backgroundColor;
  final Color plusColor;
  final Color iconColor;
  final Color textColor;

  final String title;
  final IconData icon;

  final bool enableRemove;
  final bool enableCamera;

  const AppImagePicker({
    super.key,
    required this.onChanged,
    this.initialImage,
    this.height = 140,
    this.width = double.infinity,
    this.borderRadius = 18,
    this.borderWidth = 1.5,
    this.borderColor = const Color(0xFF00B7C2),
    this.backgroundColor = const Color(0xFFE0E0E0),
    this.plusColor = const Color(0xFF00B7C2),
    this.iconColor = const Color(0xFF7A7A7A),
    this.textColor = const Color(0xFF7A7A7A),
    this.title = "Upload Image",
    this.icon = Icons.cloud_upload_outlined,
    this.enableRemove = true,
    this.enableCamera = true,
  });

  @override
  State<AppImagePicker> createState() => _AppImagePickerState();
}

class _AppImagePickerState extends State<AppImagePicker> {
  final ImagePicker _picker = ImagePicker();
  XFile? _file;

  @override
  void initState() {
    super.initState();
    _file = widget.initialImage;
  }

  Future<void> _pick(ImageSource source) async {
    final result = await _picker.pickImage(
      source: source,
      imageQuality: 85,
    );
    if (result == null) return;

    setState(() => _file = result);
    widget.onChanged(result);
  }

  void _remove() {
    setState(() => _file = null);
    widget.onChanged(null);
  }

  void _openPickerSheet() {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      builder: (_) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _sheetItem(
                  title: "Choose from gallery",
                  icon: Icons.photo_library_outlined,
                  onTap: () {
                    Navigator.pop(context);
                    _pick(ImageSource.gallery);
                  },
                ),
                if (widget.enableCamera) ...[
                  const SizedBox(height: 8),
                  _sheetItem(
                    title: "Take a photo",
                    icon: Icons.camera_alt_outlined,
                    onTap: () {
                      Navigator.pop(context);
                      _pick(ImageSource.camera);
                    },
                  ),
                ],
                if (widget.enableRemove && _file != null) ...[
                  const SizedBox(height: 8),
                  _sheetItem(
                    title: "Remove",
                    icon: Icons.delete_outline,
                    isDanger: true,
                    onTap: () {
                      Navigator.pop(context);
                      _remove();
                    },
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _sheetItem({
    required String title,
    required IconData icon,
    required VoidCallback onTap,
    bool isDanger = false,
  }) {
    final color = isDanger ? Colors.red : Colors.black87;
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
        child: Row(
          children: [
            Icon(icon, color: color),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: color),
              ),
            ),
            const Icon(Icons.chevron_right),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final hasImage = _file != null;

    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Card
          InkWell(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            onTap: _openPickerSheet,
            child: Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                color: widget.backgroundColor,
                borderRadius: BorderRadius.circular(widget.borderRadius),
                border: Border.all(
                  color: widget.borderColor,
                  width: widget.borderWidth,
                ),
              ),
              child: hasImage ? _preview() : _placeholder(),
            ),
          ),

          // Plus button
          Positioned(
            right: 10,
            bottom: -14,
            child: InkWell(
              onTap: _openPickerSheet,
              borderRadius: BorderRadius.circular(999),
              child: Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: widget.plusColor,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.12),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Icon(Icons.add, color: Colors.white, size: 20),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _placeholder() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(widget.icon, size: 42, color: widget.iconColor),
        const SizedBox(height: 6),
        Text(
          widget.title,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: widget.textColor,
          ),
        ),
      ],
    );
  }

  Widget _preview() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(widget.borderRadius),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.file(
            File(_file!.path),
            fit: BoxFit.cover,
          ),
          // Remove icon (اختياري)
          if (widget.enableRemove)
            Positioned(
              top: 10,
              right: 10,
              child: InkWell(
                onTap: _remove,
                borderRadius: BorderRadius.circular(999),
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.45),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.close, color: Colors.white, size: 18),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
