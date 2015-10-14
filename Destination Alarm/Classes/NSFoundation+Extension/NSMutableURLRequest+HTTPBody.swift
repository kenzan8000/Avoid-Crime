import Foundation


/// MARK: - NSMutableURLRequest+HTTPBody
extension NSMutableURLRequest {

    /// MARK: - public api

    /**
     * set httpbody
     * @param dictionary dictionary
     */
    func da_setHTTPBody(dictionary dictionary: Dictionary<String, AnyObject>) {
        let json = JSON(dictionary)
        
        var body: NSData? = nil
        do {
            body = try json.rawData()
        }
        catch {
            return
        }

        self.HTTPBody = body
        if body != nil { self.setValue("\(body!.length)", forHTTPHeaderField:"Content-Length") }
    }


    /// MARK: - private api
}
