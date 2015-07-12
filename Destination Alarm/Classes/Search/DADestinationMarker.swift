/// MARK: - DADestinationMarker
class DADestinationMarker: GMSMarker {

    /// MARK: - initialization

    convenience init(position: CLLocationCoordinate2D) {
        self.init()

        self.position = position
        self.draggable = true
    }


}

