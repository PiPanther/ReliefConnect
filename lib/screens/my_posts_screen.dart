import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:frs/constants/pallette.dart';
import 'package:frs/constants/toasts.dart';
import 'package:frs/models/post_model.dart';
import 'package:frs/providers/Authentication/auth_servicec.dart';
import 'package:frs/providers/Location/location_provider.dart';
import 'package:frs/providers/Posts/posts_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

class MyPostsScreen extends ConsumerWidget {
  const MyPostsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final String address = ref.watch(addressProvider);
    final user = ref.watch(currentUserProvider);
    final postprovider = ref.watch(postProvider);
    final posts = ref.watch(postProvider).fetchUserPost(user!.uid);
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
            child: SizedBox(
              width: MediaQuery.of(context).size.width - 20,
              child: TextButton.icon(
                style: const ButtonStyle(
                    elevation: WidgetStatePropertyAll(2.0),
                    backgroundColor: WidgetStatePropertyAll(Colors.pink)),
                onPressed: () async {
                  String stringlocation = await ref
                      .watch(locationPrvider)
                      .getAddressFromCoordinates();
                  print(stringlocation);
                  showDialog(
                      context: context,
                      builder: (context) {
                        return PostDialog(
                          location: stringlocation,
                        );
                      });
                },
                label: Text(
                  'Add a post',
                  style: TextStyling()
                      .styleh3
                      .copyWith(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          StreamBuilder<List<PostModel>>(
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
                  : Expanded(
                      child: ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: posts.length,
                        itemBuilder: (context, index) {
                          final post = posts[index];
                          print(post.pfp);
                          print(1);
                          return Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: 6, vertical: 5),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                    color: Colors.blue.shade300, width: 2)),
                            child: ListTile(
                              title: ListTile(
                                trailing: IconButton(
                                    onPressed: () async {
                                      await postprovider.deletePost(post.pid);
                                    },
                                    icon: const Icon(
                                      Icons.delete,
                                      color: kblue,
                                    )),
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
                      ),
                    );
            },
          ),
        ],
      ),
    );
  }
}

class PostDialog extends ConsumerStatefulWidget {
  String location;

  PostDialog({required this.location});
  @override
  _PostDialogState createState() => _PostDialogState();
}

class _PostDialogState extends ConsumerState<PostDialog> {
  final _descriptionController = TextEditingController();
  String? _imageUrl;

  @override
  Widget build(BuildContext context) {
    final postprov = ref.watch(postProvider);
    final location = ref.watch(locationPrvider);
    final user = ref.watch(currentUserProvider);
    return Card(
      color: Colors.white,
      elevation: 1,
      child: AlertDialog(
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: kblue),
          borderRadius: BorderRadius.circular(
            8,
          ),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 25, vertical: 20),
        title: const Text('Add Post'),
        content: Column(
          // mainAxisSize: MainAxisSize.min,
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              minLines: null,
              maxLines: null,
              maxLength: 100,
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
            ),
            SizedBox(height: 16),
            _imageUrl != null
                ? Image.network(
                    _imageUrl!,
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                  )
                : Text('No Image Selected'),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  icon: Icon(Icons.camera_alt),
                  label: Text('Camera'),
                  onPressed: () async {
                    String? _imageUrltemp = await postprov
                            .pickAndUploadThumbnail(ImageSource.camera) ??
                        "";
                    setState(() {
                      if (_imageUrltemp.isNotEmpty) {
                        _imageUrl = _imageUrltemp;
                      }
                    });
                    print(_imageUrl);
                    Toasts().success("Image Uploaded");
                  },
                ),
                const SizedBox(
                  width: 10,
                ),
                ElevatedButton.icon(
                  icon: Icon(Icons.photo),
                  label: Text('Gallery'),
                  onPressed: () async {
                    String? _imageUrltemp = await postprov
                            .pickAndUploadThumbnail(ImageSource.gallery) ??
                        "";
                    setState(() {
                      if (_imageUrltemp.isNotEmpty) {
                        _imageUrl = _imageUrltemp;
                      }
                    });
                    Toasts().success("Image Uploaded");

                    print(_imageUrl);
                  },
                ),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              // Close the dialog without submitting
              Navigator.of(context).pop();
            },
            child: Text(
              'Cancel',
              style: TextStyle(color: kblack),
            ),
          ),
          TextButton(
            onPressed: () async {
              // Handle the submit action here

              String description = _descriptionController.text;
              String pid = Uuid().v4();
              String? username = user!.displayName;
              Map<String, double>? currlocation =
                  await location.getCurrentLocation();
              // Do something with the input data (e.g., save it)
              try {
                if (_imageUrl != null && description.isNotEmpty) {
                  PostModel post = PostModel(
                      thumbnail: _imageUrl,
                      pid: pid,
                      username: username!,
                      location: widget.location,
                      id: user.uid,
                      shortText: description,
                      pfp: user.photoURL!,
                      latitude: currlocation['latitude']!,
                      longitude: currlocation['longitude']!);
                  await postprov.addPost(post);
                  Toasts().success("Post added successfully!");
                }
              } catch (e) {
                Toasts().error("Error adding post!");
              }

              // Close the dialog
              Navigator.of(context).pop();
            },
            child: Text(
              'Submit',
              style: TextStyle(color: kpink),
            ),
          ),
        ],
      ),
    );
  }
}
