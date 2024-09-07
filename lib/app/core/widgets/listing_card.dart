import 'package:flutter/material.dart';

import '../../../gen/assets.gen.dart';

class ListingCard extends StatelessWidget {
  final String property_id;
  final String title;
  final int price;
  final String location;
  final String status;
  final String image_url;
  //final bool featured;

  ListingCard({
    super.key,
    required this.property_id,
    required this.title,
    required this.price,
    required this.location,
    required this.status,
    required this.image_url,
    //required this.featured,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 220,
        width: 180,
        decoration: BoxDecoration(
          color: const Color(0xFFFFFFFF),
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
              color: Color.fromARGB(66, 169, 173, 189),
              offset: Offset(0, 2),
              blurRadius: 2,
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(6.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(12)),
                    // Listing Image
                    child: Image.asset(
                      "assets/images/$image_url",
                      fit: BoxFit.cover,
                      height: 115,
                      width: 180,
                    ),
                  ),
                  Positioned(
                    top: 8,
                    left: 130,
                    child: Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 229, 234, 240),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: IconButton(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.all(0),
                        icon: const Icon(Icons.favorite_border),
                        color: Colors.red,
                        iconSize: 20.0,
                        onPressed: () {},
                      ),
                    ),
                  )
                ],
              ),
              const Row(),
              const Spacer(flex: 1),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  title,
                  overflow: TextOverflow.clip,
                  maxLines: 2,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              Row(children: [
                Icon(
                  Icons.location_city_rounded,
                  size: 16.0,
                  color: Colors.grey,
                ),
                Text(
                  location,
                  overflow: TextOverflow.clip,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                )
              ]),
              const Spacer(flex: 2),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "\$$price",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Color(0xFF0744BC),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
