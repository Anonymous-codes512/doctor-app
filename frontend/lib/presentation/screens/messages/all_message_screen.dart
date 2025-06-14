import 'package:doctor_app/core/assets/colors/app_colors.dart';
import 'package:doctor_app/presentation/screens/messages/chat_screen.dart';
import 'package:doctor_app/presentation/widgets/chat_item_widget.dart';
import 'package:doctor_app/presentation/widgets/custom_search_widget.dart';
import 'package:doctor_app/presentation/widgets/custom_tabs_widget.dart';
import 'package:doctor_app/presentation/widgets/empty_state_widget.dart';
import 'package:doctor_app/presentation/widgets/search_screen_widget.dart';
import 'package:flutter/material.dart';

class AllMessageScreen extends StatefulWidget {
  const AllMessageScreen({super.key});

  @override
  State<AllMessageScreen> createState() => _AllMessageScreenState();
}

class _AllMessageScreenState extends State<AllMessageScreen> {
  final TextEditingController mySearchController = TextEditingController();

  final List<String> tabTitles = ["All chats", "Favorites", "Groups", "Former"];
  int selectedIndex = 0;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
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
    // Sample chat data per tab (3 chats each)
    final chatsPerTab = [
      [
        ChatItem(
          userName: "Darlene Steward",
          messagePreview: "Pls take a look at the images.",
          time: "18:31",
          unreadCount: 5,
          avatarUrl: "https://i.pravatar.cc/150?img=1",
          isOnline: true,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ChatScreen()),
            );
          },
        ),
        ChatItem(
          userName: "John Doe",
          messagePreview: "Got it, thanks!",
          time: "16:22",
          unreadCount: 0,
          avatarUrl: "https://i.pravatar.cc/150?img=2",
          isOnline: false,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ChatScreen()),
            );
          },
        ),
        ChatItem(
          userName: "Mary Smith",
          messagePreview: "Let's meet tomorrow.",
          time: "15:05",
          unreadCount: 2,
          avatarUrl: "https://i.pravatar.cc/150?img=3",
          isOnline: true,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ChatScreen()),
            );
          },
        ),
      ],
      // Favorites tab
      [
        ChatItem(
          userName: "Alice Johnson",
          messagePreview: "Call me when free.",
          time: "10:14",
          unreadCount: 1,
          avatarUrl: "https://i.pravatar.cc/150?img=4",
          isOnline: true,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ChatScreen()),
            );
          },
        ),
        ChatItem(
          userName: "Bob Martin",
          messagePreview: "Thanks for your help.",
          time: "09:45",
          unreadCount: 0,
          avatarUrl: "https://i.pravatar.cc/150?img=5",
          isOnline: false,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ChatScreen()),
            );
          },
        ),
        ChatItem(
          userName: "Cindy White",
          messagePreview: "Check the documents.",
          time: "08:30",
          unreadCount: 3,
          avatarUrl: "https://i.pravatar.cc/150?img=6",
          isOnline: true,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ChatScreen()),
            );
          },
        ),
      ],
      // Groups tab
      [
        ChatItem(
          userName: "Flutter Devs",
          messagePreview: "New update released!",
          time: "Yesterday",
          unreadCount: 10,
          avatarUrl: "https://i.pravatar.cc/150?img=7",
          isOnline: false,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ChatScreen()),
            );
          },
        ),
        ChatItem(
          userName: "Project Team",
          messagePreview: "Deadline is next week.",
          time: "Yesterday",
          unreadCount: 0,
          avatarUrl: "https://i.pravatar.cc/150?img=8",
          isOnline: false,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ChatScreen()),
            );
          },
        ),
        ChatItem(
          userName: "Book Club",
          messagePreview: "Meeting at 7pm.",
          time: "2 days ago",
          unreadCount: 7,
          avatarUrl: "https://i.pravatar.cc/150?img=9",
          isOnline: false,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ChatScreen()),
            );
          },
        ),
      ],
      [],
    ];

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
            onAddPressed: () => print('Add button pressed'),
            onChanged: (value) => print('Search text: $value'),
            onTap: () {
              // Jab user search bar pe click kare, tab ye chalega
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SearchScreen()),
              );
            },
          ),
          const SizedBox(height: 10),
          CustomTabs(
            tabs: tabTitles,
            selectedIndex: selectedIndex,
            onTabSelected: (index) {
              onTabTapped(index);
            },
          ),
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: tabTitles.length,
              onPageChanged: onPageChanged,
              itemBuilder: (context, index) {
                final chats = chatsPerTab[index];
                if (chats.isEmpty) {
                  return const EmptyState(text: 'You have no messages yet');
                }
                return ListView.builder(
                  itemCount: chats.length,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  itemBuilder: (context, chatIndex) {
                    return chats[chatIndex];
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
