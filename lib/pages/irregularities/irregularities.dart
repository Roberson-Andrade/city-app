import 'package:city/model/irregularity.dart';
import 'package:city/repositories/irregularity_repository.dart';
import 'package:city/widgets/irregularity_post.dart';
import 'package:flutter/material.dart';

class IrregularitiesPage extends StatefulWidget {
  const IrregularitiesPage({super.key});

  @override
  State<IrregularitiesPage> createState() => _IrregularitiesPageState();
}

class _IrregularitiesPageState extends State<IrregularitiesPage> {
  final IrregularityRepository irregularityRepository =
      IrregularityRepository();
  List<Irregularity> irregularities = [];

  @override
  void initState() {
    super.initState();
    irregularities = irregularityRepository.irregularities;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.search))],
      ),
      body: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: irregularities.length,
          itemBuilder: (context, index) =>
              IrregularityPost(irregularity: irregularities[index])),
    );
  }
}
