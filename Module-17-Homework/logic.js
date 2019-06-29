// Store our API endpoint inside earthquakeUrl
var earthquakeUrl = "https://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/all_week.geojson";
var platesUrl = "https://raw.githubusercontent.com/fraxen/tectonicplates/master/GeoJSON/PB2002_boundaries.json";

// Perform a GET request to the earthquake URL (this is a "promise")
d3.json(earthquakeUrl, function(data) {
  // Once we get a response, send the data.features object to the createFeatures function
  createFeatures(data.features);
});

// quake magnitude color function
function markerColor(d) {
  if (d >= 6.0) {
    return "#A30000";
  } 
  if (d >= 5.0) {
    return "#FF3333";
  } 
  else if (d >= 4.0) {
    return "#ff6666";
  }
  else if (d >= 3.0) {
    return "#ff9999";
  }
  else if (d >= 2.0) {
    return '#ffcccc';
  }
  else if (d >= 1.0) {
    return '#ffe5e5';
  }   
  else {
    return '#ffffff';
  }
};

function createFeatures(earthquakeData) {

  // Define a function we want to run once for each feature in the features array
  // Give each feature a popup describing the place and time of the earthquake
  function onEachFeature(feature, layer) {
    layer.bindPopup("<h3>" + feature.properties.place + "<br>Magnitude: " + feature.properties.mag + "<br>Duration (minutes): " + feature.properties.dmin +
      "</h3><hr><p>" + new Date(feature.properties.time) + "</p>");
  }

  // Create a GeoJSON layer containing the features array on the earthquakeData object
  // Run the onEachFeature function once for each piece of data in the array
  var earthquakes = L.geoJSON(earthquakeData, {
    onEachFeature: onEachFeature,
    pointToLayer: function(feature, coordinates) {
      var markers = {
        radius: 2 * feature.properties.mag,
        fillColor: markerColor(feature.properties.mag),
        color: "#000",
        fillOpacity: 0.9,
        stroke: true,
        weight: .3
      };
    return L.circleMarker(coordinates, markers);
    }
  });

  // Sending our earthquakes layer to the createMap function
  createMap(earthquakes);
}

function createMap(earthquakes) {

  // Define lightmap and darkmap layers
  var lightmap = L.tileLayer("https://api.tiles.mapbox.com/v4/{id}/{z}/{x}/{y}.png?access_token={accessToken}", {
    attribution: "Map data &copy; <a href=\"https://www.openstreetmap.org/\">OpenStreetMap</a> contributors, <a href=\"https://creativecommons.org/licenses/by-sa/2.0/\">CC-BY-SA</a>, Imagery Â© <a href=\"https://www.mapbox.com/\">Mapbox</a>",
    maxZoom: 18,
    id: "mapbox.streets",
    accessToken: API_KEY
  });

  var darkmap = L.tileLayer("https://api.tiles.mapbox.com/v4/{id}/{z}/{x}/{y}.png?access_token={accessToken}", {
    attribution: "Map data &copy; <a href=\"https://www.openstreetmap.org/\">OpenStreetMap</a> contributors, <a href=\"https://creativecommons.org/licenses/by-sa/2.0/\">CC-BY-SA</a>, Imagery Â© <a href=\"https://www.mapbox.com/\">Mapbox</a>",
    maxZoom: 18,
    id: "mapbox.dark",
    accessToken: API_KEY
  });

  // Define a baseMaps object to hold our base layers
  var baseMaps = {
    "Dark Map": darkmap,
    "Light Map": lightmap

  };

  // Add a new layer for tectonic plates
  var tectonicPlates = new L.layerGroup();

  // Create overlay object to hold our overlay layer
  var overlayMaps = {
    "Earthquakes": earthquakes,
    "Fault Lines": tectonicPlates
  };

  // Create our map, giving it the satellite and earthquakes layers to display on load
  var myMap = L.map("map", {
    center: [
      36, -5
    ],
    zoom: 2,
    layers: [darkmap, earthquakes]
  });

    // Perform a GET request to the query tectonic plates URL (this is a "promise")
  d3.json(platesUrl, function(platesData) {
    L.geoJSON(platesData, {
      color: "white",
      weight: 1
    }).addTo(tectonicPlates)
  });


  // Create a layer control
  // Pass in our baseMaps and overlayMaps
  // Add the layer control to the map
  L.control.layers(baseMaps, overlayMaps, {
    collapsed: false
  }).addTo(myMap);
    // Set up the legend 
    var legend = L.control({position: 'topright'});

    legend.onAdd = function(myMap) {
  
      var div = L.DomUtil.create('div', 'info legend'),
                grades = [0, 1, 2, 3, 4, 5, 6],
                labels = [];
  
    // loop through our density intervals and generate a label with a colored square for each interval
      for (var i = 0; i < grades.length; i++) {
          div.innerHTML +=
              '<i style="background:' + markerColor(grades[i]) + '"></i> ' +
              grades[i] + (grades[i + 1] ? '&ndash;' + grades[i + 1] + '<br>' : '+');
      }
      return div;
    };
  
    // Adding legend to the map
    legend.addTo(myMap);
  
}
