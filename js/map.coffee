# based on http://wiki.openstreetmap.org/wiki/OpenLayers_Simple_Example

# compile to javascript:
# % coffee -c map.coffee
# => map.js

CATMAP = {}
@CATMAP = CATMAP

# load_map(map_name): initialize openlayers w/ open-street-maps and google-maps base layers
# scope: global, called from rendered html pages
# input: String, dom id of map element
# output: initialized map object
CATMAP.load_map = (map_div_name) ->

  # projections
  geoProj  = new OpenLayers.Projection "EPSG:4326"
  mercProj = new OpenLayers.Projection "EPSG:900913"

  # initialize openlayers map
  layerSwitcher = new OpenLayers.Control.LayerSwitcher
  controls = [ #new OpenLayers.Control.MousePosition({displayProjection:geoProj})
                                            # display lat/lon of mouse's map position in lower-right corner
    # new OpenLayers.Control.OverviewMap      # toggled, lower-right corner
    new OpenLayers.Control.KeyboardDefaults # +/- zoom in/out, move map via arrow keys
    # new OpenLayers.Control.Zoom
    new OpenLayers.Control.Graticule
    layerSwitcher   # toggled, upper-right corner, base-layer select, and vector and image checkboxes
    new OpenLayers.Control.Navigation ]     # move map, zoom in/out w/ via mouse input

  map = new OpenLayers.Map map_div_name,
      controls:controls

  layerSwitcher.maximizeControl()
  CATMAP.map = map
  # layer for open-streep maps
  osm = new OpenLayers.Layer.OSM()
  map.addLayer osm

  # google-maps layers
  # based on http://openlayers.org/dev/examples/google-v3.html
  # docs: http://dev.openlayers.org/apidocs/files/OpenLayers/Layer/Google-js.html
  gterr = new OpenLayers.Layer.Google "Google Terrain",   { type: google.maps.MapTypeId.TERRAIN }
  gmap  = new OpenLayers.Layer.Google "Google Streets",   { numZoomLevels: 20 }
  ghyb  = new OpenLayers.Layer.Google "Google Hybrid",    { type: google.maps.MapTypeId.HYBRID,    numZoomLevels: 20 }
  gsat  = new OpenLayers.Layer.Google "Google Satellite", { type: google.maps.MapTypeId.SATELLITE, numZoomLevels: 22 }

  map.addLayers [ gterr, gmap, ghyb, gsat ]

  # boulder = new OpenLayers.LonLat -105.3, 40.028
  # salina  = new OpenLayers.LonLat -97.6459, 38.7871
  christchurch = new OpenLayers.LonLat 172.620278, -43.53
  # center  = boulder
  center  = christchurch

  map.setCenter center.transform(geoProj, mercProj), 5

  # kml-layer styling
  # colors = [ 'ff0000', '00ff00', '0000ff', 'ffd700', 'ff00ff', '00ffff' ]
  # styles = ( new OpenLayers.Style('strokeWidth': 3, 'strokeColor': '#' + color) for color in colors )

  # kml layers
  kmlDir = "kml"
  # kmlFilenames = [ "betasso.kml", "boulder.kml", "flagstaff.kml", "gold-hill.kml", "mesa-lab.kml" ]

  # kmlFilenames = [ "ge.research.201205090000.N677F_flight_track.kml" ]

  # kmlFilenames = [ "ge.research.201205090000.N677F_flight_track.kml",
  #   "ge.research.201205111738.NA817_flight_track.kml",
  #   "ge.SMART-R.201205131825.NOXP_location.kml",
  #   "ge.SMART-R.201205111750.NOXP_location.kml",
  #   "ge.NCAR_ISS.201205111652.location.kml" ]

  # kmlLayers = []

  # create kml layers
  # for kmlFilename, i in kmlFilenames
  #   kmlLayers.push new OpenLayers.Layer.Vector 'KML' #kmlFilename, kmlDir + "/" + kmlFilename,
  #       strategies: [ new OpenLayers.Strategy.Fixed() ]
  #       protocol: new OpenLayers.Protocol.HTTP
  #           url:    kmlDir + "/" + kmlFilename
  #           format: new OpenLayers.Format.KML
  #               extractStyles: true
  #               extractAttributes: true

  # map.addLayers kmlLayers

  # create handlers for popups in kml layers
  # for kmlLayer in kmlLayers
  #   # http://dev.openlayers.org/releases/OpenLayers-2.11/examples/sundials.html
  #   kmlLayer.events.on
  #       "featureselected":   onFeatureSelect
  #       "featureunselected": onFeatureUnselect

  # TODO: draw a line from Boulder to Salina
  # https://github.com/NCAR-Earth-Observing-Laboratory/catalog-maps/issues/69
  # lineLayer = new OpenLayers.Layer.Vector("Line Layer")
  # map.addControl( new OpenLayers.Control.DrawFeature(lineLayer, OpenLayers.Handler.Path) )

  # # points =[ new OpenLayers.Geometry.Point(lon1, lat1), new OpenLayers.Geometry.Point(lon2, lat2) ]
  # points = [ salina, boulder ]

  # line = new OpenLayers.Geometry.LineString(points)

  # style = { strokeColor: '#0000ff'
  #   strokeOpacity: 0.5
  #   strokeWidth: 5
  # }

  # lineFeature = new OpenLayers.Feature.Vector(line, null, style)
  # lineLayer.addFeatures( [ lineFeature ])

  # map.addLayer lineLayer

  # kmlSelector = new OpenLayers.Control.SelectFeature kmlLayers
  # map.addControl kmlSelector
  # kmlSelector.activate()

  # G14 1km: N: 41.876 S: 28.1227 E: -76.2822 W: -93.1523
  # sasGoesSeBounds = new OpenLayers.Bounds(-93.1523, 28.09, -76.26, 41.876).transform(geoProj, mercProj)

  # ops.GOES-14.201305311645.1km_SE_ch1_vis.jpg
  # sas1kmCh1SeLayer = new OpenLayers.Layer.Image(
  #   'ops.GOES-13.201306201740.1km_SE_ch1_vis.jpg',
  #   'img/ops.GOES-13.201306201740.1km_SE_ch1_vis.jpg',
  #   sasGoesSeBounds,
  #   new OpenLayers.Size(1024,1024),
  #     isBaseLayer: false
  #     alwaysInRange: true
  #     wrapDateLine: true
  #   )

  # map.addLayers [ sas1kmCh1SeLayer ]
  # sas1kmCh1SeLayer.setOpacity .5

  # multipliers = [-2, -1, 0, 1, 2]
  multipliers = [-1, 0]

  mtsat4kmImages = ['img/ops.MTSAT-2.201308012032.ch1_vis.jpg', 'img/ops.MTSAT-2.201308012032.ch2_thermal_IR.jpg', 'img/ops.MTSAT-2.201308012032.ch4_water_vapor.jpg']
  # mtsat4kmImages = ['img/ops.MTSAT-2.201308012032.ch1_vis.jpg']

  for multiplier in multipliers
    # latLonBounds2km = [161.0289+(360*multiplier), -46.54, 178.9711+(360*multiplier), -32.76]
    # mtsatBounds2km = new OpenLayers.Bounds(latLonBounds2km).transform(geoProj, mercProj)

    # mtsat2kmCh1Layer = new OpenLayers.Layer.Image(
    #   "ops.MTSAT-2.201307242032.Hi-Res_ch1_vis.jpg (#{multiplier})",
    #   'img/ops.MTSAT-2.201307242032.Hi-Res_ch1_vis.jpg',
    #   mtsatBounds2km,
    #   new OpenLayers.Size(2000,2000),
    #     isBaseLayer:   false
    #     alwaysInRange: true
    #     wrapDateLine:  true
    #   )
    # # console.log "mtsat4kmCh1Layer.wrapDateLine #{mtsat4kmCh1Layer.wrapDateLine}"

    # map.addLayers [ mtsat2kmCh1Layer ]
    # mtsat2kmCh1Layer.setOpacity .5

    # North: -17.84
    # South: -63.04
    # West: 130E
    # East: 150W

    latLonBounds4km = [130.5+(360*multiplier), -63.5, 360-150.5+(360*multiplier), -17.84]
    mtsatBounds4km = new OpenLayers.Bounds(latLonBounds4km).transform(geoProj, mercProj)

    for image in mtsat4kmImages

      mtsat4kmLayer = new OpenLayers.Layer.Image(
        image,
        image,
        mtsatBounds4km,
        new OpenLayers.Size(2200,1800),
          isBaseLayer:   false
          alwaysInRange: true
          wrapDateLine:  true
        )
      # console.log "mtsat4kmCh1Layer.wrapDateLine #{mtsat4kmCh1Layer.wrapDateLine}"

      map.addLayers [ mtsat4kmLayer ]
      mtsat4kmLayer.setOpacity .5

  return map


onFeatureSelect = (event) ->
  feature = event.feature
  console.log feature
  # console.log "featureselected"
  content = "<h2>" + feature.attributes.name + "</h2>" + feature.attributes.description

  console.log feature.attributes.description

  popup = new OpenLayers.Popup.FramedCloud "chickenXXX",
    feature.geometry.getBounds().getCenterLonLat()
    new OpenLayers.Size(100,100)
    content
    null
    true #, onFeatureUnselect(event)

  feature.popup = popup
  CATMAP.map.addPopup popup

onFeatureUnselect = (event) ->
  # alert 'unselected'
  feature = event.feature
  console.log feature
  if feature.popup
    CATMAP.map.removePopup feature.popup
    feature.popup.destroy()
    delete feature.popup
