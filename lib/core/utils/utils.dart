String fixImageUrl(String? url) {
  if (url == null || url.isEmpty) return '';
  if (url.startsWith('http://localhost')) {
    return url.replaceFirst('http://localhost', 'http://10.0.2.2');
  }
  return url;
}
