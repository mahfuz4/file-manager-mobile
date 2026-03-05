import 'r2_service.dart';

class R2ThumbnailService {
  static const int thumbnailSize = 200;
  
  final R2Service _r2Service;
  
  R2ThumbnailService(this._r2Service);
  
  String getThumbnailUrl(String key) {
    return _r2Service.generatePresignedUrl(key, expirySeconds: 3600);
  }
  
  String getPreviewUrl(String key, {int expirySeconds = 3600}) {
    return _r2Service.generatePresignedUrl(key, expirySeconds: expirySeconds);
  }
}