import Foundation


/// MARK: - NSURL+Ago
extension NSDate {

    /// MARK: - class method

    /**
     * get the Date ~ month ago
     * @param months months
     * @return NSDate
     */
    class func da_monthAgo(#months: Int) -> NSDate? {
        // date 3 months and 2 months ago
        var dateComponents = NSDateComponents()
        let calendar = NSCalendar.currentCalendar()
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM"
        dateComponents.month = -months
        return calendar.dateByAddingComponents(dateComponents, toDate: NSDate(), options: NSCalendarOptions(0))
    }
}
