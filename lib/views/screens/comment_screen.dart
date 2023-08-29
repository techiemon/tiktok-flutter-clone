import 'package:flutter/material.dart';
// import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tiktok_tutorial/constants.dart';
import 'package:tiktok_tutorial/controllers/comment_controller.dart';
import 'package:tiktok_tutorial/models/comment.dart';
import 'package:timeago/timeago.dart' as tago;

class CommentScreen extends StatelessWidget {
  final String id;
  CommentScreen({
    Key? key,
    required this.id,
  }) : super(key: key);

  final TextEditingController _commentController = TextEditingController();
  final CommentController commentController = CommentController();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    commentController.updatePostId(id);

    return Scaffold(
      body: SingleChildScrollView(
        child: SizedBox(
          width: size.width,
          height: size.height,
          child: Column(
            children: [
              Expanded(
                  child: StreamBuilder<List<Comment>>(
                stream: commentController.comments,
                builder: ((context, snapshot) {
                  if (snapshot.hasData) {
                    final comments = snapshot.data;
                    return ListView.builder(
                        itemCount: comments!.length,
                        itemBuilder: (context, index) {
                          final comment = comments[index];
                          final fileParts = comment.profilePhoto.split('/');
                          final String publicUrl = supabase.storage
                              .from(fileParts[0])
                              .getPublicUrl(fileParts[1],
                                  transform: const TransformOptions(
                                    width: 100,
                                    height: 100,
                                    resize: ResizeMode.cover,
                                  ));
                          return ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Colors.black,
                              backgroundImage: NetworkImage(publicUrl),
                            ),
                            title: Row(
                              children: [
                                Text(
                                  "${comment.username}  ",
                                  style: const TextStyle(
                                    fontSize: 20,
                                    color: Colors.red,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                Text(
                                  comment.comment,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                            subtitle: Row(
                              children: [
                                Text(
                                  tago.format(
                                    DateTime.parse(comment.datePublished),
                                  ),
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  '${comment.likes.toString()} likes',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.white,
                                  ),
                                )
                              ],
                            ),
                            trailing: InkWell(
                              onTap: () => commentController
                                  .likeComment(comment.id.toString()),
                              child: Icon(
                                Icons.favorite,
                                size: 25,
                                color: Colors.white, //.likes
                                //     .contains(authController.user.id)
                                // ? Colors.red
                                // : Colors.white,
                              ),
                            ),
                          );
                        });
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                }),
              )),
              const Divider(),
              ListTile(
                title: TextFormField(
                  controller: _commentController,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                  decoration: const InputDecoration(
                    labelText: 'Comment',
                    labelStyle: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.red,
                      ),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.red,
                      ),
                    ),
                  ),
                ),
                trailing: TextButton(
                  onPressed: () {
                    commentController.postComment(_commentController.text);
                    _commentController.clear();
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    'Send',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
