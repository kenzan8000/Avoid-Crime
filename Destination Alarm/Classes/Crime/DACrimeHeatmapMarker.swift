/// MARK: - DACrimeHeatmapMarker
class DACrimeHeatmapMarker: GMSMarker {

    /// MARK: - property

    var boost: Float!
    var weights: [NSNumber]!
    var locations: [CLLocation]!


    /// MARK: - public api

    /**
     * draw heatmap
     **/
    func draw() {
        var points: [NSValue] = []
        for var i = 0; i < self.locations.count; i++ {
            let location = locations[i]
            points.append(NSValue(CGPoint: self.map.projection.pointForCoordinate(location.coordinate)))
        }
        let image = LFHeatMap.heatMapWithRect(
            self.map.frame,
            boost: boost,
            points: points,
            weights: weights,
            weightsAdjustmentEnabled: false,
            groupingEnabled: true
        )
        self.icon = image
    }

    /**
     * get heatmap image
     * @return UIImage
     **/
    func heatmapImage(#map: GMSMapView) -> UIImage {
        var points: [NSValue] = []
        for var i = 0; i < self.locations.count; i++ {
            let location = locations[i]
            points.append(NSValue(CGPoint: map.projection.pointForCoordinate(location.coordinate)))
        }
        let image = LFHeatMap.heatMapWithRect(
            map.frame,
            boost: boost,
            points: points,
            weights: weights,
            weightsAdjustmentEnabled: false,
            groupingEnabled: true
        )
        return image
    }

}
