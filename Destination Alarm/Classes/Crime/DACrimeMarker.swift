/// MARK: - DACrimeMarker
class DACrimeMarker: GMSMarker {

    /// MARK: - public api

    /**
     * do settings (design, draggable, etc)
     * @param crime DACrime
     **/
    func doSettings(#crime: DACrime) {
        // settings
        var iconName = crime.category.lowercaseString.stringByReplacingOccurrencesOfString("/", withString: ":", options: nil, range: nil)
        var image = UIImage(named: "marker_"+iconName)
        if image == nil { image = UIImage(named: "marker_question") }
        self.icon = image
        self.draggable = false
        self.title = crime.category
        self.snippet = crime.desc
    }

}
