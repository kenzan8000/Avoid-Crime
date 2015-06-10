/// MARK: - DAGMSMapView
class DAGMSMapView: GMSMapView {

    /// MARK: - properties

    static let sharedInstance = DAGMSMapView()

    /// dragging waypoint
    private var draggingWaypoint: CLLocationCoordinate2D!
    /// waypoints for routing
    var waypoints: [CLLocationCoordinate2D] = []
    /// route json
    private var routeJSON: JSON?
    /// crimes
    private var crimes: [DACrime]?
    /// crime marker type
    private var crimeMarkerType = DAMarker.None


    /// MARK: - public api

    /**
     * draw all markers, route, overlays and something like that
     **/
    func draw() {
        self.clear()

        // crime
        if self.crimes != nil {
            switch (self.crimeMarkerType) {
                case DAMarker.CrimePoint:
                    self.drawCrimeMakers()
                    break
                case DAMarker.CrimeHeatmap:
                    self.drawCrimeHeatmap()
                    break
                default:
                    break
            }
        }

        // route
        if self.routeJSON != nil { self.drawRoute() }
    }

    /**
     * set route json
     * @param json json
     **/
    func setRouteJSON(json: JSON?) {
        self.routeJSON = json
        if json == nil { self.removeAllWaypoints() }
    }

    /**
     * set crime marker type
     * @param markerType DAMarker
     **/
    func setCrimeMarkerType(markerType: DAMarker) {
        self.crimeMarkerType = markerType
    }

    /**
     * set crimes
     * @param crimes [DACrime]
     **/
    func setCrimes(crimes: [DACrime]?) {
        self.crimes = crimes
    }

    /**
     * add waypoint for routing
     * @param waypoint waypoint
     */
    func appendWaypoint(waypoint: CLLocationCoordinate2D) {
        self.waypoints.append(waypoint)
    }

    /**
     * remove all waypoints for routing
     */
    func removeAllWaypoints() {
        self.waypoints = []
    }

    /**
     * startMovingWaypoint
     * @param waypoint waypoint
     */
    func startMovingWaypoint(waypoint: CLLocationCoordinate2D) {
        self.draggingWaypoint = waypoint
    }

    /**
     * endMovingWaypoint
     * @param waypoint waypoint
     */
    func endMovingWaypoint(waypoint: CLLocationCoordinate2D) {
        var index = -1
        for var i = 0; i < self.waypoints.count; i++ {
            let location1 = CLLocation(latitude: self.waypoints[i].latitude, longitude: self.waypoints[i].longitude)
            let location2 = CLLocation(latitude: self.draggingWaypoint.latitude, longitude: self.draggingWaypoint.longitude)
            let meter = location1.distanceFromLocation(location2)
            if meter > 10 { continue }
            index = i
            break
        }
        self.draggingWaypoint = CLLocationCoordinate2D(latitude: 0, longitude: 0)
        if index >= 0 {
            self.waypoints[index] = waypoint
        }
    }


    /// MARK: - private api

    /**
     * draw route
     **/
    private func drawRoute() {
        let pathes = self.encodedPathes()
        for pathString in pathes {
            let path = GMSPath(fromEncodedPath: pathString)
            var line = GMSPolyline(path: path)
            line.strokeWidth = 4.0
            line.tappable = true
            line.map = self
        }

        let locations = self.endLocations()
        let index = locations.count - 1
        if index >= 0 {
            self.drawDestination(location: locations[index])
        }

        self.drawWaypoints()
    }

    /**
     * draw waypoint
     **/
    private func drawWaypoints() {
        for waypoint in self.waypoints {
            self.drawWaypoint(location: waypoint)
        }
    }

    /**
     * draw waypoint marker
     * @param location location
     **/
    private func drawWaypoint(#location: CLLocationCoordinate2D) {
        var marker = DAWaypointMarker(position: location)
        marker.doSettings()
        marker.map = self
    }

    /**
     * draw destination marker
     * @param location location
     **/
    private func drawDestination(#location: CLLocationCoordinate2D) {
        var marker = DADestinationMarker(position: location)
        marker.doSettings()
        marker.map = self
    }

    /**
     * draw crimes
     **/
    private func drawCrimeMakers() {
        if self.crimes == nil { return }
        let drawingCrimes = self.crimes as [DACrime]!
        for crime in drawingCrimes {
            self.drawCrimeMaker(crime)
        }
    }

    /**
     * draw crime marker
     * @param crime DACrime
     **/
    private func drawCrimeMaker(crime: DACrime) {
        var marker = DACrimeMarker(position: CLLocationCoordinate2DMake(crime.lat.doubleValue, crime.long.doubleValue))
        marker.doSettings(crime: crime)
        marker.map = self
    }

    /**
     * draw crime heatmap
     **/
    private func drawCrimeHeatmap() {
        if self.crimes == nil { return }

        let drawingCrimes = self.crimes as [DACrime]!
        var min = CLLocationCoordinate2DMake(drawingCrimes[0].lat.doubleValue, drawingCrimes[0].long.doubleValue)
        var max = CLLocationCoordinate2DMake(drawingCrimes[0].lat.doubleValue, drawingCrimes[0].long.doubleValue)

        var locations: [CLLocation] = []
        var weights: [NSNumber] = []
        for crime in drawingCrimes {
            let lat = crime.lat.doubleValue
            let long = crime.long.doubleValue
            locations.append(CLLocation(latitude: lat, longitude: long))
            weights.append(NSNumber(double: 1.0))
            if lat < min.latitude { min.latitude = lat }
            if long < min.longitude { min.longitude = long }
            if lat > max.latitude { max.latitude = lat }
            if long > max.longitude { max.longitude = long }
        }
        let center = self.projection.coordinateForPoint(CGPointMake(self.frame.size.width/2.0, self.frame.size.height))
        var marker = DACrimeHeatmapMarker(position: center)
        marker.map = self
        marker.draggable = false
        marker.boost = 1.0
        marker.weights = weights
        marker.locations = locations
        marker.draw()
    }

    /**
     * return encodedPath
     * @return [String]
     **/
    private func encodedPathes() -> [String] {
        // make pathes
        var pathes = [] as [String]
        let json = self.routeJSON
        if json == nil { return pathes }

        let routes = json!["routes"].arrayValue
        for route in routes {
            let overviewPolyline = route["overview_polyline"].dictionaryValue
            let path = overviewPolyline["points"]!.stringValue
            pathes.append(path)
        }

        return pathes
    }

    /**
     * return end location
     * @return [CLLocationCoordinate2D]
     **/
    private func endLocations() -> [CLLocationCoordinate2D] {
        var locations: [CLLocationCoordinate2D] = []
        let json = self.routeJSON
        if json == nil { return locations }

        let routes = json!["routes"].arrayValue
        for route in routes {
            let legs = route["legs"].arrayValue
            for leg in legs {
                if let locationDictionary = leg["end_location"].dictionary {
                    locations.append(CLLocationCoordinate2D(latitude: locationDictionary["lat"]!.doubleValue, longitude: locationDictionary["lng"]!.doubleValue))
                }
            }
        }
        return locations
    }
}
