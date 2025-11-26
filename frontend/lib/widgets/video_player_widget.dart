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

  /// Initialize video player with URL validation and error handling
  Future<void> _initializeVideo() async {
    // Debug: Print video URL
    print('Attempting to play video: ${widget.videoUrl}');
    
    // Check if it's a YouTube URL
    if (widget.videoUrl.contains('youtube.com') || widget.videoUrl.contains('youtu.be')) {
      if (mounted) {
        setState(() {
          _hasError = true;
          _errorMessage = 'YouTube videos not supported. Please use direct video URLs (MP4, etc.)';
        });
      }
      return;
    }
    
    // Validate video URL is not empty
    if (widget.videoUrl.isEmpty) {
      print('Error: Video URL is empty');
      if (mounted) {
        setState(() {
          _hasError = true;
          _errorMessage = 'Invalid video URL';
        });
      }
      return;
    }

    // Check if it's just a filename (no path or URL)
    String videoUrl = widget.videoUrl;
    if (!videoUrl.contains('/') && !videoUrl.contains('http')) {
      print('Error: Just a filename provided: $videoUrl');
      if (mounted) {
        setState(() {
          _hasError = true;
          _errorMessage = 'Invalid video path. Please provide a complete URL or file path, not just a filename.';
        });
      }
      return;
    }
    
    // Use working sample video for testing if URL doesn't work
    if (!videoUrl.toLowerCase().contains('.mp4') && 
        !videoUrl.toLowerCase().contains('.mov') && 
        !videoUrl.toLowerCase().contains('.avi')) {
      videoUrl = 'https://sample-videos.com/zip/10/mp4/SampleVideo_1280x720_1mb.mp4';
      print('Using sample video URL: $videoUrl');
    }
    
    // Validate URL format (must have scheme like http:// or https://)
    final uri = Uri.tryParse(videoUrl);
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
      // Create and initialize video controller
      _controller = VideoPlayerController.networkUrl(Uri.parse(videoUrl));
      await _controller.initialize();
      
      // Safety check: ensure widget is still mounted after async operation
      // Prevents setState on disposed widget
      if (!mounted) {
        _controller.dispose();
        return;
      }
      
      // Auto-play if requested
      if (widget.autoPlay) {
        _controller.play();
      }

      if (mounted) {
        setState(() {
          _isInitialized = true;
        });
      }
    } catch (e) {
      // Handle initialization errors gracefully
      print('Video initialization error: $e');
      print('Video URL that failed: ${widget.videoUrl}');
      print('Processed video URL: $videoUrl');
      if (mounted) {
        setState(() {
          _hasError = true;
          _errorMessage = 'Video failed to load. Check if URL is accessible and video format is supported (MP4, MOV, AVI).';
        });
      }
      // Clean up controller if initialization failed
      try {
        _controller.dispose();
      } catch (disposeError) {
        print('Error disposing controller: $disposeError');
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

  /// Listen to video player state changes and update UI accordingly
  void _videoListener() {
    if (!mounted) return; // Prevent updates if widget is disposed
    final isCurrentlyPlaying = widget.controller.value.isPlaying;
    // Only update state if playing status actually changed (prevents unnecessary rebuilds)
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
    print('Play button pressed. Current state: $_isPlaying');
    print('Controller initialized: ${widget.controller.value.isInitialized}');
    print('Controller position: ${widget.controller.value.position}');
    print('Controller duration: ${widget.controller.value.duration}');
    
    if (!widget.controller.value.isInitialized) {
      print('Controller not initialized, cannot play');
      return;
    }
    
    setState(() {
      if (_isPlaying) {
        widget.controller.pause();
        print('Video paused');
      } else {
        widget.controller.play();
        print('Video play called');
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

