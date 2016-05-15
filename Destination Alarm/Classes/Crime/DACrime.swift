import Foundation
import CoreData
import CoreLocation
import SwiftyJSON

/// MARK: - DACrime
class DACrime: NSManagedObject {

    /// MARK: - property
    @NSManaged var category: String
    @NSManaged var desc: String
    @NSManaged var lat: NSNumber
    @NSManaged var long: NSNumber
    @NSManaged var timestamp: NSDate


    /// MARK: - class method

    /**
     * GET crime data from SFGovernment
     **/
    class func requestToGetNewCrimes() {
        // crime API
        if DACrime.hasData() { return }
        DACrimeClient.sharedInstance.cancelGetCrime()
        DACrimeClient.sharedInstance.getCrime(
            completionHandler: { (json) in
                DACrime.save(json: json)
            }
        )
    }

    /**
     * fetch all data
     * @return [DACrime]
     **/
    class func fetchAll() -> [DACrime] {
        return DACrime.fetch(minimumCoordinate: CLLocationCoordinate2DMake(-180.0, -90.0), maximumCoordinate: CLLocationCoordinate2DMake(180.0, 90.0))
    }

    /**
     * fetch datas from coredata
     * @param minimumCoordinate CLLocationCoordinate2D
     * @param maximumCoordinate CLLocationCoordinate2D
     * @return [DACrime]
     */
    class func fetch(minimumCoordinate minimumCoordinate: CLLocationCoordinate2D, maximumCoordinate: CLLocationCoordinate2D) -> [DACrime] {
        let context = DACoreDataManager.sharedInstance.managedObjectContext

        // make fetch request
        let fetchRequest = NSFetchRequest()
        let entity = NSEntityDescription.entityForName("DACrime", inManagedObjectContext:context)
        fetchRequest.entity = entity
        fetchRequest.fetchBatchSize = 20
            // time
        let currentDate = NSDate()
        var startDate = currentDate.da_monthAgo(months: DASFGovernment.Crime.MonthsAgo)
        var endDate = startDate!.da_daysLater(days: DASFGovernment.Crime.Days)
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let startDateString = dateFormatter.stringFromDate(startDate!)
        let endDateString = dateFormatter.stringFromDate(endDate!)
        dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
        startDate = dateFormatter.dateFromString(startDateString+" 00:00:00")
        endDate = dateFormatter.dateFromString(endDateString+" 00:00:00")
            // rect
        let predicaets = [
            NSPredicate(format: "(timestamp >= %@) AND (timestamp < %@)", startDate!, endDate!),
            NSPredicate(format: "(lat <= %@) AND (lat >= %@)", NSNumber(double: maximumCoordinate.latitude), NSNumber(double: minimumCoordinate.latitude)),
            NSPredicate(format: "(long <= %@) AND (long >= %@)", NSNumber(double: maximumCoordinate.longitude), NSNumber(double: minimumCoordinate.longitude)),
        ]
        fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicaets)
        fetchRequest.returnsObjectsAsFaults = false

        // return crimes
        var crimes: [DACrime]? = []
        do {
            crimes = try context.executeFetchRequest(fetchRequest) as? [DACrime]
        }
        catch {
            crimes = nil
        }
        if crimes == nil {
            NSUserDefaults().setObject("", forKey: DAUserDefaults.CrimeYearMonth)
            NSUserDefaults().synchronize()
            return []
        }
        return crimes!
    }

    /**
     * fetch datas from coredata
     * @param location location
     * @param radius radius of miles
     * @return [DACrime]
     */
    class func fetch(location location: CLLocation, radius: Double) -> [DACrime] {
        let context = DACoreDataManager.sharedInstance.managedObjectContext

        // make fetch request
        let fetchRequest = NSFetchRequest()
        let entity = NSEntityDescription.entityForName("DACrime", inManagedObjectContext:context)
        fetchRequest.entity = entity
        fetchRequest.fetchBatchSize = 20
            // time
        let currentDate = NSDate()
        var startDate = currentDate.da_monthAgo(months: DASFGovernment.Crime.MonthsAgo)
        var endDate = startDate!.da_daysLater(days: DASFGovernment.Crime.Days)
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let startDateString = dateFormatter.stringFromDate(startDate!)
        let endDateString = dateFormatter.stringFromDate(endDate!)
        dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
        startDate = dateFormatter.dateFromString(startDateString+" 00:00:00")
        endDate = dateFormatter.dateFromString(endDateString+" 00:00:00")
            // rect
        let coordinate = location.coordinate
        let latOffset = DAMapMath.degreeOfLatitudePerRadius(radius, location: location)
        let longOffset = DAMapMath.degreeOfLongitudePerRadius(radius, location: location)
        let predicaets = [
            NSPredicate(format: "(timestamp >= %@) AND (timestamp < %@)", startDate!, endDate!),
            NSPredicate(format: "(lat <= %@) AND (lat >= %@)", NSNumber(double: coordinate.latitude + latOffset), NSNumber(double: coordinate.latitude - latOffset)),
            NSPredicate(format: "(long <= %@) AND (long >= %@)", NSNumber(double: coordinate.longitude + longOffset), NSNumber(double: coordinate.longitude - longOffset)),
        ]
        fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicaets)
        fetchRequest.returnsObjectsAsFaults = false

        // return crimes
        var crimes: [DACrime]? = []
        do { crimes = try context.executeFetchRequest(fetchRequest) as? [DACrime] }
        catch { crimes = nil }
        if crimes == nil {
            NSUserDefaults().setObject("", forKey: DAUserDefaults.CrimeYearMonth)
            NSUserDefaults().synchronize()
            return []
        }
        return crimes!
    }

    /**
     * save json datas to coredata
     * @param json JSON
     * [
     *   {
     *     "time" : "08:42",
     *     "category" : "LARCENY/THEFT",
     *     "pddistrict" : "SOUTHERN",
     *     "pdid" : "13054930206362",
     *     "location" : {
     *       "needs_recoding" : false,
     *       "longitude" : "-122.407633520742",
     *       "latitude" : "37.7841893501425",
     *       "human_address" : "{\"address\":\"\",\"city\":\"\",\"state\":\"\",\"zip\":\"\"}"
     *     },
     *     "address" : "800 Block of MARKET ST",
     *     "descript" : "PETTY THEFT SHOPLIFTING",
     *     "dayofweek" : "Tuesday",
     *     "resolution" : "ARREST, BOOKED",
     *     "date" : "2015-02-03T00:00:00",
     *     "y" : "37.7841893501425",
     *     "x" : "-122.407633520742",
     *     "incidntnum" : "130549302"
     *   },
     *   ...
     * ]
     */
    class func save(json json: JSON) {
        if DACrime.hasData() { return }

        let crimeDatas: Array<JSON> = json.arrayValue
        let context = DACoreDataManager.sharedInstance.managedObjectContext

        let dateFormatter = NSDateFormatter()

        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        for crimeData in crimeDatas {
            let yyyymmddhhmm = (crimeData["date"].stringValue).stringByReplacingOccurrencesOfString("T00:00:00", withString: " ") + crimeData["time"].stringValue
            let timestamp = dateFormatter.dateFromString(yyyymmddhhmm)
            if timestamp == nil { continue }

            let crime = NSEntityDescription.insertNewObjectForEntityForName("DACrime", inManagedObjectContext: context) as! DACrime
            crime.category = crimeData["category"].stringValue
            crime.desc = crimeData["descript"].stringValue
            if let location = crimeData["location"].dictionary {
                crime.lat = location["latitude"]!.numberValue
                crime.long = location["longitude"]!.numberValue
            }
            crime.timestamp = timestamp!
        }

        do { try context.save() }
        catch { return }

        if crimeDatas.count > 0 {
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let currentYearMonth = dateFormatter.stringFromDate(NSDate())
            NSUserDefaults().setObject(currentYearMonth, forKey: DAUserDefaults.CrimeYearMonth)
            NSUserDefaults().synchronize()
        }
    }

    /**
     * check if client needs to get new crime data
     * @return Bool
     **/
    class func hasData() -> Bool {
        let crimeYearMonth = NSUserDefaults().stringForKey(DAUserDefaults.CrimeYearMonth)

        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let currentYearMonth = dateFormatter.stringFromDate(NSDate())

        return (crimeYearMonth == currentYearMonth)
    }

    /**
     * return density of cirme 2 miles around
     * @param coordinate CLLocationCoordinate2D
     * @return if the coordinate is dangerous or not
     **/
    class func isHighRated(coordinate coordinate: CLLocationCoordinate2D) -> Bool {
        // get crimes Radius miles around
        let Radius = 0.35
        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        let offsetLat = DAMapMath.degreeOfLatitudePerRadius(Radius, location: location)
        let offsetLong = DAMapMath.degreeOfLongitudePerRadius(Radius, location: location)
        let crimes = DACrime.fetch(
            minimumCoordinate: CLLocationCoordinate2DMake(coordinate.latitude-offsetLat, coordinate.longitude-offsetLong),
            maximumCoordinate: CLLocationCoordinate2DMake(coordinate.latitude+offsetLat, coordinate.longitude+offsetLong)
        )

        // caliculate density
            // Radius x Radius square miles' area divides into RowCount x ColumnCount kernels
        let RowCount = 5
        let ColumnCount = 5
        var kernels = Array<Array<Double>>()
        for var i = 0; i < ColumnCount; i++ {
            kernels.append(Array(count: RowCount, repeatedValue: 0.0))
        }
            // weight kernels
        let RowWidth = offsetLat * 2 / Double(RowCount)
        let ColumnWidth = offsetLong * 2 / Double(ColumnCount)
        for crime in crimes {
            var weight = DASFGovernment.Crime.Weights[crime.category]
            if weight == nil { weight = DASFGovernment.Crime.Weights["THE OTHERS"] }
            let row = Int((Double(crime.lat) - coordinate.latitude + offsetLat) / RowWidth)
            let column = Int((Double(crime.long) - coordinate.longitude + offsetLong) / ColumnWidth)
            kernels[column][row] += weight!
        }

        // detection
        let DangerousThreshold = 1.5
        let DangerousCountThreshold = 5
        var dangerousAreaCount = 0
        for var i = 0; i < ColumnCount; i++ {
            for var j = 0; j < RowCount; j++ {
                if kernels[i][j] >= DangerousThreshold { dangerousAreaCount++ }
            }
        }
/*
        DALOG("---------------------------")
        for var i = 0; i < ColumnCount; i++ {
            var str = ""
            for var j = 0; j < RowCount; j++ { str += String(format: "%.2f ", kernels[i][j]); }
            DALOG(str)
        }
        let isDangerous = (dangerousAreaCount >= DangerousCountThreshold)
        DALOG((isDangerous) ? "Dangerous!" : "OK!")
*/
        let isDangerous = (dangerousAreaCount >= DangerousCountThreshold)
        return isDangerous
    }

}
