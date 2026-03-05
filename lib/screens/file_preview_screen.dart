import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:pdfx/pdfx.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import '../models/file_item.dart';
import '../services/r2_thumbnail_service.dart';

class FilePreviewScreen extends StatefulWidget {
  final FileItem file;
  final R2ThumbnailService thumbnailService;

  const FilePreviewScreen({
    super.key,
    required this.file,
    required this.thumbnailService,
  });

  @override
  State<FilePreviewScreen> createState() => _FilePreviewScreenState();
}

class _FilePreviewScreenState extends State<FilePreviewScreen> {
  PdfController? _pdfController;
  int _currentPage = 1;
  int _totalPages = 0;
  VideoPlayerController? _videoController;
  ChewieController? _chewieController;

  @override
  void initState() {
    super.initState();
    if (widget.file.fileType == FileType.document && widget.file.name.toLowerCase().endsWith('.pdf')) {
      _initPdfController();
    } else if (widget.file.fileType == FileType.video) {
      _initVideoController();
    }
  }

  Future<void> _initPdfController() async {
    // PDF preview temporarily disabled - API compatibility issue
    debugPrint('PDF preview temporarily disabled');
  }

  void _initVideoController() {
    final url = widget.thumbnailService.getPreviewUrl(widget.file.key);
    _videoController = VideoPlayerController.networkUrl(Uri.parse(url));
    _videoController!.initialize().then((_) {
      _chewieController = ChewieController(
        videoPlayerController: _videoController!,
        autoPlay: false,
        looping: false,
        materialProgressColors: ChewieProgressColors(
          playedColor: const Color(0xFFF97316),
          handleColor: const Color(0xFFF97316),
          backgroundColor: const Color(0xFF2A2A2A),
          bufferedColor: const Color(0xFF71717A),
        ),
      );
      setState(() {});
    });
  }

  @override
  void dispose() {
    _pdfController?.dispose();
    _chewieController?.dispose();
    _videoController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF161616),
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.file.name,
          style: const TextStyle(color: Colors.white),
        ),
      ),
      body: _buildPreviewBody(),
    );
  }

  Widget _buildPreviewBody() {
    if (widget.file.fileType == FileType.image) {
      return PhotoView.customChild(
        child: CachedNetworkImage(
          imageUrl: widget.thumbnailService.getPreviewUrl(widget.file.key),
          placeholder: (context, url) => const Center(
            child: CircularProgressIndicator(
              color: Color(0xFFF97316),
            ),
          ),
          errorWidget: (context, url, error) => const Center(
            child: Icon(Icons.error, color: Colors.white),
          ),
        ),
        minScale: PhotoViewComputedScale.contained,
        maxScale: PhotoViewComputedScale.covered * 3,
        backgroundDecoration: const BoxDecoration(
          color: Color(0xFF0A0A0A),
        ),
      );
    }
    
    if (widget.file.fileType == FileType.video) {
      if (_chewieController == null) {
        return const Center(
          child: CircularProgressIndicator(
            color: Color(0xFFF97316),
          ),
        );
      }
      return Center(
        child: Chewie(controller: _chewieController!),
      );
    }
    
    if (widget.file.fileType == FileType.document && widget.file.name.toLowerCase().endsWith('.pdf')) {
      return _buildPdfView();
    }

    return const Center(
      child: CircularProgressIndicator(
        color: Color(0xFFF97316),
      ),
    );
  }

  Widget _buildPdfView() {
    if (_pdfController == null) {
      return const Center(
        child: CircularProgressIndicator(
          color: Color(0xFFF97316),
        ),
      );
    }

    return Column(
      children: [
        Expanded(
          child: PdfView(
            controller: _pdfController!,
            onPageChanged: (page) {
              setState(() {
                _currentPage = page;
              });
            },
            onDocumentLoaded: (document) {
              setState(() {
                _totalPages = document.pagesCount;
              });
            },
          ),
        ),
        Container(
          color: const Color(0xFF161616),
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: null, // PDF navigation temporarily disabled
                icon: const Icon(Icons.chevron_left, color: Colors.white),
              ),
              Text(
                '$_currentPage / $_totalPages',
                style: const TextStyle(color: Colors.white),
              ),
              IconButton(
                onPressed: null, // PDF navigation temporarily disabled
                icon: const Icon(Icons.chevron_right, color: Colors.white),
              ),
            ],
          ),
        ),
      ],
    );
  }
}