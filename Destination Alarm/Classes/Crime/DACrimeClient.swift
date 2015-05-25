import CoreLocation


/// MARK: - DACrimeClient
class DACrimeClient {

    /// MARK: - class method
    static let sharedInstance = DACrimeClient()


    /// MARK: - public api

    /**
     * request DASFGovernment.API.Row
     * @param location location
     * @param radius search range of radius
     * @param completionHandler (json: JSON) -> Void
     */
    func getRow(#location: CLLocation, radius: Double, completionHandler: (json: JSON) -> Void) {
        // API URL
        let longDegreeOffset = DAMapMath.degreeOfLongitudePerRadius(radius, location: location)
        let latDegreeOffset = DAMapMath.degreeOfLatitudePerRadius(radius, location: location)
        let url = NSURL(
            URLString: DASFGovernment.API.Row,
            queries: [
                "accessType" : "DOWNLOAD",
                "method" : "clustered2",
                "min_lon" : location.coordinate.longitude - longDegreeOffset,
                "max_lon" : location.coordinate.longitude + longDegreeOffset,
                "min_lat" : location.coordinate.latitude - latDegreeOffset,
                "max_lat" : location.coordinate.latitude + latDegreeOffset,
                "target_node_clusters" : "250",
                "min_distance_between_clusters" : "0.0030525141384952644",
            ]
        )

        // request
        let request = NSURLRequest(URL: url!)
        ISHTTPOperation.sendRequest(
            request,
            handler:{ (response: NSHTTPURLResponse!, object: AnyObject!, error: NSError!) -> Void in
                var responseJSON = JSON([:])
                if object != nil { responseJSON = JSON(data: object as! NSData) }

                dispatch_async(dispatch_get_main_queue(), {
                    completionHandler(json: responseJSON)
                })
            }
        )
    }

}

