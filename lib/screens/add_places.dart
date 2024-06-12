import 'package:favourite_places/model/places.dart';
import 'package:favourite_places/provider/user_places.dart';
import 'package:favourite_places/widgets/input_image.dart';
import 'package:favourite_places/widgets/input_location.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:io';
class AddPlaces extends ConsumerStatefulWidget {
  const AddPlaces({super.key});

  @override
  ConsumerState<AddPlaces> createState() => _AddPlacesState();
}

class _AddPlacesState extends ConsumerState<AddPlaces> {
  final TextEditingController _titleController = TextEditingController();
  File? _selectedImage;
  PlaceLocation? _selectedLocation;
  @override
  void _savePlace(){
    final enteredTitle = _titleController.text;
    print("this is selected location=$_selectedLocation");
    if(enteredTitle.isEmpty||enteredTitle == null || _selectedImage==null || _selectedLocation==null){
     showDialog(context: context, builder:(BuildContext context){
       return AlertDialog(
         title: Text("Please Enter Valid Input"),
         actions: [TextButton(onPressed: (){
           Navigator.of(context).pop();
         }, child: Text("Close"))],
       );
     });
      return;
    }
    ref.read(userPlacesProvider.notifier).addPlaces(enteredTitle,_selectedImage!,_selectedLocation!);
    Navigator.of(context).pop();
  }
  void dispose() {
    // TODO: implement dispose
    _titleController.dispose();
    super.dispose();

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title:const Text("Add New Place"),),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: SingleChildScrollView(child: Column(
          children: [
            TextFormField(
              style: TextStyle(color: Theme.of(context).colorScheme.onBackground),
              decoration:  InputDecoration(label: Text("Title",style: TextStyle(color: Theme.of(context).colorScheme.onBackground),)),
              controller: _titleController,
            ),
            const SizedBox(height: 16,),
            ImageInput(onPickImage: (File image) {
              _selectedImage=image;
            },),
            const SizedBox(height: 16,),
            InputLocation(onSelectLocation: (PlaceLocation placeLocation) {
              _selectedLocation = placeLocation;
              print("this is placeLocation $placeLocation");
            },),
            ElevatedButton.icon(onPressed: _savePlace,
              label: const Text("Add Place"),
                icon: const Icon(Icons.add),
              ),
          ],
        ),),
      ),
    );
  }
}
