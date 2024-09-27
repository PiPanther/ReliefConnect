import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frs/constants/pallette.dart';
import 'package:frs/models/post_model.dart';
import 'package:frs/providers/Posts/posts_provider.dart';

class AllPostsScreen extends ConsumerWidget {
  const AllPostsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final posts = ref.watch(postProvider).fetchPosts();
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: StreamBuilder<List<PostModel>>(
          stream: posts,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (snapshot.hasError) {
              return Text("Error ${snapshot.error}");
            }

            final posts = snapshot.data ?? [];

            return posts.isEmpty
                ? const Center(
                    child: Text("No Posts available"),
                  )
                : ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: posts.length,
                    itemBuilder: (context, index) {
                      final post = posts[index];
                      print(post.pfp);
                      print(1);
                      return Container(
                        margin:
                            EdgeInsets.symmetric(horizontal: 6, vertical: 5),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                                color: Colors.blue.shade300, width: 2)),
                        child: ListTile(
                          title: ListTile(
                            title: Text(post.username),
                            subtitle: Text(post.location),
                            leading: post.pfp != null
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(50),
                                    child: Image.network(post.pfp))
                                : Icon(Icons.person),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Divider(
                                color: kpink,
                              ),
                              Text(post.shortText),
                              Container(
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 0, vertical: 12),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 4, vertical: 6),
                                height: 200,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  image: DecorationImage(
                                    image: NetworkImage(
                                      post.thumbnail!,
                                    ),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
          },
        ),
      ),
    );
  }
}
