/// MARK: - DAWaypointMarker
class DAWaypointMarker: GMSMarker {

    /// MARK: - public api

    /**
     * do settings (design, draggable, etc)
     **/
    func doSettings() {
        self.icon = DAWaypointMarker.markerImageWithColor(UIColor.blueColor())
        self.draggable = true
    }

}

