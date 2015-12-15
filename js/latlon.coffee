# $ coffee -c js/latlon.coffee

# proof of concept using EOL MapServer w/ Lat-Lon projection

init = ->
  lon = -75
  lat = -55
  zoom = 5

  map = new OpenLayers.Map('map')
  # http://mapserver.eol.ucar.edu/catalog-mapserv?LAYERS=bath,cntry00&TRANSPARENT=TRUE&SERVICE=WMS&VERSION=1.1.1&REQUEST=GetMap&STYLES=&FORMAT=image/png&SRS=EPSG:4326&WIDTH=768&HEIGHT=768&BBOX=-80,-65,-50,-50>

  params = layers: [ 'bath', 'cntry00' ]

  layer = new OpenLayers.Layer.WMS('EOL MapServer WMS', 'http://mapserver.eol.ucar.edu/catalog-mapserv', params)

  map.addLayer layer
  map.setCenter new OpenLayers.LonLat(lon, lat), zoom
  map.addControl new OpenLayers.Control.LayerSwitcher

  map.addControl new OpenLayers.Control.Graticule

  return

init()
