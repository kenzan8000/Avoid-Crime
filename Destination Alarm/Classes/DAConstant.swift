import Foundation


/// MARK: - LOG

/**
 * display log
 * @param body log
 */
func DALOG(str: String) {
#if DEBUG
    print(str)
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
    static let CrimeYearMonth =            "DAUserDefaults.CrimeYearMonth"
    static let TutorialHasDone =           "DAUserDefaults.TutorialHasDone"
}


/// MARK: - Google Map

/// Base URI
let kURIGoogleMapAPI =                  "https://maps.googleapis.com/maps/api"

struct DAGoogleMap {
    /// API key
    static let APIKey =                 kDAGoogleMapAPIKey
    static let BrowserAPIKey =          kDAGoogleMapBrowserAPIKey

    static let Latitude: CLLocationDegrees =        37.7833
    static let Longitude: CLLocationDegrees =       -122.4167

    /// zoom
    static let Zoom: Float =            13.0

    /// z index
    struct ZIndex {
        static let Heatmap: Int32 =            30
        static let Icon: Int32 =               40
        static let Route: Int32 =              50
        static let Waypoint: Int32 =           60
        static let Destination: Int32 =        70
    }

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
            "ASSAULT" : 1.5,
            "ROBBERY" : 0.75,
            "LARCENY/THEFT" : 0.25,
            "DRUG/NARCOTIC" : 0.5,
            "ARSON" : 0.75,
            "WEAPON LAWS" : 1.5,
            "MISSING PERSON" : 1.5,
            "VANDALISM" : 0.5,
            "VEHICLE THEFT" : 0.75,
            "OTHER OFFENSES" : 0.5,
            "STOLEN PROPERTY" : 1.0,
            "PROSTITUTION" : 1.0,
            "DRIVING UNDER THE INFLUENCE" : 0.75,
            "DRUNKENNESS" : 0.75,
            "BURGLARY" : 0.25,
            "SUSPICIOUS OCC" : 0.5,
            "SUICIDE" : 0.25,
            "\"SEX OFFENSES, FORCIBLE\"" : 1.5,
            "KIDNAPPING" : 1.5,
            "DISORDERLY CONDUCT" : 0.5,
            "SECONDARY CODES" : 0.5,
            "RUNAWAY" : 0.25,
            "TRESPASS" : 0.25,
            "FRAUD" : 0.25,
            "FORGERY/COUNTERFEITING" : 0.25,
            "EMBEZZLEMENT" : 0.25,
            "WARRANTS" : 0.25,
            "LOITERING" : 1.0,
            "THE OTHERS" : 0.25,
        ]

        static let Weights_number = [
            "ASSAULT" : NSNumber(double: 1.5),
            "ROBBERY" : NSNumber(double: 0.75),
            "LARCENY/THEFT" : NSNumber(double: 0.25),
            "DRUG/NARCOTIC" : NSNumber(double: 0.5),
            "ARSON" : NSNumber(double: 0.75),
            "WEAPON LAWS" : NSNumber(double: 1.5),
            "MISSING PERSON" : NSNumber(double: 1.5),
            "VANDALISM" : NSNumber(double: 0.5),
            "VEHICLE THEFT" : NSNumber(double: 0.75),
            "OTHER OFFENSES" : NSNumber(double: 0.5),
            "STOLEN PROPERTY" : NSNumber(double: 1.0),
            "PROSTITUTION" : NSNumber(double: 1.0),
            "DRIVING UNDER THE INFLUENCE" : NSNumber(double: 0.75),
            "DRUNKENNESS" : NSNumber(double: 0.75),
            "BURGLARY" : NSNumber(double: 0.25),
            "SUSPICIOUS OCC" : NSNumber(double: 0.5),
            "SUICIDE" : NSNumber(double: 0.25),
            "\"SEX OFFENSES, FORCIBLE\"" : NSNumber(double: 1.5),
            "KIDNAPPING" : NSNumber(double: 1.5),
            "DISORDERLY CONDUCT" : NSNumber(double: 0.5),
            "SECONDARY CODES" : NSNumber(double: 0.5),
            "RUNAWAY" : NSNumber(double: 0.25),
            "TRESPASS" : NSNumber(double: 0.25),
            "FRAUD" : NSNumber(double: 0.25),
            "FORGERY/COUNTERFEITING" : NSNumber(double: 0.25),
            "EMBEZZLEMENT" : NSNumber(double: 0.25),
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
