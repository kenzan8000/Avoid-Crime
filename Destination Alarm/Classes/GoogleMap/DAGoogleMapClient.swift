import Foundation


/// MARK: - DAGoogleMapClient
class DAGoogleMapClient: AnyObject {

    /// MARK: - property


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
            "mode": "walking",
        ]
        // waypoints
        let waypoints = DAGMSMapView.sharedInstance.waypoints
        if waypoints.count > 0 {
            q["waypoints"] = "optimize:true|"
            for var i = 0; i < waypoints.count; i++ {
                let coordinate = waypoints[i]
                q["waypoints"] = (q["waypoints"] as! String) + "\(coordinate.latitude),\(coordinate.longitude)|"
            }
        }
        for (key, value) in queries { q[key] = value }
        let request = NSMutableURLRequest(URL: NSURL(URLString: DAGoogleMap.API.Directions, queries: q)!)

        // request
        var operation = ISHTTPOperation(request: request, handler:{ (response: NSHTTPURLResponse!, object: AnyObject!, error: NSError!) -> Void in
                var responseJSON = JSON([:])
                if object != nil { responseJSON = JSON(data: object as! NSData) }
                dispatch_async(dispatch_get_main_queue(), {
                    completionHandler(json: responseJSON)
                })
            }
        )
        DAGoogleMapOperationQueue.defaultQueue().addOperation(operation)
    }

    /**
     * cancel direction API
     **/
    func cancelGetRoute() {
        DAGoogleMapOperationQueue.defaultQueue().cancelOperationsWithPath(NSURL(string: DAGoogleMap.API.Directions)!.path)
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
        var operation = ISHTTPOperation(request: request, handler:{ (response: NSHTTPURLResponse!, object: AnyObject!, error: NSError!) -> Void in
                var responseJSON = JSON([:])
                if object != nil { responseJSON = JSON(data: object as! NSData) }
                dispatch_async(dispatch_get_main_queue(), {
                    completionHandler(json: responseJSON)
                })
            }
        )
        DAGoogleMapOperationQueue.defaultQueue().addOperation(operation)
    }

    /**
     * cancel geocode API
     **/
    func cancelGetGeocode() {
        DAGoogleMapOperationQueue.defaultQueue().cancelOperationsWithPath(NSURL(string: DAGoogleMap.API.GeoCode)!.path)
    }

    /**
     * request google map API (https://developers.google.com/places/webservice/autocomplete)
     * @param input search words
     * @param radius mile
     * @param location location
     * @param completionHandler (json: JSON) -> Void
     */
    func getPlaceAutoComplete(#input: String, radius: Double, location: CLLocationCoordinate2D, completionHandler: (json: JSON) -> Void) {
        // make request
        let queries = [
            "input" : input,
            "radius" : "\(DAMapMath.meterFromMile(radius))",
            "location" : "\(location.latitude),\(location.longitude)", // latitude,longitude
            "sensor" : "false",
            "key" : DAGoogleMap.BrowserAPIKey,
        ]
        let request = NSMutableURLRequest(URL: NSURL(URLString: DAGoogleMap.API.PlaceAutoComplete, queries: queries)!)

        // request
        var operation = ISHTTPOperation(request: request, handler:{ (response: NSHTTPURLResponse!, object: AnyObject!, error: NSError!) -> Void in
                var responseJSON = JSON([:])
                if object != nil { responseJSON = JSON(data: object as! NSData) }
                dispatch_async(dispatch_get_main_queue(), {
                    completionHandler(json: responseJSON)
                })
            }
        )
        DAGoogleMapOperationQueue.defaultQueue().addOperation(operation)
    }

    /**
     * cancel get place auto complete API
     **/
    func cancelGetPlaceAutoComplete() {
        DAGoogleMapOperationQueue.defaultQueue().cancelOperationsWithPath(NSURL(string: DAGoogleMap.API.PlaceAutoComplete)!.path)
    }

}
