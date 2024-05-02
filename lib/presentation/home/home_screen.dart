import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';
import 'package:selby/core/ui.dart';
import 'package:selby/presentation/category/select_category_screen.dart';
import 'package:selby/presentation/country_state_city/csc_screen.dart';
import 'package:selby/presentation/home/chat_screen.dart';
import 'package:selby/presentation/home/posts_screen.dart';
import 'package:selby/presentation/home/profile_screen.dart';
import 'package:selby/presentation/home/search_screen.dart';
import 'package:selby/presentation/home/user_feed_screen.dart';
import 'package:selby/provider/csc_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentIndex = 0;
  String userId = '';
  String city = '';
  String state = '';
  String country = '';
  String pincode = '';
  List<Widget> screens = [
    const UserFeedScreen(),
    const PostsScreen(),
    const ChatScreen(),
    const ProfileScreen(),
  ];
  TextEditingController searchTextController = TextEditingController();

  getLocation() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    city = preferences.getString('city').toString();
    state = preferences.getString('state').toString();
    country = preferences.getString('country').toString();
    pincode = preferences.getString('pincode').toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: AppColors.main,
          automaticallyImplyLeading: false,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset(
                'assets/images/selby_logo.png',
                width: 100,
              )
            ],
          ),
          actions: [
            IconButton(
              onPressed: () {},
              icon: Icon(
                Ionicons.notifications_outline,
                color: AppColors.white,
              ),
            ),
            // IconButton(
            //   onPressed: () {},
            //   icon: Icon(
            //     Ionicons.search_outline,
            //     color: AppColors.white,
            //   ),
            // ),
          ],
          bottom: PreferredSize(
              preferredSize:
                  Size.fromHeight(MediaQuery.of(context).size.height * 0.13),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: TextField(
                      controller: searchTextController,
                      style:
                          const TextStyle(fontFamily: "Oxygen", fontSize: 16),
                      decoration: InputDecoration(
                        suffixIcon: IconButton(
                          icon: Icon(
                            Ionicons.send,
                            color: AppColors.main,
                          ),
                          color: AppColors.main,
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SearchScreen(
                                          searchText:
                                              searchTextController.text.trim(),
                                        )));
                          },
                        ),
                        prefixIcon: const Icon(
                          Ionicons.search_outline,
                          color: Colors.black26,
                          size: 23,
                        ),
                        hintText: "Search",
                        hintStyle: const TextStyle(
                            fontFamily: "Oxygen",
                            fontSize: 16,
                            color: Colors.grey),
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 12, horizontal: 25),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                    ),
                  ),
                  Container(
                    color: Colors.white.withOpacity(0.05),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: 7, bottom: 7, left: 10, right: 10),
                      child: Row(
                        children: [
                          FutureBuilder(
                              future: getLocation(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState !=
                                    ConnectionState.done) {
                                  return Text("Loading ...");
                                }
                                return Text(
                                  'Location : ${context.watch<CscProvider>().city}, ${context.watch<CscProvider>().state}, ${context.watch<CscProvider>().country}',
                                  style: TextStyle(
                                      color: AppColors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      fontFamily: "Oxygen"),
                                );
                              }),
                          const Spacer(),
                          TextButton(
                            style: TextButton.styleFrom(
                                padding: EdgeInsets.zero,
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                alignment: Alignment.centerRight),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const CscScreen(),
                                ),
                              );
                            },
                            child: Icon(
                              Ionicons.location_outline,
                              color: AppColors.white,
                              size: 23,
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ))),
      body: screens[currentIndex],
      floatingActionButton: Align(
        alignment: const Alignment(0, 0.89),
        child: Container(
          decoration: BoxDecoration(
            // gradient: LinearGradient(
            //   colors: [
            //     AppColors.main,
            //     AppColors.main.withOpacity(0.2),
            //   ],
            // ),
            color: AppColors.main,
            shape: BoxShape.circle,
          ),
          child: FloatingActionButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50),
            ),
            backgroundColor: Colors.transparent,
            onPressed: () => {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => SelectCategoryScreen())),
            },
            child: Icon(
              Ionicons.add,
              color: AppColors.white,
              size: 30,
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Ionicons.home_outline), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Ionicons.heart_outline), label: "My Ads"),
          BottomNavigationBarItem(
              icon: Icon(Ionicons.chatbox_outline), label: "Chats"),
          BottomNavigationBarItem(
              icon: Icon(Ionicons.person_outline), label: "Profile")
        ],
      ),
    );
  }
}
