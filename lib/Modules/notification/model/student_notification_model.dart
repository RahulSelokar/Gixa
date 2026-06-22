class StudentNotificationResponse {
  final bool ok;
  final int count;
  final int page;
  final int totalPages;
  final bool hasNext;
  final bool hasPrevious;
  final List<StudentNotification> results;

  const StudentNotificationResponse({
    required this.ok,
    required this.count,
    required this.page,
    required this.totalPages,
    required this.hasNext,
    required this.hasPrevious,
    required this.results,
  });

  factory StudentNotificationResponse.fromJson(Map<String, dynamic> json) {
    final rawResults = _extractNotificationItems(json);
    final parsedResults = rawResults
        .whereType<Map>()
        .map(
          (item) =>
              StudentNotification.fromJson(Map<String, dynamic>.from(item)),
        )
        .toList();

    return StudentNotificationResponse(
      ok: json['ok'] ?? false,

      count: json['count'] is int
          ? json['count'] as int
          : int.tryParse(json['count']?.toString() ?? '') ?? 0,

      page: json['page'] is int
          ? json['page'] as int
          : int.tryParse(json['page']?.toString() ?? '') ?? 1,

      totalPages: json['total_pages'] is int
          ? json['total_pages'] as int
          : int.tryParse(json['total_pages']?.toString() ?? '') ?? 1,

      hasNext: json['has_next'] ?? false,

      hasPrevious: json['has_previous'] ?? false,

      results: parsedResults,
    );
  }

  static List<dynamic> _extractNotificationItems(Map<String, dynamic> json) {
    final candidates = [
      json['results'],
      json['notifications'],
      json['data'],
      json['items'],
    ];

    for (final candidate in candidates) {
      if (candidate is List) {
        return candidate;
      }

      if (candidate is Map<String, dynamic>) {
        final nestedCandidates = [
          candidate['results'],
          candidate['notifications'],
          candidate['data'],
          candidate['items'],
        ];

        for (final nested in nestedCandidates) {
          if (nested is List) {
            return nested;
          }
        }
      }
    }

    if (json.values.any((value) => value is List)) {
      return json.values.firstWhere((value) => value is List) as List<dynamic>;
    }

    return const [];
  }
}

class StudentNotification {
  final int id;
  final String source;
  final String sourceUrl;
  final String title;
  final String body;
  final String link;
  final String attachment;
  final DateTime? createdAt;
  final bool isRead;

  const StudentNotification({
    required this.id,
    required this.source,
    required this.sourceUrl,
    required this.title,
    required this.body,
    required this.link,
    required this.attachment,
    required this.createdAt,
    required this.isRead,
  });

  factory StudentNotification.fromJson(Map<String, dynamic> json) {
    String resolveTitle(Map<String, dynamic> j) {
      final candidates = [
        j['headline'],
        j['title'],
        j['message'],
        j['body'],
        j['description'],
        j['text'],
      ];

      for (final c in candidates) {
        if (c != null) {
          final s = c.toString().trim();
          if (s.isNotEmpty) return s;
        }
      }
      return '';
    }

    String resolveBody(Map<String, dynamic> j) {
      final candidates = [
        j['notification_text'],
        j['body'],
        j['message'],
        j['description'],
        j['text'],
        j['content'],
      ];

      for (final c in candidates) {
        if (c != null) {
          final s = c.toString().trim();
          if (s.isNotEmpty) return s;
        }
      }
      return '';
    }

    String resolveSource(Map<String, dynamic> j) {
      final candidates = [
        j['source'],
        j['source_name'],
        j['from'],
        j['sender'],
      ];
      for (final c in candidates) {
        if (c != null) {
          final s = c.toString().trim();
          if (s.isNotEmpty) return s;
        }
      }
      return '';
    }

    return StudentNotification(
      id: json['id'] is int
          ? json['id'] as int
          : int.tryParse(json['id']?.toString() ?? '') ?? 0,

      source: resolveSource(json),
      sourceUrl: (json['source_url'] ?? '').toString(),
      title: resolveTitle(json),
      body: resolveBody(json),
      link: (json['link'] ?? '').toString(),
      attachment: (json['attachment'] ?? '').toString(),
      createdAt: _parseDateTime(json['created_at']),
      isRead: json['is_read'] == true || json['read'] == true,
    );
  }

  String get bodyText {
    final bodyValue = body.trim();
    if (bodyValue.isNotEmpty) return bodyValue;

    final titleValue = title.trim();
    if (titleValue.isNotEmpty) return titleValue;

    return source.trim();
  }

  static DateTime? _parseDateTime(dynamic value) {
    final raw = value?.toString().trim();

    if (raw == null || raw.isEmpty) {
      return null;
    }

    return DateTime.tryParse(raw);
  }
}
