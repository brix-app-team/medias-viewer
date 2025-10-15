import 'package:flutter/material.dart';
import 'package:medias_viewer/medias_viewer.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Media Viewer Example',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const ExampleHomePage(),
    );
  }
}

class ExampleHomePage extends StatelessWidget {
  const ExampleHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Media Viewer Examples'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildExampleCard(
            context,
            title: 'Basic Image Gallery',
            description: 'Simple image gallery with zoom',
            onTap: () => _showBasicImageGallery(context),
          ),
          const SizedBox(height: 16),
          _buildExampleCard(
            context,
            title: 'Mixed Media Gallery',
            description: 'Images and videos together',
            onTap: () => _showMixedMediaGallery(context),
          ),
          const SizedBox(height: 16),
          _buildExampleCard(
            context,
            title: 'Custom Configuration',
            description: 'Custom colors and indicator position',
            onTap: () => _showCustomConfigGallery(context),
          ),
          const SizedBox(height: 16),
          _buildExampleCard(
            context,
            title: 'No Zoom Gallery',
            description: 'Gallery with zoom disabled',
            onTap: () => _showNoZoomGallery(context),
          ),
          const SizedBox(height: 16),
          _buildExampleCard(
            context,
            title: 'Video Gallery',
            description: 'Gallery with video autoplay',
            onTap: () => _showVideoGallery(context),
          ),
          const SizedBox(height: 16),
          _buildExampleCard(
            context,
            title: 'Grid Gallery',
            description: 'Thumbnail grid opening full viewer',
            onTap: () => _showGridGallery(context),
          ),
          const SizedBox(height: 16),
          _buildExampleCard(
            context,
            title: 'With Navigation Arrows',
            description: 'Gallery with left/right arrows',
            onTap: () => _showArrowsGallery(context),
          ),
          const SizedBox(height: 16),
          _buildExampleCard(
            context,
            title: 'With Back Button',
            description: 'Gallery with close button',
            onTap: () => _showBackButtonGallery(context),
          ),
          const SizedBox(height: 16),
          _buildExampleCard(
            context,
            title: 'Swipe Down to Dismiss',
            description: 'Swipe down to close the gallery',
            onTap: () => _showDismissibleGallery(context),
          ),
          const SizedBox(height: 16),
          _buildExampleCard(
            context,
            title: 'Full Featured Gallery',
            description: 'All features enabled',
            onTap: () => _showFullFeaturedGallery(context),
          ),
          const SizedBox(height: 16),
          _buildExampleCard(
            context,
            title: 'Auto-Detection Gallery',
            description: 'Automatic media type detection',
            onTap: () => _showAutoDetectionGallery(context),
          ),
          const SizedBox(height: 16),
          _buildExampleCard(
            context,
            title: 'YouTube Video Gallery',
            description: 'Play YouTube videos in the viewer',
            onTap: () => _showYouTubeGallery(context),
          ),
        ],
      ),
    );
  }

  Widget _buildExampleCard(
    BuildContext context, {
    required String title,
    required String description,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 2,
      child: ListTile(
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: Text(description),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: onTap,
      ),
    );
  }

  void _showBasicImageGallery(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => MediaViewer(
          items: [
            const MediaItem.imageUrl('https://picsum.photos/800/600?random=1'),
            const MediaItem.imageUrl('https://picsum.photos/800/600?random=2'),
            const MediaItem.imageUrl('https://picsum.photos/800/600?random=3'),
            const MediaItem.imageUrl('https://picsum.photos/800/600?random=4'),
            const MediaItem.imageUrl('https://picsum.photos/800/600?random=5'),
          ],
          onDismissed: () => Navigator.of(context).pop(),
        ),
      ),
    );
  }

  void _showMixedMediaGallery(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => MediaViewer(
          items: [
            const MediaItem.imageUrl('https://picsum.photos/800/600?random=10'),
            const MediaItem.videoUrl(
              'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
            ),
            const MediaItem.imageUrl('https://picsum.photos/800/600?random=11'),
            const MediaItem.videoUrl(
              'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4',
            ),
            const MediaItem.imageUrl('https://picsum.photos/800/600?random=12'),
          ],
          onDismissed: () => Navigator.of(context).pop(),
        ),
      ),
    );
  }

  void _showCustomConfigGallery(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => MediaViewer(
          items: [
            const MediaItem.imageUrl('https://picsum.photos/800/600?random=20'),
            const MediaItem.imageUrl('https://picsum.photos/800/600?random=21'),
            const MediaItem.imageUrl('https://picsum.photos/800/600?random=22'),
          ],
          config: MediaViewerConfig(
            backgroundColor: Colors.blueGrey.shade900,
            indicatorPosition: IndicatorPosition.bottomCenter,
            indicatorStyle: IndicatorStyle(
              textStyle: const TextStyle(
                color: Colors.amber,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              backgroundColor: Colors.black54,
              borderRadius: 16,
            ),
            maxScale: 5.0,
          ),
          onDismissed: () => Navigator.of(context).pop(),
        ),
      ),
    );
  }

  void _showNoZoomGallery(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => MediaViewer(
          items: [
            const MediaItem.imageUrl('https://picsum.photos/800/600?random=30'),
            const MediaItem.imageUrl('https://picsum.photos/800/600?random=31'),
            const MediaItem.imageUrl('https://picsum.photos/800/600?random=32'),
          ],
          config: const MediaViewerConfig(
            enableImageZoom: false,
            enableDoubleTapZoom: false,
          ),
          onDismissed: () => Navigator.of(context).pop(),
        ),
      ),
    );
  }

  void _showVideoGallery(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => MediaViewer(
          items: const [
            MediaItem.videoUrl(
              'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
            ),
            MediaItem.videoUrl(
              'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4',
            ),
          ],
          config: MediaViewerConfig(autoPlayVideo: true),
          onDismissed: () => Navigator.of(context).pop(),
        ),
      ),
    );
  }

  void _showGridGallery(BuildContext context) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const GridGalleryPage()));
  }

  void _showArrowsGallery(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => MediaViewer(
          items: [
            const MediaItem.imageUrl('https://picsum.photos/800/600?random=60'),
            const MediaItem.imageUrl('https://picsum.photos/800/600?random=61'),
            const MediaItem.imageUrl('https://picsum.photos/800/600?random=62'),
            const MediaItem.imageUrl('https://picsum.photos/800/600?random=63'),
          ],
          config: const MediaViewerConfig(
            showNavigationArrows: true,
            navigationArrowsPosition: NavigationArrowsPosition.centerVertical,
            arrowsColor: Colors.white,
            arrowsSize: 40,
          ),
          onDismissed: () => Navigator.of(context).pop(),
        ),
      ),
    );
  }

  void _showBackButtonGallery(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => MediaViewer(
          items: [
            const MediaItem.imageUrl('https://picsum.photos/800/600?random=70'),
            const MediaItem.imageUrl('https://picsum.photos/800/600?random=71'),
            const MediaItem.imageUrl('https://picsum.photos/800/600?random=72'),
          ],
          config: const MediaViewerConfig(
            showBackButton: true,
            backButtonColor: Colors.white,
          ),
          onDismissed: () => Navigator.of(context).pop(),
        ),
      ),
    );
  }

  void _showDismissibleGallery(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => MediaViewer(
          items: [
            const MediaItem.imageUrl('https://picsum.photos/800/600?random=80'),
            const MediaItem.imageUrl('https://picsum.photos/800/600?random=81'),
            const MediaItem.imageUrl('https://picsum.photos/800/600?random=82'),
          ],
          config: const MediaViewerConfig(
            enableDismissOnSwipeDown: true,
            showIndicator: true,
            indicatorPosition: IndicatorPosition.bottomCenter,
          ),
          onDismissed: () => Navigator.of(context).pop(),
        ),
      ),
    );
  }

  void _showFullFeaturedGallery(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => MediaViewer(
          items: [
            const MediaItem.imageUrl('https://picsum.photos/800/600?random=90'),
            const MediaItem.videoUrl(
              'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
            ),
            const MediaItem.imageUrl('https://picsum.photos/800/600?random=91'),
            const MediaItem.videoUrl(
              'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4',
            ),
          ],
          config: MediaViewerConfig(
            showNavigationArrows: true,
            showBackButton: true,
            enableDismissOnSwipeDown: true,
            showIndicator: true,
            indicatorPosition: IndicatorPosition.topCenter,
            indicatorStyle: IndicatorStyle(
              backgroundColor: Colors.black54,
              borderRadius: 16,
            ),
            autoPlayVideo: true,
            navigationArrowsPosition: NavigationArrowsPosition.centerVertical,
          ),
          onDismissed: () => Navigator.of(context).pop(),
        ),
      ),
    );
  }

  void _showAutoDetectionGallery(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => MediaViewer(
          items: [
            // Images - automatically detected from extension
            MediaItem.url('https://picsum.photos/800/600?random=1.jpg'),
            MediaItem.url('https://picsum.photos/800/600?random=2.png'),
            MediaItem.url('https://picsum.photos/800/600?random=3.jpeg'),
            // Video - automatically detected from extension
            MediaItem.url(
              'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4',
            ),
            MediaItem.url('https://www.youtube.com/watch?v=dQw4w9WgXcQ'),
            MediaItem.url('https://picsum.photos/800/600?random=4.webp'),
            MediaItem.url('https://picsum.photos/800/600?random=5.jpg'),

            // Mix with images
          ],
          config: MediaViewerConfig(
            enableAutoDetectMediaType: true,
            showNavigationArrows: true,
            showBackButton: true,
            backButtonPadding: const EdgeInsets.only(top: 40, left: 12),
            enableDismissOnSwipeDown: true,
            indicatorPosition: IndicatorPosition.topCenter,
            indicatorStyle: const IndicatorStyle(
              backgroundColor: Colors.black54,
              borderRadius: 16,
            ),
          ),
          onDismissed: () => Navigator.of(context).pop(),
        ),
      ),
    );
  }

  void _showYouTubeGallery(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => MediaViewer(
          items: [
            // YouTube video starting from the beginning
            MediaItem.youtubeUrl('https://www.youtube.com/watch?v=dQw4w9WgXcQ'),
            // Mix with images
            const MediaItem.imageUrl(
              'https://picsum.photos/800/600?random=100',
            ),
            // YouTube video with start time at 90 seconds (1min30s)
            MediaItem.youtubeUrl(
              'https://www.youtube.com/watch?v=dQw4w9WgXcQ&t=90',
            ),
            // Another YouTube video (short URL format with start time)
            MediaItem.youtubeUrl('https://youtu.be/9bZkp7q19f0?t=30'),
            // Regular video
            const MediaItem.videoUrl(
              'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
            ),
            // Another image
            const MediaItem.imageUrl(
              'https://picsum.photos/800/600?random=101',
            ),
          ],
          config: MediaViewerConfig(
            autoPlayVideo: true,
            allowFullScreen: true,
            showBackButton: true,
            showNavigationArrows: true,
            enableDismissOnSwipeDown: true,
            indicatorPosition: IndicatorPosition.topCenter,
            indicatorStyle: const IndicatorStyle(
              backgroundColor: Colors.black54,
              borderRadius: 16,
            ),
          ),
          onDismissed: () => Navigator.of(context).pop(),
        ),
      ),
    );
  }
}

class GridGalleryPage extends StatelessWidget {
  const GridGalleryPage({super.key});

  static final List<MediaItem> _mediaItems = [
    const MediaItem.imageUrl(
      'https://picsum.photos/800/600?random=40',
      tag: 'hero_40',
    ),
    const MediaItem.imageUrl(
      'https://picsum.photos/800/600?random=41',
      tag: 'hero_41',
    ),
    const MediaItem.imageUrl(
      'https://picsum.photos/800/600?random=42',
      tag: 'hero_42',
    ),
    const MediaItem.imageUrl(
      'https://picsum.photos/800/600?random=43',
      tag: 'hero_43',
    ),
    const MediaItem.imageUrl(
      'https://picsum.photos/800/600?random=44',
      tag: 'hero_44',
    ),
    const MediaItem.imageUrl(
      'https://picsum.photos/800/600?random=45',
      tag: 'hero_45',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Grid Gallery')),
      body: GridView.builder(
        padding: const EdgeInsets.all(8),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
        ),
        itemCount: _mediaItems.length,
        itemBuilder: (context, index) {
          final item = _mediaItems[index];
          return GestureDetector(
            onTap: () => _openViewer(context, index),
            child: Hero(
              tag: '${item.tag}_media_viewer',
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  image: DecorationImage(
                    image: NetworkImage(item.url!),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _openViewer(BuildContext context, int index) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => MediaViewer(
          items: _mediaItems,
          initialIndex: index,
          onDismissed: () => Navigator.of(context).pop(),
        ),
      ),
    );
  }
}
