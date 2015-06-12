import Foundation


/// MARK: - LOG

/**
 * display log
 * @param body log
 */
func DALOG(str: String) {
#if DEBUG
    println("////////// DA log\n" + str + "\n\n")
#endif
}


/// MARK: - function

/**
 * return class name
 * @param classType classType
 * @return class name
 */
func DANSStringFromClass(classType:AnyClass) -> String {
    let classString = NSStringFromClass(classType.self)
    let range = classString.rangeOfString(".", options: NSStringCompareOptions.CaseInsensitiveSearch, range: Range<String.Index>(start:classString.startIndex, end: classString.endIndex), locale: nil)
    return classString.substringFromIndex(range!.endIndex)
}


/// MARK: - UserDefaults

struct DAUserDefaults {
    static let CrimeYearMonth =         "DAUserDefaults.CrimeYearMonth"
}


/// MARK: - Google Map

/// Base URI
let kURIGoogleMapAPI =                  "https://maps.googleapis.com/maps/api"

struct DAGoogleMap {
    /// API key
    static let APIKey =                 kDAGoogleMapAPIKey
    static let BrowserAPIKey =          kDAGoogleMapBrowserAPIKey

    /// zoom
    static let Zoom: Float =            13.0

    /// MARK: - API
    struct API {
        static let Directions =        kURIGoogleMapAPI + "/directions/json" /// directions API
        static let GeoCode =           kURIGoogleMapAPI + "/geocode/json" /// geocode API
        static let PlaceAutoComplete = kURIGoogleMapAPI + "/place/autocomplete/json" /// autocomplete API
    }

    /// MARK: - status code
    static let Status =                     "status"
    struct Statuses {
        static let OK =                     "OK"
        static let NotFound =               "NOT_FOUND"
        static let ZeroResults =            "ZERO_RESULTS"
        static let MaxWayPointsExceeded =   "MAX_WAYPOINTS_EXCEEDED"
        static let InvalidRequest =         "INVALID_REQUEST"
        static let OverQueryLimit =         "OVER_QUERY_LIMIT"
        static let RequestDenied =          "REQUEST_DENIED"
        static let UnknownError =           "UNKNOWN_ERROR"
    }

    /// MARK: - travel mode
    static let TravelMode =            "mode"
    struct TravelModes {
        static let Driving =           "driving"
        static let Walking =           "walking"
        static let Bicycling =         "bicycling"
    }

}


/// MARK: - SF Government

let kURISFGovernmentAPI =               "https://data.sfgov.org"

struct DASFGovernment {
    /// MARK: - API
    struct API {
        static let GetCrime =                kURISFGovernmentAPI + "/resource/tmnf-yvry.json" /// Get Crime
    }

    /// MARK: - Crime
    struct Crime {
        static let Days =                     1
        static let MonthsAgo =                1

        static let Weights = [
            "ASSAULT" : NSNumber(double: 1.0),
            "ROBBERY" : NSNumber(double: 0.5),
            "LARCENY/THEFT" : NSNumber(double: 0.25),
            "DRUG/NARCOTIC" : NSNumber(double: 0.5),
            "ARSON" : NSNumber(double: 0.5),
            "WEAPON LAWS" : NSNumber(double: 1.0),
            "MISSING PERSON" : NSNumber(double: 1.0),
            "VANDALISM" : NSNumber(double: 0.75),
            "VEHICLE THEFT" : NSNumber(double: 1.0),
            "OTHER OFFENSES" : NSNumber(double: 1.0),
            "STOLEN PROPERTY" : NSNumber(double: 1.0),
            "PROSTITUTION" : NSNumber(double: 1.0),
            "DRIVING UNDER THE INFLUENCE" : NSNumber(double: 0.75),
            "DRUNKENNESS" : NSNumber(double: 0.5),
            "BURGLARY" : NSNumber(double: 0.25),
            "SUSPICIOUS OCC" : NSNumber(double: 0.5),
            "SEX OFFENSES), FORCIBLE" : NSNumber(double: 1.0),
            "KIDNAPPING" : NSNumber(double: 1.0),
            "DISORDERLY CONDUCT" : NSNumber(double: 0.5),
            "SECONDARY CODES" : NSNumber(double: 0.5),
            "TRESPASS" : NSNumber(double: 0.25),
            "FRAUD" : NSNumber(double: 0.25),
            "FORGERY/COUNTERFEITING" : NSNumber(double: 0.25),
            "WARRANTS" : NSNumber(double: 0.25),
            "LOITERING" : NSNumber(double: 1.0),
            "THE OTHERS" : NSNumber(double: 0.25),
        ]
    }
}


/// MARK: - marker
enum DAVisualization {
    case None
    case Destination
    case Waypoint
    case CrimePoint
    case CrimeHeatmap
}
