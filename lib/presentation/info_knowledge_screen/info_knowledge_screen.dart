import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../theme/app_theme.dart';
import '../../widgets/custom_icon_widget.dart';
import '../article_detail_view/article_detail_view.dart';
import './widgets/article_card_widget.dart';
import './widgets/category_tab_widget.dart';

class InfoKnowledgeScreen extends StatefulWidget {
  const InfoKnowledgeScreen({super.key});

  @override
  State<InfoKnowledgeScreen> createState() => _InfoKnowledgeScreenState();
}

class _InfoKnowledgeScreenState extends State<InfoKnowledgeScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  List<String> categories = [];
  Map<String, List<Map<String, dynamic>>> articlesByCategory = {};
  String _selectedLanguage = 'en';

  @override
  void initState() {
    super.initState();
    _loadHealthInfo();
  }

  Future<void> _loadHealthInfo() async {
    final String response = await rootBundle.loadString(
      'assets/health_info.json',
    );
    final data = await json.decode(response);
    setState(() {
      articlesByCategory = {
        for (var category in data[_selectedLanguage].keys)
          data[_selectedLanguage][category]['title']:
              List<Map<String, dynamic>>.from(
                data[_selectedLanguage][category]['questions'],
              ),
      };
      categories = articlesByCategory.keys.toList();
      _tabController = TabController(length: categories.length, vsync: this);
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.colorScheme.surface,
      appBar: AppBar(
        title: Text(
          'Info & Knowledge',
          style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          PopupMenuButton<String>(
            onSelected: (String value) {
              setState(() {
                _selectedLanguage = value;
                _loadHealthInfo();
              });
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(value: 'en', child: Text('English')),
              const PopupMenuItem<String>(value: 'bn', child: Text('বাংলা')),
            ],
          ),
        ],
      ),
      body: categories.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                CategoryTabWidget(
                  tabController: _tabController,
                  categories: categories,
                ),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: categories.map((category) {
                      return _buildArticleList(category);
                    }).toList(),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildArticleList(String category) {
    final articles = articlesByCategory[category] ?? [];

    return RefreshIndicator(
      onRefresh: () async {
        // Simulate refresh
        await Future.delayed(const Duration(seconds: 1));
      },
      color: AppTheme.lightTheme.colorScheme.primary,
      child: articles.isEmpty
          ? _buildEmptyState()
          : ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
              itemCount: articles.length,
              itemBuilder: (context, index) {
                final article = articles[index];
                return ArticleCardWidget(
                  title: article['question'],
                  iconName: 'info',
                  description: '',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ArticleDetailView(
                          question: article['question'],
                          answer: article['answer'],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomIconWidget(
            iconName: 'article',
            size: 64,
            color: AppTheme.lightTheme.colorScheme.onSurface.withAlpha(102),
          ),
          SizedBox(height: 2.h),
          Text(
            'No articles available',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurface.withAlpha(153),
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            'Check back later for new content',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurface.withAlpha(102),
            ),
          ),
        ],
      ),
    );
  }
}
