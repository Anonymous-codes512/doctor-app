import 'dart:convert';

import 'package:doctor_app/core/assets/colors/app_colors.dart';
import 'package:doctor_app/core/constants/approutes/approutes.dart';
import 'package:doctor_app/data/services/socket_service.dart';
import 'package:doctor_app/presentation/widgets/custom_search_widget.dart';
import 'package:doctor_app/presentation/widgets/custom_tabs_widget.dart';
import 'package:doctor_app/presentation/widgets/empty_state_widget.dart';
import 'package:doctor_app/presentation/widgets/search_screen_widget.dart';
import 'package:doctor_app/presentation/widgets/voice_call_item.dart';
import 'package:doctor_app/provider/call_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  CallProvider? _callProvider;
  int? userId;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _callProvider = Provider.of<CallProvider>(context, listen: false);
    _initializeAsyncStuff();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _callProvider?.loadCallHistory();
    });
  }

  Future<void> _initializeAsyncStuff() async {
    userId = await _getUserId();
    if (userId == null) {
      print('❌ User ID not found in SharedPreferences');
      return;
    }
    SocketService().initSocket(userId!);
  }

  Future<int?> _getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    final user = prefs.getString('user');
    if (user != null) {
      return jsonDecode(user)['id'];
    }
    return null;
  }

  @override
  void dispose() {
    mySearchController.dispose();
    _pageController.dispose();
    SocketService().disconnectSocket();
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
    final callProvider = Provider.of<CallProvider>(context);
    final callConversations = callProvider.callHistory;
    final isLoading = callProvider.isLoading;

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
        onPressed: () {},
        shape: const CircleBorder(),
        backgroundColor: AppColors.primaryColor,
        child: const Icon(Icons.add_call, color: AppColors.backgroundColor),
      ),

      body: Column(
        children: [
          SearchBarWithAddButton(
            controller: mySearchController,
            onAddPressed: () async {
              final users = await callProvider.fetchUsersForNewCall();
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
            tabs: tabTitles,
            selectedIndex: selectedIndex,
            onTabSelected: (index) {
              onTabTapped(index);
            },
          ),
          Expanded(
            child:
                isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : callConversations.isEmpty
                    ? const EmptyState(text: 'You have no voice calls yet')
                    : ListView.builder(
                      itemCount: callConversations.length,
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      itemBuilder: (context, index) {
                        final call = callConversations[index];
                        return VoiceCallItem(
                          userName: call['name'] ?? '',
                          callTime: call['last_time'] ?? '',
                          callType: call['call_type'] ?? '',
                          avatarUrl: call['avatar'] ?? '',
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              Routes.voiceCallDetailScreen,
                              arguments: call,
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
