import 'package:city/model/irregularity.dart';
import 'package:city/model/user.dart';
import 'package:city/repositories/irregularity_repository.dart';
import 'package:city/repositories/user_repository.dart';
import 'package:city/services/storage_service.dart';
import 'package:firebase_auth/firebase_auth.dart' as F;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:timeago_flutter/timeago_flutter.dart';

class IrregularityPost extends StatefulWidget {
  final Irregularity irregularity;

  const IrregularityPost({Key? key, required this.irregularity})
      : super(key: key);

  @override
  State<IrregularityPost> createState() => _IrregularityPostState();
}

class _IrregularityPostState extends State<IrregularityPost> {
  final CarouselController _controller = CarouselController();
  int _current = 0;

  User? user;
  List<Reference>? images;
  bool _isLoadingDeletion = false;
  String? userId = F.FirebaseAuth.instance.currentUser?.uid;

  @override
  void initState() {
    super.initState();

    loadUser();
    loadImages();
  }

  loadUser() {
    context
        .read<UserRepository>()
        .getUserById(widget.irregularity.userId)
        .then((value) => {
              setState(() {
                if (value != null) {
                  user = value;
                }
              })
            });
  }

  loadImages() async {
    final loadedImages = await StorageService.getIrregularityImages(
        userId: widget.irregularity.userId,
        irregularityId: widget.irregularity.id);

    if (loadedImages != null) {
      setState(() {
        images = loadedImages;
      });
    }
  }

  void deleteIrregularity() async {
    if (userId == null) {
      return;
    }

    setState(() {
      _isLoadingDeletion = true;
    });

    try {
      await context
          .read<IrregularityRepository>()
          .deleteIrregularity(id: widget.irregularity.id, userId: userId!);
      Navigator.of(context).pop();
    } catch (e) {
      print(e);
    } finally {
      setState(() {
        _isLoadingDeletion = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Theme.of(context).colorScheme.secondaryContainer,
      ),
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildUserInfo(),
          const SizedBox(height: 8),
          _buildDescription(),
          const SizedBox(height: 8),
          _buildImageCarousel(),
          _buildBottomPost()
        ],
      ),
    );
  }

  Widget _buildUserInfo() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            GestureDetector(
              onTap: () {
                if (user != null) {
                  Navigator.of(context).pushNamed('/profile', arguments: user);
                }
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(60),
                child: user?.avatarImage != null
                    ? Image.network(
                        user!.avatarImage!,
                        height: 42,
                      )
                    : const Icon(Icons.account_circle, size: 42),
              ),
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(user?.name ?? ""),
                Timeago(
                  builder: (_, value) => Text(
                    value,
                    style: Theme.of(context).textTheme.labelSmall!.copyWith(
                        color: Theme.of(context).colorScheme.outline,
                        fontWeight: FontWeight.w400),
                  ),
                  date: widget.irregularity.createdAt,
                  locale: 'pt_BR',
                  allowFromNow: true,
                ),
              ],
            ),
          ],
        ),
        Row(
          children: [
            SizedBox(
              height: 28,
              width: 28,
              child: IconButton(
                onPressed: () {},
                iconSize: 20,
                padding: EdgeInsets.all(4),
                icon: const Icon(
                  Icons.map_outlined,
                ),
                tooltip: 'Ver no mapa',
              ),
            ),
            if (widget.irregularity.userId == userId)
              SizedBox(
                height: 28,
                width: 28,
                child: IconButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: const Text("Deletar post"),
                        content: const Text(
                            "Tem certeza que deseja deletar esse post?"),
                        actions: [
                          TextButton(
                              onPressed: _isLoadingDeletion
                                  ? null
                                  : () {
                                      Navigator.of(context).pop();
                                    },
                              child: const Text("Voltar")),
                          TextButton(
                            onPressed:
                                _isLoadingDeletion ? null : deleteIrregularity,
                            child: const Text("Deletar"),
                          )
                        ],
                      ),
                    );
                  },
                  padding: const EdgeInsets.all(4),
                  iconSize: 20,
                  icon: const Icon(
                    Icons.delete_outline,
                  ),
                  tooltip: 'Deletar',
                ),
              )
          ],
        )
      ],
    );
  }

  Widget _buildDescription() {
    return Text(
      widget.irregularity.description,
      textAlign: TextAlign.start,
      style: const TextStyle(
        fontWeight: FontWeight.w400,
      ),
    );
  }

  Widget _buildImageCarousel() {
    return Column(
      children: [
        CarouselSlider(
          items: images
              ?.map(
                (image) => ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: FutureBuilder(
                    future: image.getDownloadURL(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Image.network(snapshot.data!);
                      }

                      return const Center(child: CircularProgressIndicator());
                    },
                  ),
                ),
              )
              .toList(),
          carouselController: _controller,
          options: CarouselOptions(
            autoPlay: false,
            viewportFraction: 1.0,
            enlargeCenterPage: false,
            enableInfiniteScroll: false,
            onPageChanged: (index, reason) {
              setState(() {
                _current = index;
              });
            },
          ),
        ),
        _buildImageIndicators(),
      ],
    );
  }

  Widget _buildImageIndicators() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: widget.irregularity.imagesUrl.asMap().entries.map((entry) {
        return GestureDetector(
          onTap: () => _controller.animateToPage(entry.key),
          child: Container(
            width: 8.0,
            height: 8.0,
            margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: (Theme.of(context).brightness == Brightness.dark
                      ? Colors.white
                      : Colors.black)
                  .withOpacity(_current == entry.key ? 0.9 : 0.4),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildBottomPost() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            IconButton(
                onPressed: () {},
                icon: const Icon(Icons.thumb_up_alt_outlined)),
            Text(NumberFormat.compact(locale: 'pt_BR')
                .format(widget.irregularity.likes)
                .toString()),
          ],
        ),
        const SizedBox(width: 32),
        Flexible(
          child: Container(
            child: Text(
              widget.irregularity.address,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.labelSmall,
            ),
          ),
        ),
      ],
    );
  }
}
