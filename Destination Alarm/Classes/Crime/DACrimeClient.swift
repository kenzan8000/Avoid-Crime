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
        // date 3 months and 2 months ago
        var dateComponents = NSDateComponents()
        let calendar = NSCalendar.currentCalendar()
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-01T00:00:00"
        dateComponents.month = -3
        let threeMonthsAgo = calendar.dateByAddingComponents(dateComponents, toDate: NSDate(), options: NSCalendarOptions(0))
        dateComponents.month = -2
        let twoMonthsAgo = calendar.dateByAddingComponents(dateComponents, toDate: NSDate(), options: NSCalendarOptions(0))

        // API URL
        let url = NSURL(
            URLString: DASFGovernment.API.GetCrime,
            queries: [
                "$where" : "date > \(dateFormatter.stringFromDate(threeMonthsAgo!)) and date < \(dateFormatter.stringFromDate(twoMonthsAgo!))",
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

