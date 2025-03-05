import 'package:flutter/material.dart';
import 'package:vortex/viewmodels/home_view_model.dart';

void main() {
  runApp(Vortex());
}

class Vortex extends StatefulWidget {
  const Vortex({super.key});

  @override
  State<Vortex> createState() => _VortexState();
}

class _VortexState extends State<Vortex> {
  var viewModel = HomeViewModel();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.blue,
        brightness: Brightness.light,
      ),
      home: Scaffold(
        body: IndexedStack(
          index: viewModel.currentView,
          children: viewModel.views
        ),
        bottomNavigationBar:NavigationBar(
          selectedIndex: viewModel.currentView,
          destinations: [
            NavigationDestination(icon: Icon(Icons.home_rounded), label: "Home"),
            NavigationDestination(icon: Icon(Icons.map_rounded), label: "Map"),
          ],
          onDestinationSelected: (value) {
            setState(() {
                viewModel.currentView = value;
            });
          },
        ),
      )
    );
  }
}
