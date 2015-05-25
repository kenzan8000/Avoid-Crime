import Foundation


/// MARK: - DADestination
class DADestination: AnyObject {

    /// MARK: - property
    var desc: String = ""


    /// MARK: - class method

    /**
     * return destination array from JSON
     * @param json JSON
     * {
     *   "status" : "OK",
     *   "predictions" : [
     *     {
     *       "reference" : "CoQBewAAAIHap3nqERh_1MOaDuS0gGn92yYPVgNE7PaAt_HHuj9rT_zGc9BoXoYk1r5_QpF_eIglKvmAgoEMzzXrDX8M_HdPguKBRjATBgmdYMF0qgZkX1xQcSoIsRWV8cPJ9VoKJlIMBh06x5YAX8mKrdfOxkrWdeO2Xmd3RAgJ7M1ReLnbEhDfJjEX25PM5hAI2fi81zCvGhQEnp6_WPYOgkB-oGb4txDkfTtJ_g",
     *       "id" : "a46ea2dc78f3248b98b569711475bf9dccdd91c5",
     *       "types" : [
     *         "establishment"
     *       ],
     *       "matched_substrings" : [
     *         {
     *           "offset" : 0,
     *           "length" : 11
     *         }
     *       ],
     *       "place_id" : "ChIJLVgtY4iAhYARoO_UxqNv5Bw",
     *       "description" : "Super Duper Burger, Market Street, San Francisco, CA, United States",
     *       "terms" : [
     *         {
     *           "value" : "Super Duper Burger",
     *           "offset" : 0
     *         },
     *         {
     *           "value" : "Market Street",
     *           "offset" : 20
     *         },
     *         {
     *           "value" : "San Francisco",
     *           "offset" : 35
     *         },
     *         {
     *           "value" : "CA",
     *           "offset" : 50
     *         },
     *         {
     *           "value" : "United States",
     *           "offset" : 54
     *         }
     *       ]
     *     },
     *     ...
     *   ]
     * }
     * @return [DADestination]
     */
    class func destinations(#json: JSON) -> [DADestination] {
        var destinations: [DADestination] = []

        let predictions: Array<JSON> = json["predictions"].arrayValue
        for prediction in predictions {
            let destination = DADestination()
            destination.desc = prediction["description"].stringValue
            destinations.append(destination)
        }

        return destinations
    }

}
