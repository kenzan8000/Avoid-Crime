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


/// MARK: - Google Map

/// Base URI
let kURIGoogleMapAPI =                  "https://maps.googleapis.com/maps/api"

struct DAGoogleMap {
    /// API key
    static let APIKey =                  "AIzaSyAdv1alDFQn2fVExouRjWC5I6-A2tKP3f8"

    /// MARK: - API
    struct API {
        static let Directions =        kURIGoogleMapAPI + "/directions/json" /// directions API
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

let kURISFGovernmentAPI =               "https://data.sfgov.org/api"

struct DASFGovernment {
    /// MARK: - API
    struct API {
        static let Row =                kURISFGovernmentAPI + "/views/w5k3-8ah8/rows.json" /// row API
    }
}

