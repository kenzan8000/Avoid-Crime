import CoreLocation


/// MARK: - DAMapMath
class DAMapMath {

    /// MARK: - class method

    /**
     * get longitude degree from miles
     * @param radius mile
     * @param location CLLocation
     * @return degree
     */
    class func degreeOfLongitudePerRadius(radius: Double, location: CLLocation) -> Double {
        let locationLongPlus1 = CLLocation(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude + 1.0)
        let mile = locationLongPlus1.distanceFromLocation(location) * 0.000621371
        if mile == 0 { return 0.0 }
        return radius / mile
    }

    /**
     * get latitude degree from miles
     * @param location CLLocation
     * @param radius mile
     * @return degree
     */
    class func degreeOfLatitudePerRadius(radius: Double, location: CLLocation) -> Double {
        let locationLatPlus1 = CLLocation(latitude: location.coordinate.latitude + 1.0, longitude: location.coordinate.longitude)
        let mile = locationLatPlus1.distanceFromLocation(location) * 0.000621371
        if mile == 0 { return 0.0 }
        return radius / mile
    }

}