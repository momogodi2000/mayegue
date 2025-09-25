import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:video_player/video_player.dart';
import '../../domain/entities/lesson_content.dart';

/// A unified media player widget that handles both audio and video content
class MediaPlayerWidget extends StatefulWidget {
  final LessonContent content;
  final VoidCallback? onComplete;

  const MediaPlayerWidget({
    super.key,
    required this.content,
    this.onComplete,
  });

  @override
  State<MediaPlayerWidget> createState() => _MediaPlayerWidgetState();
}

class _MediaPlayerWidgetState extends State<MediaPlayerWidget> {
  AudioPlayer? _audioPlayer;
  VideoPlayerController? _videoController;
  bool _isPlaying = false;
  bool _isLoading = true;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;
  String? _error;

  @override
  void initState() {
    super.initState();
    _initializeMedia();
  }

  @override
  void dispose() {
    _audioPlayer?.dispose();
    _videoController?.dispose();
    super.dispose();
  }

  Future<void> _initializeMedia() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      if (widget.content.type == ContentType.audio) {
        await _initializeAudio();
      } else if (widget.content.type == ContentType.video) {
        await _initializeVideo();
      }
    } catch (e) {
      setState(() {
        _error = 'Erreur de chargement: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _initializeAudio() async {
    _audioPlayer = AudioPlayer();

    // Set up listeners
    _audioPlayer!.onDurationChanged.listen((duration) {
      setState(() => _duration = duration);
    });

    _audioPlayer!.onPositionChanged.listen((position) {
      setState(() => _position = position);
    });

    _audioPlayer!.onPlayerComplete.listen((_) {
      setState(() => _isPlaying = false);
      widget.onComplete?.call();
    });

    // Load audio
    await _audioPlayer!.setSource(UrlSource(widget.content.content));
    setState(() => _isLoading = false);
  }

  Future<void> _initializeVideo() async {
    _videoController = VideoPlayerController.networkUrl(
      Uri.parse(widget.content.content),
    );

    await _videoController!.initialize();

    _videoController!.addListener(() {
      if (mounted) {
        setState(() {
          _position = _videoController!.value.position;
          _duration = _videoController!.value.duration;
          _isPlaying = _videoController!.value.isPlaying;
        });

        // Check if video completed
        if (_videoController!.value.position >= _videoController!.value.duration &&
            !_videoController!.value.isPlaying) {
          widget.onComplete?.call();
        }
      }
    });

    setState(() => _isLoading = false);
  }

  Future<void> _togglePlayback() async {
    if (_audioPlayer != null) {
      if (_isPlaying) {
        await _audioPlayer!.pause();
      } else {
        await _audioPlayer!.resume();
      }
      setState(() => _isPlaying = !_isPlaying);
    } else if (_videoController != null) {
      if (_isPlaying) {
        await _videoController!.pause();
      } else {
        await _videoController!.play();
      }
    }
  }

  Future<void> _seekTo(Duration position) async {
    if (_audioPlayer != null) {
      await _audioPlayer!.seek(position);
    } else if (_videoController != null) {
      await _videoController!.seekTo(position);
    }
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    if (_error != null) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.red[50],
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.red[200]!),
        ),
        child: Row(
          children: [
            Icon(Icons.error, color: Colors.red[700]),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                _error!,
                style: TextStyle(color: Colors.red[700]),
              ),
            ),
          ],
        ),
      );
    }

    if (_isLoading) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Row(
          children: [
            SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
            SizedBox(width: 12),
            Text('Chargement du média...'),
          ],
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Video display (only for video content)
          if (_videoController != null && _videoController!.value.isInitialized)
            AspectRatio(
              aspectRatio: _videoController!.value.aspectRatio,
              child: VideoPlayer(_videoController!),
            ),

          // Controls
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Text(
                  widget.content.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),

                // Progress bar
                Slider(
                  value: _position.inSeconds.toDouble(),
                  max: _duration.inSeconds.toDouble(),
                  onChanged: (value) {
                    _seekTo(Duration(seconds: value.toInt()));
                  },
                ),

                // Time and controls
                Row(
                  children: [
                    // Play/Pause button
                    IconButton(
                      onPressed: _togglePlayback,
                      icon: Icon(
                        _isPlaying ? Icons.pause : Icons.play_arrow,
                        size: 32,
                      ),
                      color: Theme.of(context).primaryColor,
                    ),

                    // Time display
                    Text(
                      '${_formatDuration(_position)} / ${_formatDuration(_duration)}',
                      style: const TextStyle(fontSize: 12),
                    ),

                    const Spacer(),

                    // Media type indicator
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: widget.content.type == ContentType.audio
                            ? Colors.green[100]
                            : Colors.red[100],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            widget.content.type == ContentType.audio
                                ? Icons.audiotrack
                                : Icons.videocam,
                            size: 14,
                            color: widget.content.type == ContentType.audio
                                ? Colors.green[700]
                                : Colors.red[700],
                          ),
                          const SizedBox(width: 4),
                          Text(
                            widget.content.type == ContentType.audio ? 'Audio' : 'Vidéo',
                            style: TextStyle(
                              fontSize: 10,
                              color: widget.content.type == ContentType.audio
                                  ? Colors.green[700]
                                  : Colors.red[700],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
