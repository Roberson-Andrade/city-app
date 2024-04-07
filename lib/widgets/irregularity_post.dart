import 'package:city/model/irregularity.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

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
        ],
      ),
    );
  }

  Widget _buildUserInfo() {
    return Row(
      children: [
        CircleAvatar(
          backgroundImage: NetworkImage(widget.irregularity.user.avatarImage),
        ),
        const SizedBox(width: 8),
        Text(widget.irregularity.user.name),
      ],
    );
  }

  Widget _buildDescription() {
    return Text(
      widget.irregularity.description,
      textAlign: TextAlign.start,
      style: const TextStyle(
        fontWeight: FontWeight.w300,
      ),
    );
  }

  Widget _buildImageCarousel() {
    return SizedBox(
      height: 250,
      child: Column(
        children: [
          CarouselSlider(
            items: widget.irregularity.imagesUrl
                .map((image) => ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: Image.network(
                        image,
                        width: MediaQuery.of(context).size.width,
                        fit: BoxFit.cover,
                      ),
                    ))
                .toList(),
            carouselController: _controller,
            options: CarouselOptions(
              autoPlay: false,
              viewportFraction: 1.0,
              enlargeCenterPage: false,
              onPageChanged: (index, reason) {
                setState(() {
                  _current = index;
                });
              },
            ),
          ),
          _buildImageIndicators(),
        ],
      ),
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
}
