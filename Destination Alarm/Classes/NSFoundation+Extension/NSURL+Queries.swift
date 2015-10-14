import Foundation


/// MARK: - NSURL+Queries
extension NSURL {

    /// MARK: - Initialization

    /**
     * create URL
     * @param URLString URL String
     * @param queries queries
     * @return NSURL
     */
    convenience init?(URLString: String, queries: Dictionary<String, AnyObject>) {
        var string: String = URLString
        var i: Int = 0
        for (key, value) in queries {
            if i == 0 { string += "?" }
            else { string += "&" }

            let encodedKey = NSString(string: "\(key)").stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet()) as String!
            let encodedValue = NSString(string: "\(value)").stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet()) as String!
            string += encodedKey + "=" + encodedValue
            i++
        }

        self.init(string: string)
    }


    /// MARK: - public api

    /**
     * get URL Queries from URL
     * @param URL URL
     * @return Dictionary<Key, Value>
     */
    func da_queries() -> Dictionary<String, String> {
        var queries : Dictionary<String, String> = Dictionary<String, String>()

        let URLString = self.absoluteString
        let URLComponents = URLString.componentsSeparatedByString("?")
        if URLComponents.count < 2 { return queries }

        let query = URLComponents[1].componentsSeparatedByString("&")
        for parameter in query {
            let keyValue = parameter.componentsSeparatedByString("=")
            if keyValue.count < 2 { continue }
            queries[keyValue[0]] = keyValue[1]
        }
        return queries
    }
}
