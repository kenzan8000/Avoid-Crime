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
}


/// MARK: - SF Government

let kURISFGovernmentAPI =               "https://data.sfgov.org/api"

struct DASFGovernment {
    /// MARK: - API
    struct API {
        static let Row =                "/views/w5k3-8ah8/rows.json"
    }
}
/*
Content-Type: application/json
Content-Length:

accessType:DOWNLOAD
method:clustered2
min_lon:-122.44828466022
max_lon:-122.37575772847
min_lat:37.77697600598
max_lat:37.79230641032
target_node_clusters:250
min_distance_between_clusters:0.0030525141384952644
*/
