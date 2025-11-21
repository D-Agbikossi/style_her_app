/**
 * Video Player Widget
 * 
 * Displays and controls video playback from URLs
 */

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerWidget extends StatefulWidget {
  final String videoUrl;
  final bool autoPlay;
  final bool showControls;

  const VideoPlayerWidget({
    super.key,
    required this.videoUrl,
    this.autoPlay = false,
    this.showControls = true,
  });

  @override
  State<VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController _controller;
  bool _isInitialized = false;
  bool _hasError = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  Future<void> _initializeVideo() async {
    // Validate video URL
    if (widget.videoUrl.isEmpty) {
      if (mounted) {
        setState(() {
          _hasError = true;
          _errorMessage = 'Invalid video URL';
        });
      }
      return;
    }

    final uri = Uri.tryParse(widget.videoUrl);
    if (uri == null || !uri.hasScheme) {
      if (mounted) {
        setState(() {
          _hasError = true;
          _errorMessage = 'Invalid video URL format';
        });
      }
      return;
    }

    try {
      _controller = VideoPlayerController.networkUrl(uri);
      await _controller.initialize();
      
      // Check if widget is still mounted after async operation
      if (!mounted) {
        _controller.dispose();
        return;
      }
      
      if (widget.autoPlay) {
        _controller.play();
      }

      if (mounted) {
        setState(() {
          _isInitialized = true;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _hasError = true;
          _errorMessage = 'Unable to load video. Please check your connection.';
        });
      }
      // Dispose controller if initialization failed
      if (_controller.value.isInitialized) {
        _controller.dispose();
      }
    }
  }

  @override
  void dispose() {
    if (_isInitialized || (_controller.value.isInitialized)) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_hasError) {
      return Container(
        color: Colors.black,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, color: Colors.white, size: 48),
              const SizedBox(height: 16),
              Text(
                _errorMessage ?? 'Error loading video',
                style: const TextStyle(color: Colors.white),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    if (!_isInitialized) {
      return Container(
        color: Colors.black,
        child: const Center(
          child: CircularProgressIndicator(color: Colors.white),
        ),
      );
    }

    return AspectRatio(
      aspectRatio: _controller.value.aspectRatio,
      child: Stack(
        alignment: Alignment.center,
        children: [
          VideoPlayer(_controller),
          if (widget.showControls)
            _VideoControlsOverlay(controller: _controller),
        ],
      ),
    );
  }
}

class _VideoControlsOverlay extends StatefulWidget {
  final VideoPlayerController controller;

  const _VideoControlsOverlay({required this.controller});

  @override
  State<_VideoControlsOverlay> createState() => _VideoControlsOverlayState();
}

class _VideoControlsOverlayState extends State<_VideoControlsOverlay> {
  bool _showControls = true;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _isPlaying = widget.controller.value.isPlaying;
    widget.controller.addListener(_videoListener);
  }

  void _videoListener() {
    if (!mounted) return;
    final isCurrentlyPlaying = widget.controller.value.isPlaying;
    if (_isPlaying != isCurrentlyPlaying) {
      setState(() {
        _isPlaying = isCurrentlyPlaying;
      });
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(_videoListener);
    super.dispose();
  }

  void _togglePlayPause() {
    setState(() {
      if (_isPlaying) {
        widget.controller.pause();
      } else {
        widget.controller.play();
      }
      _isPlaying = !_isPlaying;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _showControls = !_showControls;
        });
      },
      child: AnimatedOpacity(
        opacity: _showControls ? 1.0 : 0.0,
        duration: const Duration(milliseconds: 300),
        child: Container(
          color: Colors.black.withOpacity(0.3),
          child: Center(
            child: IconButton(
              icon: Icon(
                _isPlaying ? Icons.pause : Icons.play_arrow,
                color: Colors.white,
                size: 64,
              ),
              onPressed: _togglePlayPause,
            ),
          ),
        ),
      ),
    );
  }
}

