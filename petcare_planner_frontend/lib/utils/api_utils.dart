class ApiUtils {
  static String getFullImageUrl(String path) {
    if (path.startsWith('http')) return path;

    const host = 'localhost';

    return 'http://$host:3000/$path';
  }
}
