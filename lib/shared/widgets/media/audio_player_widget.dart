import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import '../common/loading_widget.dart';
import '../../themes/colors.dart';

/// Audio Player Widget - Reusable audio player component
class AudioPlayerWidget extends StatefulWidget {
  final String audioUrl;
  final String? title;
  final bool showControls;
  final bool autoPlay;
  final VoidCallback? onPlay;
  final VoidCallback? onPause;
  final Function(Duration)? onPositionChanged;
  final Function(Duration)? onDurationChanged;

  const AudioPlayerWidget({
    super.key,
    required this.audioUrl,
    this.title,
    this.showControls = true,
    this.autoPlay = false,
    this.onPlay,
    this.onPause,
    this.onPositionChanged,
    this.onDurationChanged,
  });

  @override
  State<AudioPlayerWidget> createState() => _AudioPlayerWidgetState();
}

class _AudioPlayerWidgetState extends State<AudioPlayerWidget> {
  late AudioPlayer _audioPlayer;
  bool _isInitialized = false;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;
  PlayerState _playerState = PlayerState.stopped;

  @override
  void initState() {
    super.initState();
    _initializePlayer();
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _initializePlayer() async {
    _audioPlayer = AudioPlayer();

    // Set up listeners
    _audioPlayer.onDurationChanged.listen((duration) {
      setState(() {
        _duration = duration;
      });
      widget.onDurationChanged?.call(duration);
    });

    _audioPlayer.onPositionChanged.listen((position) {
      setState(() {
        _position = position;
      });
      widget.onPositionChanged?.call(position);
    });

    _audioPlayer.onPlayerStateChanged.listen((state) {
      setState(() {
        _playerState = state;
      });
    });

    try {
      await _audioPlayer.setSourceUrl(widget.audioUrl);

      if (widget.autoPlay) {
        await _audioPlayer.resume();
      }

      setState(() {
        _isInitialized = true;
      });
    } catch (e) {
      debugPrint('Error initializing audio player: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return const LoadingWidget();
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          if (widget.title != null) ...[
            Text(
              widget.title!,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
          ],
          if (widget.showControls) _buildControls(),
        ],
      ),
    );
  }

  Widget _buildControls() {
    final isPlaying = _playerState == PlayerState.playing;
    final isLoading = _playerState == PlayerState.playing && _position == Duration.zero;

    return Column(
      children: [
        // Progress bar
        Slider(
          value: _position.inMilliseconds.toDouble(),
          max: _duration.inMilliseconds.toDouble(),
          onChanged: (value) {
            _audioPlayer.seek(Duration(milliseconds: value.toInt()));
          },
          activeColor: AppColors.primary,
          inactiveColor: AppColors.border,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _formatDuration(_position),
                style: TextStyle(
                  color: AppColors.onSurface.withOpacity(0.7),
                  fontSize: 12,
                ),
              ),
              Text(
                _formatDuration(_duration),
                style: TextStyle(
                  color: AppColors.onSurface.withOpacity(0.7),
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),

        // Control buttons
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              onPressed: () {
                _audioPlayer.seek(Duration.zero);
              },
              icon: Icon(
                Icons.replay_10,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(width: 16),
            Container(
              decoration: BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
              child: IconButton(
                onPressed: isLoading
                    ? null
                    : () async {
                        if (isPlaying) {
                          await _audioPlayer.pause();
                          widget.onPause?.call();
                        } else {
                          await _audioPlayer.resume();
                          widget.onPlay?.call();
                        }
                      },
                icon: Icon(
                  isLoading ? Icons.hourglass_empty : (isPlaying ? Icons.pause : Icons.play_arrow),
                  color: AppColors.onPrimary,
                ),
              ),
            ),
            const SizedBox(width: 16),
            IconButton(
              onPressed: () {
                final newPosition = _position + const Duration(seconds: 10);
                _audioPlayer.seek(newPosition);
              },
              icon: Icon(
                Icons.forward_10,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
      ],
    );
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }
}

/// Compact Audio Player - Minimal audio player for lists
class CompactAudioPlayer extends StatefulWidget {
  final String audioUrl;
  final String title;
  final double? progress;
  final VoidCallback? onTap;

  const CompactAudioPlayer({
    super.key,
    required this.audioUrl,
    required this.title,
    this.progress,
    this.onTap,
  });

  @override
  State<CompactAudioPlayer> createState() => _CompactAudioPlayerState();
}

class _CompactAudioPlayerState extends State<CompactAudioPlayer> {
  late AudioPlayer _audioPlayer;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _initializePlayer();
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _initializePlayer() async {
    _audioPlayer = AudioPlayer();

    try {
      await _audioPlayer.setSourceUrl(widget.audioUrl);

      _audioPlayer.onPlayerStateChanged.listen((state) {
        setState(() {
          _isPlaying = state == PlayerState.playing;
        });
      });
    } catch (e) {
      debugPrint('Error initializing compact audio player: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap ?? _togglePlayback,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
              child: IconButton(
                onPressed: _togglePlayback,
                icon: Icon(
                  _isPlaying ? Icons.pause : Icons.play_arrow,
                  color: AppColors.onPrimary,
                  size: 20,
                ),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.title,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppColors.onSurface,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (widget.progress != null) ...[
                    const SizedBox(height: 4),
                    LinearProgressIndicator(
                      value: widget.progress,
                      backgroundColor: AppColors.border,
                      valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _togglePlayback() async {
    try {
      if (_isPlaying) {
        await _audioPlayer.pause();
      } else {
        await _audioPlayer.resume();
      }
    } catch (e) {
      debugPrint('Error toggling playback: $e');
    }
  }
}
