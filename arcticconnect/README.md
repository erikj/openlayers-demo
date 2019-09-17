# OpenLayers Demo: ArcticConnect

Demonstration of polar-projection maps in OpenLayers using ArcticConnect base layers.

<http://erikj.github.io/openlayers-demo/arcticconnect/>

## OpenLayers

[Polar Projections WMS Example](http://dev.openlayers.org/examples/polar-projections.html)

## Arctic Connect

Polar-projected base layer is provided by Arctic Connect WMS tiles.

[Arctic Web Map Tiles](https://webmap.arcticconnect.ca/tiles.html)

> Currently we support six Arctic projections on our tile server.
>
> - EPSG:3571
> - EPSG:3572
> - EPSG:3573
> - EPSG:3574
> - EPSG:3575
> - EPSG:3576
>
> These projections provide a Lambert Azimuthal Equal-Area (LAEA) view of the North Pole region, from 45°N to 90°N. Each projection is centred *(sic)* on a specific longitude: 180°W, 150°W, 100°W, 40°W, 10°E, and 90° E.

> **Coverage**
>
> We currently provide data for the region North of 45°N.

- [Arctic Web Map API and Usage](https://webmap.arcticconnect.ca/usage.html)

## Demo Code

The six projections are demonstrated via individual html pages that are linked from `index.html`. *E.g.* `map-3571.html` demonstrates projection `EPSG:3571`.

From the projection-specific pages, the OpenLayers JavaScript is invoked by calling `map.init()`, which is defined in [`map.js`](https://github.com/erikj/openlayers-demo/blob/gh-pages/arcticconnect/js/map.js). For example, for `EPSG:3571`, [`map-3571.html`](https://github.com/erikj/openlayers-demo/blob/gh-pages/arcticconnect/map-3571.html):

```html
<body onload="map.init('map', 3571, 180);">
```

`map.init` takes three arguments:

- `divName` the DOM ID of the element in which the map should be drawn
- `projectionLabel`: the EPSG projection that should be used, e.g. `3571`
- `offsetLabel`: the value of longitude offset that the projection uses. This is displayed for informational purposes only, and does not affect the display of the map.

The demo is accessible on GitHub Pages via:

<http://erikj.github.io/openlayers-demo/arcticconnect/>
