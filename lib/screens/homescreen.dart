import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frs/constants/pallette.dart';
import 'package:frs/providers/Authentication/auth_servicec.dart';
import 'package:frs/providers/nav_bar_provider.dart';
import 'package:frs/screens/campaign_homepage.dart';
import 'package:frs/screens/posts_screen.dart';
import 'package:frs/screens/seek_help_screen.dart';
import 'package:frs/screens/homepage.dart';

class Homescreen extends ConsumerWidget {
  const Homescreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncUser = ref.watch(authStateProvider);
    return asyncUser.when(
      data: (user) => _buildScaffold(context, ref, user),
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (error, stackTrace) => Scaffold(
        body: Center(child: Text('Error: $error')),
      ),
    );
  }

  Widget _buildScaffold(BuildContext context, WidgetRef ref, User? user) {
    final currentPage = ref.watch(currentPageProvider);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0),
        child: IndexedStack(
          index: currentPage,
          children: const [
            Homepage(),
            CampaignHomepage(),
            DonationsScreen(),
            PostsScreen(),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
          backgroundColor: kblue,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white,
          selectedFontSize: 16,
          type: BottomNavigationBarType.fixed,
          onTap: (index) =>
              ref.read(currentPageProvider.notifier).state = index,
          currentIndex: currentPage,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(
                icon: Icon(Icons.attach_money), label: 'Campaigns'),
            BottomNavigationBarItem(
                icon: Icon(Icons.local_police), label: 'Seek Help'),
            BottomNavigationBarItem(
                icon: Icon(Icons.newspaper), label: 'Posts'),
          ]),
    );
  }
}
