import UIKit


/// MARK: - ViewController
class ViewController: UIViewController {

    /// MARK: - property
    @IBOutlet weak var mapView : DAGMSMapView!
    var locationManager: CLLocationManager!


    /// MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // google map view
        self.mapView.myLocationEnabled = true
        self.mapView.delegate = self

        // location manager
        self.locationManager = CLLocationManager()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.distanceFilter = 300
        self.locationManager.startUpdatingLocation()
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
        // place autocomplete API
        let location = self.mapView.myLocation
        if location == nil { return }
        DAGoogleMapClient.sharedInstance.getPlaceAutoComplete(
            input: "Super Duper",
            radius: 5,
            location: location.coordinate,
            completionHandler: { [unowned self] (json) in
                let destinations = DADestination.destinations(json: json)
                for destination in destinations {
                    println(destination.desc)
                }
            }
        )
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
/*
        // render direction
        DAGoogleMapClient.sharedInstance.removeAllWaypoints()
        self.renderDirectoin()
*/
/*
    // crime API
        let location = self.mapView.myLocation
        if location == nil { return }
        DACrimeClient.sharedInstance.getRow(
            location: location,
            radius: 3.0,
            completionHandler: { [unowned self] (json) in
            }
        )
*/
    }


    /// MARK: - private api

    /**
     * render direction
     */
    func renderDirectoin() {
        // google map direction API
        let location = self.mapView.myLocation
        if location == nil { return }
        let coordinate = location.coordinate
        DAGoogleMapClient.sharedInstance.getRoute(
            queries: [ "origin" : "\(coordinate.latitude),\(coordinate.longitude)", "destination" : "37.7932,-122.4145", ],
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
        self.renderDirectoin()
    }

    func mapView(mapView: GMSMapView, didTapMarker marker: GMSMarker) -> Bool {
        return true
    }

    func mapView(mapView: GMSMapView,  didBeginDraggingMarker marker: GMSMarker) {
        DAGoogleMapClient.sharedInstance.startMovingWaypoint(marker.position)
    }

    func mapView(mapView: GMSMapView,  didEndDraggingMarker marker: GMSMarker) {
        DAGoogleMapClient.sharedInstance.endMovingWaypoint(marker.position)
        self.renderDirectoin()
    }

    func mapView(mapView: GMSMapView,  didDragMarker marker:GMSMarker) {
    }

}
