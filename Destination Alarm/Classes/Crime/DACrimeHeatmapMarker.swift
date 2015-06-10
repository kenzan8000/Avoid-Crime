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
        let image = LFHeatMap.heatMapWithRect(self.map.frame, boost: boost, points: points, weights: weights)
        self.icon = image
    }


}
