import 'package:favourite_places/provider/user_places.dart';
import 'package:favourite_places/screens/add_places.dart';
import 'package:favourite_places/widgets/places_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
class FavouritePlaces extends ConsumerStatefulWidget {
  const FavouritePlaces({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _FavouritePlacesState();
  }
}
  class _FavouritePlacesState extends ConsumerState<FavouritePlaces>{
  late Future<void> _futurePlaces;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _futurePlaces = ref.read(userPlacesProvider.notifier).loadPlaces();

  }
  @override
  Widget build(BuildContext context) {
  final userPlaces = ref.watch(userPlacesProvider);
  return Scaffold(
  appBar: AppBar(title: Text("Your Places"),
  actions: [
  IconButton(onPressed: (){
  Navigator.of(context).push(MaterialPageRoute(builder: (context)=>AddPlaces()));
  }, icon: Icon(Icons.add)),
  ],
  ),
  body: FutureBuilder(future: _futurePlaces,
  builder: (context, snapshot) => snapshot.connectionState == ConnectionState.waiting?Center(child: CircularProgressIndicator(),):PlacesList(places: userPlaces),
   ),
  );
  }
  }

