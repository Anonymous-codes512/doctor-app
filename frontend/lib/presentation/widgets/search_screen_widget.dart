import 'package:doctor_app/core/assets/colors/app_colors.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController searchController = TextEditingController();

  List<Map<String, dynamic>> recentSearches = [
    {"userName": "something", "avatarUrl": "https://i.pravatar.cc/150?img=10"},
    {
      "userName": "something something",
      "avatarUrl": "https://i.pravatar.cc/150?img=11",
    },
    {
      "userName": "timmythetank",
      "avatarUrl": "https://i.pravatar.cc/150?img=12",
    },
    {"userName": "monkeycafams", "avatarUrl": "https://i.pravatar.cc/15img=13"},
  ];

  void removeSearch(int index) {
    setState(() {
      recentSearches.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundColor,
        centerTitle: true,
        title: Text(
          "Search",
          style: TextStyle(
            color: AppColors.textColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.close))],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Column(
          children: [
            Container(
              height: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.black26, width: 1),
              ),
              child: Row(
                children: [
                  const SizedBox(width: 12),
                  const Icon(Icons.search, color: Colors.grey),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: searchController,
                      onChanged: (value) {},
                      onTap: () {},
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: "Search",
                        isDense: true,
                      ),
                      readOnly: true,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            Expanded(
              child: ListView.separated(
                itemCount: recentSearches.length,
                separatorBuilder:
                    (context, index) => Divider(color: Colors.grey.shade300),
                itemBuilder: (context, index) {
                  final item = recentSearches[index];
                  return ListTile(
                    leading: ClipOval(
                      child: Image.network(
                        item["avatarUrl"],
                        width: 40,
                        height: 40,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            width: 40,
                            height: 40,
                            color: Colors.grey.shade300,
                            child: const Icon(Icons.search, color: Colors.grey),
                          );
                        },
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Container(
                            width: 40,
                            height: 40,
                            color: Colors.grey.shade200,
                            child: const Center(
                              child: Icon(Icons.search, color: Colors.grey),
                            ),
                          );
                        },
                      ),
                    ),
                    title: Text(
                      item["userName"],
                      style: TextStyle(
                        color: AppColors.textColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    trailing: GestureDetector(
                      onTap: () => removeSearch(index),
                      child: Icon(
                        Icons.close,
                        color: AppColors.textColor.withOpacity(0.5),
                        size: 20,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
