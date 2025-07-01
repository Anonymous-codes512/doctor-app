import 'package:doctor_app/core/assets/colors/app_colors.dart';
import 'package:doctor_app/core/constants/approutes/approutes.dart';
import 'package:doctor_app/presentation/widgets/chat_item_widget.dart';
import 'package:doctor_app/presentation/widgets/custom_search_widget.dart';
import 'package:doctor_app/presentation/widgets/custom_tabs_widget.dart';
import 'package:doctor_app/presentation/widgets/empty_state_widget.dart';
import 'package:doctor_app/presentation/widgets/search_screen_widget.dart';
import 'package:doctor_app/provider/chat_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MessageHomeScreen extends StatefulWidget {
  const MessageHomeScreen({super.key});

  @override
  State<MessageHomeScreen> createState() => _MessageHomeScreenState();
}

class _MessageHomeScreenState extends State<MessageHomeScreen> {
  final TextEditingController mySearchController = TextEditingController();

  int selectedIndex = 0;
  late PageController _pageController;
  @override
  void initState() {
    super.initState();
    _pageController = PageController();

    // ✅ Call conversation loading on screen open
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ChatProvider>(context, listen: false).loadConversations();
    });
  }

  @override
  void dispose() {
    mySearchController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void onTabTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void onPageChanged(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final chatProvider = Provider.of<ChatProvider>(context);
    final conversations = chatProvider.conversations;
    final isLoading = chatProvider.isLoading;

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundColor,
        centerTitle: true,
        title: Text(
          "Messages",
          style: TextStyle(
            color: AppColors.textColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.menu))],
      ),
      body: Column(
        children: [
          SearchBarWithAddButton(
            controller: mySearchController,
            onAddPressed: () async {
              final users =
                  await Provider.of<ChatProvider>(
                    context,
                    listen: false,
                  ).fetchUsersForNewChat();
              Navigator.pushNamed(
                context,
                Routes.chatListScreen,
                arguments: users,
              );
            },
            onChanged: (value) => print('Search text: $value'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SearchScreen()),
              );
            },
          ),
          const SizedBox(height: 10),
          CustomTabs(
            tabs: ["All chats", "Favorites", "Groups", "Former"],
            selectedIndex: selectedIndex,
            onTabSelected: onTabTapped,
          ),
          Expanded(
            child:
                isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : conversations.isEmpty
                    ? const EmptyState(text: 'You have no messages yet')
                    : ListView.builder(
                      itemCount: conversations.length,
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      itemBuilder: (context, index) {
                        final convo = conversations[index];
                        return ChatItem(
                          userName: convo['name'] ?? 'Unknown',
                          messagePreview: convo['last_message'] ?? '',
                          time: convo['last_time'] ?? '',
                          unreadCount: convo['unread_count'] ?? 0,
                          avatarUrl: convo['avatar'] ?? '',
                          isOnline: convo['is_online'] ?? false,
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              Routes.chatScreen,
                              arguments: convo,
                            );
                          },
                        );
                      },
                    ),
          ),
        ],
      ),
    );
  }
}
