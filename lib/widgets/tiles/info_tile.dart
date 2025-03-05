import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import '../components/property_widget.dart';
import 'package:vortex/widgets/components/custom_card_widget.dart';
import '../../models/data/properties/property.dart';
import 'dart:math';

class InfoTile extends StatefulWidget {
  final List<Property> properties;

  const InfoTile({super.key, required this.properties});

  @override
  State<StatefulWidget> createState() => InfoTileState();
}

class InfoTileState extends State<InfoTile> {
  List<List<Property>> _splitProperties(List<Property> properties, int count) {
    List<List<Property>> res = [];

    for (int i = 0; i < properties.length; i += count) {
      final size = i + count;
      res.add(properties.sublist(
          i, size > properties.length ? properties.length : size));
    }
    return res;
  }

  @override
  Widget build(BuildContext context) {
    int numberOfColumns = (MediaQuery.of(context).size.width / 200).round();
    numberOfColumns = numberOfColumns > 3 ? 3 : numberOfColumns;
    final splitedProperties = _splitProperties(widget.properties, numberOfColumns);
    return CustomCardWidget(
      child: ListView.separated(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: splitedProperties.length,
        separatorBuilder: (context, index) => Divider(
          thickness: 1, color: Theme.of(context).colorScheme.secondary),
        itemBuilder: (context, i) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: splitedProperties[i]
            .map((p) => PropertyWidget(property: p))
            .toList(),
          );
    }));
  }
}
