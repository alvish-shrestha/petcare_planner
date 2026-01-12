class UserApiUtils {
  static String getFullImageUrl(String path) {
    if (path.startsWith('http')) return path;

    // const host = 'localhost';
    const host = '192.168.1.71';

    return 'http://$host:3000$path';
  }
}
