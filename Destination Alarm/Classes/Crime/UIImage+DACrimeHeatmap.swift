/// MARK: - UIImage+DACrimeHeatmap
extension UIImage {

    /// MARK: - public api

    /**
     * get heatmap image
     * @map map google map
     * @map crimes [DACrime]
     * @return UIImage
     **/
    class func heatmapImage(map map: GMSMapView, crimes: [DACrime]) -> UIImage {
        var locations: [CLLocation] = []
        var weights: [NSNumber] = []
        for crime in crimes {
            let lat = crime.lat.doubleValue
            let long = crime.long.doubleValue
            locations.append(CLLocation(latitude: lat, longitude: long))
            var weight = DASFGovernment.Crime.Weights_number[crime.category]
            if weight == nil { weight = DASFGovernment.Crime.Weights_number["THE OTHERS"] }
            weights.append(weight!)
        }

        var points: [NSValue] = []
        for var i = 0; i < locations.count; i++ {
            let location = locations[i]
            points.append(NSValue(CGPoint: map.projection.pointForCoordinate(location.coordinate)))
        }

        let image = DACrimeHeatmap.crimeHeatmapWithRect(
            map.frame,
            boost: 1.0,
            points: points,
            weights: weights
        )

        return image
    }

    /**
     * get heatmap image
     * @map map google map
     * @map sensors [DASensor]
     * @return UIImage
     **/
    class func heatmapImage(map map: GMSMapView, sensors: [DASensor]) -> UIImage {
        var locations: [CLLocation] = []
        var weights: [NSNumber] = []
        for sensor in sensors {
            let lat = sensor.lat.doubleValue
            let long = sensor.long.doubleValue
            locations.append(CLLocation(latitude: lat, longitude: long))
            weights.append(sensor.weight)
        }

        var points: [NSValue] = []
        for var i = 0; i < locations.count; i++ {
            let location = locations[i]
            points.append(NSValue(CGPoint: map.projection.pointForCoordinate(location.coordinate)))
        }

        let image = DACrimeHeatmap.crimeHeatmapWithRect(
            map.frame,
            boost: 1.0,
            points: points,
            weights: weights
        )

        return image
    }

}
