import UIKit


/// MARK: - AppDelegate
class AppDelegate: UIResponder, UIApplicationDelegate {

    /// MARK: - property
    var window: UIWindow?


    /// MARK: - life cycle
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Google Map
        GMSServices.provideAPIKey(DAGoogleMap.APIKey)
        // UI setting
        (application as! QTouchposeApplication).alwaysShowTouches = true
        (application as! QTouchposeApplication).touchEndAnimationDuration = 0.50

        // notification setting
        if #available(iOS 8.0, *) {
            let settings = UIUserNotificationSettings(forTypes: [.Sound, .Alert], categories: nil)
            UIApplication.sharedApplication().registerUserNotificationSettings(settings)
        }

        return true
    }

    func applicationWillResignActive(application: UIApplication) {
    }

    func applicationDidEnterBackground(application: UIApplication) {
    }

    func applicationWillEnterForeground(application: UIApplication) {
    }

    func applicationDidBecomeActive(application: UIApplication) {
        DACrime.requestToGetNewCrimes()
    }

    func applicationWillTerminate(application: UIApplication) {
    }

}
