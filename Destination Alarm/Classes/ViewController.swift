import UIKit


/// MARK: - ViewController
class ViewController: UIViewController {

    /// MARK: - property
    @IBOutlet weak var testButton: UIButton!
    var destinationString: String = ""

    var mapView: DAGMSMapView!
    var searchBoxView: DASearchBoxView!
    var searchResultView: DASearchResultView!
    var locationManager: CLLocationManager!


    /// MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

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

        // location manager
        self.locationManager = CLLocationManager()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.distanceFilter = 300
        self.locationManager.startUpdatingLocation()

        self.view.bringSubviewToFront(self.searchResultView)
        self.view.bringSubviewToFront(self.searchBoxView)
        self.view.bringSubviewToFront(self.testButton)
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
/*
        // geocode API
        let location = self.mapView.myLocation
        if location == nil { return }
        DAGoogleMapClient.sharedInstance.getGeocode(
            address: "24th St. Mission Street",
            radius: 5,
            location: location.coordinate,
            completionHandler: { [unowned self] (json) in
            }
        )
*/
        DAGoogleMapClient.sharedInstance.removeAllWaypoints()
        self.requestDirectoin()

        //let hoge = DACrime.fetch(location: self.mapView.myLocation, radius: 30.0)
        //println(hoge)
    }


    /// MARK: - private api

    /**
     * request dirction API and render direction
     */
    func requestDirectoin() {
        if self.destinationString == "" { return }

        DAGoogleMapClient.sharedInstance.cancelGetRoute()

        // google map direction API
        let location = self.mapView.myLocation
        if location == nil { return }
        let coordinate = location.coordinate
        DAGoogleMapClient.sharedInstance.getRoute(
            queries: [ "origin" : "\(coordinate.latitude),\(coordinate.longitude)", "destination" : self.destinationString, ],
            completionHandler: { [unowned self] (json) in
                // render routes
                self.mapView.drawRoute(json: json)
                // render way points
                let waypoints = DAGoogleMapClient.sharedInstance.waypoints
                for waypoint in waypoints {
                    var marker = GMSMarker(position: waypoint)
                    marker.map = self.mapView
                    marker.draggable = true
                }
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
        DAGoogleMapClient.sharedInstance.appendWaypoint(coordinate)
        self.requestDirectoin()
    }

    func mapView(mapView: GMSMapView, didTapMarker marker: GMSMarker) -> Bool {
        return true
    }

    func mapView(mapView: GMSMapView,  didBeginDraggingMarker marker: GMSMarker) {
        DAGoogleMapClient.sharedInstance.startMovingWaypoint(marker.position)
    }

    func mapView(mapView: GMSMapView,  didEndDraggingMarker marker: GMSMarker) {
        DAGoogleMapClient.sharedInstance.endMovingWaypoint(marker.position)
        self.requestDirectoin()
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
    }

    func searchDidFinish(#searchBoxView: DASearchBoxView, destinations: [DADestination]) {
        self.searchResultView.updateDestinations(destinations)
    }

}


/// MARK: - DASearchResultViewDelegate
extension ViewController: DASearchResultViewDelegate {

    func didSelectRow(#searchResultView: DASearchResultView, selectedDestination: DADestination) {
        self.searchBoxView.endSearch()
        self.searchBoxView.setSearchText(selectedDestination.desc)
        if self.destinationString == selectedDestination.desc { return }
        self.destinationString = selectedDestination.desc
        self.requestDirectoin()
    }

}

