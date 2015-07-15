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
        let currentDate = NSDate()
        var startDate = currentDate.da_monthAgo(months: DASFGovernment.Crime.MonthsAgo)
        var endDate = startDate!.da_daysLater(days: DASFGovernment.Crime.Days)
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"

        // API URL
        let url = NSURL(
            URLString: DASFGovernment.API.GetCrime,
            queries: [
                "$where" : "date >= '\(dateFormatter.stringFromDate(startDate!))T00:00:00' and date < '\(dateFormatter.stringFromDate(endDate!))T00:00:00' and category != 'NON-CRIMINAL'",
            ]
        )

        MTStatusBarOverlay.sharedInstance().postMessage("Getting crime data")

        // request
        let request = NSURLRequest(URL: url!)
        var operation = ISHTTPOperation(
            request: request,
            handler:{ (response: NSHTTPURLResponse!, object: AnyObject!, error: NSError!) -> Void in
                var responseJSON = JSON([:])
                if object != nil {
                    responseJSON = JSON(data: object as! NSData)
                    MTStatusBarOverlay.sharedInstance().postImmediateFinishMessage("Done", duration:2.0, animated:true)
                }
                else {
                    MTStatusBarOverlay.sharedInstance().postImmediateErrorMessage("Failed", duration:2.0, animated:true)
                }

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

