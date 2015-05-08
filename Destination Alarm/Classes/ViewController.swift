import UIKit


/// MARK: - ViewController
class ViewController: UIViewController {

    /// MARK: - property
    @IBOutlet weak var mapview : GMSMapView!
    var locationManager: CLLocationManager!


    /// MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        self.mapview.myLocationEnabled = true
        self.mapview.delegate = self

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

}


/// MARK: - CLLocationManagerDelegate
extension ViewController: CLLocationManagerDelegate {

    func locationManager(manager: CLLocationManager!, didUpdateToLocation newLocation: CLLocation!, fromLocation oldLocation: CLLocation!) {
        self.mapview.camera = GMSCameraPosition.cameraWithLatitude(
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
