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

        // google map direction API
        let location = self.mapView.myLocation
        if location == nil { return }
        let coordinate = location.coordinate
        DAGoogleMapClient.sharedInstance.removeAllWaypoints()
        DAGoogleMapClient.sharedInstance.getRoute(
            queries: [ "origin" : "\(coordinate.latitude),\(coordinate.longitude)", "destination" : "37.7932,-122.4145", ],
            completionHandler: { [unowned self] (json) in
                println("\(json)")
                self.mapView.drawRoute(json: json)
            }
        )

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
}


/// MARK: - CLLocationManagerDelegate
extension ViewController: CLLocationManagerDelegate {

    func locationManager(manager: CLLocationManager!, didUpdateToLocation newLocation: CLLocation!, fromLocation oldLocation: CLLocation!) {
        self.mapView.camera = GMSCameraPosition.cameraWithLatitude(
            newLocation.coordinate.latitude,
            longitude:newLocation.coordinate.longitude,
            zoom: 17
        )
    }

    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
    }

}


/// MARK: - GMSMapViewDelegate
extension ViewController: GMSMapViewDelegate {
}
