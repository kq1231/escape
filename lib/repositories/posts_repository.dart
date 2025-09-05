import 'package:escape/env.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/post_model.dart';
part 'posts_repository.g.dart';

// Keep alive so that we don't reinitialize Supabase client again and again
// unnecessarily.
@Riverpod(keepAlive: true)
class PostsRepository extends _$PostsRepository {
  late SupabaseClient _supabase;

  @override
  Future<bool> build() async {
    await Supabase.initialize(
      url: Env.supabaseUrl,
      anonKey: Env.supabaseAnonKey,
    );
    _supabase = Supabase.instance.client;

    return true;
  }

  // Get latest posts with pagination and filtering
  Future<List<PostPreview>> getLatestPosts({
    int limit = 10,
    int offset = 0,
    PostType? filter,
    String? searchQuery,
  }) async {
    await future;
    try {
      var query = _supabase.from('posts').select('''
      id,
      title,
      post_type,
      featured_image_url,
      video_url,
      audio_url,
      tags,
      reading_time,
      duration,
      views_count,
      created_at,
      user_profiles (
        id,
        display_name,
        avatar_url,
        bio
      )
    ''');

      if (filter != null) {
        query = query.eq('post_type', filter.name);
      }

      if (searchQuery != null && searchQuery.isNotEmpty) {
        query = query.or("title.ilike.%$searchQuery%,tags.cs.{$searchQuery}");
      }

      // Apply ordering and pagination - FIXED: Remove cascade operators
      query = query..order('created_at', ascending: false);
      query = query..range(offset, offset + limit - 1);

      final response = await query;

      if (response.isEmpty) {
        return [];
      }

      return response.map((map) => PostPreview.fromMap(map)).toList();
      // Removed unnecessary .cast<PostPreview>() since map already returns PostPreview
    } catch (e) {
      throw Exception('Failed to fetch posts: $e');
    }
  }

  // Get single post with view increment using PostgreSQL function
  Future<Post> getPostWithViewIncrement(String postId) async {
    await future;

    try {
      // Call the PostgreSQL function
      final response = await _supabase
          .rpc('get_post_with_view_increment', params: {'post_uuid': postId})
          .select()
          .single();
      // Convert the response to our Post model
      return Post.fromMap(response);
    } catch (e) {
      throw Exception('Failed to fetch post: $e');
    }
  }

  // Get post by slug
  Future<Post> getPostBySlug(String slug) async {
    try {
      final response = await _supabase
          .from('posts')
          .select('''
            *,
            user_profiles (
              id,
              display_name,
              avatar_url,
              bio
            )
          ''')
          .eq('slug', slug)
          .single();
      return Post.fromMap(response);
    } catch (e) {
      throw Exception('Failed to fetch post by slug: $e');
    }
  }

  // Get posts by tag
  Future<List<PostPreview>> getPostsByTag({
    required String tag,
    int limit = 10,
    int offset = 0,
  }) async {
    await future;

    try {
      final response = await _supabase
          .from('posts')
          .select('''
            id,
            title,
            post_type,
            featured_image_url,
            video_url,
            audio_url,
            tags,
            reading_time,
            duration,
            views_count,
            created_at,
            user_profiles (
              display_name,
              avatar_url
            )
          ''')
          .contains('tags', tag)
          .order('created_at', ascending: false)
          .range(offset, offset + limit - 1);
      if (response.isEmpty) {
        return [];
      }
      return response.map((map) => PostPreview.fromMap(map)).toList();
    } catch (e) {
      throw Exception('Failed to fetch posts by tag: $e');
    }
  }

  // Get posts by author
  Future<List<PostPreview>> getPostsByAuthor({
    required String authorId,
    int limit = 10,
    int offset = 0,
  }) async {
    await future;

    try {
      final response = await _supabase
          .from('posts')
          .select('''
            id,
            title,
            post_type,
            featured_image_url,
            video_url,
            audio_url,
            tags,
            reading_time,
            duration,
            views_count,
            created_at,
            user_profiles (
              display_name,
              avatar_url
            )
          ''')
          .eq('user_id', authorId)
          .order('created_at', ascending: false)
          .range(offset, offset + limit - 1);
      if (response.isEmpty) {
        return [];
      }
      return response.map((map) => PostPreview.fromMap(map)).toList();
    } catch (e) {
      throw Exception('Failed to fetch posts by author: $e');
    }
  }

  // Get popular posts (by view count)
  Future<List<PostPreview>> getPopularPosts({
    int limit = 10,
    PostType? filter,
  }) async {
    await future;

    try {
      final query = _supabase
          .from('posts')
          .select('''
            id,
            title,
            post_type,
            featured_image_url,
            video_url,
            audio_url,
            tags,
            reading_time,
            duration,
            views_count,
            created_at,
            user_profiles (
              display_name,
              avatar_url
            )
          ''')
          .order('views_count', ascending: false)
          .limit(limit);
      if (filter != null) {
        query.appendSearchParams('post_type', filter.name);
      }
      final response = await query;
      if (response.isEmpty) {
        return [];
      }
      return response.map((map) => PostPreview.fromMap(map)).toList();
    } catch (e) {
      throw Exception('Failed to fetch popular posts: $e');
    }
  }

  // Get related posts (by tags)
  Future<List<PostPreview>> getRelatedPosts({
    required String postId,
    int limit = 5,
  }) async {
    await future;

    try {
      // First get the current post's tags
      final currentPost = await _supabase
          .from('posts')
          .select('tags')
          .eq('id', postId)
          .single();
      if (currentPost.isEmpty || currentPost['tags'] == null) {
        return [];
      }
      final tags = List<String>.from(currentPost['tags']);
      if (tags.isEmpty) {
        return [];
      }
      // Get posts with similar tags (excluding the current post)
      final response = await _supabase
          .from('posts')
          .select('''
            id,
            title,
            post_type,
            featured_image_url,
            video_url,
            audio_url,
            tags,
            reading_time,
            duration,
            views_count,
            created_at,
            user_profiles (
              display_name,
              avatar_url
            )
          ''')
          .neq('id', postId)
          .contains('tags', tags.first) // Use first tag for simplicity
          .order('created_at', ascending: false)
          .limit(limit);
      if (response.isEmpty) {
        return [];
      }
      return response.map((map) => PostPreview.fromMap(map)).toList();
    } catch (e) {
      throw Exception('Failed to fetch related posts: $e');
    }
  }
}
