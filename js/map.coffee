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
  CATMAP.geoProj = geoProj
  CATMAP.mercProj = mercProj
  # initialize openlayers map
  layerSwitcher = new OpenLayers.Control.LayerSwitcher
  CATMAP.graticuleControl = new OpenLayers.Control.Graticule
  controls = [ #new OpenLayers.Control.MousePosition({displayProjection:geoProj})
                                            # display lat/lon of mouse's map position in lower-right corner
    # new OpenLayers.Control.OverviewMap      # toggled, lower-right corner
    new OpenLayers.Control.KeyboardDefaults # +/- zoom in/out, move map via arrow keys
    # new OpenLayers.Control.Zoom
    CATMAP.graticuleControl
    layerSwitcher   # toggled, upper-right corner, base-layer select, and vector and image checkboxes
    new OpenLayers.Control.Navigation ]     # move map, zoom in/out w/ via mouse input

  map = new OpenLayers.Map map_div_name,
      controls:controls
  CATMAP.graticuleControl.deactivate()


  setInterval "CATMAP.graticuleControl.activate()", 1000


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
  # osm = new OpenLayers.Layer.OSM 'Open Street Map', "http://localhost/osm_tiles/${z}/${x}/${y}.png", {
    resolutions:       osmResolutions,
    serverResolutions: osmResolutions,
    transitionEffect: 'resize',
    wrapDateLine:true }

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
  # makePlaneMarker()
  # planeLayer = newPlaneLayer()

  # map.addLayer planeLayer
  # # icon = planeLayer.getFeatureByFid('gv-icon')
  # console.log 'AA'
  # icon = planeLayer.getFeaturesByAttribute('name', 'gv-icon')[0]
  # console.log icon
  # console.log 'AB'
  # lonLat = new OpenLayers.LonLat(-105, 40).transform(CATMAP.geoProj, CATMAP.mercProj)
  # console.log 'AC'
  # # icon.move( lonLat)
  # # icon.lonlat = lonLat
  # console.log 'AD'


  # google-maps layers
  # based on http://openlayers.org/dev/examples/google-v3.html
  # docs: http://dev.openlayers.org/apidocs/files/OpenLayers/Layer/Google-js.html
  # gterr = new OpenLayers.Layer.Google "Google Terrain",   { type: google.maps.MapTypeId.TERRAIN }
  # gmap  = new OpenLayers.Layer.Google "Google Streets",   { numZoomLevels: 20 }
  # ghyb  = new OpenLayers.Layer.Google "Google Hybrid",    { type: google.maps.MapTypeId.HYBRID,    numZoomLevels: 20 }
  # gsat  = new OpenLayers.Layer.Google "Google Satellite", { type: google.maps.MapTypeId.SATELLITE, numZoomLevels: 22 }

  # map.addLayers [ gterr, gmap, ghyb, gsat ]

  boulder = new OpenLayers.LonLat -105.3, 40.028
  # salina  = new OpenLayers.LonLat -97.6459, 38.7871
  # christchurch = new OpenLayers.LonLat 172.620278, -43.53
  mendoza =  new OpenLayers.LonLat -68.0, -35.0
  # dateline = new OpenLayers.LonLat -180, 0
  center  = mendoza
  # center  = christchurch
  # nexradCenter = new OpenLayers.LonLat -103, 39
  # center = nexradCenter
  # darwin = new OpenLayers.LonLat 130.833, -12.45 #12°27′0″S 130°50′0″E
  # oswego = new OpenLayers.LonLat -76.5, 43.45 # 43°27′17″N 76°30′24″W
  # # guam: 13.5000° N, 144.8000° E
  # guam = new OpenLayers.LonLat 144.8, 13.5
  # center = guam

  map.setCenter center.transform(geoProj, mercProj), 6

  # kml-layer styling
  # colors = [ 'ff0000', '00ff00', '0000ff', 'ffd700', 'ff00ff', '00ffff' ]
  # styles = ( new OpenLayers.Style('strokeWidth': 3, 'strokeColor': '#' + color) for color in colors )

  # kml layers
  kmlDir = "kml"
  # kmlFilenames = [ "betasso.kml", "boulder.kml", "flagstaff.kml", "gold-hill.kml", "mesa-lab.kml" ]
  # kmlFilenames = [ "GV_flighttrack.kml", "gold-hill.kml" ]

  # kmlFilenames = ['ge.facility_locations.201312111200.soundings.kml', 'ge.COSMIC.201312130000.soundings.kml']

  # kmlFilenames = ['GV_RF02.kml']

  # kmlFilenames = ['ge.DOW6.201312061818.DBZ_radar_only.kml', 'ge.DOW7.201311280108.RHOHV_radar_only.kml', 'ge.research.201205090000.N677F_flight_track.kml']

  groundOverlayFilenames = []
  # groundOverlayFilenames = ['catmap.ge.DOW6.201312071606.NCP_radar_only.kml', 'catmap.ge.DOW7.201312071633.NCP_radar_only.kml']


  # kmlFilenames = [ "ge.research.201205090000.N677F_flight_track.kml" ]
  # kmlFilenames = ['gis.InciWeb.201709181336.Current_Incidents.kml', 'gis.NSF_NCAR_C130.201709211932.flight_track.kml']

  # kmlFilenames = ['gis.RV_Investigator.201801042000.track.kml']
  kmlFilenames = []
  # drawLinestring [170,0], [179,0]
  drawLinestring()

  drawLinestring([-180,10], [-180,-10], '#ff9900')



  # kmlFilenames = ['potential_mobile_sites.kml']

  # kmlFilenames = [ "ge.research.201205090000.N677F_flight_track.kml",
  #   "ge.research.201205111738.NA817_flight_track.kml",
  #   "ge.SMART-R.201205131825.NOXP_location.kml",
  #   "ge.SMART-R.201205111750.NOXP_location.kml",
  #   "ge.NCAR_ISS.201205111652.location.kml" ]

  kmlLayers = []

  # create kml layers
  for kmlFilename, i in groundOverlayFilenames
    # create kmlUrl from window.location and relative path
    kmlUrl = "#{window.location['href'].replace(/\/[^\/]*$/, '/')}#{kmlDir}/#{kmlFilename}"

    # check for groundoverlays and add as image layers, as needed

    OpenLayers.Request.GET
        url: kmlUrl
        callback: (response, kmlUrl)->
          if response.status==200
            # parse response.responseText
            xmlParser = new OpenLayers.Format.XML()
            kmlDom = xmlParser.read(response.responseText)
            groundOverlayElements = xmlParser.getElementsByTagNameNS(kmlDom, "*", "GroundOverlay")
            console.log groundOverlayElements.length
            if groundOverlayElements.length < 1
              # plain-old KML
              # TODO: create KML layer, add to CATMAP.map
              # console.log kmlUrl
            else
              for element in groundOverlayElements
                iconElement = xmlParser.getElementsByTagNameNS(element, '*', 'Icon')[0]
                iconHrefElement = xmlParser.getElementsByTagNameNS(iconElement, '*', 'href')[0]
                iconHref = iconHrefElement.firstChild.nodeValue
                latLonBoxElement = xmlParser.getElementsByTagNameNS(element, '*', 'LatLonBox')[0]
                northElement = xmlParser.getElementsByTagNameNS(latLonBoxElement, '*', 'north')[0]
                southElement = xmlParser.getElementsByTagNameNS(latLonBoxElement, '*', 'south')[0]
                eastElement  = xmlParser.getElementsByTagNameNS(latLonBoxElement, '*', 'east' )[0]
                westElement  = xmlParser.getElementsByTagNameNS(latLonBoxElement, '*', 'west' )[0]
                # trim whitespace
                north = northElement.firstChild.nodeValue.replace(/(^\s+|\s+$)/g, '')
                # console.log northElement
                south = southElement.firstChild.nodeValue.replace(/(^\s+|\s+$)/g, '')
                east = eastElement.firstChild.nodeValue.replace(/(^\s+|\s+$)/g, '')
                west = westElement.firstChild.nodeValue.replace(/(^\s+|\s+$)/g, '')
                # bounds = "#{west},#{south},#{east},#{north}"
                console.log "iconHref: #{iconHref}"
                # console.log "bounds: #{west},#{south},#{east},#{north}"
                # add image layer, based on bounds and iconHref
                latLonGroundOverlayBounds = [west,south,east,north]
                groundOverlayBounds = new OpenLayers.Bounds(latLonGroundOverlayBounds).transform(CATMAP.geoProj, CATMAP.mercProj)
                # get name from href's match characters after last slash
                iconName = iconHref.match(/\/([^\/]*)$/)[1]
                groundOverlayImage  = new OpenLayers.Layer.Image(
                    iconName,
                    iconHref,
                    groundOverlayBounds,
                    new OpenLayers.Size(800,800), # is this really used? this value is bogus
                      isBaseLayer:   false
                      alwaysInRange: true
                      wrapDateLine:  true
                    )
                CATMAP.map.addLayers [groundOverlayImage]
                groundOverlayImage.setOpacity .5
          else
            console.log "#{request.status} ERROR: #{request.responseText}"

  for kmlFilename, i in kmlFilenames

    kmlLayers.push new OpenLayers.Layer.Vector kmlFilename,
        strategies: [ new OpenLayers.Strategy.Fixed() ]
        protocol: new OpenLayers.Protocol.HTTP
            url:    kmlDir + "/" + kmlFilename
            format: new OpenLayers.Format.KML
                extractStyles: true
                extractAttributes: true

  # create handlers for popups in kml layers
  for kmlLayer in kmlLayers
    console.log kmlLayer
    # http://dev.openlayers.org/releases/OpenLayers-2.11/examples/sundials.html
    kmlLayer.events.on
        "featureselected":   onFeatureSelect
        "featureunselected": onFeatureUnselect

  map.addLayers kmlLayers

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

  kmlSelector = new OpenLayers.Control.SelectFeature kmlLayers
  map.addControl kmlSelector
  kmlSelector.activate()

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
  # multipliers = [-1, 0]
  multipliers = [0]

  mtsat4kmImages = ['img/ops.MTSAT-2.201308012032.ch1_vis.jpg', 'img/ops.MTSAT-2.201308012032.ch2_thermal_IR.jpg', 'img/ops.MTSAT-2.201308012032.ch4_water_vapor.jpg']
  mtsat2Images = ['img/ops.MTSAT-2.201401272201.CONTRAST_GUAM_ch1_vis.jpg']
  # mtsat4kmImages = ['img/ops.MTSAT-2.201308012032.ch1_vis.jpg']

  goesCoImages = ['img/satellite.GOES-13.201610042137.1km_CO_ch1_vis.jpg']

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

    # images = ['img/model.CAMChem_NCAR_1deg.201401090000.000_200hPa_BrO_gis.png']
    images = ['img/model.CAMChem_NCAR_1deg.201401090000.072_200hPa_OH_gis.png']

    images = ['img/radar.SMN_AR_Radar.201811262216.Mendoza_Reflectivity.gif']

    # latLonCamChemBounds = [51.0857,-47.5559,-71.0857,52.175]
    # camChemBounds = new OpenLayers.Bounds(latLonCamChemBounds).transform(geoProj, mercProj)
    # camChemImage  = new OpenLayers.Layer.Image(
    #     'img/model.CAMChem_NCAR_1deg.201401090000.000_200hPa_BrO_gis.png',
    #     'img/model.CAMChem_NCAR_1deg.201401090000.000_200hPa_BrO_gis.png',
    #     camChemBounds,
    #     new OpenLayers.Size(0,0),
    #       isBaseLayer:   false
    #       alwaysInRange: true
    #       wrapDateLine:  true
    #     )
    # map.addLayers [camChemImage]
    # camChemImage.setOpacity .5

    # [left, bottom, right, top]

    # lower-left (88 E, 39.1795 S), upper-left (88 E, 58.2806 N), upper-right (68 W, 58.2806 N), lower-right (68 W, 39.1795 S)
    # latLonBounds = [88+(360*multiplier), -39.1795, 360-68+(360*multiplier), 58.2806]

    # N: 20.9 N
    # S: 11.0 N
    # E: 154.9E
    # W: 134.95 E
    # left   = 134.695
    # bottom = 5.738
    # right  = 154.91
    # top    = 20.9845


    # left =   -109.46
    # bottom = 36.45
    # right =  -100.5
    # top =    43.35

    #   new google.maps.LatLng(-37.49747577933491,-71.74932632043229),
    # new google.maps.LatLng(-31.18903475404245,-64.69171692441731));


    top = -31.27
    bottom = -37.42
    left = -71.67
    # right = -64.69171
    right = -65.17

    latLonBounds = [left+(360*multiplier), bottom, right+(360*multiplier), top]

    bounds = new OpenLayers.Bounds(latLonBounds).transform(geoProj, mercProj)

    # for image in mtsat2Images
    for image in images
      # for image in []

      imageLayer = new OpenLayers.Layer.Image(
        'adjusted',
        image,
        bounds,
        new OpenLayers.Size(2200,1800),
          isBaseLayer:   false
          alwaysInRange: true
          wrapDateLine:  true
        )

      # console.log "mtsat4kmCh1Layer.wrapDateLine #{mtsat4kmCh1Layer.wrapDateLine}"

      map.addLayers [ imageLayer ]
      imageLayer.setOpacity .5

    #   new google.maps.LatLng(-37.49747577933491,-71.74932632043229),
    # new google.maps.LatLng(-31.18903475404245,-64.69171692441731));

    bottom = -37.49747577933491
    left = -71.74932632043229
    top = -31.18903475404245
    right = -64.69171692441731

    latLonBounds = [left+(360*multiplier), bottom, right+(360*multiplier), top]

    bounds = new OpenLayers.Bounds(latLonBounds).transform(geoProj, mercProj)


    for image in images
      # for image in []

      imageLayer = new OpenLayers.Layer.Image(
        'original',
        image,
        bounds,
        new OpenLayers.Size(2200,1800),
          isBaseLayer:   false
          alwaysInRange: true
          wrapDateLine:  true
        )

      # console.log "mtsat4kmCh1Layer.wrapDateLine #{mtsat4kmCh1Layer.wrapDateLine}"

      map.addLayers [ imageLayer ]
      imageLayer.setOpacity .5



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

  # latLonOwlesGoesBounds = [-84.0830386349909,38.8520916019916,-71.1603613650091,48.1931765247953]
  # owlesGoesBounds = new OpenLayers.Bounds(latLonOwlesGoesBounds).transform(geoProj, mercProj)
  # owlesGoesImage  = new OpenLayers.Layer.Image(
  #     'img/ops.GOES-13.201310282002.1km_ch1_vis.jpg',
  #     'img/ops.GOES-13.201310282002.1km_ch1_vis.jpg',
  #     owlesGoesBounds,
  #     new OpenLayers.Size(800,800),
  #       isBaseLayer:   false
  #       alwaysInRange: true
  #       wrapDateLine:  true
  #     )
  # map.addLayers [owlesGoesImage]
  # owlesGoesImage.setOpacity .5

  # contrastImages
  # The coordinates for each corner of the whole image are lower-left (94.3286 E, 47.5559 S), upper-left (71.0857 E, 52.1575 N), upper-right (51.0857 W, 52.1575 N), lower-right (74.3286 W, 47.5559 S).


  return map


onFeatureSelect = (event) ->
  feature = event.feature
  console.log feature
  # console.log "featureselected"
  content = "<h2>" + feature.attributes.name + "</h2>" + feature.attributes.description

  console.log feature

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


newPlaneLayer = () ->

  console.log 'A'
  planeLayer = new OpenLayers.Layer.Vector('gv-layer',
      visibility: true,
      displayInLayerSwitcher: true,
      'calculateInRange': () ->
        return true
      numZoomLevels: 18
  )

  console.log 'B'
  icon = new OpenLayers.Feature.Vector(
    new OpenLayers.Geometry.Point(-105, 40).transform(CATMAP.geoProj, CATMAP.mercProj),
    {
      name: 'gv-icon',
      description: "plane description"
    },
    {
      externalGraphic: 'img/blueplane.png',
      graphicWidth: 30,
      graphicHeight: 30,
      graphicOpacity: 0.8
    }
  )
  icon.style.rotation = '-450'
  console.log 'C'
  # icon.attributes =

  console.log 'D'
  # lonLat = new OpenLayers.LonLat(-105, 40).transform(CATMAP.geoProj, CATMAP.mercProj)
  # icon.lonlat = lonLat
  planeLayer.addFeatures [icon]
  console.log 'E'

  return planeLayer

makePlaneMarker = () ->

  lonLat = new OpenLayers.LonLat(-105, 40).transform(CATMAP.geoProj, CATMAP.mercProj)
  markers = new OpenLayers.Layer.Markers( 'Markers' );
  CATMAP.map.addLayer(markers);
  iconSize = OpenLayers.Size(30,30)
  icon = OpenLayers.Icon('img/blueplane.png', iconSize)
  markers.addMarker( new OpenLayers.Marker(lonLat, icon) )


straightPath = (startPoint, endPoint) ->
  console.log "straightPath()"
  console.log startPoint
  console.log endPoint
  # Do we cross the dateline? If yes, then flip endPoint across it
  if Math.abs(startPoint.x - (endPoint.x)) > 180
    if startPoint.x < endPoint.x
      endPoint.x -= 360
    else
      endPoint.x += 360
  [
    startPoint
    endPoint
  ]

XdrawLinestring = (start, end) ->
  console.log "drawLinestring()"
  console.log start
  console.log end

  geoProjection  = new OpenLayers.Projection "EPSG:4326"


  cList = straightPath(new OpenLayers.Geometry.Point(start[0], start[1]), new OpenLayers.Geometry.Point(end[0], end[1]))
  console.log cList
  cFeature = new OpenLayers.Feature.Vector( new OpenLayers.Geometry.LineString(cList), null,
    strokeColor: "#0000ff"
    strokeOpacity: 0.7
    strokeWidth: 4
    strokeDashstyle: "longdash"
  )

  features = [cFeature]
  #
  # Path is in or extends into east (+) half, so we have to make a -360 copy
  #
  # if start[0] > 0 or end[0] > 0
  #   wList = straightPath(new (OpenLayers.Geometry.Point)(start[0] - 360, start[1]), new (OpenLayers.Geometry.Point)(end[0] - 360, end[1]))
  #   features.push new (OpenLayers.Feature.Vector)(new (OpenLayers.Geometry.LineString)(wList))

  #
  # Path is in or extends into west (-) half, so we have to make a +360 copy
  #
  # if start[0] < 0 or end[0] < 0
  #   eList = straightPath(new (OpenLayers.Geometry.Point)(start[0] + 360, start[1]), new (OpenLayers.Geometry.Point)(end[0] + 360, end[1]))

  #   features.push new (OpenLayers.Feature.Vector)(new (OpenLayers.Geometry.LineString)(eList))

  # startLocation = new OpenLayers.Geometry.Point(start[0], start[1]) \
  #   .transform geoProjection, CATMAP.map.getProjectionObject()

  # endLocation = new OpenLayers.Geometry.Point(end[0], end[1]) \
  #   .transform geoProjection, CATMAP.map.getProjectionObject()

  # linestringFeature = new OpenLayers.Feature.Vector(new OpenLayers.Geometry.LineString( [ startLocation, endLocation ]), null,
  #   strokeColor: "#0000ff"
  #   strokeOpacity: 0.7
  #   strokeWidth: 4
  #   strokeDashstyle: "longdash"
  # )

  linestringLayer = new OpenLayers.Layer.Vector "Measure Lines",
    visibility: true
    displayInLayerSwitcher: false

  # linestringLayer.addFeatures [linestringFeature]
  linestringLayer.addFeatures features
  CATMAP.map.addLayers [linestringLayer]

drawLinestring = (start = [170,0], end = [190,0], color = "#0000ff") ->
  # start = [-179,0]
  # end = [170,0]

  console.log "drawLinestring()"
  console.log start
  console.log end

  if Math.abs( start[0] - end[0]) > 180
    end[0] += if start[0] < end[0]
      -360
    else
      360
    console.log "adjusted longitude: #{end[0]}"




  geoProjection  = new OpenLayers.Projection "EPSG:4326"

  startLocation = new OpenLayers.Geometry.Point(start[0], start[1]) \
    .transform geoProjection, CATMAP.map.getProjectionObject()

  endLocation = new OpenLayers.Geometry.Point(end[0], end[1]) \
    .transform geoProjection, CATMAP.map.getProjectionObject()

  linestringFeature = new OpenLayers.Feature.Vector(new OpenLayers.Geometry.LineString( [ startLocation, endLocation ]), null,
    strokeColor: color
    strokeOpacity: 1
    strokeWidth: 4
    # strokeDashstyle: "longdash"
  )

  linestringLayer = new OpenLayers.Layer.Vector "Measure Lines",
    visibility: true
    displayInLayerSwitcher: false

  linestringLayer.addFeatures [linestringFeature]

  CATMAP.map.addLayers [linestringLayer]

