

import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:mapbox_gl/mapbox_gl.dart';

class FullScreenMap extends StatefulWidget {
  
  @override
  _FullScreenMapState createState() => _FullScreenMapState();
}

class _FullScreenMapState extends State<FullScreenMap> {
  MapboxMapController mapController;
  
  final center = LatLng(43.737996, 7.426000);
  String firstStye = 'mapbox://styles/neffen20/ckgjox3z40gcm1bldjxhs2yqw';
  double zoom = 14;
  
  final darkStyle = 'mapbox://styles/neffen20/ckgjox3z40gcm1bldjxhs2yqw';
  final routeStyle = 'mapbox://styles/neffen20/ckgjozksl0c6y19na5ti0zvsw';
  

  void _onMapCreated(MapboxMapController controller) {
    mapController = controller;
    _onStyleLoaded();
  }
  
  void _onStyleLoaded() {
    addImageFromAsset("assetImage", "assets/custom-icon.png");
    addImageFromUrl("networkImage", "https://via.placeholder.com/50");
  }
  
  
  /// Adds an asset image to the currently displayed style
  Future<void> addImageFromAsset(String name, String assetName) async {
    final ByteData bytes = await rootBundle.load(assetName);
    final Uint8List list = bytes.buffer.asUint8List();
    return mapController.addImage(name, list);
  }

  /// Adds a network image to the currently displayed style
  Future<void> addImageFromUrl(String name, String url) async {
    var response = await http.get(url);
    return mapController.addImage(name, response.bodyBytes);
  } 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: buildMap(),
      floatingActionButton: botonesFlotantes(),
    );
  }

  Column botonesFlotantes() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget> [
        
        // Simbolo
        FloatingActionButton(
          child: Icon(Icons.sentiment_very_dissatisfied),
          onPressed: () {
            
            mapController.addSymbol(SymbolOptions(
              geometry: center,
              // iconSize: 3,
              iconImage: 'networkImage',
              textField: 'Tengo la Magia del Universo',
              textOffset: Offset(0, 3)
            ));            
            
          },
          
        ),
        
        SizedBox(height: 10),
        
        
        // ZoomIn
        FloatingActionButton(
          child: Icon(Icons.zoom_in),
          onPressed: () {
            
            mapController.animateCamera(CameraUpdate.zoomIn());            
            
          },
          
        ),
        
        SizedBox(height: 10),
        // ZoomOut
        FloatingActionButton(
          child: Icon(Icons.zoom_out),
          onPressed: () {
            mapController.animateCamera(CameraUpdate.zoomOut());
          },
        ),
        
        SizedBox(height: 10), 
        
        // Style
        FloatingActionButton(
          child: Icon(Icons.ac_unit),
          onPressed: () {
            
            if(firstStye == darkStyle) {
              firstStye = routeStyle;
            } else {
              firstStye = darkStyle;
            }
              _onStyleLoaded();
            
            setState(() {
            });
            
          },
        )
        
      ],
    );
  }

  MapboxMap buildMap() {
    return MapboxMap(
        styleString: firstStye,
        // accessToken: MapsDemo.ACCESS_TOKEN,  
        onStyleLoadedCallback: _onStyleLoaded,
        onMapCreated: _onMapCreated,
        initialCameraPosition:
        CameraPosition(
          target: center,
          zoom: zoom
        ),
        
      );
  }
}