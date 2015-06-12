/// MARK: - UIImage+DACrimeHeatmap
extension UIImage {

    /// MARK: - public api

    /**
     * get heatmap image
     * @return UIImage
     **/
    class func heatmapImage(#map: GMSMapView, crimes: [DACrime]) -> UIImage {
        var locations: [CLLocation] = []
        var weights: [NSNumber] = []
        for crime in crimes {
            let lat = crime.lat.doubleValue
            let long = crime.long.doubleValue
            locations.append(CLLocation(latitude: lat, longitude: long))
            var weight = DASFGovernment.Crime.Weights[crime.category]
            if weight == nil { weight = DASFGovernment.Crime.Weights["THE OTHERS"] }
            weights.append(weight!)
        }

        var points: [NSValue] = []
        for var i = 0; i < locations.count; i++ {
            let location = locations[i]
            points.append(NSValue(CGPoint: map.projection.pointForCoordinate(location.coordinate)))
        }

        let image = LFHeatMap.heatMapWithRect(
            map.frame,
            boost: 1.0,
            points: points,
            weights: weights,
            weightsAdjustmentEnabled: false,
            groupingEnabled: true
        )

        return image
    }

}
