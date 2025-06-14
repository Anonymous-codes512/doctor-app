import 'package:doctor_app/core/assets/colors/app_colors.dart';
import 'package:doctor_app/presentation/screens/voice/call_screen.dart';
import 'package:doctor_app/presentation/screens/voice/voice_detail_screen.dart';
import 'package:doctor_app/presentation/widgets/custom_search_widget.dart';
import 'package:doctor_app/presentation/widgets/custom_tabs_widget.dart';
import 'package:doctor_app/presentation/widgets/empty_state_widget.dart';
import 'package:doctor_app/presentation/widgets/search_screen_widget.dart';
import 'package:doctor_app/presentation/widgets/voice_call_item.dart';
import 'package:flutter/material.dart';

class AllVoiceCallScreen extends StatefulWidget {
  const AllVoiceCallScreen({super.key});

  @override
  State<AllVoiceCallScreen> createState() => _AllVoiceCallScreenState();
}

class _AllVoiceCallScreenState extends State<AllVoiceCallScreen> {
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
    final voiceCallsPerTab = [
      // Tab 1
      [
        VoiceCallItem(
          userName: "Darlene Steward",
          callTime: "July 08, 06:30 PM",
          callType: "Incoming",
          avatarUrl: "https://i.pravatar.cc/150?img=1",
          isOnline: true,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder:
                    (context) => VoiceCallDetailScreen(
                      userName: "Darlene Steward",
                      avatarUrl: "https://i.pravatar.cc/150?img=1",
                      callHistory: [
                        CallHistoryItem(
                          isMissed: false,
                          callDate: "03:30 AM",
                          durationOrSize: "33 mins 12.3 MB",
                          isVideoCall: false,
                        ),
                        CallHistoryItem(
                          isMissed: false,
                          callDate: "Yesterday, 07:53 AM",
                          durationOrSize: "0:20 47 KB",
                          isVideoCall: true,
                        ),
                      ],
                    ),
              ),
            );
          },
        ),
        VoiceCallItem(
          userName: "John Doe",
          callTime: "July 07, 04:15 PM",
          callType: "Outgoing",
          avatarUrl: "https://i.pravatar.cc/150?img=2",
          isOnline: false,
          onTap: () {},
        ),
        VoiceCallItem(
          userName: "Mary Smith",
          callTime: "July 06, 01:45 PM",
          callType: "Missed",
          avatarUrl: "https://i.pravatar.cc/150?img=3",
          isOnline: true,
          onTap: () {},
        ),
      ],
      // Tab 2
      [
        VoiceCallItem(
          userName: "Alice Johnson",
          callTime: "July 05, 10:14 AM",
          callType: "Outgoing",
          avatarUrl: "https://i.pravatar.cc/150?img=4",
          isOnline: true,
          onTap: () {},
        ),
        VoiceCallItem(
          userName: "Bob Martin",
          callTime: "July 04, 09:45 AM",
          callType: "Incoming",
          avatarUrl: "https://i.pravatar.cc/150?img=5",
          isOnline: false,
          onTap: () {},
        ),
        VoiceCallItem(
          userName: "Cindy White",
          callTime: "July 03, 08:30 AM",
          callType: "Missed",
          avatarUrl: "https://i.pravatar.cc/150?img=6",
          isOnline: true,
          onTap: () {},
        ),
      ],
      // Tab 3
      [
        VoiceCallItem(
          userName: "Flutter Devs",
          callTime: "July 02, 07:00 PM",
          callType: "Incoming",
          avatarUrl: "https://i.pravatar.cc/150?img=7",
          isOnline: false,
          onTap: () {},
        ),
        VoiceCallItem(
          userName: "Project Team",
          callTime: "July 01, 06:15 PM",
          callType: "Outgoing",
          avatarUrl: "https://i.pravatar.cc/150?img=8",
          isOnline: false,
          onTap: () {},
        ),
        VoiceCallItem(
          userName: "Book Club",
          callTime: "June 30, 05:45 PM",
          callType: "Missed",
          avatarUrl: "https://i.pravatar.cc/150?img=9",
          isOnline: false,
          onTap: () {},
        ),
      ],
      // Tab 4 (empty)
      [],
    ];

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundColor,
        centerTitle: true,
        title: Text(
          "Voice Calls",
          style: TextStyle(
            color: AppColors.textColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.menu))],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CallScreen()),
          );
        },
        shape: const CircleBorder(),
        backgroundColor: AppColors.primaryColor,
        child: const Icon(Icons.add_call, color: AppColors.backgroundColor),
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
                final chats = voiceCallsPerTab[index];
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
