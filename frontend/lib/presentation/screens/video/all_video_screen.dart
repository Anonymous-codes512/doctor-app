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

class AllVideoCallScreen extends StatefulWidget {
  const AllVideoCallScreen({super.key});

  @override
  State<AllVideoCallScreen> createState() => _AllVideoCallScreenState();
}

class _AllVideoCallScreenState extends State<AllVideoCallScreen> {
  final TextEditingController mySearchController = TextEditingController();

  final List<String> tabTitles = ["All chats", "Favorites", "Groups", "Former"];
  int selectedIndex = 0;
  late PageController _pageController;

  CallProvider? _callProvider;
  int? userId; // Current user's ID

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
      debugPrint('❌ User ID not found in SharedPreferences');
      return;
    }
  }

  Future<int?> _getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    final user = prefs.getString('user');
    if (user != null) {
      return jsonDecode(user)['id'];
    }
    return null;
  }

  // Future<void> _onCallIconTap(Map<String, dynamic> call) async {
  //   final peerUserId = call['user_id']?.toString(); // Ensure it's a string
  //   final peerUserName =
  //       call['name'] as String?; // Ensure it's a string or null

  //   if (peerUserId == null || peerUserName == null) {
  //     debugPrint('❌ Peer user ID or name is null for call: $call');
  //     return;
  //   }

  //   // ✅ ZegoCallUser ko positional arguments ke saath create karein
  //   final ZegoCallUser invitee = ZegoCallUser(
  //     peerUserId, // ✅ Pehla positional argument: userID
  //     peerUserName, // ✅ Dusra positional argument: userName
  //   );

  //   // Call ID unique hona chahiye
  //   final String callID =
  //       'call_${DateTime.now().millisecondsSinceEpoch}_$peerUserId';

  //   await ZegoUIKitPrebuiltCallInvitationService().controller.sendCallInvitation(
  //     callID: callID,
  //     invitees: [invitee], // Invitees list mein peer user ko add karein
  //     isVideoCall: false, // Voice call ke liye false
  //     resourceID:
  //         "doctor_app_call_resource", // Yeh aapka unique Zego resource ID hoga
  //     // production mein dynamic set karein ya unique naam dein.
  //   );
  //   debugPrint("✅ Call invitation sent to: $peerUserName ($peerUserId)");
  // }

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
        onPressed: () async {
          final users = await callProvider.fetchUsersForNewCall();
          Navigator.pushNamed(context, Routes.callListScreen, arguments: users);
        },
        heroTag: 'addCallButton',
        shape: const CircleBorder(),
        backgroundColor: AppColors.primaryColor,
        child: const Icon(Icons.add_call, color: AppColors.backgroundColor),
      ),
      body: Column(
        children: [
          SearchBarWithAddButton(
            controller: mySearchController,
            onAddPressed: () async {
              // final users = await callProvider.fetchUsersForNewCall();
              // if (users.isNotEmpty) {
              //   final Map<String, dynamic> firstUser = users[0];
              //   final String? peerUserId = firstUser['id']?.toString();
              //   final String? peerUserName = firstUser['name'];

              //   if (peerUserId != null && peerUserName != null) {
              //     final ZegoCallUser invitee = ZegoCallUser(
              //       peerUserId, // ✅ Pehla positional argument: userID
              //       peerUserName, // ✅ Dusra positional argument: userName
              //     );
              //     final String callID =
              //         'call_${DateTime.now().millisecondsSinceEpoch}_$peerUserId';

              //     await ZegoUIKitPrebuiltCallInvitationService().controller
              //         .sendCallInvitation(
              //           callID: callID,
              //           invitees: [invitee],
              //           isVideoCall: false,
              //           resourceID: "doctor_app_call_resource",
              //         );
              //     debugPrint(
              //       "✅ Invitation sent from Add Button to: $peerUserName ($peerUserId)",
              //     );
              //   } else {
              //     debugPrint(
              //       "❌ First user's ID or Name is null from fetchUsersForNewCall.",
              //     );
              //   }
              // } else {
              //   debugPrint("❌ No users found for new call.");
              // }
            },
            onChanged: (value) => debugPrint('Search text: $value'),
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
                          onpPhoneTap: () {},
                        );
                      },
                    ),
          ),
        ],
      ),
    );
  }
}
