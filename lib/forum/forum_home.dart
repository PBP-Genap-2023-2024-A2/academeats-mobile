import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:academeats_mobile/models/forum.dart';
import 'package:academeats_mobile/utils/fetch.dart';

class ForumHomePage extends StatelessWidget {
  const ForumHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: fetchData('forum/api/v1/'),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data == null) {
          return const Center(child: Text('No data found'));
        } else {
          List<dynamic> forumList = snapshot.data!['data'];
          return ListView.builder(
            itemCount: forumList.length,
            itemBuilder: (_, index) {
              Forum forum = Forum.fromJson(forumList[index]);

              return Card(
                // Define the shape of the card
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
                // Define how the card's content should be clipped
                clipBehavior: Clip.antiAliasWithSaveLayer,
                // Define the child widget of the card
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    // Add padding around the row widget
                    Padding(
                      padding: const EdgeInsets.all(15),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                // Add some spacing between the top of the card and the title
                                Container(height: 5),
                                // Add a title widget
                                Text(
                                  forum.judul,
                                  style: Theme.of(context).textTheme.titleSmall,
                                ),
                                // Add some spacing between the title and the subtitle
                                Container(height: 5),
                                // Add a subtitle widget
                                Text(
                                  "Sub title",
                                ),
                                // Add some spacing between the subtitle and the text
                                Container(height: 10),
                                // Add a text widget to display some text
                                Text(
                                  forum.deskripsi,
                                  maxLines: 2,
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        }
      },
    );
  }
}
