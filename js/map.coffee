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

  osmResolutions = [ 156543.03390625, 78271.516953125, 39135.7584765625,
    19567.87923828125, 9783.939619140625, 4891.9698095703125,
    2445.9849047851562, 1222.9924523925781, 611.4962261962891,
    305.74811309814453, 152.87405654907226, 76.43702827453613,
    38.218514137268066, 19.109257068634033, 9.554628534317017,
    4.777314267158508, 2.388657133579254, 1.194328566789627,
    0.5971642833948135 ]


  # osm = new OpenLayers.Layer.OSM()
  osm = new OpenLayers.Layer.OSM 'Open Street Map', null, {
    resolutions:       osmResolutions,
    serverResolutions: osmResolutions,
    transitionEffect: 'resize' }

  map.addLayer osm

  # ocm = OpenLayers.Layer.OSM("OpenCycleMap",
  # ["http://a.tile.opencyclemap.org/cycle/${z}/${x}/${y}.png",
  #  "http://b.tile.opencyclemap.org/cycle/${z}/${x}/${y}.png",
  #  "http://c.tile.opencyclemap.org/cycle/${z}/${x}/${y}.png"]


  ocm = new OpenLayers.Layer.OSM "OpenCycleMap",
    [
      "http://a.tile.opencyclemap.org/cycle/${z}/${x}/${y}.png",
      "http://b.tile.opencyclemap.org/cycle/${z}/${x}/${y}.png",
      "http://c.tile.opencyclemap.org/cycle/${z}/${x}/${y}.png"
    ]

  map.addLayer ocm


  # google-maps layers
  # based on http://openlayers.org/dev/examples/google-v3.html
  # docs: http://dev.openlayers.org/apidocs/files/OpenLayers/Layer/Google-js.html
  gterr = new OpenLayers.Layer.Google "Google Terrain",   { type: google.maps.MapTypeId.TERRAIN }
  gmap  = new OpenLayers.Layer.Google "Google Streets",   { numZoomLevels: 20 }
  ghyb  = new OpenLayers.Layer.Google "Google Hybrid",    { type: google.maps.MapTypeId.HYBRID,    numZoomLevels: 20 }
  gsat  = new OpenLayers.Layer.Google "Google Satellite", { type: google.maps.MapTypeId.SATELLITE, numZoomLevels: 22 }

  # map.addLayers [ gterr, gmap, ghyb, gsat ]

  # boulder = new OpenLayers.LonLat -105.3, 40.028
  # salina  = new OpenLayers.LonLat -97.6459, 38.7871
  # christchurch = new OpenLayers.LonLat 172.620278, -43.53
  # center  = boulder
  # center  = christchurch
  # nexradCenter = new OpenLayers.LonLat -103, 39
  # center = nexradCenter
  darwin = new OpenLayers.LonLat 130.833, -12.45 #12°27′0″S 130°50′0″E
  oswego = new OpenLayers.LonLat -76.5, 43.45 # 43°27′17″N 76°30′24″W
  center = oswego

  map.setCenter center.transform(geoProj, mercProj), 6

  # kml-layer styling
  # colors = [ 'ff0000', '00ff00', '0000ff', 'ffd700', 'ff00ff', '00ffff' ]
  # styles = ( new OpenLayers.Style('strokeWidth': 3, 'strokeColor': '#' + color) for color in colors )

  # kml layers
  kmlDir = "kml"
  # kmlFilenames = [ "betasso.kml", "boulder.kml", "flagstaff.kml", "gold-hill.kml", "mesa-lab.kml" ]
  # kmlFilenames = [ "GV_flighttrack.kml", "gold-hill.kml" ]
  # kmlFilenames = []

  kmlFilenames = ['ge.DOW6.201312061818.DBZ_radar_only.kml', 'ge.DOW7.201311280108.RHOHV_radar_only.kml']


  # kmlFilenames = [ "ge.research.201205090000.N677F_flight_track.kml" ]

  # kmlFilenames = [ "ge.research.201205090000.N677F_flight_track.kml",
  #   "ge.research.201205111738.NA817_flight_track.kml",
  #   "ge.SMART-R.201205131825.NOXP_location.kml",
  #   "ge.SMART-R.201205111750.NOXP_location.kml",
  #   "ge.NCAR_ISS.201205111652.location.kml" ]

  kmlLayers = []

  # create kml layers
  for kmlFilename, i in kmlFilenames
    kmlUrl = "http://localhost/projects/openlayers-demo/#{kmlDir}/#{kmlFilename}"

    # TODO: check for groundoverlays and add as image layers, as needed

    OpenLayers.Request.GET
        url: kmlUrl
        callback: (response)->
          if response.status==200
            # parse response.responseText
            xmlParser = new OpenLayers.Format.XML()
            kmlDom = xmlParser.read(response.responseText)
            console.log 'here'
            groundOverlayElements = xmlParser.getElementsByTagNameNS(kmlDom, "*", "GroundOverlay")
            console.log 'here2'
            for element in groundOverlayElements
              iconElement = xmlParser.getElementsByTagNameNS(element, '*', 'Icon')[0]
              console.log 'here3'
              iconHrefElement = xmlParser.getElementsByTagNameNS(iconElement, '*', 'href')[0]
              iconHref = iconHrefElement.firstChild.nodeValue
              latLonBoxElement = xmlParser.getElementsByTagNameNS(element, '*', 'LatLonBox')[0]
              northElement = xmlParser.getElementsByTagNameNS(latLonBoxElement, '*', 'north')[0]
              southElement = xmlParser.getElementsByTagNameNS(latLonBoxElement, '*', 'south')[0]
              eastElement  = xmlParser.getElementsByTagNameNS(latLonBoxElement, '*', 'east' )[0]
              westElement  = xmlParser.getElementsByTagNameNS(latLonBoxElement, '*', 'west' )[0]
              north = northElement.firstChild.nodeValue.replace(/(^\s+|\s+$)/g, '')
              console.log northElement
              south = southElement.firstChild.nodeValue.replace(/(^\s+|\s+$)/g, '')
              east = eastElement.firstChild.nodeValue.replace(/(^\s+|\s+$)/g, '')
              west = westElement.firstChild.nodeValue.replace(/(^\s+|\s+$)/g, '')
              bounds = "#{west},#{south},#{east},#{north}"
            console.log "iconHref: #{iconHref}"
            console.log "bounds: #{bounds}"
          else
            console.log "#{request.status} ERROR: #{request.responseText}"


    kmlLayers.push new OpenLayers.Layer.Vector kmlFilename,
        strategies: [ new OpenLayers.Strategy.Fixed() ]
        protocol: new OpenLayers.Protocol.HTTP
            url:    kmlDir + "/" + kmlFilename
            format: new OpenLayers.Format.KML
                extractStyles: true
                extractAttributes: true

  map.addLayers kmlLayers

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

      # map.addLayers [ mtsat4kmLayer ]
      # mtsat4kmLayer.setOpacity .5



    # Pixel Height: 1,007
    # Pixel Width: 779
    # The bounding box should be:
    # N: 41.625
    # S: 38.06161
    # E: -102.14535
    # W: -106.85465

  # latLonNexradBounds = [-106.85465, 38.06161, -102.14535, 41.625]
  # mercNexradBounds = new OpenLayers.Bounds(latLonNexradBounds).transform(geoProj, mercProj)
  # nexradImage = new OpenLayers.Layer.Image(
  #     'img/ops.NEXRAD.201310151939.l2_KFTG_Reflectivity.gif',
  #     'img/ops.NEXRAD.201310151939.l2_KFTG_Reflectivity.gif',
  #     mercNexradBounds,
  #     new OpenLayers.Size(779,1007),
  #       isBaseLayer:   false
  #       alwaysInRange: true
  #       wrapDateLine:  true
  #     )
  # map.addLayers [nexradImage]
  # nexradImage.setOpacity .5

  # N: 5 S
  # S: 20S
  # W: 110 E
  # E: 160 E

  # latLonHiwcBounds = [110, -20, 160, -5]

  # mercHiwcBounds = new OpenLayers.Bounds(latLonHiwcBounds).transform(geoProj, mercProj)
  # hiwcImage = new OpenLayers.Layer.Image(
  #     'img/hiwc-mercator-alpha-2.png',
  #     'img/hiwc-mercator-alpha-2.png',
  #     mercHiwcBounds,
  #     new OpenLayers.Size(770,232),
  #       isBaseLayer:   false
  #       alwaysInRange: true
  #       wrapDateLine:  true
  #     )
  # map.addLayers [hiwcImage]
  # hiwcImage.setOpacity .5


  # N: 48.1931765247953
  # S: 38.8520916019916
  # E: -71.1603613650091
  # W: -84.0830386349909

  latLonOwlesGoesBounds = [-84.0830386349909,38.8520916019916,-71.1603613650091,48.1931765247953]
  owlesGoesBounds = new OpenLayers.Bounds(latLonOwlesGoesBounds).transform(geoProj, mercProj)
  owlesGoesImage  = new OpenLayers.Layer.Image(
      'img/ops.GOES-13.201310282002.1km_ch1_vis.jpg',
      'img/ops.GOES-13.201310282002.1km_ch1_vis.jpg',
      owlesGoesBounds,
      new OpenLayers.Size(800,800),
        isBaseLayer:   false
        alwaysInRange: true
        wrapDateLine:  true
      )
  map.addLayers [owlesGoesImage]
  owlesGoesImage.setOpacity .5



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
