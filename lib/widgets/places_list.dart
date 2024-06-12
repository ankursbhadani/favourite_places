import 'package:favourite_places/screens/place_detail.dart';
import 'package:flutter/material.dart';
import '../model/places.dart';

class PlacesList extends StatelessWidget {
  const PlacesList({Key? key, required this.places});

  final List<Places> places;

  @override
  Widget build(BuildContext context) {
    if (places.isEmpty) {
      return Center(
        child: Text(
          "You have not added any place yet",
          style: Theme.of(context).textTheme.headline6!.copyWith(
            color: Theme.of(context).colorScheme.onBackground,
          ),
        ),
      );
    }
    return ListView.builder(
      itemCount: places.length,
      itemBuilder: (ctx, index) => Padding(
        padding: const EdgeInsets.all(6.0),
        child: ListTile(
          leading: Container(
            height: 100, // Adjust the size of the container
            width: 100, // Adjust the size of the container
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                fit: BoxFit.cover,
                image: FileImage(places[index].image),
              ),
            ),
          ),
          title: Text(
            places[index].title,
            style: Theme.of(context).textTheme.headline6!.copyWith(
              color: Theme.of(context).colorScheme.onBackground,
            ),
          ),
          subtitle: Text(
            places[index].placeLocation.address,
            style: Theme.of(context).textTheme.subtitle1!.copyWith(
              color: Theme.of(context).colorScheme.onBackground,
            ),
          ),
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => PlaceDetail(place: places[index])));
          },
        ),
      ),
    );
  }
}
