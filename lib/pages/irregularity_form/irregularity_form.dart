import 'dart:math';

import 'package:city/model/irregularity.dart';
import 'package:city/model/user.dart';
import 'package:city/pages/home/utils.dart';
import 'package:city/repositories/irregularity_repository.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class IrregularityFormArgs {
  final CategoryType type;

  IrregularityFormArgs(this.type);
}

class IrregularityForm extends StatefulWidget {
  final IrregularityFormArgs? initialCategoryType;
  const IrregularityForm({
    super.key,
    this.initialCategoryType,
  });

  @override
  State<IrregularityForm> createState() => _IrregularityFormState();
}

class _IrregularityFormState extends State<IrregularityForm> {
  late CategoryType selectedCategoryType;

  final _formKey = GlobalKey<FormState>();
  final _description = TextEditingController();

  final mockImages = [
    "https://odia.ig.com.br/_midias/jpg/2018/04/26/img_20170810_122004294_hdr-6553832.jpg",
    "https://araraquaraagora.com/images/noticias/11247/10035730_Img0_600x4.jpg",
    "https://media.istockphoto.com/id/95658927/pt/foto/estrada-danos.jpg?s=612x612&w=0&k=20&c=MUg9ULfotqHVm5kNzVEfNnOmiYiK3_n5GLXWeUwbfRs=",
    "https://www.examepelobem.com.br/fotos/images/buracos-na-estrada-o-que-fazer(1).png"
  ];

  @override
  void initState() {
    super.initState();

    selectedCategoryType = widget.initialCategoryType?.type ??
        CategoryType
            .basicSanitation; // Default value if initialCategoryType is null
  }

  saveIrregularity() {
    if (_formKey.currentState!.validate()) {
      final notesRepository = context.read<IrregularityRepository>();

      notesRepository.saveIrregularity(
        Irregularity(
          description: _description.text,
          address: "Rua dos bobos, 0",
          createdAt: DateTime.now(),
          imagesUrl: [mockImages[Random().nextInt(mockImages.length - 1)]],
          user: User(
              name: "Roberson Andrade",
              avatarImage:
                  "https://avatars.githubusercontent.com/u/78360479?v=4"),
        ),
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.check),
              const SizedBox(width: 8),
              Text(
                "Irregularidade criada com sucesso!",
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
          backgroundColor: Colors.green.shade500,
        ),
      );
      Navigator.of(context).pop();
    }
  }

  @override
  void dispose() {
    _description.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: ValueListenableBuilder<TextEditingValue>(
              valueListenable: _description,
              builder: (context, value, child) {
                return ElevatedButton(
                  onPressed: value.text.isEmpty ? null : saveIrregularity,
                  child: const Text("Criar"),
                );
              },
            ),
          )
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  TextFormField(
                    controller: _description,
                    maxLines: null,
                    minLines: 3,
                    decoration: const InputDecoration(
                      hintText: "Descreva a irregularidade",
                      border: InputBorder.none,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: Category.getAllCategories()
                        .map(
                          (category) => IconButton.filled(
                            onPressed: () {
                              setState(() {
                                selectedCategoryType = category.type;
                              });
                            },
                            icon: Icon(category.icon),
                            isSelected: selectedCategoryType == category.type,
                            tooltip: category.label,
                          ),
                        )
                        .toList(),
                  ),
                  const SizedBox(
                    height: 32,
                  ),
                  _buildSection(
                      title: 'Imagens',
                      iconBtn: IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.add_photo_alternate_outlined,
                          size: 20,
                        ),
                      ),
                      content: Container(
                        height: 200,
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: 1,
                            color:
                                Theme.of(context).colorScheme.primaryContainer,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: Icon(
                            Icons.photo_library_outlined,
                            color: Theme.of(context).colorScheme.outline,
                            size: 38,
                          ),
                        ),
                      )),
                  const SizedBox(
                    height: 32,
                  ),
                  _buildSection(
                    title: 'Local',
                    iconBtn: IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.edit_outlined,
                        size: 20,
                      ),
                    ),
                    content: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.asset(
                        "images/cat-map.jpeg",
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(
      {required String title, required Widget iconBtn, required content}) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.headline6,
            ),
            iconBtn,
          ],
        ),
        const SizedBox(
          height: 8,
        ),
        content
      ],
    );
  }
}
