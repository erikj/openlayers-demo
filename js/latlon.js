// Generated by CoffeeScript 1.7.1
(function() {
  var init;

  init = function() {
    var lat, layer, lon, map, params, zoom;
    lon = -75;
    lat = -55;
    zoom = 5;
    map = new OpenLayers.Map('map');
    params = {
      layers: ['bath', 'cntry00']
    };
    layer = new OpenLayers.Layer.WMS('EOL MapServer WMS', 'http://mapserver.eol.ucar.edu/catalog-mapserv', params);
    map.addLayer(layer);
    map.setCenter(new OpenLayers.LonLat(lon, lat), zoom);
    map.addControl(new OpenLayers.Control.LayerSwitcher);
    map.addControl(new OpenLayers.Control.Graticule);
  };

  init();

}).call(this);