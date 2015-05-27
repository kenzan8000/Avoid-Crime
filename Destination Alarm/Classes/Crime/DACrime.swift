import Foundation
import CoreData
import CoreLocation


/// MARK: - DACrime
class DACrime: NSManagedObject {

    /// MARK: - property
    @NSManaged var desc: String
    @NSManaged var resolution: String
    @NSManaged var lat: NSNumber
    @NSManaged var long: NSNumber
    @NSManaged var timestamp: NSDate


    /// MARK: - class method

    /**
     * fetch datas from coredata
     * @param location location
     * @param radius radius of miles
     * @return Array<DACrime>
     */
    class func fetch(#location: CLLocation, radius: Double) -> Array<DACrime> {
        var context = DACoreDataManager.sharedInstance.managedObjectContext

        var fetchRequest = NSFetchRequest()
        let entity = NSEntityDescription.entityForName("DACrime", inManagedObjectContext:context)
        fetchRequest.entity = entity
        fetchRequest.fetchBatchSize = 20

        let coordinate = location.coordinate
        let latOffset = DAMapMath.degreeOfLatitudePerRadius(radius, location: location)
        let longOffset = DAMapMath.degreeOfLongitudePerRadius(radius, location: location)
        let predicaets = [
            NSPredicate(format: "lat < %@", NSNumber(double: coordinate.latitude + latOffset)),
            NSPredicate(format: "lat > %@", NSNumber(double: coordinate.latitude - latOffset)),
            NSPredicate(format: "long < %@", NSNumber(double: coordinate.longitude + longOffset)),
            NSPredicate(format: "long > %@", NSNumber(double: coordinate.longitude - longOffset)),
        ]
        fetchRequest.predicate = NSCompoundPredicate.andPredicateWithSubpredicates(predicaets)

        var error: NSError? = nil
        let crimes = context.executeFetchRequest(fetchRequest, error: &error) as! Array<DACrime>
        return crimes
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
    class func save(#json: JSON) {
        let crimeDatas: Array<JSON> = json.arrayValue

        for crimeData in crimeDatas {
            DACrime.insertCrime(json: crimeData)
        }

        var error: NSError? = nil
        var context = DACoreDataManager.sharedInstance.managedObjectContext
        !context.save(&error)
    }

    /**
     * insert new crime
     * @param json JSON
     * {
     *   "time" : "08:42",
     *   "category" : "LARCENY/THEFT",
     *   "pddistrict" : "SOUTHERN",
     *   "pdid" : "13054930206362",
     *   "location" : {
     *     "needs_recoding" : false,
     *     "longitude" : "-122.407633520742",
     *     "latitude" : "37.7841893501425",
     *     "human_address" : "{\"address\":\"\",\"city\":\"\",\"state\":\"\",\"zip\":\"\"}"
     *   },
     *   "address" : "800 Block of MARKET ST",
     *   "descript" : "PETTY THEFT SHOPLIFTING",
     *   "dayofweek" : "Tuesday",
     *   "resolution" : "ARREST, BOOKED",
     *   "date" : "2015-02-03T00:00:00",
     *   "y" : "37.7841893501425",
     *   "x" : "-122.407633520742",
     *   "incidntnum" : "130549302"
     * }
     */
    class func insertCrime(#json: JSON) {
/*
        let children = json["children"].arrayValue

        // insert child
        if children.count == 0 {
            var context = DACoreDataManager.sharedInstance.managedObjectContext
            var crime = NSEntityDescription.insertNewObjectForEntityForName("DACrime", inManagedObjectContext: context) as! DACrime
            crime.crime_id = json["id"].numberValue
            if let centroid = json["centroid"].dictionary {
                crime.lat = centroid["lat"]!.numberValue
                crime.long = centroid["lon"]!.numberValue
            }
            crime.size = json["size"].numberValue
            crime.timestamp = date
        }

        // insert children
        for child in children {
            DACrime.insertCrime(json: child, date: date)
        }
*/
    }
}
