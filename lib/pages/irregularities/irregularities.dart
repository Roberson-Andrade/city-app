import 'package:city/model/irregularity.dart';
import 'package:city/repositories/irregularity_repository.dart';
import 'package:city/widgets/irregularity_post.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class IrregularitiesPage extends StatefulWidget {
  const IrregularitiesPage({super.key});

  @override
  State<IrregularitiesPage> createState() => _IrregularitiesPageState();
}

class _IrregularitiesPageState extends State<IrregularitiesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.search))],
      ),
      body: StreamBuilder<QuerySnapshot<Irregularity>>(
          stream: context.read<IrregularityRepository>().getIrregularities(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting ||
                snapshot.data == null) {
              return const Center(child: CircularProgressIndicator());
            }

            var irregularities = snapshot.data?.docs ?? [];

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: irregularities.length,
              itemBuilder: (context, index) {
                var irregularity = irregularities[index].data();

                return IrregularityPost(irregularity: irregularity);
              },
            );
          }),
    );
  }
}
