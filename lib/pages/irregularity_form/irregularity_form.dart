import 'package:city/model/irregularity.dart';
import 'package:city/pages/home/utils.dart';
import 'package:city/repositories/irregularity_repository.dart';
import 'package:city/services/storage_service.dart';
import 'package:city/utils/gallery.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gallery_picker/gallery_picker.dart';
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
  MediaFile? imageFile;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    selectedCategoryType = widget.initialCategoryType?.type ??
        CategoryType
            .basicSanitation; // Default value if initialCategoryType is null
  }

  saveIrregularity() async {
    String? userId = FirebaseAuth.instance.currentUser?.uid;

    if (!_formKey.currentState!.validate() || userId == null) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final notesRepository = context.read<IrregularityRepository>();

    try {
      Irregularity newIrregularity = Irregularity(
        description: _description.text,
        address: "Rua dos bobos, 0",
        createdAt: DateTime.now(),
        imagesUrl: [],
        userId: userId,
      );

      await notesRepository.saveIrregularity(newIrregularity);

      var file = await imageFile?.getFile();

      if (file != null) {
        await StorageService.uploadIrregularityImage(
            file: file, irregularityId: newIrregularity.id, userId: userId);
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.check),
              SizedBox(width: 8),
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
      // ignore: empty_catches
    } on FirebaseException catch (e) {
      print(e);
    } finally {
      setState(() {
        _isLoading = false;
      });
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
                  onPressed: value.text.isEmpty || _isLoading
                      ? null
                      : saveIrregularity,
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
                    decoration: InputDecoration(
                        hintText: "Descreva a irregularidade",
                        border: InputBorder.none,
                        enabled: !_isLoading),
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
                        onPressed: () async {
                          MediaFile? selectedImage =
                              await getImageFromGallery(context);

                          if (selectedImage != null) {
                            setState(() {
                              imageFile = selectedImage;
                            });
                          }
                        },
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
                          child: imageFile != null
                              ? PhotoProvider(media: imageFile!)
                              : Icon(
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
