import 'package:favorite_places/screens/place_detail.dart';
import 'package:flutter/material.dart';

import 'package:favorite_places/models/place.dart';

class PlacesList extends StatefulWidget {
  const PlacesList({super.key, required this.places});

  final List<Place> places;

  @override
  State<PlacesList> createState() => _PlacesListState();
}

class _PlacesListState extends State<PlacesList> {
  @override
  Widget build(BuildContext context) {
    if (widget.places.isEmpty) {
      return Center(
        child: Text(
          'No places added yet',
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                color: Theme.of(context).colorScheme.onBackground,
              ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView.builder(
          itemCount: widget.places.length,
          itemBuilder: (BuildContext ctx, int index) {
            return Padding(
              padding: const EdgeInsets.only(
                left: 5.0,
                right: 5.0,
                top: 10.0,
                bottom: 10.0,
              ),
              child: Dismissible(
                key: ValueKey(widget.places[index]),
                background: Container(
                  color: Colors.red,
                  child: const Padding(
                    padding: EdgeInsets.all(15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Icon(
                          Icons.delete,
                          color: Colors.white,
                          size: 22.0,
                        ),
                        SizedBox(
                          width: 8.0,
                        ),
                        Text('Delete this item',
                            style:
                                TextStyle(color: Colors.white, fontSize: 20.0)),
                      ],
                    ),
                  ),
                ),
                confirmDismiss: (DismissDirection direction) async {
                  return await showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text("Delete Place"),
                        content: const Text(
                            "Are you sure you want to delete this place?"),
                        actions: <Widget>[
                          ElevatedButton(
                              onPressed: () => Navigator.of(context).pop(true),
                              child: const Text("Yes")),
                          ElevatedButton(
                            onPressed: () => Navigator.of(context).pop(false),
                            child: const Text("No"),
                          ),
                        ],
                      );
                    },
                  );
                },
                onDismissed: (DismissDirection direction) {
                  if (direction == DismissDirection.endToStart ||
                      direction == DismissDirection.startToEnd) {}
                  setState(() {
                    widget.places.removeAt(index);
                  });
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content:
                          Text('${widget.places[index].title} has been deleted')));
                },
                child: ListTile(
                  leading: CircleAvatar(
                    radius: 26,
                    backgroundImage: FileImage(widget.places[index].image),
                  ),
                  title: Text(
                    widget.places[index].title,
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          color: Theme.of(context).colorScheme.onBackground,
                        ),
                  ),
                  subtitle: Text(
                    widget.places[index].location.address,
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
                          color: Theme.of(context).colorScheme.onBackground,
                        ),
                  ),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (ctx) =>
                            PlaceDetailScreen(place: widget.places[index]),
                      ),
                    );
                  },
                ),
              ),
            );
          }),
    );
  }
}
