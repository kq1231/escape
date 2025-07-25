import 'package:flutter/material.dart';
import '../../onboarding/constants/onboarding_theme.dart';
import '../atoms/media_tag.dart';
import '../molecules/article_card.dart';
import '../molecules/video_card.dart';
import '../templates/media_feed.dart';

class MediaScreen extends StatefulWidget {
  const MediaScreen({super.key});

  @override
  State<MediaScreen> createState() => _MediaScreenState();
}

class _MediaScreenState extends State<MediaScreen> {
  List<Widget> _allItems = [];
  List<Widget> _articleItems = [];
  List<Widget> _videoItems = [];
  String _selectedCategory = 'All';

  @override
  void initState() {
    super.initState();
    _initializeMediaContent();
  }

  void _initializeMediaContent() {
    setState(() {
      // Article items
      _articleItems = [
        ArticleCard(
          title: 'Understanding Islamic Finance',
          imageUrl:
              'https://images.unsplash.com/photo-1579532536505-600b177b8e7a?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=600&q=80',
          excerpt:
              'Learn about the principles and practices of Islamic finance and how it differs from conventional banking.',
          tags: ['Finance', 'Education'],
          onTap: () {
            // Handle article tap
          },
        ),
        ArticleCard(
          title: 'The Importance of Salah in Daily Life',
          imageUrl:
              'https://images.unsplash.com/photo-1614023345100-00cd7c00c31e?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=600&q=80',
          excerpt:
              'Discover how regular prayer can bring peace and structure to your daily routine.',
          tags: ['Spirituality', 'Prayer'],
          onTap: () {
            // Handle article tap
          },
        ),
        ArticleCard(
          title: 'Building Strong Family Bonds in Islam',
          imageUrl:
              'https://images.unsplash.com/photo-1511895426328-dc8714191300?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=600&q=80',
          excerpt:
              'Explore the Islamic teachings on family relationships and how to strengthen them.',
          tags: ['Family', 'Relationships'],
          onTap: () {
            // Handle article tap
          },
        ),
        ArticleCard(
          title: 'Charity in Islam: Zakat and Sadaqah',
          imageUrl:
              'https://images.unsplash.com/photo-1516321318423-f06f85e504b3?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=600&q=80',
          excerpt:
              'Learn about the importance of giving in Islam and the different forms of charity.',
          tags: ['Charity', 'Zakat'],
          onTap: () {
            // Handle article tap
          },
        ),
      ];

      // Video items
      _videoItems = [
        VideoCard(
          title: 'Introduction to Ramadan',
          thumbnailUrl:
              'https://images.unsplash.com/photo-1614023345100-00cd7c00c31e?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=600&q=80',
          duration: '12:35',
          views: 12500,
          author: 'Islamic Learning Center',
          tags: ['Ramadan', 'Basics'],
          onTap: () {
            // Handle video tap
          },
        ),
        VideoCard(
          title: 'Hajj Preparation Guide',
          thumbnailUrl:
              'https://images.unsplash.com/photo-1579532536505-600b177b8e7a?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=600&q=80',
          duration: '24:18',
          views: 8900,
          author: 'Pilgrimage Experts',
          tags: ['Hajj', 'Guide'],
          onTap: () {
            // Handle video tap
          },
        ),
        VideoCard(
          title: 'Understanding the Quran: Surah Yasin',
          thumbnailUrl:
              'https://images.unsplash.com/photo-1611162617474-99bb5f1d4b9f?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=600&q=80',
          duration: '32:45',
          views: 15600,
          author: 'Quranic Studies',
          tags: ['Quran', 'Tafsir'],
          onTap: () {
            // Handle video tap
          },
        ),
        VideoCard(
          title: 'Dua for Difficult Times',
          thumbnailUrl:
              'https://images.unsplash.com/photo-1545239351-ef35f43d01b4?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=600&q=80',
          duration: '8:22',
          views: 9800,
          author: 'Spiritual Guidance',
          tags: ['Dua', 'Spirituality'],
          onTap: () {
            // Handle video tap
          },
        ),
      ];

      // All items
      _allItems = [..._articleItems, ..._videoItems];
    });
  }

  void _filterContent(String category) {
    setState(() {
      _selectedCategory = category;
      switch (category) {
        case 'Articles':
          _allItems = _articleItems;
          break;
        case 'Videos':
          _allItems = _videoItems;
          break;
        default:
          _allItems = [..._articleItems, ..._videoItems];
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Media', style: OnboardingTheme.headlineMedium),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // Handle search
            },
          ),
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              // Handle filter
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Category tags
            SizedBox(
              height: 50,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(
                  horizontal: OnboardingTheme.spacingM,
                ),
                children: [
                  MediaTag(
                    label: 'All',
                    backgroundColor: _selectedCategory == 'All'
                        ? OnboardingTheme.primaryGreen
                        : OnboardingTheme.lightGray,
                    textColor: _selectedCategory == 'All'
                        ? OnboardingTheme.white
                        : OnboardingTheme.darkGray,
                    onTap: () => _filterContent('All'),
                  ),
                  SizedBox(width: OnboardingTheme.spacingS),
                  MediaTag(
                    label: 'Articles',
                    backgroundColor: _selectedCategory == 'Articles'
                        ? OnboardingTheme.primaryGreen
                        : OnboardingTheme.lightGray,
                    textColor: _selectedCategory == 'Articles'
                        ? OnboardingTheme.white
                        : OnboardingTheme.darkGray,
                    onTap: () => _filterContent('Articles'),
                  ),
                  SizedBox(width: OnboardingTheme.spacingS),
                  MediaTag(
                    label: 'Videos',
                    backgroundColor: _selectedCategory == 'Videos'
                        ? OnboardingTheme.primaryGreen
                        : OnboardingTheme.lightGray,
                    textColor: _selectedCategory == 'Videos'
                        ? OnboardingTheme.white
                        : OnboardingTheme.darkGray,
                    onTap: () => _filterContent('Videos'),
                  ),
                  SizedBox(width: OnboardingTheme.spacingS),
                  MediaTag(
                    label: 'Podcasts',
                    backgroundColor: OnboardingTheme.lightGray,
                    textColor: OnboardingTheme.darkGray,
                    onTap: () {
                      // Handle podcast filter
                    },
                  ),
                  SizedBox(width: OnboardingTheme.spacingS),
                  MediaTag(
                    label: 'Courses',
                    backgroundColor: OnboardingTheme.lightGray,
                    textColor: OnboardingTheme.darkGray,
                    onTap: () {
                      // Handle courses filter
                    },
                  ),
                ],
              ),
            ),
            SizedBox(height: OnboardingTheme.spacingM),
            // Media feed
            MediaFeed(
              title: 'Latest Content',
              items: _allItems,
              onRefresh: () {
                // Handle refresh
              },
            ),
          ],
        ),
      ),
    );
  }
}
