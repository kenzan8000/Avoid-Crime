import UIKit


/// MARK: - ViewController
class ViewController: UIViewController {

    /// MARK: - property
    @IBOutlet weak var testButton: UIButton!
    var destinationString: String = ""

    var mapView: DAGMSMapView!
    var searchBoxView: DASearchBoxView!
    var searchResultView: DASearchResultView!
    var horizontalTableView: DAHorizontalTableView!
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
        self.mapView.removeAllWaypoints()
        self.requestDirectoin()
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
        self.mapView.delegate = self
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

        // horizontal table view
        let horizontalTableViewNib = UINib(nibName: DANSStringFromClass(DAHorizontalTableView), bundle:nil)
        let horizontalTableViews = horizontalTableViewNib.instantiateWithOwner(nil, options: nil)
        self.horizontalTableView = horizontalTableViews[0] as! DAHorizontalTableView
        self.horizontalTableView.frame = CGRectMake(0, self.view.frame.size.height-self.horizontalTableView.frame.size.height, self.view.frame.size.width, self.horizontalTableView.frame.size.height)
        self.view.addSubview(self.horizontalTableView)
        self.horizontalTableView.doSettings()
        self.horizontalTableView.delegate = self

        // location manager
        self.locationManager = CLLocationManager()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.distanceFilter = 300
        self.locationManager.startUpdatingLocation()

        self.view.bringSubviewToFront(self.horizontalTableView)
        self.view.bringSubviewToFront(self.searchResultView)
        self.view.bringSubviewToFront(self.searchBoxView)
        self.view.bringSubviewToFront(self.testButton)
    }

    /**
     * request dirction API and render direction
     */
    private func requestDirectoin() {
        if self.destinationString == "" { return }

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


/// MARK: - GMSMapViewDelegate
extension ViewController: GMSMapViewDelegate {

    func mapView(mapView: GMSMapView, didTapAtCoordinate coordinate: CLLocationCoordinate2D) {
        self.mapView.appendWaypoint(coordinate)
        self.requestDirectoin()
    }

    func mapView(mapView: GMSMapView, didTapMarker marker: GMSMarker) -> Bool {
        return true
    }

    func mapView(mapView: GMSMapView,  didBeginDraggingMarker marker: GMSMarker) {
        self.mapView.startMovingWaypoint(marker.position)
    }

    func mapView(mapView: GMSMapView,  didEndDraggingMarker marker: GMSMarker) {
        self.mapView.endMovingWaypoint(marker.position)
        self.requestDirectoin()
    }

    func mapView(mapView: GMSMapView, didChangeCameraPosition position: GMSCameraPosition) {
        if !(self.mapView.isDraggingNow()) {
            let crimes = DACrime.fetch(minimumCoordinate: self.mapView.getMinimumCoordinate(), maximumCoordinate: self.mapView.getMaximumCoordinate())
            if crimes.count > 0 { self.mapView.setCrimes(crimes) }
            self.mapView.draw()
        }
    }

    func mapView(mapView: GMSMapView,  didDragMarker marker:GMSMarker) {
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
        self.mapView.setRouteJSON(nil)
        self.destinationString = ""
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
        self.mapView.removeAllWaypoints()
        self.requestDirectoin()
    }

}


/// MARK: - DAHorizontalTableViewDelegate
extension ViewController: DAHorizontalTableViewDelegate {

    func tableView(tableView: DAHorizontalTableView, indexPath: NSIndexPath, wasOn: Bool) {
        let markerType = tableView.dataSource[indexPath.row].markerType
        self.mapView.setCrimeMarkerType(markerType)
        switch (markerType) {
            case DAVisualization.CrimePoint:
                DACrime.requestToGetNewCrimes()
                break
            case DAVisualization.CrimeHeatmap:
                DACrime.requestToGetNewCrimes()
                break
            default:
                break
        }

        //let location = self.mapView.myLocation
        //let on = wasOn && (location != nil)
        //self.mapView.setCrimes(on ? DACrime.fetch(location: location, radius: 15.0) : nil)

        let on = wasOn
        self.mapView.setCrimes(on ? DACrime.fetch(minimumCoordinate: self.mapView.getMinimumCoordinate(), maximumCoordinate: self.mapView.getMaximumCoordinate()) : nil)

        self.mapView.draw()
    }

}
