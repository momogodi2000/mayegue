import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import '../../themes/colors.dart';

/// File Picker Widget - Reusable file selection component
class FilePickerWidget extends StatefulWidget {
  final String label;
  final String? hintText;
  final List<String>? allowedExtensions;
  final bool allowMultiple;
  final Function(List<PlatformFile>)? onFilesSelected;
  final Function(PlatformFile)? onFileSelected;
  final String? initialFileName;
  final bool enabled;

  const FilePickerWidget({
    super.key,
    required this.label,
    this.hintText,
    this.allowedExtensions,
    this.allowMultiple = false,
    this.onFilesSelected,
    this.onFileSelected,
    this.initialFileName,
    this.enabled = true,
  });

  @override
  State<FilePickerWidget> createState() => _FilePickerWidgetState();
}

class _FilePickerWidgetState extends State<FilePickerWidget> {
  List<PlatformFile> _selectedFiles = [];
  String? _errorMessage;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: AppColors.onSurface,
          ),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: widget.enabled ? _pickFiles : null,
          borderRadius: BorderRadius.circular(8),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: widget.enabled ? AppColors.surface : AppColors.onSurface.withValues(alpha: 12),
              border: Border.all(
                color: _errorMessage != null ? AppColors.error : AppColors.border,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(
                  _getFileIcon(),
                  color: widget.enabled ? AppColors.primary : AppColors.onSurface.withValues(alpha: 76),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _getDisplayText(),
                        style: TextStyle(
                          color: widget.enabled ? AppColors.onSurface : AppColors.onSurface.withValues(alpha: 127),
                          fontSize: 14,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (_selectedFiles.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(
                          _getFileInfo(),
                          style: TextStyle(
                            color: AppColors.onSurface.withValues(alpha: 153),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                if (_selectedFiles.isNotEmpty)
                  IconButton(
                    onPressed: _clearSelection,
                    icon: const Icon(
                      Icons.clear,
                      color: AppColors.error,
                    ),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  )
                else
                  Icon(
                    Icons.attach_file,
                    color: widget.enabled ? AppColors.primary : AppColors.onSurface.withValues(alpha: 76),
                  ),
              ],
            ),
          ),
        ),
        if (_errorMessage != null) ...[
          const SizedBox(height: 8),
          Text(
            _errorMessage!,
            style: const TextStyle(
              color: AppColors.error,
              fontSize: 12,
            ),
          ),
        ],
      ],
    );
  }

  Future<void> _pickFiles() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: widget.allowedExtensions != null ? FileType.custom : FileType.any,
        allowedExtensions: widget.allowedExtensions,
        allowMultiple: widget.allowMultiple,
      );

      if (result != null) {
        setState(() {
          _selectedFiles = result.files;
          _errorMessage = null;
        });

        if (widget.allowMultiple) {
          widget.onFilesSelected?.call(_selectedFiles);
        } else if (_selectedFiles.isNotEmpty) {
          widget.onFileSelected?.call(_selectedFiles.first);
        }
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Erreur lors de la sélection du fichier';
      });
      debugPrint('Error picking files: $e');
    }
  }

  void _clearSelection() {
    setState(() {
      _selectedFiles.clear();
      _errorMessage = null;
    });
  }

  String _getDisplayText() {
    if (_selectedFiles.isNotEmpty) {
      if (widget.allowMultiple) {
        return '${_selectedFiles.length} fichier(s) sélectionné(s)';
      } else {
        return _selectedFiles.first.name;
      }
    }
    return widget.hintText ?? 'Cliquez pour sélectionner un fichier';
  }

  String _getFileInfo() {
    if (_selectedFiles.isEmpty) return '';

    final file = _selectedFiles.first;
    final size = _formatFileSize(file.size);
    return '$size • ${file.extension?.toUpperCase() ?? 'Unknown'}';
  }

  IconData _getFileIcon() {
    if (_selectedFiles.isEmpty) {
      return Icons.insert_drive_file;
    }

    final extension = _selectedFiles.first.extension?.toLowerCase();

    switch (extension) {
      case 'pdf':
        return Icons.picture_as_pdf;
      case 'doc':
      case 'docx':
        return Icons.description;
      case 'xls':
      case 'xlsx':
        return Icons.table_chart;
      case 'ppt':
      case 'pptx':
        return Icons.slideshow;
      case 'txt':
        return Icons.text_snippet;
      case 'jpg':
      case 'jpeg':
      case 'png':
      case 'gif':
      case 'bmp':
        return Icons.image;
      case 'mp3':
      case 'wav':
      case 'aac':
        return Icons.audio_file;
      case 'mp4':
      case 'avi':
      case 'mov':
        return Icons.video_file;
      case 'zip':
      case 'rar':
      case '7z':
        return Icons.archive;
      default:
        return Icons.insert_drive_file;
    }
  }

  String _formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024) return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }
}

/// File Upload Card - Drag and drop file upload interface
class FileUploadCard extends StatefulWidget {
  final String title;
  final String subtitle;
  final List<String>? allowedExtensions;
  final bool allowMultiple;
  final Function(List<PlatformFile>)? onFilesSelected;
  final Function(PlatformFile)? onFileSelected;

  const FileUploadCard({
    super.key,
    required this.title,
    required this.subtitle,
    this.allowedExtensions,
    this.allowMultiple = false,
    this.onFilesSelected,
    this.onFileSelected,
  });

  @override
  State<FileUploadCard> createState() => _FileUploadCardState();
}

class _FileUploadCardState extends State<FileUploadCard> {
  final bool _isDragging = false;
  List<PlatformFile> _uploadedFiles = [];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: _isDragging ? AppColors.primary.withValues(alpha: 12) : AppColors.surface,
        border: Border.all(
          color: _isDragging ? AppColors.primary : AppColors.border,
          width: _isDragging ? 2 : 1,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(
            _uploadedFiles.isNotEmpty ? Icons.check_circle : Icons.cloud_upload,
            size: 48,
            color: _uploadedFiles.isNotEmpty ? AppColors.success : AppColors.primary,
          ),
          const SizedBox(height: 16),
          Text(
            _uploadedFiles.isNotEmpty ? 'Fichier(s) téléchargé(s)' : widget.title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.onSurface,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            _uploadedFiles.isNotEmpty
                ? '${_uploadedFiles.length} fichier(s) prêt(s)'
                : widget.subtitle,
            style: TextStyle(
              fontSize: 14,
              color: AppColors.onSurface.withValues(alpha: 178),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          if (_uploadedFiles.isNotEmpty) ...[
            Container(
              constraints: const BoxConstraints(maxHeight: 120),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: _uploadedFiles.length,
                itemBuilder: (context, index) {
                  final file = _uploadedFiles[index];
                  return ListTile(
                    leading: Icon(
                      _getFileIcon(file.extension),
                      color: AppColors.primary,
                    ),
                    title: Text(
                      file.name,
                      style: const TextStyle(fontSize: 14),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Text(
                      _formatFileSize(file.size),
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.onSurface.withValues(alpha: 153),
                      ),
                    ),
                    trailing: IconButton(
                      onPressed: () => _removeFile(index),
                      icon: const Icon(
                        Icons.close,
                        color: AppColors.error,
                        size: 20,
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
          ],
          ElevatedButton.icon(
            onPressed: _pickFiles,
            icon: const Icon(Icons.add),
            label: Text(_uploadedFiles.isNotEmpty ? 'Ajouter d\'autres fichiers' : 'Sélectionner des fichiers'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.secondary,
              foregroundColor: AppColors.onSecondary,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _pickFiles() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: widget.allowedExtensions != null ? FileType.custom : FileType.any,
        allowedExtensions: widget.allowedExtensions,
        allowMultiple: widget.allowMultiple,
      );

      if (result != null) {
        setState(() {
          if (widget.allowMultiple) {
            _uploadedFiles.addAll(result.files);
          } else {
            _uploadedFiles = result.files;
          }
        });

        if (widget.allowMultiple) {
          widget.onFilesSelected?.call(_uploadedFiles);
        } else if (_uploadedFiles.isNotEmpty) {
          widget.onFileSelected?.call(_uploadedFiles.first);
        }
      }
    } catch (e) {
      debugPrint('Error picking files: $e');
    }
  }

  void _removeFile(int index) {
    setState(() {
      _uploadedFiles.removeAt(index);
    });
  }

  IconData _getFileIcon(String? extension) {
    final ext = extension?.toLowerCase();

    switch (ext) {
      case 'pdf':
        return Icons.picture_as_pdf;
      case 'doc':
      case 'docx':
        return Icons.description;
      case 'jpg':
      case 'jpeg':
      case 'png':
        return Icons.image;
      case 'mp3':
      case 'wav':
        return Icons.audio_file;
      case 'mp4':
      case 'avi':
        return Icons.video_file;
      default:
        return Icons.insert_drive_file;
    }
  }

  String _formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024) return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }
}
