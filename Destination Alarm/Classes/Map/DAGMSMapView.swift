/// MARK: - DAGMSMapView
class DAGMSMapView: GMSMapView {

    /// MARK: - api
    func drawRoute(#json: JSON) {
        self.clear()

        let pathes = self.encodedPathes(json: json)
        for pathString in pathes {
            let path = GMSPath(fromEncodedPath: pathString)
            var line = GMSPolyline(path: path)
            line.strokeWidth = 4.0
            line.tappable = true
            line.map = self
        }
    }


    /// MARK: - private api
    /**
     * return encodedPath
     * @param json json
     * @return [String]
     **/
    private func encodedPathes(#json: JSON) -> [String] {
        // make pathes
        var pathes = [] as [String]

        let routes = json["routes"].arrayValue
        for route in routes {
            let overviewPolyline = route["overview_polyline"].dictionaryValue
            let path = overviewPolyline["points"]!.stringValue
            pathes.append(path)
        }

        return pathes
    }
}

