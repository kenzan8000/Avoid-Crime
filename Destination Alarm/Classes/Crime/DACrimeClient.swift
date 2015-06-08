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
        let threeMonthsAgo = currentDate.da_monthAgo(months: 3)
        let threeMonthsAgoADayLater = threeMonthsAgo!.da_daysLater(days: 1)
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"

        // API URL
        let url = NSURL(
            URLString: DASFGovernment.API.GetCrime,
            queries: [
                "$where" : "date >= '\(dateFormatter.stringFromDate(threeMonthsAgo!))T00:00:00' and date < '\(dateFormatter.stringFromDate(threeMonthsAgoADayLater!))T00:00:00' and category != 'NON-CRIMINAL'",
//date >= '2015-03-01T00:00:00' and date < '2015-03-02T00:00:00' and category != 'NON-CRIMINAL'
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

