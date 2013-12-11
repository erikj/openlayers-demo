// Generated by CoffeeScript 1.6.2
(function() {
  var CATMAP, onFeatureSelect, onFeatureUnselect;

  CATMAP = {};

  this.CATMAP = CATMAP;

  CATMAP.load_map = function(map_div_name) {
    var center, controls, darwin, geoProj, groundOverlayFilenames, i, image, kmlDir, kmlFilename, kmlFilenames, kmlLayer, kmlLayers, kmlSelector, kmlUrl, latLonBounds4km, latLonOwlesGoesBounds, layerSwitcher, map, mercProj, mtsat4kmImages, mtsat4kmLayer, mtsatBounds4km, multiplier, multipliers, ocm, osm, osmResolutions, oswego, owlesGoesBounds, owlesGoesImage, _i, _j, _k, _l, _len, _len1, _len2, _len3, _len4, _m;

    geoProj = new OpenLayers.Projection("EPSG:4326");
    mercProj = new OpenLayers.Projection("EPSG:900913");
    CATMAP.geoProj = geoProj;
    CATMAP.mercProj = mercProj;
    layerSwitcher = new OpenLayers.Control.LayerSwitcher;
    controls = [new OpenLayers.Control.KeyboardDefaults, new OpenLayers.Control.Graticule, layerSwitcher, new OpenLayers.Control.Navigation];
    map = new OpenLayers.Map(map_div_name, {
      controls: controls
    });
    layerSwitcher.maximizeControl();
    CATMAP.map = map;
    osmResolutions = [156543.03390625, 78271.516953125, 39135.7584765625, 19567.87923828125, 9783.939619140625, 4891.9698095703125, 2445.9849047851562, 1222.9924523925781, 611.4962261962891, 305.74811309814453, 152.87405654907226, 76.43702827453613, 38.218514137268066, 19.109257068634033, 9.554628534317017, 4.777314267158508, 2.388657133579254, 1.194328566789627, 0.5971642833948135];
    osm = new OpenLayers.Layer.OSM('Open Street Map', null, {
      resolutions: osmResolutions,
      serverResolutions: osmResolutions,
      transitionEffect: 'resize'
    });
    map.addLayer(osm);
    ocm = new OpenLayers.Layer.OSM("OpenCycleMap", ["http://a.tile.opencyclemap.org/cycle/${z}/${x}/${y}.png", "http://b.tile.opencyclemap.org/cycle/${z}/${x}/${y}.png", "http://c.tile.opencyclemap.org/cycle/${z}/${x}/${y}.png"]);
    map.addLayer(ocm);
    darwin = new OpenLayers.LonLat(130.833, -12.45);
    oswego = new OpenLayers.LonLat(-76.5, 43.45);
    center = oswego;
    map.setCenter(center.transform(geoProj, mercProj), 6);
    kmlDir = "kml";
    kmlFilenames = ['ge.facility_locations.201312111200.soundings.kml'];
    groundOverlayFilenames = ['catmap.ge.DOW6.201312071606.NCP_radar_only.kml', 'catmap.ge.DOW7.201312071633.NCP_radar_only.kml'];
    kmlLayers = [];
    for (i = _i = 0, _len = groundOverlayFilenames.length; _i < _len; i = ++_i) {
      kmlFilename = groundOverlayFilenames[i];
      kmlUrl = "" + (window.location['href'].replace(/\/[^\/]*$/, '/')) + kmlDir + "/" + kmlFilename;
      OpenLayers.Request.GET({
        url: kmlUrl,
        callback: function(response, kmlUrl) {
          var east, eastElement, element, groundOverlayBounds, groundOverlayElements, groundOverlayImage, iconElement, iconHref, iconHrefElement, iconName, kmlDom, latLonBoxElement, latLonGroundOverlayBounds, north, northElement, south, southElement, west, westElement, xmlParser, _j, _len1, _results;

          if (response.status === 200) {
            xmlParser = new OpenLayers.Format.XML();
            kmlDom = xmlParser.read(response.responseText);
            groundOverlayElements = xmlParser.getElementsByTagNameNS(kmlDom, "*", "GroundOverlay");
            console.log(groundOverlayElements.length);
            if (groundOverlayElements.length < 1) {

            } else {
              _results = [];
              for (_j = 0, _len1 = groundOverlayElements.length; _j < _len1; _j++) {
                element = groundOverlayElements[_j];
                iconElement = xmlParser.getElementsByTagNameNS(element, '*', 'Icon')[0];
                iconHrefElement = xmlParser.getElementsByTagNameNS(iconElement, '*', 'href')[0];
                iconHref = iconHrefElement.firstChild.nodeValue;
                latLonBoxElement = xmlParser.getElementsByTagNameNS(element, '*', 'LatLonBox')[0];
                northElement = xmlParser.getElementsByTagNameNS(latLonBoxElement, '*', 'north')[0];
                southElement = xmlParser.getElementsByTagNameNS(latLonBoxElement, '*', 'south')[0];
                eastElement = xmlParser.getElementsByTagNameNS(latLonBoxElement, '*', 'east')[0];
                westElement = xmlParser.getElementsByTagNameNS(latLonBoxElement, '*', 'west')[0];
                north = northElement.firstChild.nodeValue.replace(/(^\s+|\s+$)/g, '');
                south = southElement.firstChild.nodeValue.replace(/(^\s+|\s+$)/g, '');
                east = eastElement.firstChild.nodeValue.replace(/(^\s+|\s+$)/g, '');
                west = westElement.firstChild.nodeValue.replace(/(^\s+|\s+$)/g, '');
                console.log("iconHref: " + iconHref);
                latLonGroundOverlayBounds = [west, south, east, north];
                groundOverlayBounds = new OpenLayers.Bounds(latLonGroundOverlayBounds).transform(CATMAP.geoProj, CATMAP.mercProj);
                iconName = iconHref.match(/\/([^\/]*)$/)[1];
                groundOverlayImage = new OpenLayers.Layer.Image(iconName, iconHref, groundOverlayBounds, new OpenLayers.Size(800, 800), {
                  isBaseLayer: false,
                  alwaysInRange: true,
                  wrapDateLine: true
                });
                CATMAP.map.addLayers([groundOverlayImage]);
                _results.push(groundOverlayImage.setOpacity(.5));
              }
              return _results;
            }
          } else {
            return console.log("" + request.status + " ERROR: " + request.responseText);
          }
        }
      });
    }
    for (i = _j = 0, _len1 = kmlFilenames.length; _j < _len1; i = ++_j) {
      kmlFilename = kmlFilenames[i];
      kmlLayers.push(new OpenLayers.Layer.Vector(kmlFilename, {
        strategies: [new OpenLayers.Strategy.Fixed()],
        protocol: new OpenLayers.Protocol.HTTP({
          url: kmlDir + "/" + kmlFilename,
          format: new OpenLayers.Format.KML({
            extractStyles: true,
            extractAttributes: true
          })
        })
      }));
    }
    for (_k = 0, _len2 = kmlLayers.length; _k < _len2; _k++) {
      kmlLayer = kmlLayers[_k];
      console.log(kmlLayer);
      kmlLayer.events.on({
        "featureselected": onFeatureSelect,
        "featureunselected": onFeatureUnselect
      });
    }
    map.addLayers(kmlLayers);
    kmlSelector = new OpenLayers.Control.SelectFeature(kmlLayers);
    map.addControl(kmlSelector);
    kmlSelector.activate();
    multipliers = [-1, 0];
    mtsat4kmImages = ['img/ops.MTSAT-2.201308012032.ch1_vis.jpg', 'img/ops.MTSAT-2.201308012032.ch2_thermal_IR.jpg', 'img/ops.MTSAT-2.201308012032.ch4_water_vapor.jpg'];
    for (_l = 0, _len3 = multipliers.length; _l < _len3; _l++) {
      multiplier = multipliers[_l];
      latLonBounds4km = [130.5 + (360 * multiplier), -63.5, 360 - 150.5 + (360 * multiplier), -17.84];
      mtsatBounds4km = new OpenLayers.Bounds(latLonBounds4km).transform(geoProj, mercProj);
      for (_m = 0, _len4 = mtsat4kmImages.length; _m < _len4; _m++) {
        image = mtsat4kmImages[_m];
        mtsat4kmLayer = new OpenLayers.Layer.Image(image, image, mtsatBounds4km, new OpenLayers.Size(2200, 1800), {
          isBaseLayer: false,
          alwaysInRange: true,
          wrapDateLine: true
        });
      }
    }
    latLonOwlesGoesBounds = [-84.0830386349909, 38.8520916019916, -71.1603613650091, 48.1931765247953];
    owlesGoesBounds = new OpenLayers.Bounds(latLonOwlesGoesBounds).transform(geoProj, mercProj);
    owlesGoesImage = new OpenLayers.Layer.Image('img/ops.GOES-13.201310282002.1km_ch1_vis.jpg', 'img/ops.GOES-13.201310282002.1km_ch1_vis.jpg', owlesGoesBounds, new OpenLayers.Size(800, 800), {
      isBaseLayer: false,
      alwaysInRange: true,
      wrapDateLine: true
    });
    map.addLayers([owlesGoesImage]);
    owlesGoesImage.setOpacity(.5);
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
