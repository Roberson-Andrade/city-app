import 'package:city/model/irregularity.dart';
import 'package:city/repositories/irregularity_repository.dart';
import 'package:city/widgets/irregularity_post.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class IrregularitiesPage extends StatefulWidget {
  const IrregularitiesPage({super.key});

  @override
  State<IrregularitiesPage> createState() => _IrregularitiesPageState();
}

class _IrregularitiesPageState extends State<IrregularitiesPage> {
  List<Irregularity> irregularities = [];
  late bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final IrregularityRepository irregularityRepository =
        context.watch<IrregularityRepository>();

    irregularities = irregularityRepository.getIrregularities();

    return Scaffold(
      appBar: AppBar(
        actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.search))],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: irregularities.length,
              itemBuilder: (context, index) =>
                  IrregularityPost(irregularity: irregularities[index]),
            ),
    );
  }
}
