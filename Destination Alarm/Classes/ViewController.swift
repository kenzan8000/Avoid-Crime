import UIKit


/// MARK: - ViewController
class ViewController: UIViewController {

    /// MARK: - property
    var destinationString: String = ""

    var mapView: DAGMSMapView!
    var searchBoxView: DASearchBoxView!
    var searchResultView: DASearchResultView!
    var durationView: DADurationView!
    var crimePointButton: DACrimeButton!
    var crimeHeatmapButton: DACrimeButton!
    var locationManager: CLLocationManager!


    /// MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        self.doSettings()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


    /// MARK: - event listener

    /**
     * called when touched button
     * @param button UIButton
     **/
    @IBAction func touchedUpInside(#button: UIButton) {
    }


    /// MARK: - private api

    /**
     * do settings
     **/
    private func doSettings() {
        // google map view
        self.mapView = DAGMSMapView.sharedInstance
        self.mapView.frame = CGRectMake(0, 0, self.view.bounds.width, self.view.bounds.height)
        self.mapView.myLocationEnabled = true
        self.mapView.settings.myLocationButton = true
        self.mapView.delegate = self
        //self.mapView.mapType = kGMSTypeNone
        //self.mapView.padding = UIEdgeInsetsMake(0.0, 0.0, 48.0, 0.0)
        self.view.addSubview(self.mapView)

        // search result
        let searchResultNib = UINib(nibName: DANSStringFromClass(DASearchResultView), bundle:nil)
        let searchResultViews = searchResultNib.instantiateWithOwner(nil, options: nil)
        self.searchResultView = searchResultViews[0] as! DASearchResultView
        self.searchResultView.frame = CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, UIScreen.mainScreen().bounds.height)
        self.searchResultView.hidden = true
        self.searchResultView.delegate = self
        self.view.addSubview(self.searchResultView)
        self.searchResultView.design()

        // search box
        let searchBoxNib = UINib(nibName: DANSStringFromClass(DASearchBoxView), bundle:nil)
        let searchBoxViews = searchBoxNib.instantiateWithOwner(nil, options: nil)
        self.searchBoxView = searchBoxViews[0] as! DASearchBoxView
        self.searchBoxView.delegate = self
        self.view.addSubview(self.searchBoxView)
        self.searchBoxView.design(parentView: self.view)

        // duration view
        let durationViewNib = UINib(nibName: DANSStringFromClass(DADurationView), bundle:nil)
        let durationViews = durationViewNib.instantiateWithOwner(nil, options: nil)
        self.durationView = durationViews[0] as! DADurationView
        self.view.addSubview(self.durationView)
        self.durationView.design(parentView: self.view)
        self.durationView.delegate = self

        // crime buttons
        let crimePointButtonNib = UINib(nibName: DANSStringFromClass(DACrimeButton), bundle:nil)
        let crimePointButtons = crimePointButtonNib.instantiateWithOwner(nil, options: nil)
        self.crimePointButton = crimePointButtons[0] as! DACrimeButton
        let crimeHeatmapButtonNib = UINib(nibName: DANSStringFromClass(DACrimeButton), bundle:nil)
        let crimeHeatmapButtons = crimeHeatmapButtonNib.instantiateWithOwner(nil, options: nil)
        self.crimeHeatmapButton = crimeHeatmapButtons[0] as! DACrimeButton
        let crimeButtons = [self.crimeHeatmapButton, self.crimePointButton]
        let crimeButtonImages = [UIImage(named: "button_crime_heatmap")!, UIImage(named: "button_crime_point")!]
//        let xOffset: CGFloat = 10.0
//        let yOffset: CGFloat = 10.0
        for var i = 0; i < crimeButtons.count; i++ {
            var crimeButton = crimeButtons[i]
/*
            crimeButton.frame = CGRectMake(
                self.view.frame.size.width - crimeButton.frame.size.width - xOffset,
                self.view.frame.size.height - (crimeButton.frame.size.height + yOffset) * CGFloat(i+2) - 48.0,
                crimeButton.frame.size.width,
                crimeButton.frame.size.height
            )
*/
            crimeButton.setImage(crimeButtonImages[i])
            self.view.addSubview(crimeButton)
            crimeButton.delegate = self
        }

        // location manager
        self.locationManager = CLLocationManager()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.distanceFilter = 300
        self.locationManager.startUpdatingLocation()

        self.setButtonPositions(offsetY: 0)

        self.view.bringSubviewToFront(self.searchResultView)
        self.view.bringSubviewToFront(self.searchBoxView)
    }

    /**
     * set button positions
     * @param offsetY CGFloat
     **/
    private func setButtonPositions(#offsetY: CGFloat) {
        self.durationView.frame = CGRectMake(0, self.view.frame.size.height - offsetY, self.durationView.frame.size.width, self.durationView.frame.size.height)

        self.mapView.padding = UIEdgeInsetsMake(0.0, 0.0, offsetY, 0.0)

        let crimeButtons = [self.crimeHeatmapButton, self.crimePointButton]
        let xOffset: CGFloat = 10.0
        let yOffset: CGFloat = 10.0
        for var i = 0; i < crimeButtons.count; i++ {
            var crimeButton = crimeButtons[i]
            crimeButton.frame = CGRectMake(
                self.view.frame.size.width - crimeButton.frame.size.width - xOffset,
                self.view.frame.size.height - (crimeButton.frame.size.height + yOffset) * CGFloat(i+2) - offsetY,
                crimeButton.frame.size.width,
                crimeButton.frame.size.height
            )
        }
    }

    /**
     * request dirction API and render direction
     * @param doUpdateCamera Bool if camera updates when routing has done
     */
    private func requestDirectoin(#doUpdateCamera: Bool) {
        var didRequestDestinationFromCoordinate = false
        if self.destinationString == "" {
            if self.mapView.destination == nil { return }
            didRequestDestinationFromCoordinate = true
            self.destinationString = String(format: "%.4f,%.4f", self.mapView.destination!.latitude, self.mapView.destination!.longitude)
        }
        if self.destinationString == "" { return }
        self.searchBoxView.setSearchText(self.destinationString)

        DAGoogleMapClient.sharedInstance.cancelGetRoute()

        // google map direction API
        let location = self.mapView.myLocation
        if location == nil { return }
        let coordinate = location.coordinate
        DAGoogleMapClient.sharedInstance.getRoute(
            queries: [ "origin" : "\(coordinate.latitude),\(coordinate.longitude)", "destination" : self.destinationString, ],
            completionHandler: { [unowned self] (json) in
                self.mapView.setRouteJSON(json)
                self.mapView.draw()

                // update camera
                if doUpdateCamera { self.mapView.updateCameraWhenRoutingHasDone() }

                // duration view
                if didRequestDestinationFromCoordinate {
                    self.destinationString = self.mapView.endAddress()
                    self.searchBoxView.setSearchText(self.destinationString)
                }
                self.durationView.show(destinationString: self.destinationString, durationString: self.mapView.routeDuration())
            }
        )
    }
}


/// MARK: - CLLocationManagerDelegate
extension ViewController: CLLocationManagerDelegate {

    func locationManager(manager: CLLocationManager!, didUpdateToLocation newLocation: CLLocation!, fromLocation oldLocation: CLLocation!) {
        let location = self.mapView.myLocation
        if location == nil { return }
        self.mapView.camera = GMSCameraPosition.cameraWithLatitude(
            location.coordinate.latitude,
            longitude: location.coordinate.longitude,
            zoom: DAGoogleMap.Zoom
        )
    }

    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
    }

}


/// MARK: - UIActionSheetDelegate
extension ViewController: UIActionSheetDelegate {

    func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int) {
        if buttonIndex != 0 { return }
        if !(self.mapView.isEditingNow()) { return }

        let doRequestDirectoin = self.mapView.editingMarker!.isKindOfClass(DAWaypointMarker)

        let doDeleteDestination = self.mapView.editingMarker!.isKindOfClass(DADestinationMarker)
        if doDeleteDestination { self.searchBoxView.setSearchText("") }

        // delete editing marker
        self.durationView.hide()
        self.mapView.deleteEditingMarker()
        self.mapView.draw()

        // RequestDirectoin
        if doRequestDirectoin {
            self.requestDirectoin(doUpdateCamera: false)
        }
    }

}


/// MARK: - GMSMapViewDelegate
extension ViewController: GMSMapViewDelegate {

    func mapView(mapView: GMSMapView, didTapAtCoordinate coordinate: CLLocationCoordinate2D) {
        // append destination or waypoint
        if !(self.mapView.isEditingNow()) {
            self.mapView.appendPoint(coordinate)
            self.requestDirectoin(doUpdateCamera: false)
        }
    }

    func mapView(mapView: GMSMapView, didLongPressAtCoordinate coordinate: CLLocationCoordinate2D) {
    }

    func mapView(mapView: GMSMapView, didTapMarker marker: GMSMarker) -> Bool {
        // destination or waypoint
        if marker.isKindOfClass(DADestinationMarker) || marker.isKindOfClass(DAWaypointMarker) {
            self.mapView.editingMarker = marker
            self.showDeleteMarkerActionSheet()
            return false
        }

        self.mapView.selectedMarker = marker
        return true
    }

    func mapView(mapView: GMSMapView,  didBeginDraggingMarker marker: GMSMarker) {
        self.mapView.startMovingMarker(marker)
    }

    func mapView(mapView: GMSMapView,  didEndDraggingMarker marker: GMSMarker) {
        self.durationView.hide()
        self.mapView.endMovingMarker(marker)
        if marker.isKindOfClass(DADestinationMarker) { self.destinationString = "" }
        self.requestDirectoin(doUpdateCamera: false)
    }
/*
    func mapView(mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView {
    }
*/
    func mapView(mapView: GMSMapView, didChangeCameraPosition position: GMSCameraPosition) {
        if !(self.mapView.isEditingNow()) {
            let crimes = DACrime.fetch(minimumCoordinate: self.mapView.getMinimumCoordinate(), maximumCoordinate: self.mapView.getMaximumCoordinate())
            if crimes.count > 0 { self.mapView.setCrimes(crimes) }
            self.mapView.draw()
        }
    }

    func mapView(mapView: GMSMapView,  didDragMarker marker:GMSMarker) {
    }

    /**
     * show action sheet if you deletes marker or not
     **/
    func showDeleteMarkerActionSheet() {
        let actionSheet = UIActionSheet()
        actionSheet.delegate = self
        actionSheet.addButtonWithTitle("Delete")
        actionSheet.destructiveButtonIndex = 0
        actionSheet.addButtonWithTitle("Cancel")
        actionSheet.cancelButtonIndex = 1
        actionSheet.showInView(self.view)
    }

}


/// MARK: - DASearchBoxViewDelegate
extension ViewController: DASearchBoxViewDelegate {

    func searchBoxWasActive(#searchBoxView: DASearchBoxView) {
        self.searchResultView.hidden = false
    }

    func searchBoxWasInactive(#searchBoxView: DASearchBoxView) {
        self.searchResultView.hidden = true
        self.searchBoxView.setSearchText(self.destinationString)
    }

    func searchDidFinish(#searchBoxView: DASearchBoxView, destinations: [DADestination]) {
        self.searchResultView.updateDestinations(destinations)
    }

    func clearButtonTouchedUpInside(#searchBoxView: DASearchBoxView) {
        if self.searchBoxView.isActive { return }

        DAGoogleMapClient.sharedInstance.cancelGetRoute()

        self.durationView.hide()
        self.mapView.setRouteJSON(nil)
        self.destinationString = ""
        self.mapView.destination = nil

        self.mapView.draw()
    }

}


/// MARK: - DASearchResultViewDelegate
extension ViewController: DASearchResultViewDelegate {

    func didSelectRow(#searchResultView: DASearchResultView, selectedDestination: DADestination) {
        self.searchBoxView.endSearch()
        self.searchBoxView.setSearchText(selectedDestination.desc)
        if self.destinationString == selectedDestination.desc { return }
        self.destinationString = selectedDestination.desc
        self.mapView.removeAllPoints()
        self.requestDirectoin(doUpdateCamera: true)
    }

}


/// MARK: - DADurationViewDelegate
extension ViewController: DADurationViewDelegate {

    func touchedUpInside(#durationView: DADurationView) {
    }

    func willShow(#durationView: DADurationView) {
        UIView.animateWithDuration(
            0.30,
            delay: 0.0,
            options: .CurveEaseOut,
            animations: { [unowned self] in self.setButtonPositions(offsetY: self.durationView.frame.size.height) },
            completion: { [unowned self] finished in }
        )
    }

    func willHide(#durationView: DADurationView) {
        UIView.animateWithDuration(
            0.15,
            delay: 0.0,
            options: .CurveEaseOut,
            animations: { [unowned self] in self.setButtonPositions(offsetY: 0) },
            completion: { [unowned self] finished in }
        )
    }
}


/// MARK: - DACrimeButtonDelegate
extension ViewController: DACrimeButtonDelegate {

    func crimeButton(crimeButton: DACrimeButton, wasOn: Bool) {
        var markerType = DAVisualization.None
        if crimeButton == self.crimePointButton {
            markerType = DAVisualization.CrimePoint
            self.crimeHeatmapButton.setCheckBox(isOn: false)
        }
        else if crimeButton == self.crimeHeatmapButton {
            markerType = DAVisualization.CrimeHeatmap
            self.crimePointButton.setCheckBox(isOn: false)
        }
        self.mapView.setCrimeMarkerType(markerType)
        if markerType != DAVisualization.None { DACrime.requestToGetNewCrimes() }

        let on = wasOn
        self.mapView.setCrimes(on ? DACrime.fetch(minimumCoordinate: self.mapView.getMinimumCoordinate(), maximumCoordinate: self.mapView.getMaximumCoordinate()) : nil)

        self.mapView.draw()
    }

}
