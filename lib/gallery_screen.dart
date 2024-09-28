import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'gallery_provider.dart';
import 'package:cached_network_image/cached_network_image.dart';

class GalleryScreen extends StatefulWidget {
  const GalleryScreen({super.key});

  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    final provider = Provider.of<GalleryProvider>(context, listen: false);
    provider.fetchImages();

    _scrollController = ScrollController();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent &&
          !provider.isLoading) {
        provider.fetchImages();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pixabay Flowers Gallery'),
        centerTitle: true,
      ),
      body: Consumer<GalleryProvider>(
        builder: (context, provider, child) {
          return GridView.builder(
            controller: _scrollController,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: (MediaQuery.of(context).size.width / 200).floor(),
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              childAspectRatio: 1,
            ),
            itemCount: provider.images.length + (provider.isLoading ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == provider.images.length) {
                return const Center(child: CircularProgressIndicator());
              }

              final image = provider.images[index];
              return Card(
                child: Column(
                  children: [
                    Expanded(
                      child: CachedNetworkImage(
                        imageUrl: image['webformatURL'],
                        fit: BoxFit.cover,
                        placeholder: (context, url) =>
                            const Center(child: CircularProgressIndicator()),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Likes: ${image['likes']}'),
                          Text('Views: ${image['views']}'),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
