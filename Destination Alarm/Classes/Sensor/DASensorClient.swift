import CoreLocation


/// MARK: - DASensorClient
class DASensorClient {

    /// MARK: - class method
    static let sharedInstance = DASensorClient()


    /// MARK: - public api

    /**
     * request DAServer.API.GetSensor
     * @param completionHandler (json: JSON) -> Void
     */
    func getSensor(completionHandler completionHandler: (json: JSON) -> Void) {

        // API URL
        let url = NSURL(
            URLString: DAServer.API.GetSensor,
            queries: [
                "type": "1",
                "lat": "37.40525905",
                "lng": "-121.984760117",
                "radius": "50"
            ]
        )

        JDStatusBarNotification.showWithStatus("Getting sensor data")
        JDStatusBarNotification.showActivityIndicator(true, indicatorStyle: .Gray)

        // request
        let request = NSURLRequest(URL: url!)
        let operation = ISHTTPOperation(
            request: request,
            handler:{ (response: NSHTTPURLResponse!, object: AnyObject!, error: NSError!) -> Void in
                var responseJSON = JSON([:])
                if object != nil {
                    responseJSON = JSON(data: object as! NSData)
                    JDStatusBarNotification.showWithStatus("Done", dismissAfter: 2.0)
                }
                else {
                    JDStatusBarNotification.showWithStatus("Failed", dismissAfter: 2.0)
                }

                dispatch_async(dispatch_get_main_queue(), {
                    completionHandler(json: responseJSON)
                })
            }
        )
        DASensorOperationQueue.defaultQueue().addOperation(operation)
    }

    /**
     * cancel get sensor API
     **/
    func cancelGetSensor() {
        DASensorOperationQueue.defaultQueue().cancelOperationsWithPath(NSURL(string: DAServer.API.GetSensor)!.path)
    }


}

