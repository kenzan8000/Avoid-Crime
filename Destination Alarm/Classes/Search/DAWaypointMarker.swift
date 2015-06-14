/// MARK: - DAWaypointMarker
class DAWaypointMarker: GMSMarker {

    /// MARK: - public api

    /**
     * do settings (design, draggable, etc)
     **/
    func doSettings() {
        self.draggable = true
        self.icon = IonIcons.imageWithIcon(
            ion_ios_circle_filled,
            size: 28.0,
            color: UIColor(red: CGFloat(28.0/255.0), green: CGFloat(80.0/255.0), blue: CGFloat(120.0/255.0), alpha: 1.0)
        )

    }

}

