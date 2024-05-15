import 'package:city/model/irregularity.dart';
import 'package:city/repositories/irregularity_repository.dart';
import 'package:city/widgets/irregularity_post.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:city/model/user.dart';
import 'package:provider/provider.dart'; // Assuming you have your User model defined here

class Profile extends StatelessWidget {
  final User user;

  Profile({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Align(
        alignment: Alignment.topCenter,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: StreamBuilder<QuerySnapshot<Irregularity>>(
              stream: context
                  .read<IrregularityRepository>()
                  .getIrregularitiesByUserId(user.id),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting ||
                    snapshot.data == null) {
                  return const Center(child: CircularProgressIndicator());
                }

                var irregularities = snapshot.data?.docs ?? [];

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    user.avatarImage == null
                        ? const Icon(Icons.account_circle)
                        : CircleAvatar(
                            radius: 50,
                            backgroundImage: NetworkImage(user.avatarImage!),
                          ),
                    const SizedBox(height: 5),
                    Text(
                      user.name,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Total Likes: 0',
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(width: 20),
                        Text(
                          'Total Posts: 0',
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: ListView.builder(
                        itemCount: irregularities.length,
                        itemBuilder: (context, index) {
                          var item = irregularities[index].data();
                          return IrregularityPost(
                            irregularity: item,
                          );
                        },
                      ),
                    )
                  ],
                );
              }),
        ),
      ),
    );
  }
}
