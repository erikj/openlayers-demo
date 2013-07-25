// Generated by CoffeeScript 1.6.3
(function() {
  var CATMAP, onFeatureSelect, onFeatureUnselect;

  CATMAP = {};

  this.CATMAP = CATMAP;

  CATMAP.load_map = function(map_div_name) {
    var center, christchurch, controls, geoProj, ghyb, gmap, gsat, gterr, kmlDir, latLonBounds, layerSwitcher, map, mercProj, mtsat2kmCh1Layer, mtsatBounds, multiplier, osm, _i, _len, _ref;
    geoProj = new OpenLayers.Projection("EPSG:4326");
    mercProj = new OpenLayers.Projection("EPSG:900913");
    layerSwitcher = new OpenLayers.Control.LayerSwitcher;
    controls = [new OpenLayers.Control.KeyboardDefaults, new OpenLayers.Control.Graticule, layerSwitcher, new OpenLayers.Control.Navigation];
    map = new OpenLayers.Map(map_div_name, {
      controls: controls
    });
    layerSwitcher.maximizeControl();
    CATMAP.map = map;
    osm = new OpenLayers.Layer.OSM();
    map.addLayer(osm);
    gterr = new OpenLayers.Layer.Google("Google Terrain", {
      type: google.maps.MapTypeId.TERRAIN
    });
    gmap = new OpenLayers.Layer.Google("Google Streets", {
      numZoomLevels: 20
    });
    ghyb = new OpenLayers.Layer.Google("Google Hybrid", {
      type: google.maps.MapTypeId.HYBRID,
      numZoomLevels: 20
    });
    gsat = new OpenLayers.Layer.Google("Google Satellite", {
      type: google.maps.MapTypeId.SATELLITE,
      numZoomLevels: 22
    });
    map.addLayers([gterr, gmap, ghyb, gsat]);
    christchurch = new OpenLayers.LonLat(172.620278, -43.53);
    center = christchurch;
    map.setCenter(center.transform(geoProj, mercProj), 5);
    kmlDir = "kml";
    _ref = [-2, -1, 0, 1, 2];
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      multiplier = _ref[_i];
      latLonBounds = [161.0289 + (360 * multiplier), -46.54, 178.9711 + (360 * multiplier), -32.76];
      mtsatBounds = new OpenLayers.Bounds(latLonBounds).transform(geoProj, mercProj);
      mtsat2kmCh1Layer = new OpenLayers.Layer.Image("ops.MTSAT-2.201307242032.Hi-Res_ch1_vis.jpg (" + multiplier + ")", 'img/ops.MTSAT-2.201307242032.Hi-Res_ch1_vis.jpg', mtsatBounds, new OpenLayers.Size(2000, 2000), {
        isBaseLayer: false,
        alwaysInRange: true,
        wrapDateLine: true
      });
      map.addLayers([mtsat2kmCh1Layer]);
      mtsat2kmCh1Layer.setOpacity(.5);
    }
    return map;
  };

  onFeatureSelect = function(event) {
    var content, feature, popup;
    feature = event.feature;
    console.log(feature);
    content = "<h2>" + feature.attributes.name + "</h2>" + feature.attributes.description;
    console.log(feature.attributes.description);
    popup = new OpenLayers.Popup.FramedCloud("chickenXXX", feature.geometry.getBounds().getCenterLonLat(), new OpenLayers.Size(100, 100), content, null, true);
    feature.popup = popup;
    return CATMAP.map.addPopup(popup);
  };

  onFeatureUnselect = function(event) {
    var feature;
    feature = event.feature;
    console.log(feature);
    if (feature.popup) {
      CATMAP.map.removePopup(feature.popup);
      feature.popup.destroy();
      return delete feature.popup;
    }
  };

}).call(this);
