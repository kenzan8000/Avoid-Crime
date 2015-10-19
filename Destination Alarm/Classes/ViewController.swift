import UIKit


/// MARK: - ViewController
class ViewController: UIViewController {

    /// MARK: - property
    var destinationString: String = "" {
        didSet {
            self.searchBoxView.setSearchText(destinationString)
        }
    }

    var mapView: DAGMSMapView!
    var searchBoxView: DASearchBoxView!
    var searchResultView: DASearchResultView!
    var durationView: DADurationView!
    @IBOutlet weak var tutorialButton: UIButton!
    var crimePointButton: DACrimeButton!
    var crimeHeatmapButton: DACrimeButton!
    var locationManager: CLLocationManager!


    /// MARK: - life cycle
    override func loadView() {
        super.loadView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.doSettings()

        let tutorialHasDone = NSUserDefaults().boolForKey(DAUserDefaults.TutorialHasDone)
        if !tutorialHasDone { self.showTutorial() }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


    /// MARK: - event listener

    /**
     * called when touched button
     * @param button UIButton
     **/
    @IBAction func touchedUpInside(button button: UIButton) {
        if button == self.tutorialButton {
            self.showTutorial()
        }
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
        self.view.addSubview(self.mapView)
        self.mapView.camera = GMSCameraPosition.cameraWithLatitude(
            DAGoogleMap.Latitude,
            longitude: DAGoogleMap.Longitude,
            zoom: DAGoogleMap.Zoom
        )

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
        for var i = 0; i < crimeButtons.count; i++ {
            let crimeButton = crimeButtons[i]
            crimeButton.setImage(crimeButtonImages[i])
            self.view.addSubview(crimeButton)
            crimeButton.delegate = self
        }

        // tutorial button
        self.tutorialButton.setImage(IonIcons.imageWithIcon(ion_ios_information, size: 32.0, color: UIColor.grayColor()), forState: .Normal)

        // location manager
        self.locationManager = CLLocationManager()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        if #available(iOS 8.0, *) { self.locationManager.requestAlwaysAuthorization() }
        if #available(iOS 9.0, *) { self.locationManager.allowsBackgroundLocationUpdates = true }
        self.locationManager.distanceFilter = 100
        self.locationManager.pausesLocationUpdatesAutomatically = false
        self.locationManager.startUpdatingLocation()

        self.setButtonPositions(offsetY: 0)
        //self.setButtonPositions(offsetY: self.view.bounds.size.height - self.view.bounds.size.width)

        self.view.bringSubviewToFront(self.tutorialButton)
        self.view.bringSubviewToFront(self.searchResultView)
        self.view.bringSubviewToFront(self.searchBoxView)
    }

    /**
     * show tutorial
     **/
    private func showTutorial() {
        let bgColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.75)
        let color = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        let titleFont = UIFont(name: "HelveticaNeue-Bold", size: 20.0)
        let descFont = UIFont(name: "HelveticaNeue-Light", size: 14.0)
        let titles = [
            "Welcome to San Francisco",
            "Set your destination",
            "Check crime on map",
            "Avoid crime",
            "Have a safe trip!",
        ]
        let descs = [
            "",
            "Input an address or tap location on map.",
            "Tap buttons to display crime. The skull button shows detail of cirme. The red one shows heatmap.",
            "Tap location to pass and avoid crime.",
            "",
        ]

        var offset: CGFloat = 20.0
        switch self.view.frame.size {
            case CGSize(width: 320.0, height: 480.0):
                offset = 60.0
                break
            default:
                break
        }
        var pages: [EAIntroPage] = []
        for var i = 0; i < titles.count; i++ {
            let page = EAIntroPage()
            page.title = titles[i]
            page.desc = descs[i]
            page.bgColor = bgColor
            page.titleFont = titleFont
            page.titleColor = color
            page.descFont = descFont
            page.descColor = color
            let imageView = UIImageView(image: UIImage(named: "tutorial_\(i+1)"))
            imageView.frame = CGRectMake(0, 0, self.view.frame.size.width - offset, self.view.frame.size.width - offset)
            page.titleIconView = imageView

            pages.append(page)
        }

        let introView = EAIntroView(frame: self.view.bounds, andPages: pages)
        introView.delegate = self
        introView.showInView(self.view, animateDuration: 1.0)
    }

    /**
     * set button positions
     * @param offsetY CGFloat
     **/
    private func setButtonPositions(offsetY offsetY: CGFloat) {
        self.durationView.frame = CGRectMake(0, self.view.frame.size.height - offsetY, self.durationView.frame.size.width, self.durationView.frame.size.height)

        self.mapView.padding = UIEdgeInsetsMake(0.0, 0.0, offsetY, 0.0)

        let crimeButtons = [self.crimeHeatmapButton, self.crimePointButton]
        let xOffset: CGFloat = 10.0
        let yOffset: CGFloat = 10.0
        for var i = 0; i < crimeButtons.count; i++ {
            let crimeButton = crimeButtons[i]
            crimeButton.frame = CGRectMake(
                self.view.frame.size.width - crimeButton.frame.size.width - xOffset,
                self.view.frame.size.height - (crimeButton.frame.size.height + yOffset) * CGFloat(i+2) - offsetY,
                crimeButton.frame.size.width,
                crimeButton.frame.size.height
            )
        }

        self.tutorialButton.frame = CGRectMake(
            0,
            self.view.frame.size.height - (self.tutorialButton.frame.size.height) * CGFloat(1) - offsetY,
            self.tutorialButton.frame.size.width,
            self.tutorialButton.frame.size.height
        )
    }

    /**
     * request dirction API and render direction
     * @param doUpdateCamera Bool if camera updates when routing has done
     */
    private func requestDirectoin(doUpdateCamera doUpdateCamera: Bool) {
        var didRequestDestinationFromCoordinate = false
        if self.destinationString == "" {
            if self.mapView.destination == nil { return }
            didRequestDestinationFromCoordinate = true
            self.destinationString = String(format: "%.4f,%.4f", self.mapView.destination!.latitude, self.mapView.destination!.longitude)
        }

        DAGoogleMapClient.sharedInstance.cancelGetRoute()
        self.searchBoxView.startRequestRouting()

        // google map direction API
        let location = self.mapView.myLocation
        if location == nil { return }
        let coordinate = location.coordinate
        DAGoogleMapClient.sharedInstance.getRoute(
            queries: [ "origin" : "\(coordinate.latitude),\(coordinate.longitude)", "destination" : self.destinationString, "mode" : self.searchBoxView.getMode(), ],
            completionHandler: { [unowned self] (json) in
                self.searchBoxView.endRequestRouting()

                // failed
                if json[DAGoogleMap.Status].stringValue == DAGoogleMap.Statuses.ZeroResults {
                    self.mapView.removeAllPoints()
                    self.destinationString = ""
                    return
                }

                // succeeded
                self.mapView.setRouteJSON(json)
                self.mapView.draw()
                // update camera
                if doUpdateCamera { self.mapView.updateCameraWhenRoutingHasDone() }
                // duration view
                if didRequestDestinationFromCoordinate {
                    self.destinationString = self.mapView.endAddress()
                }
                self.durationView.show(destinationString: self.destinationString, durationString: self.mapView.routeDuration())
            }
        )
    }
}


/// MARK: - CLLocationManagerDelegate
extension ViewController: CLLocationManagerDelegate {

    func locationManager(manager: CLLocationManager, didUpdateToLocation newLocation: CLLocation, fromLocation oldLocation: CLLocation) {
        let location = self.mapView.myLocation
        if location == nil { return }
        self.mapView.camera = GMSCameraPosition.cameraWithLatitude(
            location.coordinate.latitude,
            longitude: location.coordinate.longitude,
            zoom: DAGoogleMap.Zoom
        )
/*
        // if you are close to dangerous area, post local notification
        if DACrime.isHighRated(coordinate: location.coordinate) {
            let localNotification = UILocalNotification()
            localNotification.alertBody = String(format: "Be careful! You are close to dangerous area. (%.2f, %.2f)", location.coordinate.latitude, location.coordinate.longitude)
            localNotification.soundName = UILocalNotificationDefaultSoundName
            localNotification.timeZone = NSTimeZone.defaultTimeZone()
            localNotification.fireDate = NSDate(timeIntervalSinceNow: 1)
            UIApplication.sharedApplication().scheduleLocalNotification(localNotification)
        }
*/
    }

    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
    }

    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .Denied {
            if #available(iOS 8.0, *) { self.locationManager.requestAlwaysAuthorization() }
        }
    }
}


/// MARK: - UIActionSheetDelegate
extension ViewController: UIActionSheetDelegate {

    func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int) {
        if buttonIndex != 0 { return }
        if !(self.mapView.isEditingNow()) { return }

        let doRequestDirectoin = self.mapView.editingMarker!.isKindOfClass(DAWaypointMarker)

        let doDeleteDestination = self.mapView.editingMarker!.isKindOfClass(DADestinationMarker)
        if doDeleteDestination {
            self.destinationString = ""
            self.mapView.removeAllPoints()
        }

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
        if marker.isKindOfClass(DADestinationMarker) {
            self.destinationString = ""
        }
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


/// MARK: - EAIntroDelegate
extension ViewController: EAIntroDelegate {

    func intro(introView: EAIntroView, pageAppeared page: EAIntroPage, withIndex pageIndex: UInt) {
        NSUserDefaults().setObject(true, forKey: DAUserDefaults.TutorialHasDone)
        NSUserDefaults().synchronize()
    }

}


/// MARK: - DASearchBoxViewDelegate
extension ViewController: DASearchBoxViewDelegate {

    func searchBoxWasActive(searchBoxView searchBoxView: DASearchBoxView) {
        self.searchResultView.hidden = false
    }

    func searchBoxWasInactive(searchBoxView searchBoxView: DASearchBoxView) {
        self.searchResultView.hidden = true
        self.searchBoxView.setSearchText(self.destinationString)
    }

    func searchDidFinish(searchBoxView searchBoxView: DASearchBoxView, destinations: [DADestination]) {
        self.searchResultView.updateDestinations(destinations)
    }

    func clearButtonTouchedUpInside(searchBoxView searchBoxView: DASearchBoxView) {
        if self.searchBoxView.isActive { return }

        DAGoogleMapClient.sharedInstance.cancelGetRoute()

        self.durationView.hide()
        self.mapView.removeAllPoints()
        self.destinationString = ""

        self.mapView.draw()
    }

    func modeDidChanged(searchBoxView searchBoxView: DASearchBoxView) {
        if self.destinationString != "" {
            self.requestDirectoin(doUpdateCamera: false)
        }
    }

    func didCancelRequestRouting(searchBoxView searchBoxView: DASearchBoxView) {
        DAGoogleMapClient.sharedInstance.cancelGetRoute()
        self.searchBoxView.endRequestRouting()

        self.durationView.hide()
        self.mapView.removeAllPoints()
        self.destinationString = ""

        self.mapView.draw()
    }

}


/// MARK: - DASearchResultViewDelegate
extension ViewController: DASearchResultViewDelegate {

    func didSelectRow(searchResultView searchResultView: DASearchResultView, selectedDestination: DADestination) {
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

    func touchedUpInside(durationView durationView: DADurationView) {
    }

    func willShow(durationView durationView: DADurationView) {
        UIView.animateWithDuration(
            0.30,
            delay: 0.0,
            options: .CurveEaseOut,
            animations: { [unowned self] in
                self.setButtonPositions(offsetY: self.durationView.frame.size.height)
                //self.setButtonPositions(offsetY: self.view.bounds.size.height - self.view.bounds.size.width + self.durationView.frame.size.height)
            },
            completion: { [unowned self] finished in }
        )
    }

    func willHide(durationView durationView: DADurationView) {
        UIView.animateWithDuration(
            0.15,
            delay: 0.0,
            options: .CurveEaseOut,
            animations: { [unowned self] in
                self.setButtonPositions(offsetY: 0)
                //self.setButtonPositions(offsetY: self.view.bounds.size.height - self.view.bounds.size.width)
            },
            completion: { [unowned self] finished in }
        )
    }
}


/// MARK: - DACrimeButtonDelegate
extension ViewController: DACrimeButtonDelegate {

    func crimeButton(crimeButton: DACrimeButton, wasOn: Bool) {
        // crime visualization
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
