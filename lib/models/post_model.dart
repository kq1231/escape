enum PostType { article, video, podcast, link, text }

class Author {
  final String id;
  final String name;
  final String? avatarUrl;
  final String? bio;

  const Author({
    required this.id,
    required this.name,
    this.avatarUrl,
    this.bio,
  });

  factory Author.fromMap(Map<String, dynamic> map) {
    return Author(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      avatarUrl: map['avatar_url'],
      bio: map['bio'],
    );
  }

  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name, 'avatar_url': avatarUrl, 'bio': bio};
  }
}

class Post {
  final String id;
  final String title;
  final String? content;
  final String? slug;
  final PostType postType;
  final String? featuredImageUrl;
  final String? videoUrl;
  final String? audioUrl;
  final String? externalLink;
  final List<String> tags;
  final int? readingTime;
  final int? duration;
  final int viewsCount;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isPublished;
  final String? excerpt;
  final Author? author;

  const Post({
    required this.id,
    required this.title,
    this.content,
    this.slug,
    required this.postType,
    this.featuredImageUrl,
    this.videoUrl,
    this.audioUrl,
    this.externalLink,
    this.tags = const [],
    this.readingTime,
    this.duration,
    this.viewsCount = 0,
    required this.createdAt,
    required this.updatedAt,
    this.isPublished = true,
    this.excerpt,
    this.author,
  });

  factory Post.fromMap(Map<String, dynamic> map) {
    return Post(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      content: map['content'],
      slug: map['slug'],
      postType: PostType.values.firstWhere(
        (type) => type.name == map['post_type'],
        orElse: () => PostType.article,
      ),
      featuredImageUrl: map['featured_image_url'],
      videoUrl: map['video_url'],
      audioUrl: map['audio_url'],
      externalLink: map['external_link'],
      tags: List<String>.from(map['tags'] ?? []),
      readingTime: map['reading_time'],
      duration: map['duration'],
      viewsCount: map['views_count'] ?? 0,
      createdAt: DateTime.parse(
        map['created_at'] ?? DateTime.now().toIso8601String(),
      ),
      updatedAt: DateTime.parse(
        map['updated_at'] ?? DateTime.now().toIso8601String(),
      ),
      isPublished: map['is_published'] ?? true,
      excerpt: map['excerpt'],
      author: map['author'] != null ? Author.fromMap(map['author']) : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'slug': slug,
      'post_type': postType.name,
      'featured_image_url': featuredImageUrl,
      'video_url': videoUrl,
      'audio_url': audioUrl,
      'external_link': externalLink,
      'tags': tags,
      'reading_time': readingTime,
      'duration': duration,
      'views_count': viewsCount,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'is_published': isPublished,
      'excerpt': excerpt,
      'author': author?.toMap(),
    };
  }

  Post copyWith({
    String? id,
    String? title,
    String? content,
    String? slug,
    PostType? postType,
    String? featuredImageUrl,
    String? videoUrl,
    String? audioUrl,
    String? externalLink,
    List<String>? tags,
    int? readingTime,
    int? duration,
    int? viewsCount,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isPublished,
    String? excerpt,
    Author? author,
  }) {
    return Post(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      slug: slug ?? this.slug,
      postType: postType ?? this.postType,
      featuredImageUrl: featuredImageUrl ?? this.featuredImageUrl,
      videoUrl: videoUrl ?? this.videoUrl,
      audioUrl: audioUrl ?? this.audioUrl,
      externalLink: externalLink ?? this.externalLink,
      tags: tags ?? this.tags,
      readingTime: readingTime ?? this.readingTime,
      duration: duration ?? this.duration,
      viewsCount: viewsCount ?? this.viewsCount,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isPublished: isPublished ?? this.isPublished,
      excerpt: excerpt ?? this.excerpt,
      author: author ?? this.author,
    );
  }

  @override
  String toString() {
    return 'Post(id: $id, title: $title, postType: $postType)';
  }
}

class PostPreview {
  final String id;
  final String title;
  final String? excerpt;
  final PostType postType;
  final String? featuredImageUrl;
  final String? videoUrl;
  final String? audioUrl;
  final List<String> tags;
  final int? readingTime;
  final int? duration;
  final int viewsCount;
  final DateTime createdAt;
  final Author? author;

  const PostPreview({
    required this.id,
    required this.title,
    this.excerpt,
    required this.postType,
    this.featuredImageUrl,
    this.videoUrl,
    this.audioUrl,
    this.tags = const [],
    this.readingTime,
    this.duration,
    this.viewsCount = 0,
    required this.createdAt,
    this.author,
  });

  factory PostPreview.fromPost(Post post) {
    return PostPreview(
      id: post.id,
      title: post.title,
      excerpt: post.excerpt,
      postType: post.postType,
      featuredImageUrl: post.featuredImageUrl,
      videoUrl: post.videoUrl,
      audioUrl: post.audioUrl,
      tags: post.tags,
      readingTime: post.readingTime,
      duration: post.duration,
      viewsCount: post.viewsCount,
      createdAt: post.createdAt,
      author: post.author,
    );
  }

  factory PostPreview.fromMap(Map<String, dynamic> map) {
    return PostPreview(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      excerpt: map['excerpt'],
      postType: PostType.values.firstWhere(
        (type) => type.name == map['post_type'],
        orElse: () => PostType.article,
      ),
      featuredImageUrl: map['featured_image_url'],
      videoUrl: map['video_url'],
      audioUrl: map['audio_url'],
      tags: List<String>.from(map['tags'] ?? []),
      readingTime: map['reading_time'],
      duration: map['duration'],
      viewsCount: map['views_count'] ?? 0,
      createdAt: DateTime.parse(
        map['created_at'] ?? DateTime.now().toIso8601String(),
      ),
      author: map['author'] != null ? Author.fromMap(map['author']) : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'excerpt': excerpt,
      'post_type': postType.name,
      'featured_image_url': featuredImageUrl,
      'video_url': videoUrl,
      'audio_url': audioUrl,
      'tags': tags,
      'reading_time': readingTime,
      'duration': duration,
      'views_count': viewsCount,
      'created_at': createdAt.toIso8601String(),
      'author': author?.toMap(),
    };
  }

  PostPreview copyWith({
    String? id,
    String? title,
    String? excerpt,
    PostType? postType,
    String? featuredImageUrl,
    String? videoUrl,
    String? audioUrl,
    List<String>? tags,
    int? readingTime,
    int? duration,
    int? viewsCount,
    DateTime? createdAt,
    Author? author,
  }) {
    return PostPreview(
      id: id ?? this.id,
      title: title ?? this.title,
      excerpt: excerpt ?? this.excerpt,
      postType: postType ?? this.postType,
      featuredImageUrl: featuredImageUrl ?? this.featuredImageUrl,
      videoUrl: videoUrl ?? this.videoUrl,
      audioUrl: audioUrl ?? this.audioUrl,
      tags: tags ?? this.tags,
      readingTime: readingTime ?? this.readingTime,
      duration: duration ?? this.duration,
      viewsCount: viewsCount ?? this.viewsCount,
      createdAt: createdAt ?? this.createdAt,
      author: author ?? this.author,
    );
  }

  @override
  String toString() {
    return 'PostPreview(id: $id, title: $title, postType: $postType)';
  }
}
