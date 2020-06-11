import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../screens/add_place_screen.dart';
import '../screens/place_detail_screen.dart';

import '../providers/great_places.dart';

class PlacesListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Your Places'),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                Navigator.of(context).pushNamed(AddPlaceScreen.routName);
              },
            )
          ],
        ),
        body: FutureBuilder(
          future: Provider.of<GreatPlaces>(context, listen: false)
              .fetchAndSetPlaces(),
          builder: (ctx, snapshot) => snapshot.connectionState ==
                  ConnectionState.waiting
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : Consumer<GreatPlaces>(
                  builder: (ctx, greatPlaces, ch) =>
                      greatPlaces.items.length <= 0
                          ? ch
                          : ListView.builder(
                              itemBuilder: (ctx, index) => ListTile(
                                leading: CircleAvatar(
                                  backgroundImage:
                                      FileImage(greatPlaces.items[index].image),
                                ),
                                title: Text(greatPlaces.items[index].title),
                                onTap: () {
                                  Navigator.of(context)
                                      .pushNamed(PlaceDetailScreen.routName,arguments: greatPlaces.items[index].id );
                                },
                              ),
                              itemCount: greatPlaces.items.length,
                            ),
                  child: Center(
                    child: Text('Got no Places yet, start adding  some'),
                  ),
                ),
        ));
  }
}
