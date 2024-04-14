import 'package:city/model/irregularity.dart';
import 'package:city/repositories/irregularity_repository.dart';
import 'package:city/widgets/irregularity_post.dart';
import 'package:flutter/material.dart';
import 'package:city/model/user.dart'; // Assuming you have your User model defined here

class Profile extends StatelessWidget {
  final User user;
  final IrregularityRepository repository = IrregularityRepository();

  Profile({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Irregularity> userIrregularities =
        repository.getIrregularitiesByName(user.name);

    int totalLikes = userIrregularities.fold<int>(
        0, (sum, irregularity) => sum + irregularity.likes);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: Align(
        alignment: Alignment.topCenter,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage(user.avatarImage),
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
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Total Likes: $totalLikes',
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(width: 20),
                  Text(
                    'Total Posts: ${userIrregularities.length}',
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Expanded(
                  child: ListView.builder(
                itemCount: userIrregularities.length,
                itemBuilder: (context, index) {
                  return IrregularityPost(
                    irregularity: userIrregularities[index],
                  );
                },
              ))
            ],
          ),
        ),
      ),
    );
  }
}
