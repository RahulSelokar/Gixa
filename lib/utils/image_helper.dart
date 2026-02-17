String fixImageUrl(String url) {
  if (url.isEmpty) return '';

  // Always normalize Unsplash URLs
  if (url.contains('images.unsplash.com')) {
    return '${url.split('?').first}?auto=format&fit=crop&w=800&q=80';
  }

  return url;
}
