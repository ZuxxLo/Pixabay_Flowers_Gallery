import 'package:flutter/material.dart';
import 'pixabay_api_service.dart';

class GalleryProvider extends ChangeNotifier {
  final PixabayApiService _apiService = PixabayApiService();
  final List<dynamic> _images = [];
  bool _isLoading = false;
  int _page = 1;

  List<dynamic> get images => _images;
  bool get isLoading => _isLoading;

  Future<void> fetchImages() async {
    if (_isLoading) return;

    _isLoading = true;

    try {
      final newImages = await _apiService.fetchImages(page: _page, perPage: 30);
      _images.addAll(newImages);
      _page++;
    } catch (e) {
      print(e);
    } finally {
      _isLoading = false;
    }
    notifyListeners();
  }
}
