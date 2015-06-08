import CoreLocation


/// MARK: - DACrimeClient
class DACrimeClient {

    /// MARK: - class method
    static let sharedInstance = DACrimeClient()


    /// MARK: - public api

    /**
     * request DASFGovernment.API.GetCrime
     * @param completionHandler (json: JSON) -> Void
     */
    func getCrime(#completionHandler: (json: JSON) -> Void) {
        let threeMonthsAgo = NSDate.da_monthAgo(months: 3)
        let twoMonthsAgo = NSDate.da_monthAgo(months: 2)
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM"

        // API URL
        let url = NSURL(
            URLString: DASFGovernment.API.GetCrime,
            queries: [
                "$where" : "date > '\(dateFormatter.stringFromDate(threeMonthsAgo!))-01T00:00:00' and date < '\(dateFormatter.stringFromDate(twoMonthsAgo!))-01T00:00:00'",
            ]
        )

        // request
        let request = NSURLRequest(URL: url!)
        var operation = ISHTTPOperation(
            request: request,
            handler:{ (response: NSHTTPURLResponse!, object: AnyObject!, error: NSError!) -> Void in
                var responseJSON = JSON([:])
                if object != nil { responseJSON = JSON(data: object as! NSData) }

                dispatch_async(dispatch_get_main_queue(), {
                    completionHandler(json: responseJSON)
                })
            }
        )
        DACrimeOperationQueue.defaultQueue().addOperation(operation)
    }

    /**
     * cancel get crime API
     **/
    func cancelGetCrime() {
        DACrimeOperationQueue.defaultQueue().cancelOperationsWithPath(NSURL(string: DASFGovernment.API.GetCrime)!.path)
    }


}

