import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import '../models/file_item.dart';
import '../services/r2_thumbnail_service.dart';
import '../theme/app_theme.dart';

class CarouselGalleryScreen extends StatefulWidget {
  final List<FileItem> files;
  final int initialIndex;
  final R2ThumbnailService thumbnailService;

  const CarouselGalleryScreen({
    super.key,
    required this.files,
    required this.initialIndex,
    required this.thumbnailService,
  });

  @override
  State<CarouselGalleryScreen> createState() => _CarouselGalleryScreenState();
}

class _CarouselGalleryScreenState extends State<CarouselGalleryScreen> {
  late PageController _pageController;
  late int _currentIndex;
  late List<FileItem> _mediaFiles;

  @override
  void initState() {
    super.initState();
    _mediaFiles = widget.files.where((file) => 
      file.fileType == FileType.image || file.fileType == FileType.video
    ).toList();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: _currentIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: _mediaFiles.length,
            onPageChanged: (index) => setState(() => _currentIndex = index),
            itemBuilder: (context, index) => _buildMediaItem(_mediaFiles[index]),
          ),
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(_mediaFiles.length, (index) => 
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: index == _currentIndex
                      ? AppColors.primary
                      : AppColors.textMuted,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMediaItem(FileItem file) {
    if (file.fileType == FileType.image) {
      return PhotoView.customChild(
        child: CachedNetworkImage(
          imageUrl: widget.thumbnailService.getPreviewUrl(file.key),
          placeholder: (context, url) => const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          ),
          errorWidget: (context, url, error) => const Center(
            child: Icon(Icons.error, color: Colors.white),
          ),
        ),
        minScale: PhotoViewComputedScale.contained,
        maxScale: PhotoViewComputedScale.covered * 3,
        backgroundDecoration: const BoxDecoration(color: AppColors.background),
      );
    }
    
    if (file.fileType == FileType.video) {
      return _VideoPlayer(
        url: widget.thumbnailService.getPreviewUrl(file.key),
      );
    }

    return const Center(child: CircularProgressIndicator(color: AppColors.primary));
  }
}

class _VideoPlayer extends StatefulWidget {
  final String url;

  const _VideoPlayer({required this.url});

  @override
  State<_VideoPlayer> createState() => _VideoPlayerState();
}

class _VideoPlayerState extends State<_VideoPlayer> {
  VideoPlayerController? _videoController;
  ChewieController? _chewieController;

  @override
  void initState() {
    super.initState();
    _initVideoController();
  }

  void _initVideoController() {
    _videoController = VideoPlayerController.networkUrl(Uri.parse(widget.url));
    _videoController!.initialize().then((_) {
      _chewieController = ChewieController(
        videoPlayerController: _videoController!,
        autoPlay: false,
        looping: false,
        materialProgressColors: ChewieProgressColors(
          playedColor: AppColors.primary,
          handleColor: AppColors.primary,
          backgroundColor: AppColors.border,
          bufferedColor: AppColors.textMuted,
        ),
      );
      setState(() {});
    });
  }

  @override
  void dispose() {
    _chewieController?.dispose();
    _videoController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_chewieController == null) {
      return const Center(child: CircularProgressIndicator(color: AppColors.primary));
    }
    return Center(child: Chewie(controller: _chewieController!));
  }
}