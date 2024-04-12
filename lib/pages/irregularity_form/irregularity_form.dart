import 'package:city/pages/home/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

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
  final descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    selectedCategoryType = widget.initialCategoryType?.type ??
        CategoryType
            .basicSanitation; // Default value if initialCategoryType is null
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: ElevatedButton(
              onPressed: () {},
              child: const Text("Criar"),
            ),
          )
        ],
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                TextField(
                  controller: descriptionController,
                  maxLines: null,
                  minLines: 3,
                  autofocus: true,
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
                          color: Theme.of(context).colorScheme.primaryContainer,
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
                  title: 'Imagens',
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
