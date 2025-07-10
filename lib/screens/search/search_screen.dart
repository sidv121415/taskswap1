import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/app_provider.dart';
import '../../models/user.dart';
import '../../utils/theme.dart';
import '../../widgets/user_card.dart';
import '../../widgets/custom_text_field.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _searchController = TextEditingController();
  List<User> _searchResults = [];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchResults = context.read<AppProvider>().searchUsers(query);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Find People'),
        backgroundColor: AppTheme.surfaceColor,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              context.read<AppProvider>().logout();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Header
          Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              color: AppTheme.surfaceColor,
              border: Border(
                bottom: BorderSide(
                  color: Color(0xFFE5E7EB),
                  width: 1,
                ),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Search for users to connect and exchange tasks',
                  style: TextStyle(
                    color: AppTheme.textSecondary,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  controller: _searchController,
                  hintText: 'Search by username or name...',
                  prefixIcon: Icons.search,
                  onChanged: _onSearchChanged,
                ),
              ],
            ),
          ),

          // Search Results
          Expanded(
            child: _searchController.text.isEmpty
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search,
                          size: 64,
                          color: AppTheme.textTertiary,
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Start typing to search for users',
                          style: TextStyle(
                            color: AppTheme.textSecondary,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  )
                : _searchResults.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.search_off,
                              size: 64,
                              color: AppTheme.textTertiary,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'No users found matching "${_searchController.text}"',
                              style: const TextStyle(
                                color: AppTheme.textSecondary,
                                fontSize: 16,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(20),
                        itemCount: _searchResults.length,
                        itemBuilder: (context, index) {
                          final user = _searchResults[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: UserCard(
                              user: user,
                              showConnectButton: true,
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}