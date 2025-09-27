import 'package:flutter/material.dart';
import '../../themes/colors.dart';

/// Image Viewer Widget - Reusable image display component with zoom and pan
class ImageViewer extends StatefulWidget {
  final String imageUrl;
  final String? title;
  final double? width;
  final double? height;
  final BoxFit fit;
  final bool enableZoom;
  final bool enablePan;
  final VoidCallback? onTap;
  final Widget? placeholder;
  final Widget? errorWidget;

  const ImageViewer({
    super.key,
    required this.imageUrl,
    this.title,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.enableZoom = false,
    this.enablePan = false,
    this.onTap,
    this.placeholder,
    this.errorWidget,
  });

  @override
  State<ImageViewer> createState() => _ImageViewerState();
}

class _ImageViewerState extends State<ImageViewer> {
  bool _hasError = false;

  @override
  Widget build(BuildContext context) {
    Widget imageWidget = _hasError
        ? (widget.errorWidget ??
            Container(
              color: AppColors.error.withValues(alpha: 25),
              child: const Icon(
                Icons.broken_image,
                color: AppColors.error,
                size: 48,
              ),
            ))
        : Image.network(
            widget.imageUrl,
            width: widget.width,
            height: widget.height,
            fit: widget.fit,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return widget.placeholder ??
                  Container(
                    color: AppColors.surface,
                    child: Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                            : null,
                        valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
                      ),
                    ),
                  );
            },
            errorBuilder: (context, error, stackTrace) {
              setState(() {
                _hasError = true;
              });
              return widget.errorWidget ??
                  Container(
                    color: AppColors.error.withValues(alpha: 25),
                    child: const Icon(
                      Icons.broken_image,
                      color: AppColors.error,
                      size: 48,
                    ),
                  );
            },
          );

    // Wrap with zoom/pan if enabled
    if (widget.enableZoom || widget.enablePan) {
      imageWidget = InteractiveViewer(
        minScale: 0.5,
        maxScale: 4.0,
        panEnabled: widget.enablePan,
        scaleEnabled: widget.enableZoom,
        child: imageWidget,
      );
    }

    // Wrap with tap gesture if provided
    if (widget.onTap != null) {
      imageWidget = GestureDetector(
        onTap: widget.onTap,
        child: imageWidget,
      );
    }

    // Add container with styling
    return Container(
      width: widget.width,
      height: widget.height,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Column(
          children: [
            Expanded(child: imageWidget),
            if (widget.title != null) ...[
              Container(
                padding: const EdgeInsets.all(8),
                color: AppColors.surface.withValues(alpha: 229),
                child: Text(
                  widget.title!,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: AppColors.onSurface,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Image Gallery - Display multiple images in a grid
class ImageGallery extends StatelessWidget {
  final List<String> imageUrls;
  final int crossAxisCount;
  final double spacing;
  final double? aspectRatio;
  final VoidCallback? onImageTap;
  final Function(int)? onImageLongPress;

  const ImageGallery({
    super.key,
    required this.imageUrls,
    this.crossAxisCount = 3,
    this.spacing = 8.0,
    this.aspectRatio,
    this.onImageTap,
    this.onImageLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: spacing,
        mainAxisSpacing: spacing,
        childAspectRatio: aspectRatio ?? 1.0,
      ),
      itemCount: imageUrls.length,
      itemBuilder: (context, index) {
        return ImageViewer(
          imageUrl: imageUrls[index],
          fit: BoxFit.cover,
          onTap: onImageTap,
          placeholder: Container(
            color: AppColors.surface,
            child: Icon(
              Icons.image,
              color: AppColors.onSurface.withValues(alpha: 76),
            ),
          ),
        );
      },
    );
  }
}

/// Full Screen Image Viewer - Modal for viewing images in full screen
class FullScreenImageViewer extends StatelessWidget {
  final String imageUrl;
  final String? title;
  final VoidCallback? onClose;

  const FullScreenImageViewer({
    super.key,
    required this.imageUrl,
    this.title,
    this.onClose,
  });

  static Future<void> show({
    required BuildContext context,
    required String imageUrl,
    String? title,
  }) {
    return showDialog(
      context: context,
      useSafeArea: false,
      builder: (context) => FullScreenImageViewer(
        imageUrl: imageUrl,
        title: title,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black.withValues(alpha: 178),
        foregroundColor: Colors.white,
        title: title != null ? Text(title!) : null,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            Navigator.of(context).pop();
            onClose?.call();
          },
        ),
      ),
      body: Center(
        child: InteractiveViewer(
          minScale: 0.5,
          maxScale: 4.0,
          child: Image.network(
            imageUrl,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return Center(
                child: CircularProgressIndicator(
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded /
                          loadingProgress.expectedTotalBytes!
                      : null,
                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              );
            },
            errorBuilder: (context, error, stackTrace) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.broken_image,
                      color: Colors.white,
                      size: 64,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Erreur de chargement de l\'image',
                      style: const TextStyle(color: Color(0xB3FFFFFF)),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
