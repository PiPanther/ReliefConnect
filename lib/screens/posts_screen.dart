import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frs/constants/pallette.dart';
import 'package:frs/constants/toasts.dart';
import 'package:frs/providers/Authentication/auth_servicec.dart';
import 'package:frs/providers/Location/location_provider.dart';
import 'package:frs/screens/all_posts_screen.dart';
import 'package:frs/screens/my_posts_screen.dart';
import 'package:toastification/toastification.dart';

class PostsScreen extends ConsumerWidget {
  const PostsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.read(currentUserProvider);
    final locationUser = ref.watch(locationPrvider).getCurrentLocation();
    return DefaultTabController(
      initialIndex: 0,
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          bottom: const TabBar(
            // dividerColor: ,
            indicatorColor: kblue,
            indicatorSize: TabBarIndicatorSize.tab,
            isScrollable: false,
            tabs: [
              Text("All Posts"),
              Text("My Posts"),
            ],
          ),
        ),
        body: const TabBarView(children: [
          AllPostsScreen(),
          MyPostsScreen(),
        ]),
      ),
    );
  }
}
