import UIKit


class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Google Map
        GMSServices.provideAPIKey(DAGoogleMap.APIKey)

        // UI setting
        (application as! QTouchposeApplication).alwaysShowTouches = true
        (application as! QTouchposeApplication).touchEndAnimationDuration = 0.50

        return true
    }

    func applicationWillResignActive(application: UIApplication) {
    }

    func applicationDidEnterBackground(application: UIApplication) {
    }

    func applicationWillEnterForeground(application: UIApplication) {
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // crime API
        if DACrime.hasData() { return {
        DACrimeClient.sharedInstance.getCrime(
            completionHandler: { [unowned self] (json) in
                DACrime.save(json: json)
            }
        )
    }

    func applicationWillTerminate(application: UIApplication) {
    }

}
