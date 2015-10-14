/// MARK: - DACrimeMarker
class DACrimeMarker: GMSMarker {

    /// MARK: - initialization

    /**
     * constructor
     * @param position CLLocationCoordinate2D
     * @param crime DACrime
     * @return DACrimeMarker
     **/
    convenience init(position: CLLocationCoordinate2D, crime: DACrime) {
        self.init()

        self.position = position

        let iconName = crime.category.lowercaseString.stringByReplacingOccurrencesOfString("/", withString: ":", options: [], range: nil)
        var image = UIImage(named: "marker_"+iconName)
        if image == nil { image = UIImage(named: "marker_question") }
        self.icon = image
        self.draggable = false
        self.title = crime.category
        self.snippet = crime.desc
    }

}
