#
# OpenLayersDemo displaying ArcticConnect tiles in polar projections
#

map = map or {}
@map = map

map.init = (divName='map',projectionLabel='3571', offsetLabel='0') ->
  console.log "map.init(#{divName}, #{projectionLabel}, #{offsetLabel})"
  labelEl = document.getElementById('projection-label')
  labelEl.innerHTML = "EPSG:#{projectionLabel}"
  labelEl.innerHTML += " (#{offsetLabel})"
  # based on http://polar.openstreetmap.de/
  # depends on http://cdnjs.cloudflare.com/ajax/libs/proj4js/1.1.0/proj4js-compressed.js
  # http://epsg.io/3571

  Proj4js.defs['EPSG:3571'] = '+proj=laea +lat_0=90 +lon_0=180 +x_0=0 +y_0=0 +datum=WGS84 +units=m +no_defs'
  Proj4js.defs['EPSG:3572'] = '+proj=laea +lat_0=90 +lon_0=-150 +x_0=0 +y_0=0 +datum=WGS84 +units=m +no_defs'
  Proj4js.defs['EPSG:3573'] = '+proj=laea +lat_0=90 +lon_0=-100 +x_0=0 +y_0=0 +datum=WGS84 +units=m +no_defs'
  Proj4js.defs['EPSG:3574'] = '+proj=laea +lat_0=90 +lon_0=-40 +x_0=0 +y_0=0 +datum=WGS84 +units=m +no_defs'
  Proj4js.defs['EPSG:3575'] = '+proj=laea +lat_0=90 +lon_0=10 +x_0=0 +y_0=0 +datum=WGS84 +units=m +no_defs'
  Proj4js.defs['EPSG:3576'] = '+proj=laea +lat_0=90 +lon_0=90 +x_0=0 +y_0=0 +datum=WGS84 +units=m +no_defs'

  # https://github.com/GeoSensorWebLab/polarmap.js/blob/master/API.markdown
  extent = 11000000 + 9036842.762 + 667
  console.log "extent: #{extent}"
  # maxExtent = [ -extent, -extent, extent, extent ]
  maxExtent = [ -extent, -extent, extent, extent ]

  # worldExtent = [ -180, 45, 180, 90]
  worldExtent = [ -180, 0, 180, 90]
  # worldExtent = [-360, -90, 360, 90]

  # http://spatialreference.org/ref/epsg/3574/


  # WGS84 Bounds: -180.0000, 45.0000, 180.0000, 90.0000
  # Projected Bounds: -3142803.8309, 0.0000, 0.0000, 3745447.7564


  # maxExtent = [ -3142803.8309, 0.0000, 3745447.7564, 0.0000 ]
  worldExtent = [-180.0000, 45.0000, 180.0000, 90.0000]

  OpenLayers.Projection.defaults["EPSG:3574"] =
    maxExtent: maxExtent
    worldExtent: worldExtent

  # OpenLayers.Projection.defaults["EPSG:4326"].worldExtent = [-360, -90, 360, 90]
  OpenLayers.Projection.defaults["EPSG:4326"].worldExtent = worldExtent

  map = new OpenLayers.Map 'map',
    controls: [
      new OpenLayers.Control.Navigation()
      new OpenLayers.Control.PanZoomBar()
      new OpenLayers.Control.Attribution()
      new OpenLayers.Control.ScaleLine()
    ]
    projection: "EPSG:#{projectionLabel}"
    displayProjection: 'EPSG:4326'

  tiles = new OpenLayers.Layer.XYZ "EPSG:#{projectionLabel}", "http://a.tiles.arcticconnect.ca/osm_#{projectionLabel}/${z}/${x}/${y}.png",
    projection: "EPSG:#{projectionLabel}"
    maxExtent: maxExtent
    worldExtent: worldExtent
    attribution: 'Map &copy; <a href=\'http://arcticconnect.ca/\'>ArcticConnect</a>. Data &copy; <a href=\'http://www.openstreetmap.org/\'>OpenStreetMap</a> contributors'
    numZoomLevels: 10
    transitionEffect: 'resize'

  map.addLayer tiles

  map.addControl new OpenLayers.Control.Graticule()

  if !map.getCenter()
    console.log 'map.setCenter()'
    map.setCenter new OpenLayers.LonLat(0, 0), 1

  map.zoomTo 4
