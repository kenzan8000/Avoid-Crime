import Foundation


/// MARK: - DAGoogleMapClient
class DAGoogleMapClient: AnyObject {

    /// MARK: - property

    /// waypoints for routing
    var waypoints: [CLLocationCoordinate2D] = []
    /// dragging waypoint
    private var draggingWaypoint: CLLocationCoordinate2D!


    /// MARK: - class method

    static let sharedInstance = DAGoogleMapClient()


    /// MARK: - public api

    /**
     * request google map directions API (https://developers.google.com/maps/documentation/directions/)
     * @param queries URI queries
     *  e.g. 1
     *  {
     *      "origin" : "-122.4207906162038,37.76681832250885", // longitude,latitude
     *      "destination" : "-122.3131,37.5542",
     *  }
     *  e.g. 2
     *  {
     *      "origin" : "San Francisco",
     *      "destination" : "Los Angeles",
     *      "waypoints" : "optimize:true|-122.40,37.65|-122.34,37.59|", //"waypoints" : "optimize:true|San Francisco Airport|Dalycity|",
     *      "alternatives" : "true",
     *      "avoid" : "highways",
     *      "units" : "metric",
     *      "region" : ".us",
     *      "departure_time" : "1343605500",
     *      "arrival_time" : "1343605500",
     *      "mode": "bicycling", // driving, walking, bicycling
     *      "sensor": "false",
     *  }
     * @param completionHandler (json: JSON) -> Void
     */
    func getRoute(#queries: Dictionary<String, AnyObject>, completionHandler: (json: JSON) -> Void) {
        // make request
        var q: Dictionary<String, AnyObject> = [
            "sensor": "false",
        ]
        // waypoints
        if self.waypoints.count > 0 {
            q["waypoints"] = "optimize:true|"
            for var i = 0; i < self.waypoints.count; i++ {
                let coordinate = self.waypoints[i]
                q["waypoints"] = (q["waypoints"] as! String) + "\(coordinate.latitude),\(coordinate.longitude)|"
            }
        }
        for (key, value) in queries { q[key] = value }
        let request = NSMutableURLRequest(URL: NSURL(URLString: DAGoogleMap.API.Directions, queries: q)!)

        // request
        ISHTTPOperation.sendRequest(request, handler:{ (response: NSHTTPURLResponse!, object: AnyObject!, error: NSError!) -> Void in
                var responseJSON = JSON([:])
                if object != nil { responseJSON = JSON(data: object as! NSData) }
                dispatch_async(dispatch_get_main_queue(), {
                    completionHandler(json: responseJSON)
                })
            }
        )
    }

    /**
     * request google map geocode API (https://developers.google.com/maps/documentation/geocoding/)
     * @param address address
     * @param radius mile
     * @param location location
     * @param completionHandler (json: JSON) -> Void
     */
    func getGeocode(#address: String, radius: Double, location: CLLocationCoordinate2D, completionHandler: (json: JSON) -> Void) {
        // make request
        let offsetLong = DAMapMath.degreeOfLongitudePerRadius(radius, location: CLLocation(latitude: location.latitude, longitude: location.longitude))
        let offsetLat = DAMapMath.degreeOfLatitudePerRadius(radius, location: CLLocation(latitude: location.latitude, longitude: location.longitude))
        let queries = [
            "address" : address,
            "bounds" : "\(location.latitude-offsetLat),\(location.longitude-offsetLong)|\(location.latitude+offsetLat),\(location.longitude+offsetLong)", // latitude,longitude
        ]
        let request = NSMutableURLRequest(URL: NSURL(URLString: DAGoogleMap.API.GeoCode, queries: queries)!)

        // request
        ISHTTPOperation.sendRequest(request, handler:{ (response: NSHTTPURLResponse!, object: AnyObject!, error: NSError!) -> Void in
                var responseJSON = JSON([:])
                if object != nil { responseJSON = JSON(data: object as! NSData) }
                dispatch_async(dispatch_get_main_queue(), {
                    println("\(responseJSON)")
                    completionHandler(json: responseJSON)
                })
            }
        )
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
            //if self.waypoints[i].latitude != self.draggingWaypoint.latitude || self.waypoints[i].longitude != self.draggingWaypoint.longitude { continue }
            index = i
            break
        }
        self.draggingWaypoint = CLLocationCoordinate2D(latitude: 0, longitude: 0)
        if index >= 0 {
            self.waypoints[index] = waypoint
        }
    }

}
